//
//  EmptyButtonStyle.swift
//  ObjectOneShot
//
//  Created by 권승용 on 2023/04/20.
//

import SwiftUI

struct EmptyButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
    }
}
