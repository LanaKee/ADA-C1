//
//  GoalFoundationModel.swift
//  pacemaker
//
//  Created by Lanakee on 3/26/26.
//

import Foundation
import FoundationModels
import FirebaseAILogic

public let geminiSchema = Schema.object(
  properties: [
    "subgoals": Schema.array(
      items: .object(
        properties: [
          "id": .integer(),
          "goal": .string(),
          "description": .string(),
          "tips": .array(
            items: .object(
              properties: [
                "question": .string(),
                "answer": .string(),
              ]
            )
          ),
        ]
      )
    ),
  ]
)

@Generable
struct GoalBreakDown: Hashable & Codable {
  @Guide(description: "exactly 5 small, non-overlapping, sequential subgoals")
  var subgoals: [SubGoal]
}

@Generable
struct SubGoal: Hashable & Codable {
  @Guide(description: "sequential integer starting from 1")
  var id: Int
  @Guide(description: "one clear and actionable subgoal in Korean Make it short")
  var goal: String
  @Guide(description: "specific explanation in Korean including concrete actions, deliverables, or checkpoints")
  var description: String
  @Guide(description: "exactly 3 beginner-friendly questions about this subgoal, written in Korean", .count(3))
  var tips: [FAQ]
}

@Generable
struct FAQ: Hashable & Codable {
  @Guide(description: "a short, curiosity-driven question a beginner would ask, in Korean")
  var question: String
  @Guide(description: "a clear, easy-to-understand answer in Korean, 2-3 sentences max")
  var answer: String
}

final class GoalBreakDowner {
  private let session: LanguageModelSession
  
  init(instruction: String) {
    self.session = LanguageModelSession(instructions: instruction)
  }
  
  func getResponse(prompt: String) async -> Result<GoalBreakDown, Error>  {
    do {
      let response = try await session.respond(to: prompt, generating:GoalBreakDown.self)
      return .success(response.content)
    } catch {
      return .failure(error)
    }
  }
}

func parseGoalBreakDown(from jsonString: String) throws -> GoalBreakDown {
  guard let data = jsonString.data(using: .utf8) else {
    throw NSError(domain: "ParsingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid UTF-8 string"])
  }
  
  let decoder = JSONDecoder()
  return try decoder.decode(GoalBreakDown.self, from: data)
}

