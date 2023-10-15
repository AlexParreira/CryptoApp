//
//  SettingsView.swift
//  CryptoApp
//
//  Created by Alex on 13/10/23.
//

import SwiftUI

struct SettingsView: View {
    
    let defaultURL = URL(string: "https://www.google.com")!
    let youtubetURL = URL(string: "https://www.youtube.com")!
    let coffeeURL = URL(string: "https://www.buymecoffee.com")!
    let coingeckoURL = URL(string: "https://www.coingecko.com")!
    let personalURL = URL(string: "https://www.na.com")!
    
    var body: some View {
        NavigationView{
            List {
                
                sectionSettings
                sectionCoingecko
                sectionDeveloper
                sectionApplication
            }
            .accentColor(.blue)
            .listStyle(GroupedListStyle())
            .navigationTitle("Settings")
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton()
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}

extension SettingsView {
    
    private var sectionSettings: some View{
        
        Section(header: Text("Header")){
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This a app was mmade by following a course Youtube. It uses MVVM Architecture, Combine and CoreData! ")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Subscribe on Youtube🥳", destination: youtubetURL)
            Link("Suport his coffee addiction☕️", destination: coffeeURL)
        }
    }
    private var sectionCoingecko: some View{
        
        Section(header: Text("CoinGecko")){
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("The cryptocurrentcy data thar us used in this app comes grom a gree API from CoinGecko! Prices may be slightly delayed. ")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Visit CoinGecko🥳", destination: coingeckoURL)
        }
    }
    
    private var sectionDeveloper: some View{
        
        Section(header: Text("Developer")){
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was developed by AlexParreira. It uses SwiftUI and is written 100% in Swift. The project benefits from multi-threading, publishers/subscribers, and data persistence.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Visit Website🥳", destination: personalURL)
        }
    }
    private var sectionApplication: some View{
        
        Section(header: Text("Developer")){
            Link("Terms of Service", destination: defaultURL)
            Link("Privacy of Service", destination: defaultURL)
            Link("Company Website", destination: defaultURL)
            Link("Learn More", destination: defaultURL)
        }
    }
}
