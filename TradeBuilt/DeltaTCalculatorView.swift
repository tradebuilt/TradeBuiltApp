//
//  DeltaTCalculatorView.swift
//  TradeBuilt
//
//  Created by Freedom Mechanical LLC on 9/21/25.
//

import SwiftUI

struct DeltaTCalculatorView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
        }
        .navigationTitle("Delta T")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { DeltaTCalculatorView() }
}


