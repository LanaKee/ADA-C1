//
//  SproutView.swift
//  pacemaker
//
//  Created by Lanakee on 3/26/26.
//

import SwiftUI

// MARK: - Tree Level Configuration

struct TreeLevelConfig {
  let size: CGSize
  let bottomPadding: CGFloat
  
  static let configs: [Int: TreeLevelConfig] = [
    1: TreeLevelConfig(size: CGSize(width: 40, height: 50), bottomPadding: 10),
    2: TreeLevelConfig(size: CGSize(width: 60, height: 90), bottomPadding: 5),
    3: TreeLevelConfig(size: CGSize(width: 70, height: 100), bottomPadding: 5),
    4: TreeLevelConfig(size: CGSize(width: 80, height: 90), bottomPadding: 40),
    5: TreeLevelConfig(size: CGSize(width: 120, height: 180), bottomPadding: 40),
    6: TreeLevelConfig(size: CGSize(width: 140, height: 210), bottomPadding: 40),
    7: TreeLevelConfig(size: CGSize(width: 160, height: 240), bottomPadding: 40),
    8: TreeLevelConfig(size: CGSize(width: 180, height: 270), bottomPadding: 40),
    9: TreeLevelConfig(size: CGSize(width: 200, height: 300), bottomPadding: 40),
    10: TreeLevelConfig(size: CGSize(width: 220, height: 330), bottomPadding: 40),
  ]
  
  static let `default` = TreeLevelConfig(
    size: CGSize(width: 70, height: 50),
    bottomPadding: 0
  )
  
  static func config(for level: Int) -> TreeLevelConfig {
    return configs[level] ?? .default
  }
}

// MARK: - Tree View

struct Tree: View {
  let level: Int
  let onTap: () -> Void
  @State private var grow: Bool = false
  
  private var config: TreeLevelConfig {
    TreeLevelConfig.config(for: level)
  }
  
  var body: some View {
    Image("img_tree\(level)")
      .resizable()
      .frame(width: config.size.width, height: config.size.height)
      .scaleEffect(grow ? 1.0 : 0.3, anchor: .bottom)
      .offset(y: grow ? 0 : 100)
      .opacity(grow ? 1 : 0)
      .animation(.easeOut(duration: 0.6), value: grow)
      .padding(.bottom, config.bottomPadding)
      .onAppear {
        grow = true
      }
      .onTapGesture {
        onTap()
      }
  }
}

// MARK: - Preview

struct SproutPreviewWrapper: View {
  @State private var level: Int = 1
  
  var body: some View {
    VStack(spacing: 20) {
      Spacer()
      ZStack(alignment: .bottom) {
        Image("img_ground")
          .resizable()
          .frame(maxWidth: .infinity, maxHeight: 100)
        
        Tree(
          level: level,
          onTap: { }
        )
      }
      
      Stepper("", value: $level, in: 1...10)
        .padding(.horizontal)
        .labelsHidden()
    }
  }
}

#Preview {
  SproutPreviewWrapper()
}
