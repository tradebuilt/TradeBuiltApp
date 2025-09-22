//
//  MainMenuView.swift
//  HVAC Field Calculators
//
//  Created by Freedom Mechanical LLC on 9/20/25.
//

import SwiftUI
import Combine

struct MainMenuView: View {
    @State private var showSplash: Bool = true
    @State private var overlayOpacity: Double = 1
    @State private var contentOpacity: Double = 0
    @State private var navPath: NavigationPath = NavigationPath()

    // Removed grid/placeholder data now that selection flow is disabled

    var body: some View {
        NavigationStack(path: $navPath) {
            ZStack {
                BackgroundView()
                VStack(alignment: .leading, spacing: 20) {
                    HeaderTitleView(navigateToHVAC: { navPath.append(Route.hvac) })
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
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .hvac:
                    SkilledTradesCalculatorsView()
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
    MainMenuView()
}

// MARK: - Models

// Removed Calculator model (not used in the current design)

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

enum Route: Hashable {
    case hvac
}

struct HeaderTitleView: View {
    @State private var playHVACAnim: Bool = false
    var navigateToHVAC: () -> Void = {}
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
            Button {
                withAnimation(.spring(response: 0.22, dampingFraction: 0.7)) {
                    playHVACAnim = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
                    withAnimation(.easeOut(duration: 0.12)) {
                        playHVACAnim = false
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.36) {
                    navigateToHVAC()
                }
            } label: {
                HVACCategoryButton(width: 320, animate: playHVACAnim)
            }
            .buttonStyle(.plain)
            .padding(.top, -80)
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

// Removed old CategoriesView and CategoryButtonLabel per updated design

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

// Removed CalculatorCard (not used in the current design)

// Removed CalculatorDetailView (not used in the current design)

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

struct HVACCategoryButton: View {
    var width: CGFloat = 180
    var animate: Bool = false
    var title: String = "Skilled Trades Calculators"

    var body: some View {
        ZStack {
            // Base shape
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(LinearGradient(colors: [
                    Color(.systemGray6),
                    Color(.systemGray3)
                ], startPoint: .topLeading, endPoint: .bottomTrailing))
                // Elevation shadows
                .shadow(color: .black.opacity(0.28), radius: animate ? 10 : 16, x: 0, y: animate ? 6 : 12)
                .shadow(color: .black.opacity(0.12), radius: animate ? 2 : 4, x: 0, y: animate ? 1 : 2)
                .overlay(
                    // Inner highlight for bevel effect
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(LinearGradient(colors: [
                            .white.opacity(0.6),
                            .white.opacity(0.08)
                        ], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1.2)
                        .blendMode(.overlay)
                )
                .overlay(
                    // Subtle inner shadow look
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(.black.opacity(0.08), lineWidth: 1)
                        .blur(radius: 1)
                        .offset(y: 1)
                        .mask(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(LinearGradient(colors: [.black, .clear], startPoint: .top, endPoint: .bottom))
                        )
                )
                .overlay(
                    // Directional inner shadow from top-left for depth
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(.black.opacity(0.06), lineWidth: 1)
                        .blur(radius: 1.5)
                        .offset(x: 0.5, y: 0.5)
                        .mask(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(LinearGradient(colors: [.black, .clear], startPoint: .topLeading, endPoint: .bottomTrailing))
                        )
                )
                .overlay(alignment: .top) {
                    // Specular highlight (gloss) at the top
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(LinearGradient(colors: [
                            .white.opacity(0.35),
                            .white.opacity(0.0)
                        ], startPoint: .top, endPoint: .bottom))
                        .frame(height: 22)
                        .blur(radius: 2)
                        .padding(.horizontal, 8)
                        .offset(y: 4)
                }
                .overlay(alignment: .bottom) {
                    // Bottom rim light for a 3D edge
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(LinearGradient(colors: [
                            .clear,
                            .black.opacity(0.22)
                        ], startPoint: .top, endPoint: .bottom), lineWidth: 2)
                        .blur(radius: 1)
                        .opacity(0.8)
                }
                .overlay(
                    // Animated glow when pressed
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(.white.opacity(animate ? 0.35 : 0.0), lineWidth: 3)
                        .blur(radius: 3)
                )

            // Text
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 1) // text shadow
        }
        .frame(width: width, height: 56)
        .scaleEffect(animate ? 0.96 : 1.0)
        .animation(.spring(response: 0.22, dampingFraction: 0.7), value: animate)
        .accessibilityElement(children: .combine)
    }
}

// Removed HVACCategoryView per updated design

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



