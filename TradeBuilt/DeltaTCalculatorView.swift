//
//  DeltaTCalculatorView.swift
//  TradeBuilt
//
//  Created by Freedom Mechanical LLC on 9/21/25.
//

import SwiftUI

struct DeltaTCalculatorView: View {
    @State private var returnDuctTemp: String = ""
    @State private var supplyDuctTemp: String = ""
    @FocusState private var focusedField: FocusedField?

    private enum FocusedField: Hashable {
        case returnField
        case supplyField
    }

    private var deltaT: Double? {
        let normalizedReturn = returnDuctTemp.replacingOccurrences(of: ",", with: ".")
        let normalizedSupply = supplyDuctTemp.replacingOccurrences(of: ",", with: ".")
        guard let returnValue = Double(normalizedReturn),
              let supplyValue = Double(normalizedSupply) else { return nil }
        return returnValue - supplyValue
    }

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                VStack(spacing: 14) {
                    // Return field
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [Color.orange.opacity(0.95), Color.orange.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 36, height: 36)
                            Image(systemName: "thermometer")
                                .foregroundStyle(.white)
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Return Duct Temperature")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            TextField("°F", text: $returnDuctTemp)
                                .keyboardType(.decimalPad)
                                .focused($focusedField, equals: .returnField)
                        }
                    }
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(.ultraThinMaterial)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(focusedField == .returnField ? Color.orange.opacity(0.35) : Color.secondary.opacity(0.15), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 6)

                    // Supply field
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [Color.blue.opacity(0.9), Color.blue.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 36, height: 36)
                            Image(systemName: "thermometer")
                                .foregroundStyle(.white)
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Supply Duct Temperature")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            TextField("°F", text: $supplyDuctTemp)
                                .keyboardType(.decimalPad)
                                .focused($focusedField, equals: .supplyField)
                        }
                    }
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(.ultraThinMaterial)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(focusedField == .supplyField ? Color.blue.opacity(0.35) : Color.secondary.opacity(0.15), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 6)
                }
                .padding(.horizontal)

                if let value = deltaT {
                    VStack(spacing: 6) {
                        Text("ΔT")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(String(format: "%.1f °F", value))
                            .font(.system(size: 44, weight: .bold, design: .rounded))
                            .monospacedDigit()
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(.thinMaterial, in: Capsule())
                    }
                    .padding(.top, 4)
                } else {
                    Text("Enter both temperatures")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.top, 8)
                }

                Spacer()
            }
            .padding(.top, 20)
        }
        .navigationTitle("Delta T (Δ) Calculator")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { focusedField = nil }
            }
        }
    }
}

#Preview {
    NavigationStack { DeltaTCalculatorView() }
}


