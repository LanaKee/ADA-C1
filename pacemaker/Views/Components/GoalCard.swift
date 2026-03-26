//
//  GoalCard.swift
//  pacemaker
//
//  Created by Lanakee on 3/25/26.
//
import SwiftUI

struct GoalCard: View {
    let index: Int
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.15))
                    .frame(width: 34, height: 34)

                Text("\(index)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }

            Text(text)
                .font(.body)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)

            Spacer(minLength: 0)
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        .padding(.horizontal, 16)
    }
}
