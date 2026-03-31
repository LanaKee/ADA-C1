//
//  Loading.swift
//  pacemaker
//
//  Created by Lanakee on 3/31/26.
//

import SwiftUI

struct Loading: View {
  let message: String
  var body: some View {
    VStack(spacing: 12) {
      Spacer ()
      ProgressView()
      Text(message)
        .font(.subheadline)
        .foregroundStyle(.secondary)
      Spacer ()
    }
    .padding(.top, 20)
  }
}

#Preview {
  Loading(message: "로딩중")
}
