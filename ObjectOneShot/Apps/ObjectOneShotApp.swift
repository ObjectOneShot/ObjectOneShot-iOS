//
//  ObjectOneShotApp.swift
//  ObjectOneShot
//
//  Created by 권승용 on 2023/04/07.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

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
