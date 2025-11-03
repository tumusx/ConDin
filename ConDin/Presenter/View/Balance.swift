//
//  Balance.swift
//  ConDin
//
//  Created by Murillo Alves da silva on 21/09/25.
//

import SwiftUI

struct Balance: View {
    var balance: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Gasto do mês")
                .font(.caption)
                .foregroundColor(.red)
            Text(balance)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Saldo atual")
                .font(.caption)
                .foregroundColor(.primary)
                .opacity(0.5)
            Text(balance)
                .font(.headline)
                .foregroundColor(.primary)

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .gray.opacity(0.3), radius: 8)
        )
        .padding(.horizontal)
    }
}

#Preview {
    Balance(balance: "R$ 1.000,00")
}
