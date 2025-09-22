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
    @State private var showReturnInfo: Bool = false
    @State private var showSupplyInfo: Bool = false
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
                    ZStack(alignment: .trailing) {
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
                        Button {
                            focusedField = nil
                            showReturnInfo = true
                        } label: {
                            Image(systemName: "info.circle.fill")
                                .foregroundStyle(Color.orange.opacity(0.9))
                                .imageScale(.large)
                        }
                        .buttonStyle(.plain)
                        .padding(.trailing, 10)
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
                    ZStack(alignment: .trailing) {
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
                        Button {
                            focusedField = nil
                            showSupplyInfo = true
                        } label: {
                            Image(systemName: "info.circle.fill")
                                .foregroundStyle(Color.blue.opacity(0.9))
                                .imageScale(.large)
                        }
                        .buttonStyle(.plain)
                        .padding(.trailing, 10)
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
        .sheet(isPresented: $showReturnInfo) {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Return Duct Temperature")
                        .font(.title3).bold()
                    Text("How to measure:")
                        .font(.headline)
                    Text("1. Run the system 10–15 minutes to stabilize airflow and coil.")
                    Text("2. Drill a 1/4–3/8 in test port in a straight return section about 12–18 in upstream of the coil or furnace, away from elbows/transitions.")
                    Text("3. Insert a temperature probe into the center of the airstream (on small ducts 2–3 in past the inner wall). Angle the tip into airflow and avoid touching metal.")
                    Text("4. On larger ducts, take 3–5 readings across the duct and average to reduce stratification.")
                    Text("5. When finished, plug or tape the test port to reseal the duct.")
                    Text("Used in ΔT: Return − Supply")
                        .font(.subheadline)
                }
                .padding(20)
                .padding(.bottom, 20)
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showSupplyInfo) {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Supply Duct Temperature")
                        .font(.title3).bold()
                    Text("How to measure:")
                        .font(.headline)
                    Text("1. Run the system 10–15 minutes to stabilize temperatures.")
                    Text("2. Drill a 1/4–3/8 in test port in a straight supply trunk 12–24 in downstream of the coil/heat exchanger and before the first branch or mixing point.")
                    Text("3. Insert the probe mid‑stream, angled into airflow. Avoid touching metal or radiant surfaces.")
                    Text("4. If air is stratified, take 3–5 readings around the duct and average.")
                    Text("Used in ΔT: Return − Supply")
                        .font(.subheadline)
                }
                .padding(20)
                .padding(.bottom, 20)
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    NavigationStack { DeltaTCalculatorView() }
}


