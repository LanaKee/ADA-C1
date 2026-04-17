//
//  InputView.swift
//  Sylva
//
//  Created by Lanakee on 4/16/26.
//

import SwiftUI

struct InputView: View {
  let selectedModel: AIAssistant
  let onSubmit: () async -> Void

  @Binding var goal: String
  
  @State private var isLoading: Bool = false
  
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
      
      Text("선택된 모델: \(selectedModel.title)")
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
      selectedModel: .appleIntelligence,
      onSubmit: {},
      goal: .init(get: { "Hello" }, set: { _ in }),
    )
  }
  .frame(maxHeight: .infinity)
  .background(.sky)
}
