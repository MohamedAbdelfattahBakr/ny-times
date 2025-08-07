//
//  ShimmerViewModifier.swift
//  ny-times
//
//  Created by Personal on 07/08/2025.
//

import SwiftUI

struct ShimmerViewModifier: ViewModifier {
    @State private var phase: CGFloat = -150
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.25),
                            Color.white.opacity(0.9),
                            Color.white.opacity(0.25)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(width: geo.size.width * 1.5)
                    .rotationEffect(.degrees(30))
                    .offset(x: phase)
                    .mask(content)
                }
            )
            .onAppear {
                withAnimation(.linear(duration: 1.1).repeatForever(autoreverses: false)) {
                    phase = 450
                }
            }
    }
}
extension View { func shimmer() -> some View { modifier(ShimmerViewModifier()) } }
