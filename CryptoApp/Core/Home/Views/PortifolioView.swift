//
//  PortifolioView.swift
//  CryptoApp
//
//  Created by Alexander on 02/10/23.
//

import SwiftUI

struct PortifolioView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = ""
    @State private var showCheckMark: Bool = false
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(alignment: .leading, spacing: 0){
                    SearchBarView(searchText: $vm.searchText)
                    coinLogoList
                    
                    
                    if selectedCoin != nil {
                        portifolioInputSection
                    }
                    
                }
            }
            .navigationTitle("Edit Portifolio")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading){
                    XMarkButton()	
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    trailingNavBarButton
                }
            })
            .onChange(of: vm.searchText, perform: { value in
                if value == ""{
                    removeSelectedCoin()
                }
            })
        }
    }
}

#Preview {
    PortifolioView()
        
}

extension PortifolioView {
    private var coinLogoList: some View{
        ScrollView(.horizontal, showsIndicators: false, content: {
            LazyHStack(spacing: 10){
                ForEach(vm.allCoins){ coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                updateSelectedCoin(coin: coin)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == coin.id ?
                                        Color.theme.green : Color.clear
                                        , lineWidth: 1)
                        )
                }
            }
            .frame(height: 120)
            .padding(.leading)
        })
    }
    
    private func updateSelectedCoin(coin: CoinModel) {
        selectedCoin = coin
        
        if let portifolioCoin = vm.portifolioCoins.first(where: { $0.id == coin.id }),
           let amount = portifolioCoin.currentHoldings{
            quantityText = "\(amount)"
        } else {
            quantityText = ""
        }
    }
    
    
    private func getCurrentValue() -> Double{
        if let quantity = Double(quantityText){
            return quantity * (selectedCoin?.currentPrice ?? 0.0)
        }
        return 0
    }
    
    private var portifolioInputSection: some View {
        VStack(spacing: 20){
            HStack{
                Text(" current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimal() ?? "")
            }
            Divider()
            HStack{
                Text("Amount holding:")
                Spacer()
                TextField("Ex: 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack{
                Text("Current value")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimal())
            }
        }
        .animation(.none, value: false)
        .padding()
        .font(.headline)
    }
    
    private var trailingNavBarButton: some  View{
        HStack(spacing: 10) {
            Image(systemName: "checkmark")
                .opacity(showCheckMark ? 1.0 : 0.0)
            
            Button(action: {
                saveButtonPressed()
            }, label: {
                Text("Save".uppercased())

            })
            .opacity(
                (selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText)) ?
                1.0 : 0.0
            )
        }
        .font(.headline)
    }
    
    private func saveButtonPressed() {
        
        
        guard 
            let coin = selectedCoin,
            let amount = Double(quantityText)
        
            else {return}
        
        
        //MARK: save to portfolio
        vm.updatePortifolio(coin: coin, amount: amount)
        
        //MARK: show checkmark
        
        withAnimation(.easeIn) {
            showCheckMark = true
            removeSelectedCoin()
        }
        
        //MARK: hide keyboard
        UIApplication.shared.endEditing()
        
        //MARK: hide checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            withAnimation(.easeIn){
                showCheckMark = false
            }
        }
    }
    
    
    private func removeSelectedCoin() {
        selectedCoin = nil
        vm.searchText = ""
    }
}
