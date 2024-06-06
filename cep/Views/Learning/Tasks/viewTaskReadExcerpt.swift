//  Created by Maria Novikova on 06.07.2022.

import SwiftUI

struct viewTaskReadExcerpt: View {
    
    //let localAccentColor = "AccentColorBright"
    let localAccentColor = "AccentColorCalm"
    //let localAccentColor = "BaseOrange"
    
    var task: LessonTask
    @State var currentTranslationIndex: Int = globalBibleText.getCurrentTranslationIndex()
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
                
                let verses = getExcerptTextVerses(excerpts: task.data)
                viewExcerpt(verses: verses)
                
                Button() {
                    dismiss()
                } label: {
                    baseButtonLabel("Готово!", colorName: localAccentColor)
                }
            }
        }
        .padding()
    }
    
    // MARK: Кнопки перевода
    @ViewBuilder private func viewTranslateButtons() -> some View {
        
        let arrTranslationsNames = globalBibleText.getTranslationNames()
        
        viewSegmentedButtons(arr: arrTranslationsNames, selIndex: currentTranslationIndex, baseColor: Color(uiColor: UIColor(named: localAccentColor)!)) { selectedIndex in
            self.setTranslate(index: selectedIndex)
        }
    }
    
    private func setTranslate(index: Int) {
        currentTranslationIndex = index
        globalBibleText.setCurrentTranslation(index: index)
    }
    
}

struct viewTaskReadExcerpt_Previews: PreviewProvider {
    static var previews: some View {
        viewTaskReadExcerpt(task: lessons[0].taskGroups[0].tasks[0])
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
    }
}
