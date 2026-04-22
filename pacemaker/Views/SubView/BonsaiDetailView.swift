//
//  BonsaiDetailView.swift
//  Sylva
//
//  Created by Lanakee on 4/20/26.
//

import SwiftUI

struct BonsaiDetailView: View {
  let goal: GoalModel
  @State var selectedGoal: SubGoal?

  private var treeLevel: Int {
    switch goal.state {
    case .finished: return 5
    case .active: return 3
    case .givenUp: return 1
    }
  }

  private var dateRangeText: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy.MM.dd"
    let start = formatter.string(from: goal.createdAt)
    if let finished = goal.finishedAt {
      return "\(start) ~ \(formatter.string(from: finished))"
    }
    return "\(start) ~ "
  }

  var body: some View {
    ScrollView {
      VStack(spacing: 16) {
        Image("img_bonsai")
          .resizable()
          .scaledToFit()
          .frame(height: 140)
          .padding(.top, 20)

        VStack(spacing: 4) {
          Text(goal.goal)
            .font(.title2.bold())

          Text(dateRangeText)
            .font(.subheadline)
            .foregroundStyle(.secondary)

          ScrollView {
            VStack(spacing: 12) {
              ForEach(goal.goalBreakdown.subgoals, id: \.id) { subgoal in
                GoalCard(
                  subgoal: subgoal,
                  disabled: false,
                  onTap: { selectedGoal = subgoal },
                  status: .normal
                )
                .padding(.horizontal, 16)
              }
            }
            .padding(.vertical, 20)
          }
        }
      }.frame(maxWidth: .infinity)
    }
    .background(.sky)
    .navigationTitle(goal.goal)
    .navigationBarTitleDisplayMode(.inline)
    .navigationDestination(item: $selectedGoal) { g in
      SubGoalView(
        subGoal: g,
        allSubgoals:goal.goalBreakdown.subgoals,
        goalLevel: 100,
        onComplete: {}
      )
    }
  }
}

#Preview {
  BonsaiDetailView(goal: GoalModel(
    goal: "루미와 밥먹기", goals: GoalBreakDown(
      subgoals: [
        SubGoal(
          id: 1,
          goal: "루미 밥먹기",
          description: "루미의 밥을 100% 먹게 하는 것",
          tips: [
            FAQ(question: "왜 루미의 밥을 먹어야 하는가?", answer: "루미는 밥을 먹으면 건강해지고 행복해진다."),
            FAQ(question: "어떤 음식을 루미의 밥으로 사용할 수 있을까?", answer: "루미의 밥은 다양한 음식을 대체할 수 있다."),
            FAQ(question: "매일 루미의 밥을 먹어야 하는가?", answer: "매일 루미의 밥을 먹지 않아도 된다. 루미의 밥은 시간이 지나도 충분히 먹고 있다."),
          ]
          ),
        SubGoal(
          id: 1,
          goal: "루미 밥먹기",
          description: "루미의 밥을 100% 먹게 하는 것",
          tips: [
            FAQ(question: "왜 루미의 밥을 먹어야 하는가?", answer: "루미는 밥을 먹으면 건강해지고 행복해진다."),
            FAQ(question: "어떤 음식을 루미의 밥으로 사용할 수 있을까?", answer: "루미의 밥은 다양한 음식을 대체할 수 있다."),
            FAQ(question: "매일 루미의 밥을 먹어야 하는가?", answer: "매일 루미의 밥을 먹지 않아도 된다. 루미의 밥은 시간이 지나도 충분히 먹고 있다."),
          ]
          ),
        SubGoal(
          id: 1,
          goal: "루미 밥먹기",
          description: "루미의 밥을 100% 먹게 하는 것",
          tips: [
            FAQ(question: "왜 루미의 밥을 먹어야 하는가?", answer: "루미는 밥을 먹으면 건강해지고 행복해진다."),
            FAQ(question: "어떤 음식을 루미의 밥으로 사용할 수 있을까?", answer: "루미의 밥은 다양한 음식을 대체할 수 있다."),
            FAQ(question: "매일 루미의 밥을 먹어야 하는가?", answer: "매일 루미의 밥을 먹지 않아도 된다. 루미의 밥은 시간이 지나도 충분히 먹고 있다."),
          ]
          )
      ]
    )
  ))
}
