//
//  SubGoalView.swift
//  pacemaker
//
//  Created by Lanakee on 3/27/26.
//

import SwiftUI

struct SubGoalView: View {
  let subGoal: GoalPlanResponse?
  let allSubgoals: [GoalPlanResponse]
  let onComplete: () -> Void

  @Environment(\.dismiss) private var dismiss
  @State private var tips: [SubGoalTip] = []
  @State private var expandedTipIndex: Int? = nil

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(spacing: 0) {
          VStack {
            HStack(alignment: .top) {
              ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                  .fill(Color.accentColor.opacity(0.15))
                  .frame(width: 56, height: 56)

                Text("\(subGoal?.id ?? 0)")
                  .font(.title2.bold())
                  .foregroundStyle(Color.accentColor)
              }
              .padding(.horizontal, 30)
              .padding(.top, 20)

              Spacer()
            }

            Text(subGoal?.goal ?? "불러오는중")
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(.horizontal, 30)
              .font(.title2.bold())

            Text(subGoal?.description ?? "설명이 없어요")
              .frame(maxWidth: .infinity, alignment: .leading)
              .font(.subheadline)
              .padding(.horizontal, 30)
              .padding(.bottom, 20)
          }
          .glassEffect(.regular, in: .rect(cornerRadius: 25))
          .padding(10)

          VStack(alignment: .leading, spacing: 12) {
            HStack {
              Image(systemName: "lightbulb.fill")
                .foregroundStyle(.yellow)
              Text("이런 게 궁금하지 않나요?")
                .font(.headline)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
          
            ForEach(Array((subGoal?.tips ?? []).enumerated()), id: \.offset) { index, tip in
              VStack(alignment: .leading, spacing: 0) {
                Button {
                  withAnimation(.easeInOut(duration: 0.25)) {
                    expandedTipIndex = expandedTipIndex == index ? nil : index
                  }
                } label: {
                  HStack {
                    Text(tip.question)
                      .font(.subheadline.bold())
                      .multilineTextAlignment(.leading)
                      .frame(maxWidth: .infinity, alignment: .leading)

                    Image(systemName: "chevron.down")
                      .font(.caption.bold())
                      .foregroundStyle(.secondary)
                      .rotationEffect(.degrees(expandedTipIndex == index ? 180 : 0))
                  }
                  .padding(16)
                }
                .buttonStyle(.plain)

                if expandedTipIndex == index {
                  Text(tip.answer)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
              }
              .glassEffect(.regular, in: .rect(cornerRadius: 16))
              .padding(.horizontal, 10)
            }
          }
          .padding(.top, 6)

          Button {
            onComplete()
            dismiss()
          } label: {
            Label("완료했어요", systemImage: "checkmark.circle.fill")
              .padding(10)
          }
          .buttonStyle(.glass)
          .tint(.green)
          .padding(10)
        }
      }
      .navigationTitle(subGoal?.goal ?? "로딩중...")
    }
  }
}
#Preview {
  SubGoalView(
    subGoal:
      GoalPlanResponse(
        id: 2,
        goal: "리이오와 밥 약속 잡기",
        description: "리이오와 밥을 먹으세요",
        tips: [
          SubGoalTip(question: "리이오와 어떻게 밥을 먹나요", answer: "리이오는 밥먹기 예약 폼을 운영합니다")
        ]
      ),
    allSubgoals: [
      GoalPlanResponse(
        id: 1,
        goal: "리이오와 밥 약속 잡기",
        description: "리이오와 밥을 먹으세요",
        tips: [
          SubGoalTip(question: "리이오와 어떻게 밥을 먹나요", answer: "리이오는 밥먹기 예약 폼을 운영합니다")
        ]
      ),
      GoalPlanResponse(
        id: 2,
        goal: "리이오와 밥 약속 잡기",
        description: "리이오와 밥을 먹으세요",
        tips: [
          SubGoalTip(question: "리이오와 어떻게 밥을 먹나요", answer: "리이오는 밥먹기 예약 폼을 운영합니다")
        ]
      ),
    ],
    onComplete: {}
  )
}
