//
//  advExcerpt.swift
//  cep
//
//  Created by Maria Novikova on 31.12.2022.
//

import SwiftUI


// MARK: Отрывок - массив строк
func getExcerptStrings(excerpts: String, translationIndex: Int) -> [Verse] {
    
    let currentTranslate = cTranslationsCodes[translationIndex]
    let book = books[currentTranslate]
    
    var resVerses: [Verse] = []
    
    if excerpts == "" {
        //Text("Этого перевода пока не существует!")
    }
    else {
        for excerpt in excerpts.components(separatedBy: ",") {
            if book == nil {
                //Text("Этого перевода пока не существует!")
            }
            else {
                let arrExcerpt = excerpt.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: " ")
                let verses_address = arrExcerpt[1]
                
                let arrVersesAddress = verses_address.components(separatedBy: ":")
                let chapter = Int(arrVersesAddress[0])!
                let verses_interval = arrVersesAddress[1]
                
                let arrVersesInterval = verses_interval.components(separatedBy: "-")
                let verse_first = Int(arrVersesInterval[0])!
                let verse_last = arrVersesInterval.count > 1 ? Int(arrVersesInterval[1])! : Int(arrVersesInterval[0])!
                
                for verse_index in verse_first...verse_last {
                    resVerses.append(Verse(id: verse_index, text: (book!.chapters.first(where: {element in element.id == chapter})?.verses.first(where: {element in element.id == verse_index})!.text)!))
                }
            }
        }
    }
    return resVerses
}

// MARK: Отрывок - 1 строка
func getExcerptText(excerpts: String, translationIndex: Int) -> String {
    
    let verses = getExcerptStrings(excerpts: excerpts, translationIndex: translationIndex)
    
    var resText = ""
    
    for (verse) in verses {
        resText = resText + verse.text + " "
    }
    
    return resText
}

// MARK: Готовое отображение
@ViewBuilder func viewExcerpt(task: LessonTask, translationIndex: Int) -> some View {
    
    let verses = getExcerptStrings(excerpts: task.data, translationIndex: translationIndex)
    
    ForEach(verses, id: \.self) { verse in
        HStack(alignment: .top, spacing: 4) {
            Text(String(verse.id))
                .font(.footnote)
                .foregroundColor(Color(uiColor: UIColor(named: "TextGray")!))
                .frame(width: 20, alignment: .leading)
                .padding(.top, 3)
            Text(verse.text)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.top, 4)
    }
}
