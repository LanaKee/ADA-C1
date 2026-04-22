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
  
  var subgoal: SubGoal
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
      Button {
          if !disabled { onTap() }
      } label: {
          HStack(alignment: .top, spacing: 12) {
              VStack(alignment: .leading, spacing: 6) {
                  HStack(alignment: .center) {
                      ZStack {
                          RoundedRectangle(cornerRadius: 8, style: .continuous)
                              .fill(status == .completed ? .treeGreen.opacity(0.8) : .accent.opacity(0.4))
                              .frame(width: 32, height: 32)

                          switch status {
                          case .normal:
                              Text("\(subgoal.id)")
                          case .completed:
                              Image(systemName: "checkmark")
                                  .foregroundStyle(.white)
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
          .contentShape(Rectangle())
          .fixedSize(horizontal: false, vertical: true)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding()
          .background(status == .completed ? .treeGreen.opacity(0.8) : .sylvaBg)
          .overlay(RoundedRectangle(cornerRadius: 16).stroke(style: StrokeStyle(lineWidth: 1)))
          .cornerRadius(16)
      }
      .buttonStyle(.plain)
      .disabled(disabled)
  }
}

#Preview ("상태별") {
  VStack(spacing: 20) {
    GoalCard(
      subgoal: SubGoal(
        id: 1,
        goal: "Swift UI를 공부하세요",
        description: "리이오와 밥을 먹으세요",
        tips: [
          FAQ(
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
      subgoal: SubGoal(
        id: 2,
        goal: "Swift UI를 공부하세요",
        description: "리이오와 밥을 먹으세요",
        tips: [
          FAQ(
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
      subgoal: SubGoal(
        id: 3,
        goal: "Swift UI를 공부하세요",
        description: "리이오와 밥을 먹으세요",
        tips: [
          FAQ(
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


