//
//  ContentView.swift
//  HVAC Field Calculators
//
//  Created by Freedom Mechanical LLC on 9/20/25.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var showSplash: Bool = true
    @State private var overlayOpacity: Double = 1
    @State private var contentOpacity: Double = 0
    @State private var splashOpacity: Double = 0

    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    private let calculators: [Calculator] = [
        Calculator(title: "CFM Calculator", systemImage: "wind", color: .teal, description: "Airflow by BTU/Ton"),
        Calculator(title: "Duct Sizing", systemImage: "rectangle.grid.2x2", color: .blue, description: "By CFM & Velocity"),
        Calculator(title: "Superheat", systemImage: "thermometer", color: .orange, description: "Fixed orifice"),
        Calculator(title: "Subcooling", systemImage: "snowflake", color: .indigo, description: "TXV charging"),
        Calculator(title: "Static Pressure", systemImage: "gauge", color: .purple, description: "ESP & ΔP"),
        Calculator(title: "Line Set", systemImage: "wrench", color: .pink, description: "Sizing & drop"),
        Calculator(title: "Humidity", systemImage: "drop", color: .green, description: "RH & grains"),
        Calculator(title: "Capacity", systemImage: "chart.bar", color: .red, description: "BTU & tons"),
        Calculator(title: "Placeholder 1", systemImage: "hammer", color: .gray.opacity(0.85), description: nil),
        Calculator(title: "Placeholder 2", systemImage: "slider.horizontal.3", color: .gray.opacity(0.7), description: nil)
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                VStack(alignment: .leading, spacing: 20) {
                    HeaderTitleView()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding(.horizontal, 20)
                .padding(.top, -40)
                .ignoresSafeArea(edges: .top)
                if showSplash {
                    ZStack {
                        // Opaque background to prevent menu glimpse
                        BackgroundView()
                        SplashView()
                            .opacity(contentOpacity)
                    }
                    .opacity(overlayOpacity)
                    .transition(.opacity)
                    .zIndex(1)
                }
            }
            .onAppear {
                // 1) Fade in splash content over 1s
                withAnimation(.easeInOut(duration: 1.0)) {
                    contentOpacity = 1
                }
                // 2) Hold for 3s while loading bar animates (progress tied to contentOpacity for simplicity)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 + 3.0) {
                    // 3) Fade out entire splash over 1s
                    withAnimation(.easeInOut(duration: 1.0)) {
                        overlayOpacity = 0
                    }
                    // 4) Remove splash after fade-out completes
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        showSplash = false
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    ContentView()
}

// MARK: - Models

struct Calculator: Identifiable, Hashable {
    let id: UUID = UUID()
    let title: String
    let systemImage: String
    let color: Color
    let description: String?
}

// MARK: - Views

struct BackgroundView: View {
    var body: some View {
        LinearGradient(colors: [
            Color(.systemBackground),
            Color(.secondarySystemBackground)
        ], startPoint: .topLeading, endPoint: .bottomTrailing)
        .ignoresSafeArea()
    }
}

struct HeaderTitleView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Image("TradeBuilt Logo 2")
                .resizable()
                .scaledToFit()
                .frame(width: 320)
                .frame(maxWidth: .infinity, alignment: .center)
                .accessibilityLabel("TradeBuilt")
                .shadow(color: .black.opacity(0.18), radius: 10, x: 0, y: 6)
            LaserLineView()
                .frame(width: 320)
                .padding(.top, -108)
        }
    }
}

struct LaserLineView: View {
    private let thickness: CGFloat = 4
    private let glowColor: Color = .white
    @State private var animate: Bool = false

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.12))
                    .frame(height: thickness)
                let beamWidth = max(40, geo.size.width * 0.18)
                LinearGradient(colors: [glowColor.opacity(0.0), glowColor, glowColor.opacity(0.0)], startPoint: .leading, endPoint: .trailing)
                    .frame(width: beamWidth, height: thickness)
                    .shadow(color: glowColor.opacity(0.7), radius: 8, x: 0, y: 0)
                    .shadow(color: glowColor.opacity(0.5), radius: 12, x: 0, y: 0)
                    .offset(x: animate ? max(0, geo.size.width - beamWidth) : 0)
                    .blendMode(.screen)
            }
            .frame(height: thickness)
            .clipShape(Capsule())
            .onAppear {
                withAnimation(.linear(duration: 1.6).repeatForever(autoreverses: true)) {
                    animate = true
                }
            }
        }
        .frame(height: thickness)
        .accessibilityHidden(true)
    }
}

