//
//  GoalResponse.swift
//  pacemaker
//
//  Created by Lanakee on 3/25/26.
//
import Foundation
import SwiftUI
import CoreLocation

struct GoalResponse: Hashable & Codable {
    var id: Int
    var goal: String
    var tasks: [String]
}

struct ErrorResponse: Hashable & Codable {
    let error: Bool
    let message: String
}

final class Goal {
    private var client: FoundationModelClient

    init(client: FoundationModelClient) {
        self.client = client
    }

    public func split(goal: String) async -> [GoalResponse] {
        let responseString = await client.getResponse(
            prompt: "\(goal)을/를 이루기 위해 필요한 작은 목표들을 알려주세요"
        )

        if let goals = parseJSON(responseString) as [GoalResponse]? {
            return goals
        }

        if let errorResponse = parseJSON(responseString) as ErrorResponse? {
            print("에러: \(errorResponse.message)")
            return [GoalResponse(id: 0, goal: "Error", tasks: [errorResponse.message])]
        }

        return [GoalResponse(id: 0, goal: "Parse Error", tasks: ["응답을 해석할 수 없습니다."])]
    }
}



