//
//  PortifolioView.swift
//  CryptoApp
//
//  Created by Alexander on 02/10/23.
//

import SwiftUI

struct PortifolioView: View {
    
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(alignment: .leading, spacing: 0){
                    Text("hi")
                }
            }
            .navigationTitle("Edit Portifolio")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading){
                    XMarkButton()	
                }
            })
        }
    }
}

#Preview {
    PortifolioView()
}
