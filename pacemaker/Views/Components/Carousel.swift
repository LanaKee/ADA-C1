//
//  Carousel.swift
//  pacemaker
//
//  Created by Lanakee on 3/30/26.
//

import SwiftUI

struct Carousel<Content: View>: View {
  typealias PageIndex = Int

  let pageCount: Int
  let visibleEdgeSpace: CGFloat
  let spacing: CGFloat
  let content: (PageIndex) -> Content

  @GestureState private var dragOffset: CGFloat = 0
  @State private var currentIndex: Int = 0

  init(
    pageCount: Int,
    visibleEdgeSpace: CGFloat,
    spacing: CGFloat,
    @ViewBuilder content: @escaping (PageIndex) -> Content
  ) {
    self.pageCount = pageCount
    self.visibleEdgeSpace = visibleEdgeSpace
    self.spacing = spacing
    self.content = content
  }

  var body: some View {
    GeometryReader { proxy in
      let baseOffset: CGFloat = spacing + visibleEdgeSpace
      let pageWidth: CGFloat = proxy.size.width - (visibleEdgeSpace + spacing) * 2
      let offsetX: CGFloat =
        baseOffset
        + CGFloat(currentIndex) * -pageWidth
        + CGFloat(currentIndex) * -spacing
        + dragOffset

      HStack(alignment: .top, spacing: spacing) {
        ForEach(0..<pageCount, id: \.self) { pageIndex in
          content(pageIndex)
            .frame(
              width: pageWidth,
              alignment: .topLeading
            )
        }
      }
      .offset(x: offsetX)
      .animation(.interpolatingSpring(stiffness: 300, damping: 30), value: currentIndex)
      .animation(.interpolatingSpring(stiffness: 300, damping: 30), value: dragOffset)
      .frame(
        width: proxy.size.width,
        height: proxy.size.height,
        alignment: .topLeading
      )
      .gesture(
        DragGesture()
          .updating($dragOffset) { value, out, _ in
            out = value.translation.width
          }
          .onEnded { value in
            let offsetX = value.translation.width
            let progress = -offsetX / pageWidth

            let predictedOffset = value.predictedEndTranslation.width
            let predictedProgress = -predictedOffset / pageWidth

            let increment: Int
            if abs(predictedProgress) > 0.5 {
              increment = predictedProgress > 0 ? 1 : -1
            } else {
              increment = Int(progress.rounded())
            }

            currentIndex = max(min(currentIndex + increment, pageCount - 1), 0)
          }
      )
    }
  }
}
