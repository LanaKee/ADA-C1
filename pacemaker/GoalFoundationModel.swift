//
//  GoalFoundationModel.swift
//  pacemaker
//
//  Created by Lanakee on 3/26/26.
//

import FoundationModels

@Generable
struct GoalPlan: Hashable & Codable {
    @Guide(description: "exactly 5 small, non-overlapping, sequential subgoals")
    var subgoals: [GoalPlanResponse]
}

@Generable
struct GoalPlanResponse: Hashable & Codable {
    @Guide(description: "sequential integer starting from 1")
    var id: Int
    @Guide(description: "one clear and actionable subgoal in Korean Make it short")
    var goal: String
    @Guide(description: "specific explanation in Korean including concrete actions, deliverables, or checkpoints")
    var description: String
    @Guide(description: "exactly 3 beginner-friendly questions about this subgoal, written in Korean", .count(3))
    var tips: [SubGoalTip]
}

@Generable
struct SubGoalTip: Hashable & Codable {
    @Guide(description: "a short, curiosity-driven question a beginner would ask, in Korean")
    var question: String
    @Guide(description: "a clear, easy-to-understand answer in Korean, 2-3 sentences max")
    var answer: String
}

final class FoundationModelClient {
    private let session: LanguageModelSession

    init(instruction: String) {
        self.session = LanguageModelSession(instructions: instruction)
    }

    func getResponse(prompt: String) async -> Result<GoalPlan, Error>  {
        do {
            let response = try await session.respond(to: prompt, generating:GoalPlan.self)
          return .success(response.content)
        } catch {
          return .failure(error)
        }
    }
}
