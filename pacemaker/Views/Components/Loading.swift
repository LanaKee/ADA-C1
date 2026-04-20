//
//  Loading.swift
//  pacemaker
//
//  Created by Lanakee on 3/31/26.
//

import SwiftUI

struct Loading: View {
  let message: String
  
  init(message: String = "로딩중") {
      self.message = message
  }

  var body: some View {
    VStack(spacing: 12) {
      Spacer ()
      ProgressView()
        .foregroundStyle(.white)
        .shadow(color: .gray, radius: 4)
      Text(message)
        .font(.subheadline)
        .foregroundStyle(.white)
        .shadow(color: .gray, radius: 4)
      Spacer ()
    }
  }
}

#Preview {
  Loading()
}
