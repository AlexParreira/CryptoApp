//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Alexander Parreira on 24/09/23.
//

import Foundation

class HomeViewModel: ObservableObject{
    
    @Published var allCoins: [CoinModel] = []
    @Published var portifolioCoins: [CoinModel] = []
    
    
    init(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            self.allCoins.append(DeveloperPreview.instance.coin)
            self.portifolioCoins.append(DeveloperPreview.instance.coin)
            
        }
    }
    
}
