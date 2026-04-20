//
//  pacemakerApp.swift
//  pacemaker
//
//  Created by Lanakee on 3/20/26.
//

import SwiftUI
import SwiftData
import FirebaseCore
import FirebaseAppCheck

@main
struct pacemakerApp: App {
  init() {
    #if DEBUG
    let providerFactory = AppCheckDebugProviderFactory()
    AppCheck.setAppCheckProviderFactory(providerFactory)
    #endif

    FirebaseApp.configure()
  }
  
  var sharedModelContainer: ModelContainer = {
    let schema = Schema([
      Item.self,
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    
    do {
      return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }()
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
    .modelContainer(sharedModelContainer)
  }
}
