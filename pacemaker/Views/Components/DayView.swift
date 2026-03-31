//
//  DayView.swift
//  pacemaker
//
//  Created by Lanakee on 3/31/26.
//

import SwiftUI

struct DayView: View {
  @Environment(\.colorScheme) var colorScheme
  
  var body: some View {
    ZStack {
      //MARK: - 밤하늘
      if colorScheme == .dark {
        LinearGradient(
          colors: [
            Color(red: 0.05, green: 0.05, blue: 0.15),
            Color(red: 0.08, green: 0.10, blue: 0.25),
            Color(red: 0.12, green: 0.15, blue: 0.35),
            Color(red: 0.18, green: 0.20, blue: 0.40)
          ],
          startPoint: .top,
          endPoint: .bottom
        )

        // 별
        GeometryReader { geo in
          let stars: [(x: CGFloat, y: CGFloat, size: CGFloat, opacity: Double)] = [
            (0.1, 0.05, 3, 0.9), (0.3, 0.08, 2, 0.7), (0.7, 0.04, 2.5, 0.8),
            (0.85, 0.12, 2, 0.6), (0.15, 0.2, 1.5, 0.5), (0.5, 0.15, 3, 0.85),
            (0.65, 0.22, 2, 0.7), (0.9, 0.28, 1.5, 0.55), (0.25, 0.32, 2.5, 0.75),
            (0.45, 0.38, 2, 0.6), (0.78, 0.42, 3, 0.8), (0.05, 0.45, 2, 0.65),
            (0.55, 0.5, 1.5, 0.5), (0.35, 0.55, 2.5, 0.7), (0.82, 0.58, 2, 0.6)
          ]
          ForEach(Array(stars.enumerated()), id: \.offset) { _, star in
            Circle()
              .fill(.white.opacity(star.opacity))
              .frame(width: star.size, height: star.size)
              .position(
                x: geo.size.width * star.x,
                y: geo.size.height * star.y
              )
          }

          // 달
          Circle()
            .fill(Color(red: 0.95, green: 0.93, blue: 0.82))
            .frame(width: 30, height: 30)
            .offset(x: geo.size.width * 0.8, y: geo.size.height * 0.1)
        }
      } else {
        //MARK: - 낯 하늘
        LinearGradient(
          colors: [
            Color(red: 0.40, green: 0.70, blue: 0.95),
            Color(red: 0.53, green: 0.81, blue: 0.98),
            Color(red: 0.72, green: 0.90, blue: 1.0),
            Color(red: 0.88, green: 0.96, blue: 1.0)
          ],
          startPoint: .top,
          endPoint: .bottom
        )

        // 구름
        GeometryReader { geo in
          Ellipse()
            .fill(.white.opacity(0.5))
            .frame(width: 180, height: 40)
            .blur(radius: 15)
            .offset(x: geo.size.width * 0.55, y: geo.size.height * 0.08)

          Ellipse()
            .fill(.white.opacity(0.4))
            .frame(width: 140, height: 30)
            .blur(radius: 12)
            .offset(x: geo.size.width * 0.1, y: geo.size.height * 0.18)

          Ellipse()
            .fill(.white.opacity(0.35))
            .frame(width: 200, height: 35)
            .blur(radius: 14)
            .offset(x: geo.size.width * 0.35, y: geo.size.height * 0.35)

          Ellipse()
            .fill(.white.opacity(0.3))
            .frame(width: 120, height: 25)
            .blur(radius: 10)
            .offset(x: geo.size.width * 0.7, y: geo.size.height * 0.55)
        }
      }
    }
    .ignoresSafeArea()
  }
}
