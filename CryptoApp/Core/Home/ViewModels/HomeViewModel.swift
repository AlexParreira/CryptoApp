//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Alexander Parreira on 24/09/23.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject{
    
    @Published var allCoins: [CoinModel] = []
    @Published var portifolioCoins: [CoinModel] = []
    
    @Published var searchText: String = ""
    
    private let dataService = CoinDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        addSubscribers()
    }
    
    func addSubscribers(){
        dataService.$allCoins
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
    }

    
}
