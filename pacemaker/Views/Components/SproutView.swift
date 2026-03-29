//
//  SproutView.swift
//  pacemaker
//
//  Created by Lanakee on 3/26/26.
//

import SwiftUI



struct SproutView: View {
  let level: Int
  let onTap: () -> Void
  @State private var grow: Bool = false
  
  private var sproutSize: CGSize {
    switch level {
    case 1: return CGSize(width: 120, height: 80)
    case 2: return CGSize(width: 140, height: 150)
    case 3: return CGSize(width: 160, height: 170)
    case 4: return CGSize(width: 220, height: 260)
    case 5: return CGSize(width: 250, height: 290)
    default: return CGSize(width: 120, height: 120)
    }
  }
  
  var body: some View {
    Image("sprout\(level)")
      .resizable()
      .frame(width: sproutSize.width, height: sproutSize.height)
      .scaleEffect(grow ? 1.0 : 0.3, anchor: .bottom)
      .offset(y: grow ? 0 : 100)
      .opacity(grow ? 1 : 0)
      .animation(.easeOut(duration: 0.6), value: grow)
      .onAppear {
        grow = true
      }
      .onTapGesture {
        onTap()
      }
  }
}

struct SproutPreviewWrapper: View {
    @State private var level: Int = 1

    var body: some View {
        VStack(spacing: 20) {
            SproutView(
                level: level,
                onTap: { }
            )

            Stepper("", value: $level, in: 1...5)
                .padding(.horizontal)
                .labelsHidden()
        }
        .padding()
    }
}

#Preview {
    SproutPreviewWrapper()
}
