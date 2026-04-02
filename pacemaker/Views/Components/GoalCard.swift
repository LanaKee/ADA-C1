//
//  GoalCard.swift
//  pacemaker
//
//  Created by Lanakee on 3/27/26.
//

import SwiftUI

enum GoalCardStatus {
  case normal
  case completed
  case inProgress
}


struct GoalCard: View {
  @Environment(\.colorScheme) private var colorScheme
  
  var subgoal: GoalPlanResponse
  let disabled: Bool
  let onTap: () -> Void
  let status: GoalCardStatus
  
  private var statusColor: Color {
    switch status {
    case .normal:
      return .accentColor
    case .completed:
      return .green
    case .inProgress:
      return .blue
    }
  }
  
  var body: some View {
    ZStack {
      HStack(alignment: .top, spacing: 12) {
        Rectangle()
          .fill(statusColor)
          .frame(width: 3)
          .clipShape(Capsule())
        
        VStack(alignment: .leading, spacing: 6) {
          HStack(alignment: .center) {
            ZStack {
              RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(statusColor.opacity(0.15))
                .frame(width: 32, height: 32)
              
              switch status {
              case .normal:
                Text("\(subgoal.id)")
              case .completed:
                Image(systemName: "checkmark")
              case .inProgress:
                Text("\(subgoal.id)")
              }
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
      .blur(radius: (disabled ? 5 : 0))
      .fixedSize(horizontal: false, vertical: true)
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding()
      .glassEffect(.regular, in: .rect(cornerRadius: 15))
      .shadow(radius: 10)
      .simultaneousGesture(TapGesture().onEnded {
        onTap()
      })
      if disabled {
        VStack (spacing: 0) {
          Image(systemName: "lock.fill")
            .font(.system(size: 24))
            .padding(.bottom, 10)
            .shadow(radius: 10)
          Text("이전 목표를 완료하고 확인해 보세요")
            .font(.headline.bold())
        }
      }
    }
  }
}

#Preview ("상태별") {
  VStack(spacing: 20) {
    GoalCard(
      subgoal: GoalPlanResponse(
        id: 1,
        goal: "Swift UI를 공부하세요",
        description: "리이오와 밥을 먹으세요",
        tips: [
          SubGoalTip(
            question: "리이오와 어떻게 밥을 먹을 수 있나요?",
            answer: "리이오는 밥 먹기 예약 폼을 운영합니다"
          )
        ]
      ),
      disabled: false,
      onTap: {},
      status: .normal
    )
    
    GoalCard(
      subgoal: GoalPlanResponse(
        id: 2,
        goal: "Swift UI를 공부하세요",
        description: "리이오와 밥을 먹으세요",
        tips: [
          SubGoalTip(
            question: "리이오와 어떻게 밥을 먹을 수 있나요?",
            answer: "리이오는 밥 먹기 예약 폼을 운영합니다"
          )
        ]
      ),
      disabled: false,
      onTap: {},
      status: .inProgress
    )
    
    GoalCard(
      subgoal: GoalPlanResponse(
        id: 3,
        goal: "Swift UI를 공부하세요",
        description: "리이오와 밥을 먹으세요",
        tips: [
          SubGoalTip(
            question: "리이오와 어떻게 밥을 먹을 수 있나요?",
            answer: "리이오는 밥 먹기 예약 폼을 운영합니다"
          )
        ]
      ),
      disabled: false,
      onTap: {},
      status: .completed
    )
  }
  .padding(20)
}

#Preview ("비활성화") {
  GoalCard(
    subgoal: GoalPlanResponse(
      id: 4,
      goal: "Swift UI를 공부하세요",
      description: "리이오와 밥을 먹으세요",
      tips: [
        SubGoalTip(
          question: "리이오와 어떻게 밥을 먹을 수 있나요?",
          answer: "리이오는 밥 먹기 예약 폼을 운영합니다"
        )
      ]
    ),
    disabled: true,
    onTap: {},
    status: .normal
  ).padding(20)
}


