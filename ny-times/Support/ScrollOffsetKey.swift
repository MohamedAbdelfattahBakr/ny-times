//
//  ScrollOffsetKey.swift
//  ny-times
//
//  Created by Personal on 07/08/2025.
//

import SwiftUI

// MARK: – Helper to pass the scroll offset up the view tree
private struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
