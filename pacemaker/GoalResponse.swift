//
//  GoalResponse.swift
//  pacemaker
//
//  Created by Lanakee on 3/25/26.
//
import Foundation
import SwiftUI
import CoreLocation

struct Response: Hashable & Codable {
    let error: Bool
    let subgoals: [GoalResponse]
}

struct GoalResponse: Hashable & Codable {
    let id: Int
    let goal: String
    let tasks: [String]
}

final class Goal {
    private var client: FoundationModelClient

    init(client: FoundationModelClient) {
        self.client = client
    }

    public func split(goal: String) async -> [GoalResponse] {
        var responseString = await client.getResponse(
            prompt: "\(goal)을/를 이루기 위해 필요한 작은 목표들을 알려주세요"
        )
        responseString = responseString
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .replacingOccurrences(of: "\n", with: "")
        
        if let goal = parseJSON(responseString) as Response? {
            return goal.subgoals
        }

        if let errorResponse = parseJSON(responseString) as Response? {
            return [GoalResponse(id: 0, goal: "Error", tasks: [errorResponse.error.description])]
        }

        return [GoalResponse(id: 0, goal: responseString, tasks: ["Error"])]
    }
}



