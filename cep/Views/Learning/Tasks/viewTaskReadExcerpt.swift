//
//  viewTaskReadExcerpt.swift
//  23234234
//
//  Created by Maria Novikova on 06.07.2022.
//

import SwiftUI

struct viewTaskReadExcerpt: View {
    
    //let localAccentColor = "AccentColorBright"
    let localAccentColor = "AccentColorCalm"
    //let localAccentColor = "BaseOrange"
    
    var task: LessonTask
    @State var currentTranslationIndex: Int = globalCurrentTranslationIndex
    @State var translateSelecting = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack(spacing: 0) {
            viewBack() { dismiss() }
            baseCaption(text: "Прочти отрывок")
            baseSubCaption(task.dataDescription)
                .padding(.bottom, 12)
            
            
            if (translateSelecting) {
                viewTranslateButtons()
                    .padding(.bottom, 12)
            }
            ScrollView() {
                if (!translateSelecting) {
                    Button() {
                        translateSelecting.toggle()
                    } label: {
                        Text("SYNO")
                            .foregroundColor(Color(uiColor: UIColor(named: localAccentColor)!))
                    }
                }
                
                viewExcerpt(task: task, translationIndex: currentTranslationIndex)
                
                Button() {
                    dismiss()
                } label: {
                    baseButtonLabel("Готово!", colorName: localAccentColor)
                }
                //.padding(.bottom)
            }
        }
        .padding()
    }
    
    
    
    // MARK: Кнопки перевода
    @ViewBuilder private func viewTranslateButtons() -> some View {
        /*
        let columns = Array(repeating: GridItem(spacing: 1), count:cTranslationsNames.count)
        LazyVGrid(columns: columns, spacing: 1.0) {
            ForEach(Array(cTranslationsNames.enumerated()), id: \.element) { index, translation in
                Button {
                    self.setTranslate(index: index)
                } label: {
                    ZStack {
                        Rectangle()
                            .foregroundColor(index == currentTranslationIndex ? Color(uiColor: UIColor(named: localAccentColor)!) : Color(.systemBackground))
                            .cornerRadius(radius: index==0 ? cRadius : 0, corners: [.topLeft, .bottomLeft])
                            .cornerRadius(radius: index==cTranslationsNames.count-1 ? cRadius : 0, corners: [.topRight, .bottomRight])
                        Text(translation)
                            .padding(.vertical, 10)
                            .font(.footnote)
                            .foregroundColor(index != currentTranslationIndex ? Color(uiColor: UIColor(named: localAccentColor)!) : Color(.systemBackground) )
                    }
                }
            }
        }
        .foregroundColor(Color(uiColor: UIColor(named: localAccentColor)!))
        .overlay(
            RoundedRectangle(cornerRadius: cRadius)
                .stroke(Color(uiColor: UIColor(named: localAccentColor)!), lineWidth: 2)
        )
        .font(.callout)
        .background(Color(uiColor: UIColor(named: localAccentColor)!))
        .cornerRadius(cRadius)
        .padding(.bottom, 10)
        */
        viewSegmentedButtons(arr: cTranslationsNames, selIndex: currentTranslationIndex, baseColor: Color(uiColor: UIColor(named: localAccentColor)!)) { selectedIndex in
            self.setTranslate(index: selectedIndex)
        }
    }
    
    private func setTranslate(index: Int) {
        currentTranslationIndex = index
        globalCurrentTranslationIndex = index
    }
    
}

struct viewTaskReadExcerpt_Previews: PreviewProvider {
    static var previews: some View {
        viewTaskReadExcerpt(task: lessons[0].taskGroups[0].tasks[0])
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
    }
}
