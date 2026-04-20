//
//  RecordToolbarButton.swift
//  Sylva
//
//  Created by Lanakee on 4/20/26.
//

import SwiftUI

struct RecordToolbarButton: ToolbarContent {
  let onTap: () -> Void
  
  var body: some ToolbarContent {
    ToolbarItem(placement: .topBarLeading) {
      Button {
        onTap()
      } label: {
        Label("기록", systemImage: "clock.arrow.trianglehead.counterclockwise.rotate.90")
      }
    }
  }
}
