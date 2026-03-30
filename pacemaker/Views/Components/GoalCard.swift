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
  let disabled: Bool
  let onTap: () -> Void
  
  var body: some View {
    ZStack {
      HStack(alignment: .top, spacing: 12) {
        Rectangle()
          .fill(.accent)
          .frame(width: 3)
          .clipShape(Capsule())
        
        VStack(alignment: .leading, spacing: 6) {
          HStack(alignment: .center) {
            ZStack {
              RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color.accentColor.opacity(0.15))
                .frame(width: 32, height: 32)
              
              Text("\(subgoal.id)")
                .font(.title2.bold())
                .foregroundStyle(Color.accentColor)
            }
            
            Text(subgoal.goal)
              .font(.headline.bold())
            
            Spacer()
          }
          
          Text(subgoal.description)
        }
        .padding(.leading, 10)
        Spacer()
        if !disabled {
          Image(systemName: "chevron.right")
            .font(.caption.weight(.semibold))
            .foregroundStyle(.secondary)
        }
      }
      .blur(radius: (disabled ? 3 : 0))
      .fixedSize(horizontal: false, vertical: true)
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding()
      .glassEffect(.regular, in: .rect(cornerRadius: 15))
      .shadow(radius: 10)
      .onTapGesture {
        onTap()
      }
      if disabled {
        Image(systemName: "lock.fill")
          .font(.system(size: 32))
          .padding()
      }
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
    disabled: false,
    onTap: {},

  ).padding(20)
  GoalCard(
    subgoal: GoalPlanResponse(
      id: 1,
      goal: "Swift UI를 공부하세요",
      description: "리이오와 밥을 먹으세요"
    ),
    disabled: true,
    onTap: {}
  ).padding(20)
}
