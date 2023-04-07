//
//  ObjectOneShotApp.swift
//  ObjectOneShot
//
//  Created by 권승용 on 2023/04/07.
//

import SwiftUI

@main
struct ObjectOneShotApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
