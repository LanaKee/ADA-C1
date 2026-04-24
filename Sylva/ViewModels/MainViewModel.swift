//
//  MainViewModel.swift
//  Sylva
//
//  Created by Lanakee on 4/17/26.
//

import SwiftUI
import SwiftData
import Combine
import Foundation
import FirebaseAILogic

@MainActor
class MainViewModel: ObservableObject {
  @Published var currentGoal: GoalModel?
  
  @Published var goalInput: String = ""
  
  @Published var selectedGoal: SubGoal?
  @Published var currentPage: Int = 1
  @Published var isLoading: Bool = false
  
  @Published var displayPhase: GoalDisplayPhaseEnum = .input
  @Published var mainViewState: mainViewEnum = .main
  @Published var confettiTrigger: Int = 1
  @Published var selectedAssistant: AIAssistantEnum = .appleIntelligence
  
  let imageModel = FirebaseAI.firebaseAI(backend: .googleAI()).generativeModel(
    modelName: "gemini-3.1-flash-image-preview",
    generationConfig: GenerationConfig(responseModalities: [.text, .image])
  )
  
  var goal: String {
    currentGoal?.goal ?? ""
  }
  
  var subgoals: [SubGoal] {
    currentGoal?.goalBreakdown.subgoals ?? []
  }
  
  var goalLevel: Int {
    currentGoal?.goalLevel ?? 1
  }
  
  var isComplete: Bool {
    goalLevel > 5
  }
  
  var showCarouselListToggle: Bool {
    if case .list = displayPhase { return true }
    if case .carousel = displayPhase { return true }
    return false
  }
  
  func generateImage() async -> UIImage? {
    let prompt = makeBonsaiPrompt(goal: goal)
    do {
      let response = try await imageModel.generateContent(prompt)
      guard let inlineDataPart = response.inlineDataParts.first else {
        return nil
      }
      guard let uiImage = UIImage(data: inlineDataPart.data) else {
        return nil
      }
      return uiImage
    } catch {
      // Log or handle the error as needed
      print("generateImage error: \(error)")
      return nil
    }
  }
  
  func load(from savedGoals: [GoalModel]) {
    if let activeGoal = savedGoals.first(where: { $0.state == .active }) {
      currentGoal = activeGoal
      goalInput = activeGoal.goal
      currentPage = activeGoal.goalLevel-1
      if activeGoal.goalLevel > 5 {
        displayPhase = .final
      } else {
        displayPhase = .carousel
      }
    } else {
      currentGoal = nil
      displayPhase = .input
    }
  }
  
  func setNewGoal(_ goalModel: GoalModel) {
    currentGoal = goalModel
    displayPhase = .initialList
    currentPage = 0
  }
  
  func completeMileStone() {
    guard let currentGoal else { return }
    currentGoal.goalLevel += 1
    currentPage = currentGoal.goalLevel-1
    
    objectWillChange.send()
    
    if isComplete {
      displayPhase = .final
    }
  }
  
  func skipMileStone(to: SubGoal) {
    guard let currentGoal else { return }
    currentGoal.goalLevel = to.id
    currentPage = currentGoal.goalLevel-1
    
    objectWillChange.send()
    
    if isComplete {
      displayPhase = .final
    }

  }
  
  func completeGoal () {
    if !isComplete {
      return
    }
    guard let currentGoal else { return }
    currentGoal.state = .finished
    currentGoal.finishedAt = Date()

    objectWillChange.send()
    displayPhase = .input
  }

  func toggleViewMode() {
    guard currentGoal != nil else { return }
    withAnimation(.easeInOut(duration: 0.3)) {
      switch displayPhase {
      case .carousel:
        displayPhase = .list
      case .list:
        displayPhase = .carousel
      default:
        break
      }
    }
  }

  func toggleBonsaiView() {
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

