//
//  viewCourseCaption.swift
//  cep
//
//  Created by Maria Novikova on 19.12.2022.
//

import SwiftUI

struct viewCourseCaption: View {
    var body: some View {
        VStack(spacing: 0) {
            Image("caption_gate")
                .padding(.bottom, -1)
                .padding(.top, 40)
            ZStack {
                Image("caption_ribbon")
                Text("Притчи Иисуса")
                    .foregroundColor(.white)
                    .font(.title2)
                    .padding(.bottom, 5)
            }
            .padding(.bottom, 30)
        }
    }
}

struct viewCourseCaption_Previews: PreviewProvider {
    static var previews: some View {
        viewCourseCaption()
    }
}
