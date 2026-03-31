//
//  SubGoalView.swift
//  pacemaker
//
//  Created by Lanakee on 3/27/26.
//

import SwiftUI

struct SubGoalView: View {
  let subGoal: GoalPlanResponse?
  let onComplete: () -> Void
  
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    NavigationStack {
      VStack {
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
        
        Spacer()
      }
      .navigationTitle(subGoal?.goal ?? "로딩중...")
    }
  }
}
#Preview {
  SubGoalView(
    subGoal:
      GoalPlanResponse(
        id: 1,
        goal: "리이오와 밥 약속 잡기",
        description: "리이오와 밥을 먹으세요",
      ),
    onComplete: {}
  )
}
