//
//  CoinRowView.swift
//  CryptoApp
//
//  Created by Alexander Parreira on 22/09/23.
//

import SwiftUI

struct CoinRowView: View {
    
    let coin: CoinModel
    let showHoldingsColumn: Bool
    
    var body: some View {
        HStack(spacing: 0){
            leftColumn
            Spacer()
            if showHoldingsColumn{
                centerColumn
            }
            rightColumn
        }
        .font(.subheadline)
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {

            CoinRowView(coin: dev.coin , showHoldingsColumn: true)
                .previewLayout(.sizeThatFits)
    }
}


extension CoinRowView{
    
    private var leftColumn: some View{
        HStack(spacing: 0){
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.theme.secondaryTextColor)
                .frame(minWidth: 30)
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundColor(Color.theme.accent)
        }
    }
    private var centerColumn: some View{
        VStack(alignment: .trailing){
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimal())
            Text((coin.currentHoldings ?? 0).AsNumberString())
        }
        .foregroundColor(Color.theme.accent)
        
    }
    
    private var rightColumn: some View{
        VStack(alignment: .trailing){
            Text(coin.currentPrice.asCurrencyWith6Decimal())
                .bold()
                .foregroundColor(Color.theme.accent)
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                .foregroundColor(
                    (coin.priceChangePercentage24H ?? 0) >= 0 ?
                    Color.theme.green :
                        Color.theme.red
                )
        }
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
    }
}
