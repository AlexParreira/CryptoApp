//
//  HomeView.swift
//  CryptoApp
//
//  Created by Alexander Parreira on 22/09/23.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var showPortfolio: Bool = false
    
    var body: some View {
        ZStack{
                //MARK: background layer
            Color.theme.background
                .ignoresSafeArea()
            
                //MARK: content layer
            VStack{
                homeHeader
                SearchBarView(searchText: $vm.searchText)
                columnTitles
                
                if !showPortfolio{
                    allCoinsList
                        .transition(.move(edge: .leading))
                }
                if showPortfolio{
                    portifolioCoinsList
                        .transition(.move(edge: .trailing))
                }
                
                Spacer(minLength: 0)
            }
        }
    }
    
    struct HomeView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationView{
                HomeView()
            
            }
            .environmentObject(dev.homeVM)
        }
    }
}
    extension HomeView {
        private var homeHeader: some View{
            HStack{
                CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                    .animation(.none)
                    .background(
                        CircleButtonAnimationView(animate: $showPortfolio)
                    )
                Spacer()
                Text(showPortfolio ? "Portifolio"  : "Live Prices")
                    .font(.headline)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.theme.accent)
                    .animation(.easeInOut)
                Spacer()
                CircleButtonView(iconName: "chevron.right")
                    .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                    .onTapGesture {
                        withAnimation(.spring()){
                            showPortfolio.toggle()
                        }
                    }
            }
            .padding(.horizontal)
        }
        
        private var allCoinsList: some View{
            List{
                ForEach(vm.allCoins){ coin in
                    CoinRowView(coin: coin, showHoldingsColumn: false)
                        .listRowInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
                }
            }
            .listStyle(PlainListStyle())
        }

        private var portifolioCoinsList: some View{
            List{
                ForEach(vm.portifolioCoins){ coin in
                    CoinRowView(coin: coin, showHoldingsColumn: true)
                        .listRowInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
                }
            }
            .listStyle(PlainListStyle())
        }
        
        private var columnTitles: some View {
            HStack{
                Text("Coin")
                Spacer()
                if showPortfolio {
                    Text("Holdings")
                }
                Text("Price")
                    .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            }
            .font(.caption)
            .foregroundColor(Color.theme.secondaryTextColor)
            .padding(.horizontal)
        }
    }
