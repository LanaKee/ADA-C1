//
//  GoalCard.swift
//  pacemaker
//
//  Created by Lanakee on 3/27/26.
//

import SwiftUI

struct GoalCard: View {
  @Environment(\.colorScheme) private var colorScheme
  var subgoal: GoalPlanResponse
  let onTap: () -> Void

  var body: some View {
    HStack(alignment: .top, spacing: 12) {
      Rectangle()
        .fill(.accent)
        .frame(width: 3)
        .clipShape(Capsule())
      
      VStack(alignment: .leading, spacing: 6) {
        Text("\(subgoal.id) \(subgoal.goal)")
          .font(.headline)
          .padding(.bottom, 5)
        
        Text(subgoal.description)
      }
      .padding(.leading, 10)
      Spacer()
      Image(systemName: "chevron.right")
          .font(.caption.weight(.semibold))
          .foregroundStyle(.secondary)
    }
    .fixedSize(horizontal: false, vertical: true)
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding()
    .background(
        RoundedRectangle(cornerRadius: 20)
            .fill(colorScheme == .light ? .gray.opacity(0.07) : .gray.opacity(0.3))
    )
    .shadow(radius: 10)
    .padding(.horizontal, 20)
    .onTapGesture {
      onTap()
    }
  }
}

#Preview {
  GoalCard(
    subgoal: GoalPlanResponse(
      id: 1,
      goal: "Swift UI를 공부하세요",
      description: "리이오와 밥을 먹으세요"
    ),
    onTap: {}
  )
}
