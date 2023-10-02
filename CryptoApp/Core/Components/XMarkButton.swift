//
//  XMarkButton.swift
//  CryptoApp
//
//  Created by Alexander on 02/10/23.
//

import SwiftUI

struct XMarkButton: View {
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Button(action: {
presentationMode.wrappedValue.dismiss()
        }, label:{
            Image(systemName: "xmark")
                .font(.headline)
        })
    }
}

#Preview {
    XMarkButton()
}
