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
    @Published var isLoading: Bool = false
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .holdings
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portifolioDataService = PortifolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption {
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }
    
    init(){
        addSubscribers()
    }
    
    
    
    func addSubscribers(){
        
        //MARK: update all coins
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        //MARK: update portifolio coins
        $allCoins
            .combineLatest(portifolioDataService.$savedEntities)
            .map(mapAllCoinsToPortifolioCoins)
            .sink{ [weak self] (returnedCoins) in
                guard let self = self else { return }
                self.portifolioCoins = self.sortPortfolioCoinsIfNeeded(coins: returnedCoins)
            }
            .store(in: &cancellables)
        
        //MARK: update market data
        marketDataService.$marketData
            .combineLatest($portifolioCoins)
            .map(mapGlobalMarketData)
            .sink{[weak self](returnedStats) in
                self?.statistics = returnedStats
                self?.isLoading = false

            }
            .store(in: &cancellables)
        
        
    }
    
    func updatePortifolio(coin: CoinModel, amount: Double){
        portifolioDataService.updatePortifolio(coin: coin, amount: amount)
    }
    
    func reloadData(){
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.notification(type: .success)
    }
    
    private func filterAndSortCoins(text: String, coins: [CoinModel], sort: SortOption) -> [CoinModel] {
        var updateCoins = filterCoins(text: text, coins: coins)
        sortCoins(sort: sort, coins: &updateCoins)
        return updateCoins
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
    
    private func sortCoins(sort: SortOption, coins: inout [CoinModel]){
        switch sort {
        case .rank, .holdings:
             coins.sort (by: { $0.rank < $1.rank })
        case .rankReversed, .holdingsReversed:
             coins.sort (by: { $0.rank > $1.rank })
        case .price:
             coins.sort (by: { $0.currentPrice < $1.currentPrice })
        case .priceReversed:
             coins.sort (by: { $0.currentPrice > $1.currentPrice })

        }
    }
    
    private func sortPortfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel]{
        switch sortOption {
        case .holdings:
            return coins.sorted(by: {$0.currentHoldingsValue > $1.currentHoldingsValue})
        case .holdingsReversed:
            return coins.sorted(by: {$0.currentHoldingsValue < $1.currentHoldingsValue})
        default:
            return coins
        }
    }
    
    private func mapAllCoinsToPortifolioCoins(allCoins: [CoinModel], portifolioEntities: [PortifolioEntity]) -> [CoinModel] {
        allCoins
            .compactMap{(coin) -> CoinModel? in
                guard let entity = portifolioEntities.first(where: { $0.coinID == coin.id }) else{
                    return nil
                }
                return coin.updateHoldings(amount: entity.amount)
            }
    }
    
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?, portifolioCoins: [CoinModel]) -> [StatisticModel] {
        
        var stats: [StatisticModel] = []
        
        guard let data = marketDataModel else {
            return stats
        }
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        
        let portifolioValue =
            portifolioCoins
                .map({ $0.currentHoldingsValue })
                .reduce(0, +)
        
        let previousValue =
            portifolioCoins
            .map{ (coin) -> Double in
                let currenValue = coin.currentHoldingsValue
                let percentChange = (coin.priceChangePercentage24H ?? 0) / 100.0
                let previousValue = currenValue / (1 + percentChange)
                return previousValue
            }
            .reduce(0, +)
        
        let percentageChange = ((portifolioValue - previousValue) / previousValue) * 100
        
        let portifolio = StatisticModel(
            title: "Portifolio",
            value: portifolioValue.asCurrencyWith2Decimal(),
            percentageChange: 0)
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portifolio
        ])
        return stats
    }
}
