//
//  ErrorView.swift
//  Pokemon
//
//  Created by Masaki Sato on 2024/11/04.
//

import Foundation
import SwiftUI

struct ErrorView: View {
    var message: String
    var retry: () -> Void = {}
    
    var body: some View {
        VStack {
            Text(message)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .padding()
            Button(action: {
                retry()
            }) {
                Text("Reload")
                    .padding()
                    .frame(height: 44)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }
}

#Preview {
    ErrorView(message: "Failed to fetch pokemons")
}
