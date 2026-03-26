//
//  FoundationModel.swift
//  pacemaker
//
//  Created by Lanakee on 3/25/26.
//

import SwiftUI
import FoundationModels

final class FoundationModelClient {
    private let session: LanguageModelSession

    init(instruction: String) {
        self.session = LanguageModelSession(instructions: instruction)
    }
    
    func getResponse(prompt: String) async -> String {
        do {
            let response = try await session.respond(to: prompt)
            return response.content
        } catch LanguageModelSession.GenerationError.guardrailViolation {
            return "{\"error\":\"true\", \"message\":\"GuradRail Violation\" }"
        } catch {
            return "{\"error\":\"true\", \"message\":\"\(error)\" }"
        }
    }
}
