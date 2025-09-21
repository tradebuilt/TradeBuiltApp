//
//  HVACCalculatorsView.swift
//  TradeBuilt
//
//  Created by Freedom Mechanical LLC on 9/21/25.
//

import SwiftUI

struct HVACCalculatorsView: View {
    @State private var playAnimDeltaT: Bool = false
    var body: some View {
        ZStack {
            LinearGradient(colors: [
                Color(.systemBackground),
                Color(.secondarySystemBackground)
            ], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()

            VStack(spacing: 16) {
                // Delta T (Δ) button
                Button {
                    withAnimation(.spring(response: 0.22, dampingFraction: 0.7)) {
                        playAnimDeltaT = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
                        withAnimation(.easeOut(duration: 0.12)) {
                            playAnimDeltaT = false
                        }
                    }
                } label: {
                    HVACCategoryButton(width: 300, animate: playAnimDeltaT, title: "Delta T (Δ)")
                }
                .buttonStyle(.plain)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .navigationTitle("HVAC Calculators")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { HVACCalculatorsView() }
}


