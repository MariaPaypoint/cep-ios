//
//  viewLessonsList.swift
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

struct viewLessons: View {
    
    var body: some View {
        NavigationStack {
            //VStack(spacing: 0) {
                ScrollView {
                    viewCourseCaption()
                    
                    ForEach(0..<maxRow(), id: \.self) { row in
                        HStack {
                            ForEach(lessons) { lesson in
                                if lesson.row == row {
                                    NavigationLink(destination: viewTasks(lesson: lesson)) {
                                        viewLessonItem(lesson: lesson)
                                    }
                                    .padding(.vertical, 15)
                                    .padding(.horizontal, 3)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            //}
        }
    }
    
    func maxRow() -> Int {
        var maxrow = 0
        for lesson in lessons {
            if (lesson.row > maxrow) {
                maxrow = lesson.row
            }
        }
        return maxrow+1
    }
    
}

struct viewCourse_Previews: PreviewProvider {
    static var previews: some View {
        viewLessons()
    }
}
