//
//  viewTaskReadExcerpt.swift
//  23234234
//
//  Created by Maria Novikova on 06.07.2022.
//

import SwiftUI

struct viewTaskReadExcerpt: View {
    
    var task: LessonTask
    @State var currentTranslationIndex: Int = globalCurrentTranslationIndex
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack {
            viewBack() { dismiss() }
            baseCaption(text: "Прочти отрывок")
            baseSubCaption(text: task.dataDescription)
            
            viewTranslateButtons()
            
            ScrollView() {
                viewExcerpt(task: task, translationIndex: currentTranslationIndex)
                
                Button() {
                    dismiss()
                } label: {
                    baseButtonLabel(text: "Готово!")
                }
                .padding(.bottom, 5)
            }
        }
        .padding(.horizontal, 22)
    }
    
    
    
    private func setTranslate(index: Int) {
        currentTranslationIndex = index
        globalCurrentTranslationIndex = index
    }
    
    @ViewBuilder private func viewTranslateButtons() -> some View {
        
        /*
        HStack(spacing: 1) {
            ForEach(Array(cTranslationsNames.enumerated()), id: \.element) { index, translation in
                Button(translation)
                {
                    self.setTranslate(index: index)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .font(.footnote)
                
                .foregroundColor(index != currentTranslationIndex ? designColors.BaseOrange : .white )
                .background(index == currentTranslationIndex ? designColors.BaseOrange : .white)
                
                .cornerRadius(radius: index==0 ? cRadius : 0, corners: [.topLeft, .bottomLeft])
                .cornerRadius(radius: index==cTranslationsNames.count-1 ? cRadius : 0, corners: [.topRight, .bottomRight])
            }
        }
        .foregroundColor(designColors.BaseOrange)
        .overlay(
            RoundedRectangle(cornerRadius: cRadius)
                .stroke(designColors.BaseOrange, lineWidth: 2)
        )
        .font(.callout)
        .background(designColors.BaseOrange)
        .cornerRadius(cRadius)
        //.frame(maxWidth: .infinity)
        */
        
        let columns = Array(repeating: GridItem(spacing: 1), count:cTranslationsNames.count)
        LazyVGrid(columns: columns, spacing: 1.0) {
            ForEach(Array(cTranslationsNames.enumerated()), id: \.element) { index, translation in
                Button {
                    self.setTranslate(index: index)
                } label: {
                    ZStack {
                        Rectangle()
                            .foregroundColor(index == currentTranslationIndex ? Color(uiColor: UIColor(named: "BaseOrange")!) : Color(.systemBackground))
                            .cornerRadius(radius: index==0 ? cRadius : 0, corners: [.topLeft, .bottomLeft])
                            .cornerRadius(radius: index==cTranslationsNames.count-1 ? cRadius : 0, corners: [.topRight, .bottomRight])
                        Text(translation)
                            .padding(.vertical, 10)
                            .font(.footnote)
                            .foregroundColor(index != currentTranslationIndex ? Color(uiColor: UIColor(named: "BaseOrange")!) : Color(.systemBackground) )
                    }
                }
            }
        }
        .foregroundColor(Color(uiColor: UIColor(named: "BaseOrange")!))
        .overlay(
            RoundedRectangle(cornerRadius: cRadius)
                .stroke(Color(uiColor: UIColor(named: "BaseOrange")!), lineWidth: 2)
        )
        .font(.callout)
        .background(Color(uiColor: UIColor(named: "BaseOrange")!))
        .cornerRadius(cRadius)
        .padding(.bottom, 10)
    }
    
}

struct viewTaskReadExcerpt_Previews: PreviewProvider {
    static var previews: some View {
        viewTaskReadExcerpt(task: lessons[0].taskGroups[0].tasks[0])
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
    }
}
