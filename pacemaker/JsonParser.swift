//
//  JsonParser.swift
//  pacemaker
//
//  Created by Lanakee on 3/25/26.
//
import Foundation
import SwiftUI
import CoreLocation

func parseJSON<T: Decodable>(_ jsonString: String) -> T? {
    guard let data = jsonString.data(using: .utf8) else { return nil }

    do {
        return try JSONDecoder().decode(T.self, from: data)
    } catch {
        print("JSON 파싱 실패:", error)
        return nil
    }
}

