//
//  HVACCalculatorsView.swift
//  TradeBuilt
//
//  Created by Freedom Mechanical LLC on 9/21/25.
//

import SwiftUI

struct HVACCalculatorsView: View {
    var body: some View {
        Text("HVAC Calculators")
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
            .navigationTitle("HVAC Calculators")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { HVACCalculatorsView() }
}


