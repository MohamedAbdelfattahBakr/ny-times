//
//  Animation+Extensions.swift
//  ny-times
//
//  Created by Personal on 07/08/2025.
//
import SwiftUI

extension Animation {
    static func repeatWhile<T: Equatable>(
        _ expression: T,
        duration: Double = 1
    ) -> Animation {
        return expression == true as? T ?
            .linear(duration: duration).repeatForever(autoreverses: false) :
            .default
    }
}
