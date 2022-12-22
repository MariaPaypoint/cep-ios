//
//  viewLessonsList.swift
//  cep
//
//  Created by Maria Novikova on 19.12.2022.
//

import SwiftUI

struct viewCoursesList: View {
    
    var body: some View {
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

struct viewCoursesList_Previews: PreviewProvider {
    static var previews: some View {
        viewCoursesList()
    }
}
