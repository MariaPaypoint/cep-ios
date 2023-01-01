//
//  viewTaskInsert.swift
//  cep
//
//  Created by Maria Novikova on 30.12.2022.
//

import SwiftUI

struct viewTaskInsert: View {
    
    @Environment(\.dismiss) var dismiss
    let localAccentColor = "AccentColorCalm"
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var task: LessonTask
    @State private var showHelp = true
    
    var body: some View {
        
        VStack {
            viewBack() { dismiss() }
            
            HStack {
                Spacer()
                Button {
                    showHelp.toggle()
                } label: {
                    Image("icon_bible")
                }
            }
            //Spacer()
            
            baseCaption(text: "Вставь пропущенное")
            baseSubCaption(task.dataDescription)
                .padding(.bottom, 7)
            
            Spacer()
            
            Text("Итак, ______________, потому что ______ ________ ни дня, ни часа, в __________ приидет ______ _______________.")
                .font(.title.weight(.light))
                .multilineTextAlignment(.center)
                .lineSpacing(10)
            Spacer()
            
            
            let words: [String] = ["не", "Человеческий", "знаете", "Сын", "бодрствуйте", "который"]
            LazyVGrid(columns: columns) {
                ForEach(words, id: \.self) { word in
                    Text(word)
                        .buttonStyle(.bordered)
                        .padding(12)
                        .frame(maxWidth: .infinity)
                        .background(Color(uiColor: UIColor(named: "BaseLightGray")!))
                        //.foregroundColor(.white)
                        //.foregroundColor(Color(uiColor: UIColor(named: localAccentColor)!))
                        .cornerRadius(radius: 12, corners: .allCorners)
                        .padding(3)
                }
            }
            
            Spacer()
        }
        .padding(basePadding)
        .sheet(isPresented: $showHelp) {
            viewQuote(task: task)
                .accentColor(Color(uiColor: UIColor(named: "TextBlue")!))
        }
    }
}


struct viewTaskInsert_Previews: PreviewProvider {
    static var previews: some View {
        viewTaskInsert(task: lessons[1].taskGroups[1].tasks[0])
    }
}
