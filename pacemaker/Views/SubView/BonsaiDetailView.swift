//
//  BonsaiDetailView.swift
//  Sylva
//
//  Created by Lanakee on 4/20/26.
//

import SwiftUI

struct BonsaiDetailView: View {
  let goal: GoalModel

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
        Image("img_tree\(treeLevel)")
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
        }

        VStack(spacing: 0) {
          ForEach(Array(goal.goalBreakdown.subgoals.enumerated()), id: \.offset) { index, subgoal in
            NavigationLink {
              SubGoalView(
                subGoal: subgoal,
                allSubgoals: goal.goalBreakdown.subgoals,
                goalLevel: 0,
                onComplete: {}
              )
            } label: {
              HStack {
                Text("\(subgoal.id). \(subgoal.goal)")
                  .foregroundStyle(.primary)
                  .multilineTextAlignment(.leading)

                Spacer()

                Text("Detail")
                  .foregroundStyle(.secondary)

                Image(systemName: "chevron.right")
                  .font(.caption)
                  .foregroundStyle(.secondary)
              }
              .padding(.horizontal, 20)
              .padding(.vertical, 14)
            }

            if index < goal.goalBreakdown.subgoals.count - 1 {
              Divider()
                .padding(.horizontal, 20)
            }
          }
        }
        .background(.sylvaBg)
        .cornerRadius(12)
        .padding(.horizontal, 16)
      }
    }
    .background(.sky)
    .navigationTitle(goal.goal)
    .navigationBarTitleDisplayMode(.inline)
  }
}
