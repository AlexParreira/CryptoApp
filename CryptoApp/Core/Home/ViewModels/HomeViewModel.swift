//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Alexander Parreira on 24/09/23.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject{
    
    @Published var statistics: [StatisticModel] = [
        
    ]
    
    
    @Published var allCoins: [CoinModel] = []
    @Published var portifolioCoins: [CoinModel] = []
    
    @Published var searchText: String = ""
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portifolioDataService = PortifolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        addSubscribers()
    }
    
    
    
    func addSubscribers(){
        
        //MARK: update all coins
        $searchText
            .combineLatest(coinDataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
            //MARK: update market data
        marketDataService.$marketData
            .map(mapGlobalMarketData)
            .sink{[weak self](returnedStats) in
                self?.statistics = returnedStats
            }
            .store(in: &cancellables)
        
        //MARK: update portifolio coins
        
        $allCoins
            .combineLatest(portifolioDataService.$savedEntities)
            .map{ (coinModels, portifolioEntities) -> [CoinModel] in
                
                coinModels
                    .compactMap{(coin) -> CoinModel? in
                        guard let entity = portifolioEntities.first(where: { $0.coinID == coin.id }) else{
                            return nil
                        }
                        return coin.updateHoldings(amount: entity.amount)
                    }
            }
            .sink{ [weak self] (returnedCoins) in
                self?.portifolioCoins = returnedCoins
            }
            .store(in: &cancellables)
    }
    
    func updatePortifolio(coin: CoinModel, amount: Double){
        portifolioDataService.updatePortifolio(coin: coin, amount: amount)
    }
    
    
    private func filterCoins(text: String, coins:[CoinModel]) -> [CoinModel]{
        guard !text.isEmpty else{
            return coins
        }
        
        let lowercasedText = text.lowercased()
        
        return coins.filter{(coin) -> Bool in
            return coin.name.lowercased().contains(lowercasedText)  ||
            coin.symbol.lowercased().contains(lowercasedText)
        }
    }
    
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?) -> [StatisticModel] {
        
        var stats: [StatisticModel] = []
        
        guard let data = marketDataModel else {
            return stats
        }
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        
        let portifolio = StatisticModel(title: "Portifolio", value: "$0.00", percentageChange: 0)
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portifolio
        ])
        return stats
    }
}
