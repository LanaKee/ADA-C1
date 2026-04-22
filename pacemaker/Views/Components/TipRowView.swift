//
//  TipRowView.swift
//  pacemaker
//
//  Created by Lanakee on 4/2/26.
//

import SwiftUI

struct TipRowView: View {
  let tip: FAQ
  let isExpanded: Bool
  let onTap: () -> Void
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Button {
        onTap()
      } label: {
        HStack {
          Text(tip.question)
            .font(.subheadline.bold())
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
          
          Image(systemName: "chevron.down")
            .font(.caption.bold())
            .foregroundStyle(.secondary)
            .rotationEffect(.degrees(isExpanded ? 180 : 0))
        }
        .contentShape(Rectangle())
        .padding(16)
      }
      .buttonStyle(.plain)
      
      if isExpanded {
        Text(tip.answer)
          .font(.subheadline)
          .foregroundStyle(.secondary)
          .padding(.horizontal, 16)
          .padding(.bottom, 16)
      }
    }
    .overlay(RoundedRectangle(cornerRadius: 10).stroke(style: StrokeStyle(lineWidth: 0.5)))
    .background(.white)
    .cornerRadius(10)
  }
}
