//
//  viewTaskFindWords.swift
//  cep
//
//  Created by Maria Novikova on 31.12.2022.
//

import SwiftUI

struct viewTaskFindWords: View {
    
    @Environment(\.dismiss) var dismiss
    let localAccentColor = "AccentColorCalm"
    
    var task: LessonTask
    @State private var showHelp = true
    
    var body: some View {
        
        VStack {
            
            HStack(alignment: .top) {
                viewBack() { dismiss() }
                
                Spacer()
                Button {
                    showHelp.toggle()
                } label: {
                    Image("icon_bible")
                }
            }
            
            baseCaption(text: "Найди слова")
            baseSubCaption(task.dataDescription)
                .padding(.bottom, 7)
            
            Spacer()
        }
        .padding(basePadding)
        .sheet(isPresented: $showHelp) {
            viewQuote(task: task)
                .accentColor(Color(uiColor: UIColor(named: "TextBlue")!))
        }
    }
}

struct viewTaskFindWords_Previews: PreviewProvider {
    static var previews: some View {
        viewTaskFindWords(task: lessons[1].taskGroups[1].tasks[1])
    }
}
