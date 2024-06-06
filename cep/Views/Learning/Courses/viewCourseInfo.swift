//
//  viewCourseInfo.swift
//  cep
//
//  Created by Maria Novikova on 05.07.2023.
//

import SwiftUI
import OpenAPIClient

struct viewCourseInfo: View {
    
    var courseInfo: CourseInfo
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        let is_completed = Bool.random()
        let is_process = Bool.random()
        let lessons_count = Int.random(in: 1...100)
        
        VStack {
            VStack(spacing: 15) {
                // MARK: image
                viewBack() { dismiss() }
                
                AsyncImage(url: URL(string: courseInfo.image!)) { image in
                    //AsyncImage(url: URL(string: "https://500:3490205720348012725@assets.christedu.ru/data/images/sheperd.png")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .mask { RoundedRectangle(cornerRadius: 10, style: .continuous) }
                } placeholder: {
                }
                .frame(width: 200)
                .clipped()
                
                baseCaption(text: courseInfo.name!)
                
                let crl = getProgressColor(is_completed: is_completed, is_process: is_process)
                
                Text("Уроков в курсе: \(lessons_count)")
                    .fontWeight(.medium)
                
                
                Text(courseInfo.description!)
                if is_completed {
                    Text("Курс был завершен 22.12.2023")
                        .foregroundColor(Color(uiColor: UIColor(named: "TextGreen")!))
                }
                if is_process {
                    Text("В процессе прохождения")
                        .foregroundColor(Color(uiColor: UIColor(named: "TextYellow")!))
                }
                
            }
            .padding(.top, 15)
            Spacer()
            
            Button() {
                //auth()
            } label: {
                if is_process {
                    baseButtonLabel("Перейти к обучению")
                } else {
                    baseButtonLabel(is_completed ? "Пройти курс заново" : "Начать курс")
                }
            }
        }
        .padding()
    }
}

struct viewCourseInfo_Previews: PreviewProvider {
    
    static let courseInfo: CourseInfo = CourseInfo(id: 0, name: "name", language: "en", image: "https://500:3490205720348012725@assets.christedu.ru/data/images/sheperd.png", description: "description", ownerId: 0)
    
    static var previews: some View {
        viewCourseInfo(courseInfo: courseInfo)
    }
}
