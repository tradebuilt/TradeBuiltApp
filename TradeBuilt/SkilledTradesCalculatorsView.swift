//
//  SkilledTradesCalculatorsView.swift
//  TradeBuilt
//
//  Created by Freedom Mechanical LLC on 9/21/25.
//

import SwiftUI

struct SkilledTradesCalculatorsView: View {
    var body: some View {
        Text("Skilled Trades Calculators")
            .font(.title2)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(colors: [
                    Color(.systemBackground),
                    Color(.secondarySystemBackground)
                ], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            )
            .navigationTitle("Skilled Trades Calculators")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { SkilledTradesCalculatorsView() }
}


