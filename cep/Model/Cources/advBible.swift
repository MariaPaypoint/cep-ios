//
//  advExcerpt.swift
//  cep
//
//  Created by Maria Novikova on 31.12.2022.
//

import SwiftUI


// MARK: Отрывок - массив строк
func getExcerptTextVerses(excerpts: String) -> [BibleTextVerseFull] {
    
    var resVerses: [BibleTextVerseFull] = []
    
    let clear_excerpts = excerpts.trimmingCharacters(in: .whitespacesAndNewlines)
    //let clear_excerpts = "dfdfg, mfodd; 3:3, mf 18, mf 18:kk, mk kk:4, mk 6:4-uu, mk 6:w-4, mk 7:4-5, mk 7:14, , mk 70:14, mk 7:140, mf 5:47-50" // check correct/incorrect values
    
    guard clear_excerpts != "" else {
        if globalDebug { resVerses.append(BibleTextVerseFull(id: 0, text: "EMPTY EXCERPT")) }
        return resVerses
    }
    
    var oldBook: Int = 0
    var oldChapter: Int = 0
    var oldVerse: Int = 0
    
    for excerpt in clear_excerpts.components(separatedBy: ",") {
        let arrExcerpt = excerpt.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: " ")
        guard arrExcerpt.count == 2 else {
            if globalDebug { resVerses.append(BibleTextVerseFull(id: 0, text: "INCORRECT EXCERPT: \(excerpt)")) }
            continue
        }
        let book_name = arrExcerpt[0] // for example: mf
        let verses_address = arrExcerpt[1]
        
        let book = (globalBibleText.getCurrentTranslation().books.first(where: {$0.code == book_name}))
        guard book != nil else {
            if globalDebug { resVerses.append(BibleTextVerseFull(id: 0, text: "INCORRECT BOOK: \(book_name)")) }
            continue
        }
        
        let arrVersesAddress = verses_address.components(separatedBy: ":")
        guard arrVersesAddress.count == 2 else {
            if globalDebug { resVerses.append(BibleTextVerseFull(id: 0, text: "INCORRECT ADDRESS (NO VERSES): \(verses_address)")) }
            continue
        }
        guard Int(arrVersesAddress[0]) != nil else {
            resVerses.append(BibleTextVerseFull(id: 0, text: "INCORRECT ADDRESS (NOT INT): \(arrVersesAddress[0])"))
            continue
        }
        let chapter_index = Int(arrVersesAddress[0])!
        let chapter = book!.chapters.first(where: {element in element.id == chapter_index})
        guard chapter != nil else {
            if globalDebug { resVerses.append(BibleTextVerseFull(id: 0, text: "INCORRECT CHAPTER: \(chapter_index)")) }
            continue
        }
        let verses_interval = arrVersesAddress[1]
        
        let arrVersesInterval = verses_interval.components(separatedBy: "-")
        guard Int(arrVersesInterval[0]) != nil else {
            if globalDebug { resVerses.append(BibleTextVerseFull(id: 0, text: "INCORRECT INTERVAL (NOT INT): \(arrVersesInterval[0])")) }
            continue
        }
        guard arrVersesInterval.count == 1 || (arrVersesInterval.count == 2 && Int(arrVersesInterval[1]) != nil) else {
            if globalDebug { resVerses.append(BibleTextVerseFull(id: 0, text: "INCORRECT INTERVAL (NOT INT): \(arrVersesInterval[1])")) }
            continue
        }
        
        let verse_first = Int(arrVersesInterval[0])!
        let verse_last = arrVersesInterval.count > 1 ? Int(arrVersesInterval[1])! : Int(arrVersesInterval[0])!
        
        for verse_index in verse_first...verse_last {
            let verse = chapter!.verses.first(where: {element in element.id == verse_index})
            guard verse != nil else {
                if globalDebug { resVerses.append(BibleTextVerseFull(id: 0, text: "INCORRECT VERSE: \(verse_index)")) }
                break
            }
            let text = verse!.text
            resVerses.append(BibleTextVerseFull(
                id: verse_index,
                text: text,
                bookDigitCode: book!.id,
                chapterDigitCode: chapter!.id,
                changedBook: !(oldBook == book!.id || oldBook == 0),
                changedChapter: !(oldChapter == chapter!.id || oldChapter == 0),
                skippedVerses: !(verse!.id - oldVerse == 1 || oldVerse == 0)
            ))
            
            oldBook =  book!.id
            oldChapter = chapter!.id
            oldVerse = verse!.id
            
        }
    }
    
    return resVerses
}

