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
    @Guide(description: "one clear and actionable subgoal in Korean")
    var goal: String
    @Guide(description: "specific explanation in Korean including concrete actions, deliverables, or checkpoints")
    var description: String
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
