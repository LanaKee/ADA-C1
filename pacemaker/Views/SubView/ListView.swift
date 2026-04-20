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
  @Binding var displayPhase: GoalDisplayPhaseEnum

  var body: some View {
    Text("목표를 쉽게 이룰 수 있도록 5단계로 쪼개봤어요")
      .font(.memom(.subheadline))
      .foregroundStyle(.secondary)
      .padding(.bottom, 8)
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
//        displayPhase = .carousel()
      } label: {
        Label("시작하기", systemImage: "arrow.right")
          .frame(maxWidth: .infinity)
          .padding(.vertical, 14)
      }
      .buttonStyle(.glassProminent)
      .padding(.horizontal, 16)
      .padding(.vertical, 20)
    }
  }
}
