//
//  DayView.swift
//  pacemaker
//
//  Created by Lanakee on 3/31/26.
//

import SwiftUI

struct DayViewReduced: View {
  @Environment(\.colorScheme) var colorScheme
  
  var body: some View {
    ZStack {
      //MARK: - 밤하늘
      if colorScheme == .dark {
        LinearGradient(
          colors: [
            Color(red: 0.05, green: 0.05, blue: 0.15),
            Color(red: 0.08, green: 0.10, blue: 0.25),
            Color(red: 0.12, green: 0.15, blue: 0.35),
            Color(red: 0.18, green: 0.20, blue: 0.40)
          ],
          startPoint: .top,
          endPoint: .bottom
        )
      } else {
        //MARK: - 낯 하늘
        LinearGradient(
          colors: [
            Color(red: 0.40, green: 0.70, blue: 0.95),
            Color(red: 0.53, green: 0.81, blue: 0.98),
            Color(red: 0.72, green: 0.90, blue: 1.0),
            Color(red: 0.88, green: 0.96, blue: 1.0)
          ],
          startPoint: .top,
          endPoint: .bottom
        )
      }
    }
    .ignoresSafeArea()
  }
}
