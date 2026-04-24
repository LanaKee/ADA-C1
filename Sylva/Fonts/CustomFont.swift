//
//  CustomFont.swift
//  Sylva
//
//  Created by Lanakee on 3/31/26.
//

import SwiftUI

extension Font {
    static func memom(_ style: TextStyle) -> Font {
        switch style {
        case .largeTitle:
            return .custom("MemomentKkukkukk", size: 34, relativeTo: .largeTitle)
        case .title:
            return .custom("MemomentKkukkukk", size: 28, relativeTo: .title)
        case .body:
            return .custom("MemomentKkukkukk", size: 17, relativeTo: .body)
        default:
            return .custom("MemomentKkukkukk", size: 17, relativeTo: style)
        }
    }
}
