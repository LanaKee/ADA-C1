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
  let selectedModel: AIAssistantEnum

  @Binding var goal: String

  @State private var response: GoalBreakDown? = nil
  @State private var isLoading: Bool = false

  let ai = FirebaseAI.firebaseAI(backend: .googleAI())
  lazy var gemini = ai.generativeModel(
    modelName: "gemini-3-flash-preview",
    systemInstruction: ModelContent(role: "system", parts: instruction)
  )
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
      
      Text("선택된 모델: \(selectedModel.title)")
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .padding(.bottom, 10)
      
      InputField(
        icon: "arrow.up",
        isLoading: isLoading,
        generateGoals: generateGoals,
        goal: $goal
      )
    }
  }
  
  
  private func generateGoals() async {
    let trimmed = goal.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else { return }
    
    isLoading = true
    defer { isLoading = false }
    
    let result = await client.getResponse(prompt: trimmed)
    switch result {
    case .success(let plan):
      response = plan
      print(plan)
      
    case .failure:
      print("fail")
    }
  }
  
//  private func generateGoalBreakDownGemini () async {
//    let trimmed = goal.trimmingCharacters(in: .whitespacesAndNewlines)
//    guard !trimmed.isEmpty else { return }
//    
//    isLoading = true
//    defer { isLoading = false }
//    
//    gemini.startChat()
//    let response = try await gemini.generateContent(goal)
//    print(response!)
//  }
}

#Preview {
  VStack(spacing: 0) {
    InputView(
      selectedModel: .appleIntelligence,
      goal: .init(get: { "Hello" }, set: { _ in }),
    )
  }
  .frame(maxHeight: .infinity)
  .background(.sky)
}
