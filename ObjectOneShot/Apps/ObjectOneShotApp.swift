//
//  ObjectOneShotApp.swift
//  ObjectOneShot
//
//  Created by 권승용 on 2023/04/07.
//

import SwiftUI

@main
struct ObjectOneShotApp: App {
    @StateObject private var coordinator = Coordinator()
    private var viewModel = OKRViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                MainView(coordinator: coordinator)
                    .environmentObject(viewModel)
            }
        }
    }
}
