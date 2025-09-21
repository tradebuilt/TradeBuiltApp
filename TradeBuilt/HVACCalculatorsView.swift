//
//  HVACCalculatorsView.swift
//  TradeBuilt
//
//  Created by Freedom Mechanical LLC on 9/21/25.
//

import SwiftUI

struct HVACCalculatorsView: View {
    @State private var playAnimDeltaT: Bool = false
    @State private var isTempSectionExpanded: Bool = true
    @State private var navigateDeltaT: Bool = false
    var body: some View {
        ZStack {
            LinearGradient(colors: [
                Color(.systemBackground),
                Color(.secondarySystemBackground)
            ], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()

            VStack(spacing: 16) {
                // Section header with dropdown chevron
                Button {
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.9)) {
                        isTempSectionExpanded.toggle()
                    }
                } label: {
                    HStack(spacing: 8) {
                        Text("Temperature Measurements")
                            .font(.headline)
                        Image(systemName: "chevron.down")
                            .rotationEffect(.degrees(isTempSectionExpanded ? 0 : -90))
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                if isTempSectionExpanded {
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.36) {
                            navigateDeltaT = true
                        }
                    } label: {
                        HVACCategoryButton(width: 300, animate: playAnimDeltaT, title: "Delta T (Δ)")
                    }
                    .buttonStyle(.plain)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .navigationTitle("HVAC Calculators")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $navigateDeltaT) {
            DeltaTCalculatorView()
        }
    }
}

#Preview {
    NavigationStack { HVACCalculatorsView() }
}


