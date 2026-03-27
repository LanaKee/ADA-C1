//
//  GoalFoundationModel.swift
//  pacemaker
//
//  Created by Lanakee on 3/26/26.
//

import FoundationModels

@Generable
struct GoalPlan: Hashable & Codable {
    @Guide(description: "small seperated easy goals to help you reach your big goal", .count(5))
    var subgoals: [GoalPlanResponse]
}

@Generable
struct GoalPlanResponse: Hashable & Codable {
    @Guide(description: "unique sequential id (auto increment)")
    var id: Int
    @Guide(description: "sub goal that helps you achieve your big goal")
    var goal: String
    @Guide(description: "small tasks can help you achieve your goal",.count(4))
    var tasks: [String]
    
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