// MARK: Audio

// Дополнение данными по аудио
func getExcerptAudioVerses(textVerses: [BibleTextVerseFull]) -> ([BibleAudioVerseFull], String) {
    
    var resVerses: [BibleAudioVerseFull] = []
    
    let voice = globalBibleAudio.getCurrentVoice()
    
    var audioBook: BibleAudioBook?
    var audioChapter: BibleAudioChapter?
    
    var bookDigitCode: Int = 0
    var chapterDigitCode: Int = 0
    
    for textVerse in textVerses {
        
        print(textVerse.text)
        
        guard textVerse.id != 0 else { continue } // ошибка стиха, но может он один такой
        
        if chapterDigitCode == 0 {
            // для первого стиха находим и проверяем книгу/главу
            audioBook = voice.books.first(where: {element in element.id == textVerse.bookDigitCode})
            guard audioBook != nil else {
                return (resVerses, "Book (\(textVerse.bookDigitCode)) not found in current voice")
            }
            
            audioChapter = audioBook!.chapters.first(where: {element in element.id == textVerse.chapterDigitCode})
            guard audioBook != nil else {
                return (resVerses, "Chapter (\(textVerse.chapterDigitCode)) not found in book (\(textVerse.bookDigitCode)) in current voice")
            }
            
            bookDigitCode = textVerse.bookDigitCode
            chapterDigitCode = textVerse.chapterDigitCode
        }
        else {
            // для остальных стихов просто проверяем, что книга и глава не изменились
            
            guard bookDigitCode == textVerse.bookDigitCode else {
                return (resVerses, "There are too many books in the excerpt")
            }
            guard chapterDigitCode == textVerse.chapterDigitCode else {
                return (resVerses, "There are too many chapters in the excerpt")
            }
            
        }
        
        // находим и проверяем стих
        
        let audioVerse = audioChapter!.verses.first(where: {element in element.id == textVerse.id})
        guard audioVerse != nil else {
            return (resVerses, "Verse (\(textVerse.id)) not found in chapter(\(textVerse.chapterDigitCode)) in book (\(textVerse.bookDigitCode)) in current voice")
        }
        
        resVerses.append(BibleAudioVerseFull(
            id: textVerse.id,
            text: textVerse.text,
            begin: audioVerse!.begin,
            end: audioVerse!.end))
    }
    
    return (resVerses, "")
}

// получение номера главы из отрывка (для аудио, например)
func getExcerptBookChapterDigitCode(verses: [BibleTextVerseFull]) -> (String, String) {
    
    //let resVerses = getExcerptStrings(excerpts: excerpts)
    let resVerses = verses
    
    guard !resVerses.isEmpty else { return ("","") }
    
    guard resVerses[0].id != 0 else { return ("","") }
    
    return (
        String(format: "%02d", resVerses[0].bookDigitCode),
        String(format: "%02d", resVerses[0].chapterDigitCode)
    )
}

// Начало и конец отрывка в текущей озвучке
func getExcerptPeriod(audioVerses: [BibleAudioVerseFull]) -> (Double, Double) {
    
    guard audioVerses.count > 0 else {
        return (0, 0)
    }
    
    let period_from: Double = audioVerses[0].begin
    let period_to: Double = audioVerses[audioVerses.count - 1].end
    
    return (period_from - 0, period_to - 0)
}

// MARK: Отрывок в 1 строку
func getExcerptText(excerpts: String) -> String {
    
    let verses = getExcerptTextVerses(excerpts: excerpts)
    
    var resText = ""
    
    for (verse) in verses {
        resText = resText + verse.text + " "
    }
    
    return resText.trimmingCharacters(in: CharacterSet(charactersIn: " ,"))
}

// MARK: Готовое отображение
@ViewBuilder func viewExcerpt(verses: [BibleTextVerseFull]) -> some View {
    
    ForEach(verses, id: \.self) { verse in
        
        if verse.changedBook || verse.changedChapter || verse.skippedVerses {
            //let _ = print("changedBook", verse.changedBook)
            //let _ = print("changedChapter", verse.changedChapter)
            //let _ = print("skippedVerses", verse.skippedVerses)
            Divider()
        }
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
