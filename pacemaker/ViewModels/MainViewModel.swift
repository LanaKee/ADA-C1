//
//  MainViewModel.swift
//  Sylva
//
//  Created by Lanakee on 4/17/26.
//

import SwiftUI
import Combine
import Foundation
import FirebaseAI
import FirebaseAILogic

@MainActor
class MainViewModel: ObservableObject {
  @Published var goal: String = ""
  @Published var response: GoalBreakDown?
  @Published var selectedGoal: SubGoal?
  
  @Published var goalLevel: Int = 0
  @Published var currentPage: Int = 0
  
  @Published var isLoading: Bool = false
  @Published var displayPhase: GoalDisplayPhaseEnum = .input
  @Published var mainViewState: mainViewEnum = .main
  
  @Published var confettiTrigger: Int = 0
  @Published var selectedAssistant: AIAssistantEnum = .appleIntelligence
  
  private let client = GoalBreakDowner(instruction: instruction)
  
  var subgoals: [SubGoal] {
    response?.subgoals ?? []
  }
  
  var isComplete: Bool {
    goalLevel > 5
  }
  
  func generateGoals() async -> Void {
    isLoading = true
    let trimmed = goal.trimmingCharacters(in: .whitespacesAndNewlines)
    if selectedAssistant == .appleIntelligence {
      guard !trimmed.isEmpty else { return }
      
      isLoading = true
      defer { isLoading = false }
      
      let result = await client.getResponse(prompt: trimmed)
      switch result {
      case .success(let plan):
        response = plan
        displayPhase = .initialList(response!)
        
      case .failure:
        displayPhase = .input
      }
    } else if selectedAssistant == .gemini {
      do {
        let ai = FirebaseAI.firebaseAI(backend: .googleAI())
        let model = ai.generativeModel(
          modelName: "gemini-3-flash-preview",
          generationConfig : GenerationConfig(
            responseMIMEType: "application/json",
            responseSchema: geminiSchema
          ),
          systemInstruction: ModelContent(role: "system", parts: instruction)
        )

        defer { isLoading = false }
        
        let geminiresponse = try await model.generateContent("사용자 입력: \(trimmed)")
        guard let text = geminiresponse.text else {
          return
        }
        response = try parseGoalBreakDown(from: text)
        displayPhase = .initialList(response!)
      } catch {
        print("gemini fail \(error)")
      }
    }
    isLoading = false
    
  }
  
  func completeSubgoal(_ subgoal: SubGoal) {
    goalLevel = subgoal.id + 1
    currentPage = subgoal.id
    if isComplete {
      displayPhase = .final
    }
  }
  
  func toggleViewMode() {
    guard let response else { return }
    withAnimation(.easeInOut(duration: 0.3)) {
      switch displayPhase {
      case .carousel:
        displayPhase = .list(response)
      case .list:
        displayPhase = .carousel(response, level: goalLevel)
      default: break
      }
    }
  }
  
  func toggleBonsaiView () {
    withAnimation(.easeInOut(duration: 0.3)) {
      switch mainViewState {
      case .main:
        mainViewState = .bonsai
      case .bonsai:
        mainViewState = .main
      }
    }
  }
  
  
  
  func firework() {
    confettiTrigger += 1
  }
}

