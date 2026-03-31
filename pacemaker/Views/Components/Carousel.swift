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
  @Binding var currentIndex: Int

  @GestureState private var dragOffset: CGFloat = 0


  init(
    pageCount: Int,
    visibleEdgeSpace: CGFloat,
    spacing: CGFloat,
    @ViewBuilder content: @escaping (PageIndex) -> Content,
    currentIndex: Binding<Int> = .constant(0)
    
  ) {
    self.pageCount = pageCount
    self.visibleEdgeSpace = visibleEdgeSpace
    self.spacing = spacing
    self.content = content
    self._currentIndex = currentIndex
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
      .contentShape(Rectangle())
      .gesture(
        DragGesture(minimumDistance: 15, coordinateSpace: .local)
          .updating($dragOffset) { value, out, _ in
            out = value.translation.width
          }
          .onEnded { value in
            let offsetX = value.translation.width
            let progress = -offsetX / pageWidth

            let predictedOffset = value.predictedEndTranslation.width
            let predictedProgress = -predictedOffset / pageWidth

            let increment: Int
            if abs(progress) > 0.3 {
              increment = progress > 0 ? 1 : -1
            } else if abs(predictedProgress) > 0.3 {
              increment = predictedProgress > 0 ? 1 : -1
            } else {
              increment = 0
            }

            currentIndex = max(min(currentIndex + increment, pageCount - 1), 0)
          }
      )
      .offset(x: offsetX)
      .animation(.interpolatingSpring(stiffness: 300, damping: 30), value: currentIndex)
      .animation(.interpolatingSpring(stiffness: 300, damping: 30), value: dragOffset)
      .frame(
        width: proxy.size.width,
        height: proxy.size.height,
        alignment: .topLeading
      )
    }
  }
}



#Preview {
  VStack {
    Spacer()

    Carousel(pageCount: 5, visibleEdgeSpace: 40, spacing: 12) { index in
      RoundedRectangle(cornerRadius: 16)
        .fill(.blue)
        .frame(height: 120 + CGFloat(index) * 50)
        .overlay {
          Text("Page \(index)")
            .font(.title)
            .bold()
            .foregroundColor(.white)
        }
    }
    .padding(.horizontal, 20)

    Spacer()
  }
}
