//
//  TradeDataController.swift
//  Trading Tracker
//
//  Created by Brendan Reese on 12/29/21.
//

import CoreData
import Foundation

class TradeDataController: ObservableObject{
    let container = NSPersistentContainer(name: "TradeData")
    
    init(){
        container.loadPersistentStores { description, error in
            if let error = error{
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
