//
//  ShakeEffect.swift
//  ObjectOneShot
//
//  Created by 권승용 on 2023/05/08.
//

import SwiftUI
import Combine

public struct ShakeEffect: GeometryEffect {
    public var amount: CGFloat = 5
    public var shakesPerUnit = 3
    public var animatableData: CGFloat
    
    public init(amount: CGFloat = 5, shakesPerUnit: Int = 3, animatableData: CGFloat) {
        self.amount = amount
        self.shakesPerUnit = shakesPerUnit
        self.animatableData = animatableData
    }

    public func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)), y: 0))
    }
}

extension View {
    public func shakeAnimation(_ shake: Binding<Bool>, sink: PassthroughSubject<Void, Never>) -> some View {
        modifier(ShakeEffect(animatableData: shake.wrappedValue ? 2 : 0))
            .animation(.default, value: shake.wrappedValue)
            .onReceive(sink) {
                shake.wrappedValue = true
                withAnimation(.default.delay(0.15)) { shake.wrappedValue = false }
            }
    }
}
