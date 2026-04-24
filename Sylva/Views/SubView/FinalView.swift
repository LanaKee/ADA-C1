//
//  FinalView.swift
//  Sylva
//
//  Created by Lanakee on 4/24/26.
//

import SwiftUI

struct FinalView: View {
  let goal: String
  let onComplete: () -> Void
  
  var body: some View {
    Text(goal)
      .font(.memom(.title))
      .foregroundStyle(.primary)
    Text("축하합니다 목표를 완료하셨어요!")
      .font(.memom(.subheadline))
      .foregroundStyle(.secondary)
      .padding(.top, 4)
    Spacer()
    Button {
      onComplete()
    } label : {
      Text("새로운 목표 설정하기")
        .padding(10)
        .frame(maxWidth: .infinity)
        .foregroundStyle(.white)
        .bold()
    }
    .buttonStyle(.borderedProminent)
    .tint(.accent)
    .padding(.horizontal, 16)
    .padding(.bottom, 20)
  }
}
