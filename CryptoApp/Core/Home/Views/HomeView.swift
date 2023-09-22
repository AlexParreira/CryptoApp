//
//  HomeView.swift
//  CryptoApp
//
//  Created by Alexander Parreira on 22/09/23.
//

import SwiftUI

struct HomeView: View {
    
    @State private var showPortfolio: Bool = false
    
    var body: some View {
        ZStack{
                //MARK: background layer
            Color.theme.background
                .ignoresSafeArea()
            
                //MARK: content layer
            VStack{
                homeHeader
                    
                Spacer(minLength: 0)
            }
        }
    }
    
    struct HomeView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationView{
                HomeView()
                    .navigationBarHidden(true)
            }
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

}
