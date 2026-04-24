//
//  TipSkeleton.swift
//  Sylva
//
//  Created by Lanakee on 4/1/26.
//

import SwiftUI

struct TipSkeleton: View {
  @State private var phase: CGFloat = -1
  
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      RoundedRectangle(cornerRadius: 6)
        .fill(.white.opacity(0.15))
        .frame(height: 14)
        .frame(maxWidth: .infinity)
    }
    .padding(16)
    .overlay(
      LinearGradient(
        colors: [
          .clear,
          .white.opacity(0.25),
          .clear
        ],
        startPoint: .leading,
        endPoint: .trailing
      )
      .offset(x: phase * 300)
    )
    .clipShape(.rect(cornerRadius: 16))
    .glassEffect(.regular, in: .rect(cornerRadius: 16))
    .padding(.horizontal, 10)
    .onAppear {
      phase = -1

      withAnimation(
        .linear(duration: 1.5)
        .repeatForever(autoreverses: false)
      ) {
        phase = 1
      }
    }
  }
}

#Preview {
  TipSkeleton()
}
