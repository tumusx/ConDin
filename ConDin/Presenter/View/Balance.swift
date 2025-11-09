//
//  Balance.swift
//  ConDin
//
//  Created by Murillo Alves da silva on 21/09/25.
//

import SwiftUI
struct Balance: View {
    var balance: String
    @Binding var actualBalance: String
    let onBalanceChange: ((String) -> Void)?

    init(balance: String, actualBalance: Binding<String>, onBalanceChange: ((String) -> Void)? = nil) {
        self.balance = balance
        self._actualBalance = actualBalance
        self.onBalanceChange = onBalanceChange
    }

    var body: some View {
        let actualBalanceFormatted = "R$ " + actualBalance
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
                .opacity(0.6)
            
            TextField("R$ 0,00", text: Binding(
                get: { actualBalance },
                set: {
                    let clean = $0.replacingOccurrences(of: "R$ ", with: "")
                    actualBalance = clean
                    onBalanceChange?(clean)
                }
            ))
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

struct Balance_Previews: PreviewProvider {
    @State static var previewActualBalance: String = "123"

    static var previews: some View {
        Balance(
            balance: "R$ 1.000,00",
            actualBalance: $previewActualBalance,
            onBalanceChange: { value in
            }
        )
    }
}
