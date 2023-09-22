//
//  ContentView.swift
//  CryptoApp
//
//  Created by Alexander Parreira on 22/09/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        ZStack{
            Color.theme.background
                .ignoresSafeArea()
            
            VStack(spacing: 40){
                Text("Accent Color")
                    .foregroundColor(Color.theme.accent)
                
                Text("Secondary Text Color")
                    .foregroundColor(Color.theme.secondaryTextColor)
                
                Text("Red Color")
                    .foregroundColor(Color.theme.red)
                
                Text("Green Color")
                    .foregroundColor(Color.theme.green)
                
            }
            .font(.headline)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
