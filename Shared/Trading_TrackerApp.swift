//
//  Trading_TrackerApp.swift
//  Shared
//
//  Created by Brendan Reese on 12/29/21.
//

import SwiftUI

@main
struct Trading_TrackerApp: App {
    @StateObject private var dataController = TradeDataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
