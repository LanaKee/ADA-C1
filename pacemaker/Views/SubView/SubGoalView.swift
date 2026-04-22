//
//  SubGoalView.swift
//  pacemaker
//
//  Created by Lanakee on 3/27/26.
//

import SwiftUI

struct SubGoalView: View {
  let subGoal: SubGoal?
  let allSubgoals: [SubGoal]
  let goalLevel: Int
  let onComplete: () -> Void
  let onSkip: () -> Void

  @Environment(\.dismiss) private var dismiss
  @State private var expandedTipIndex: Int? = nil
  @State private var showSkipAlert: Bool = false

  private var goalTips: [FAQ] {
    subGoal?.tips ?? []
  }

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(spacing: 0) {
          VStack {
            HStack(alignment: .top) {
              ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                  .fill(Color.accent.opacity(0.15))
                  .frame(width: 56, height: 56)

                Text("\(subGoal?.id ?? 0)")
                  .font(.title2.bold())
                  .foregroundStyle(Color.accent)
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
          .overlay(RoundedRectangle(cornerRadius: 16).stroke(style: StrokeStyle(lineWidth: 1)))
          .background(.white)
          .cornerRadius(16)
          .padding(16)

          VStack(alignment: .leading, spacing: 12) {
            HStack {
              Image(systemName: "lightbulb.fill")
                .foregroundStyle(.yellow)
              Text("이런 게 궁금하지 않나요?")
                .font(.headline)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)

            ForEach(Array(goalTips.enumerated()), id: \.offset) { index, tip in
              TipRowView(
                tip: tip,
                isExpanded: expandedTipIndex == index,
                onTap: {
                  withAnimation(.easeInOut(duration: 0.25)) {
                    expandedTipIndex = expandedTipIndex == index ? nil : index
                  }
                }
              )
              .padding(.horizontal, 16)
            }
          }
          .padding(.top, 6)
          .padding(.bottom, 10)

          Spacer()
          if goalLevel != 100 {
            if goalLevel == ((subGoal?.id ?? 0)) {
              Button {
                onComplete()
                dismiss()
              } label: {
                Text("완료했어요")
                  .padding(10)
                  .frame(maxWidth: .infinity)
                  .foregroundStyle(.white)
                  .bold()
              }
              .buttonStyle(.borderedProminent)
              .tint(.accent)
              .padding(.horizontal, 16)
            } else {
              if (goalLevel > subGoal?.id ?? 0) {
                Label("이미 완료했어요", systemImage: "checkmark.circle.fill")
                  .frame(maxWidth: .infinity)
                  .padding(.vertical, 20)
                  .background(.treeGreen)
                  .cornerRadius(40)
                  .padding(10)
              } else {
                Button {
                  showSkipAlert = true
                } label: {
                  Text("\(subGoal?.id ?? 0)단계로 건너뛰기")
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .bold()
                }
                .buttonStyle(.borderedProminent)
                .tint(.accent)
                .padding(.horizontal, 16)
              }
            }
          }
        }
      }
    }
    .navigationTitle(subGoal?.goal ?? "로딩중...")
    .background(.sky)
    .alert("정말로 건너뛸까요?", isPresented: $showSkipAlert) {
      Button("취소", role: .cancel) {
        
      }
      Button("건너뛰기", role: .destructive) {
        onSkip()
      }
    } message: {
      Text("차례 차례 마일스톤을 달성해야 더 쉽게 최종 목표에 달성할 수 있어요")
    }
  }
}

#Preview {
  SubGoalView(
    subGoal:
      SubGoal(
        id: 2,
        goal: "리이오와 밥 약속 잡기",
        description: "리이오와 밥을 먹으세요",
        tips: [
          FAQ(question: "리이오와 어떻게 밥을 먹나요", answer: "리이오는 밥먹기 예약 폼을 운영합니다")
        ]
      ),
    allSubgoals: [
      SubGoal(
        id: 1,
        goal: "리이오와 밥 약속 잡기",
        description: "리이오와 밥을 먹으세요",
        tips: [
          FAQ(question: "리이오와 어떻게 밥을 먹나요", answer: "리이오는 밥먹기 예약 폼을 운영합니다")
        ]
      ),
      SubGoal(
        id: 2,
        goal: "리이오와 밥 약속 잡기",
        description: "리이오와 밥을 먹으세요",
        tips: [
          FAQ(question: "리이오와 어떻게 밥을 먹나요", answer: "리이오는 밥먹기 예약 폼을 운영합니다")
        ]
      ),
    ], goalLevel: 2,
    onComplete: {},
    onSkip: {}
  )
}