struct CalculatorCard: View {
    let item: Calculator

    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(LinearGradient(colors: [
                    item.color.opacity(0.95),
                    item.color.opacity(0.7)
                ], startPoint: .topLeading, endPoint: .bottomTrailing))
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: item.systemImage)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(.white)
                Text(item.title)
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                if let desc = item.description {
                    Text(desc)
                        .font(.footnote)
                        .foregroundStyle(.white.opacity(0.9))
                }
            }
            .padding(16)
        }
        .frame(height: 120)
        .shadow(color: item.color.opacity(0.28), radius: 10, x: 0, y: 8)
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(.white.opacity(0.15), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
    }
}

struct CalculatorDetailView: View {
    let item: Calculator

    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(item.color.opacity(0.2))
                    .frame(width: 140, height: 140)
                Image(systemName: item.systemImage)
                    .font(.system(size: 56, weight: .semibold))
                    .foregroundStyle(item.color)
            }
            Text(item.title)
                .font(.title.bold())
            Text("Calculator coming soon")
                .font(.callout)
                .foregroundStyle(.secondary)
            Spacer()
        }
        .padding()
        .navigationTitle(item.title)
        .navigationBarTitleDisplayMode(.inline)
        .background(BackgroundView())
    }
}

// MARK: - Styles

struct PressableCardStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .shadow(color: .black.opacity(configuration.isPressed ? 0.15 : 0.22), radius: configuration.isPressed ? 6 : 10, x: 0, y: configuration.isPressed ? 4 : 8)
            .animation(.spring(response: 0.16, dampingFraction: 0.75), value: configuration.isPressed)
    }
}

// MARK: - Loading Bar
struct LoadingBar: View {
    // Expecting a value between 0 and 1; we'll animate internally
    var progress: Double
    @State private var animatedProgress: Double = 0

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(.white.opacity(0.15))
                // Filled portion
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(.white)
                    .frame(width: max(8, geo.size.width * animatedProgress))
            }
        }
        .frame(height: 8)
        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
        .padding(.horizontal, 40)
        .onAppear {
            // Animate to full over ~3 seconds
            withAnimation(.easeInOut(duration: 3.0)) {
                animatedProgress = 1
            }
        }
    }
}

// MARK: - Loading Dots
struct LoadingDots: View {
    @State private var step: Int = 0
    private let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            Text("Loading")
                .font(.footnote)
                .foregroundStyle(.secondary)
            HStack(spacing: 2) {
                Circle().fill(.secondary).frame(width: 4, height: 4).opacity(step >= 1 ? 1 : 0.2)
                Circle().fill(.secondary).frame(width: 4, height: 4).opacity(step >= 2 ? 1 : 0.2)
                Circle().fill(.secondary).frame(width: 4, height: 4).opacity(step >= 3 ? 1 : 0.2)
            }
            .alignmentGuide(.firstTextBaseline) { d in d[.bottom] }
        }
        .onReceive(timer) { _ in
            withAnimation(.easeInOut(duration: 0.25)) {
                step = step % 3 + 1
            }
        }
    }
}

// MARK: - Splash

struct SplashView: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(.systemBackground), Color(.secondarySystemBackground)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack(spacing: 16) {
                Spacer()
                Image("TradeBuilt Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 360)
                    .accessibilityLabel("TradeBuilt")
                VStack(spacing: 6) {
                    LoadingBar(progress: 1) // progress animated internally over 3s
                    LoadingDots()
                        .padding(.top, 8)
                }
                .padding(.top, -140)
                Spacer()
            }
            .padding()
            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
        }
    }
}

