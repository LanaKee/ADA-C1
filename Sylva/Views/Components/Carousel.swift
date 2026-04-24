//
//  Carousel.swift
//  Sylva
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
  
  @State private var dragOffset: CGFloat = 0
  @State private var isDragging: Bool = false
  
  private let velocityThreshold: CGFloat = 300
  private let progressThreshold: CGFloat = 0.3
  
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
      + CGFloat(currentIndex) * -(pageWidth + spacing)
      + dragOffset
      
      HStack(alignment: .top, spacing: spacing) {
        ForEach(0..<pageCount, id: \.self) { pageIndex in
          content(pageIndex)
            .frame(width: pageWidth, alignment: .topLeading)
        }
      }
      .offset(x: offsetX)
      .animation(
        isDragging
        ? .interactiveSpring(response: 0.15, dampingFraction: 0.86)
        : .interpolatingSpring(stiffness: 280, damping: 26),
        value: offsetX
      )
      .simultaneousGesture(
        DragGesture(minimumDistance: 5, coordinateSpace: .local)
          .onChanged { value in
            isDragging = true
            
            // 가장자리 저항감 (rubber banding)
            let raw = value.translation.width
            let isOverscrolling =
            (currentIndex == 0 && raw > 0) ||
            (currentIndex == pageCount - 1 && raw < 0)
            
            if isOverscrolling {
              dragOffset = raw * 0.3  // 고무줄 효과
            } else {
              dragOffset = raw
            }
          }
          .onEnded { value in
            isDragging = false
            
            let offsetX = value.translation.width
            let velocity = value.predictedEndTranslation.width - offsetX
            let progress = -offsetX / pageWidth
            
            let increment: Int
            if abs(velocity) > velocityThreshold {
              // 빠른 플릭 — 속도 기반 판단
              increment = velocity < 0 ? 1 : -1
            } else if abs(progress) > progressThreshold {
              // 느린 드래그 — 거리 기반 판단
              increment = progress > 0 ? 1 : -1
            } else {
              increment = 0
            }
            
            let newIndex = max(min(currentIndex + increment, pageCount - 1), 0)
            dragOffset = 0
            currentIndex = newIndex
          }
      )
      .frame(
        width: proxy.size.width,
        height: proxy.size.height,
        alignment: .topLeading
      )
    }
  }
}

#Preview {
  @Previewable @State var index = 0
  
  VStack {
    Spacer()
    
    Carousel(
      pageCount: 5,
      visibleEdgeSpace: 40,
      spacing: 12,
      content:  { i in
        RoundedRectangle(cornerRadius: 16)
          .fill(.blue)
          .frame(height: 120 + CGFloat(i) * 50)
          .overlay {
            Text("Page \(i)")
              .font(.title)
              .bold()
              .foregroundColor(.white)
          }
      }, currentIndex: $index)
    .padding(.horizontal, 20)
    
    Spacer()
  }
}
