//
//  BonsaiView.swift
//  Sylva
//
//  Created by Lanakee on 4/16/26.
//
import SwiftUI

struct BonsaiView: View {
  @Environment(\.colorScheme) var colorScheme

  var body: some View {
    VStack {
      Text("Hello, World!")
        .foregroundColor(.primary)
    }
  }
}

#Preview {
  BonsaiView()
}
