//
//  viewTaskAnswerQuestion.swift
//  cep
//
//  Created by Maria Novikova on 17.01.2023.
//

import SwiftUI

struct viewTaskAnswerQuestion: View {
    
    let localAccentColor = "AccentColorCalm"
    
    var task: LessonTask
    @Environment(\.dismiss) var dismiss
    
    @State private var fullText: String = ""
    @State private var publicAnswer = false
    @State private var publicAnswerHint = false
    
    var body: some View {
        
        VStack() {
            viewBack() { dismiss() }
            baseCaption(text: "Ответ на вопрос")
                
            HStack {
                Text("Читать Матфея 25:1-3")
                Image("icon_link")
            }
            .foregroundColor(Color(uiColor: UIColor(named: localAccentColor)!))
            
            
            //baseSubCaption(task.dataDescription)
            
            Text(task.dataDescription)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 1)
                .padding(.bottom, 8)
            
            //GeometryReader { geometry in
                VStack {
                    TextEditor(text: $fullText)
                        //.frame(height:geometry.size.height / 3, alignment: .center)
                        //.lineSpacing(10)
                        //.autocapitalization(.words)
                        //.disableAutocorrection(true)
                        .padding(10)
                    
                }.overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray, lineWidth: 1)
                )
                .padding(.bottom, 10)
                
            //}
            /*
            Toggle("Публичный ответ", isOn: $publicAnswer)
            */
            
             
            HStack {
                //Spacer()
                Toggle("", isOn: $publicAnswer.animation(.spring()))
                    .labelsHidden()
                    .tint(Color(uiColor: UIColor(named: "TextBlue")!))
                Text("Публичный ответ")
                    
                Spacer()
                
                Button {
                    withAnimation (.easeInOut(duration: 0.3)) {
                        publicAnswerHint.toggle()
                    }
                }
                label: {
                    Image(systemName: "info.circle")
                        .font(.title)
                        .foregroundColor(Color(uiColor: UIColor(named: "TextBlue")!))
                }
            }
            //.foregroundColor(Color(uiColor: UIColor(named: "TextBlue")!))
            
            if publicAnswerHint {
                Text(publicAnswer ? "Другие пользователи смогут прочесть ваш ответ" : "Ваш ответ будет спрятан от всех")
                    .font(.system(size: 14, weight: .light))
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Button() {
                dismiss()
            } label: {
                baseButtonLabel("Готово!", colorName: localAccentColor)
                    .padding(.top, 10)
            }
        }
        .padding()
    }
}

struct viewTaskAnswerQuestion_Previews: PreviewProvider {
    static var previews: some View {
        viewTaskAnswerQuestion(task: lessons[1].taskGroups[2].tasks[1])
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
    }
}
