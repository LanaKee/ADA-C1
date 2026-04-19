//
//  AIAssistantEnum.swift
//  Sylva
//
//  Created by Lanakee on 4/17/26.
//

enum AIAssistantEnum: String, CaseIterable, Identifiable {
    case appleIntelligence, gemini
    var id: Self { self }
    
    var title: String {
        switch self {
        case .appleIntelligence: "Apple Intelligence"
        case .gemini: "Gemini"
        }
    }
    
    var icon: String {
        switch self {
        case .appleIntelligence: "apple.intelligence"
        case .gemini: "sparkle"
        }
    }
}
