//
//  InputView.swift
//  Sylva
//
//  Created by Lanakee on 4/16/26.
//

import SwiftUI
import Foundation
import FirebaseAI

struct InputView: View {
  @Binding var goal: String
  @Binding var isLoading: Bool
  let selectedAssistant: AIAssistantEnum
  let onSubmit: () async -> Void
  
  private let client = GoalBreakDowner(instruction: instruction)
  var body: some View {
    VStack(spacing: 0) {
      Label {
        Text("목표 씨앗 만들기")
          .font(.memom(.title))
      } icon: {
        Image("ico_seed")
          .resizable()
          .scaledToFit()
          .frame(width: 50, height: 50)
      }
      
      Text("선택된 모델: \(selectedAssistant.title)")
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .padding(.bottom, 10)
      
      InputField(
        icon: "arrow.up",
        isLoading: isLoading,
        generateGoals: onSubmit,
        goal: $goal
      )
    }
  }
}

#Preview {
  VStack(spacing: 0) {
    InputView(
      goal: .constant("루미"),
      isLoading: .constant(false),
      selectedAssistant: .gemini,
      onSubmit: {}
    )
  }
  .frame(maxHeight: .infinity)
  .background(.sky)
}
