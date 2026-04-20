//
//  BonsaiView.swift
//  Sylva
//
//  Created by Lanakee on 4/16/26.
//
import SwiftUI
import SwiftData

import SwiftUI
import SwiftData

struct BonsaiView: View {
  @Environment(\.colorScheme) var colorScheme
  @Environment(\.modelContext) var context
  @Query(sort: \GoalModel.createdAt, order: .reverse) var savedGoals: [GoalModel]

  @State private var goalToDelete: GoalModel?
  @State private var showDeleteAlert = false

  private func treeLevel(for goal: GoalModel) -> Int {
    switch goal.state {
    case .finished: return 5
    case .active: return 3
    case .givenUp: return 1
    }
  }

  private func dateRangeText(for goal: GoalModel) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy.MM.dd"
    let start = formatter.string(from: goal.createdAt)
    if let finished = goal.finishedAt {
      return "\(start) ~ \(formatter.string(from: finished))"
    }
    return "\(start) ~ "
  }

  var body: some View {
    VStack(spacing: 0) {
      Text("분재")
        .font(.memom(.title))
        .padding(.top, 8)
        .padding(.bottom, 12)

      List {
        ForEach(savedGoals, id: \.id) { goal in
          NavigationLink {
            BonsaiDetailView(goal: goal)
          } label: {
            HStack(spacing: 12) {
              Image("img_tree\(treeLevel(for: goal))")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)

              VStack(alignment: .leading, spacing: 4) {
                Text(goal.goal)
                  .font(.headline.bold())
                  .foregroundStyle(.primary)
                  .multilineTextAlignment(.leading)

                Text(dateRangeText(for: goal))
                  .font(.caption)
                  .foregroundStyle(.secondary)
              }
            }
          }
          .listRowBackground(Color.sylvaBg)
          .listRowSeparator(.hidden)
          .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
              goalToDelete = goal
              showDeleteAlert = true
            } label: {
              Label("삭제", systemImage: "xmark")
            }
          }
        }
      }
      .listStyle(.plain)
      .scrollContentBackground(.hidden)
    }
    .alert("정말로 삭제할까요?", isPresented: $showDeleteAlert) {
      Button("취소", role: .cancel) {
        goalToDelete = nil
      }
      Button("삭제", role: .destructive) {
        if let goal = goalToDelete {
          context.delete(goal)
          goalToDelete = nil
        }
      }
    } message: {
      Text("삭제된 분재는 복구할 수 없어요")
    }
  }
}

