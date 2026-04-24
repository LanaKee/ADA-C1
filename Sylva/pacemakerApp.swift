//
//  SylvaApp.swift
//  Sylva
//
//  Created by Lanakee on 3/20/26.
//

import SwiftUI
import SwiftData
import FirebaseCore
import FirebaseAppCheck

@main
struct SylvaApp: App {
  init() {
    #if DEBUG
    let providerFactory = AppCheckDebugProviderFactory()
    AppCheck.setAppCheckProviderFactory(providerFactory)
    #endif

    FirebaseApp.configure()
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
    .modelContainer(for: GoalModel.self)
  }
}
