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
        }
      }.frame(maxWidth: .infinity)
    }
    .background(.sky)
    .navigationTitle(goal.goal)
    .navigationBarTitleDisplayMode(.inline)
  }
}
