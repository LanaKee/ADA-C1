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
  let onDelete: () -> Void
  
  @Environment(\.colorScheme) var colorScheme
  @Environment(\.modelContext) var context
  @Query(sort: \GoalModel.createdAt, order: .reverse) var savedGoals: [GoalModel]

  @State private var goalToDelete: GoalModel?
  @State private var showDeleteAlert = false

  init (onDelete: @escaping () -> Void) {
    self.onDelete = onDelete
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
          if (goal.state == .active) {
            EmptyView()
          } else {
            NavigationLink {
              BonsaiDetailView(goal: goal)
            } label: {
              HStack(spacing: 12) {
                Image("img_bonsai")
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
            .padding(.horizontal, 16)
            .padding(.vertical,16)
            .listRowBackground(Color.clear)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(style: StrokeStyle(lineWidth: 1)))
            .listRowSeparator(.hidden)
            .background(.sylvaBg)
            .cornerRadius(16)
            .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
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
          onDelete()
        }
      }
    } message: {
      Text("삭제된 분재는 복구할 수 없어요")
    }
  }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: GoalModel.self, configurations: config)

    let faq = FAQ(question: "어떻게 시작하나요?", answer: "작은 것부터 시작하세요.")
    let subgoal = SubGoal(
        id: 1,
        goal: "스트레칭 하기",
        description: "매일 아침 10분 스트레칭",
        tips: [faq, faq, faq]
    )
    let breakdown = GoalBreakDown(subgoals: [subgoal])

    let sample1 = GoalModel(goal: "매일 운동하기", goals: breakdown)
    let sample2 = GoalModel(goal: "책 10권 읽기", goals: breakdown)

    container.mainContext.insert(sample1)
    container.mainContext.insert(sample2)

    return NavigationStack {
        BonsaiView {}.background(.sky)
    }
    .modelContainer(container)
}
