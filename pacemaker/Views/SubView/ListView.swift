//
//  ListView.swift
//  pacemaker
//
//  Created by Lanakee on 4/2/26.
//

import SwiftUI

struct ListView: View {
  let subgoals: [SubGoal]
  let goalLevel: Int
  let showStartButton: Bool
  @Binding var selectedGoal: SubGoal?
  let onTap: () -> Void

  var body: some View {
    Text("목표를 쉽게 이룰 수 있도록 5단계로 쪼개봤어요")
      .font(.memom(.subheadline))
      .foregroundStyle(.secondary)
      .padding(.horizontal, 8)
    ScrollView {
      VStack(spacing: 12) {
        ForEach(subgoals, id: \.id) { subgoal in
          GoalCard(
            subgoal: subgoal,
            disabled: false,
            onTap: { selectedGoal = subgoal },
            status: goalLevel > subgoal.id ? .completed : .normal
          )
          .padding(.horizontal, 16)
        }
      }
      .padding(.vertical, 20)
    }
    if showStartButton {
      Button {
        onTap()
      } label: {
        Label("시작하기", systemImage: "arrow.right")
          .frame(maxWidth: .infinity)
          .padding(.vertical, 14)
      }
      .tint(.accent)
      .buttonStyle(.borderedProminent)
      .padding(.horizontal, 16)
      .padding(.vertical, 20)
    }
  }
}

#Preview {
  Button {

  } label: {
    Label("시작하기", systemImage: "arrow.right")
      .frame(maxWidth: .infinity)
      .padding(.vertical, 14)
  }
  .tint(.accent)
  .buttonStyle(.borderedProminent)
  .padding(.horizontal, 16)
  .padding(.vertical, 20)
}
