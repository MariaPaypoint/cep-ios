//
//  viewTaskFindWords.swift
//  cep
//
//  Created by Maria Novikova on 31.12.2022.
//

import SwiftUI
import Lottie

//private let defaultGridSize = 8

struct viewTaskFindWords: View {
    
    @Environment(\.dismiss) var dismiss
    let localAccentColor = "AccentColorCalm"
    
    var task: LessonTask
    @State private var showHelp = false
    
    @State var progress: CGFloat = 0
    @State var animateWrongText: Bool = false
    
    let animationView = LottieAnimationView()
    
    //@State private var complexity = 1
    @State private var gridSize: Int //= defaultGridSize
    
    @State private var excerpt: String //= "There is a thunderstorm."
    @State private var words: [String] //= []
    @State private var chars: [[Character]] //= []
    
    @State private var foundWords: [String] = []
    @State private var selected: [(Int, Int)] = []
    @State private var correctSelections: [[(Int, Int)]] = []
    
    
    // MARK: Init
    init(task: LessonTask) {
        self.task = task
        
        let sz = globalCurrentPutInWordsComplexity == 2 ? 10 : 8
        let ex = getExcerptText(excerpts: task.data, translationIndex: globalCurrentTranslationIndex)
        
        let(wo, ch) = tryGenerate(ex: ex, rows: sz, columns: sz, easyMode: globalCurrentPutInWordsComplexity == 0)
        
        _gridSize = State(initialValue: sz)
        _excerpt = State(initialValue: ex)
        _words = State(initialValue: wo)
        _chars = State(initialValue: ch)
    }
    
    // MARK: Body
    var body: some View {
        
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HStack(alignment: .top) {
                    viewBack() { dismiss() }
                    
                    Spacer()
                    Button {
                        //restartGame()
                        showHelp.toggle()
                    } label: {
                        Image("icon_bible")
                    }
                }
                
                baseCaption(text: "Найди слова")
                
                Spacer()
                
                // MARK: Квадрат
                if progress < 1 {
                    SearchView( chars: self.chars, words: $words, foundWords: $foundWords, selected: $selected, correctSelections: $correctSelections)
                        //.onWin {
                        //    withAnimation {
                        //        progress = (CGFloat(foundWords.count) / CGFloat(words.count))
                        //    }
                        //}
                        .onWrong {
                            animateWrong()
                        }
                        .frame(maxWidth: geometry.size.height / 2.1) // iphone5
                        .frame(maxHeight: min(geometry.size.width, geometry.size.height / 2.1))
                    Spacer()
                }
                
                // MARK: Quote
                highlightedText()
                    .multilineTextAlignment(.center)
                
                // MARK: Animation
                if progress == 1 {
                    Spacer()
                    LottieView(animationView: animationView)
                        .frame(maxWidth: .infinity)
                        .onTapGesture() {
                            animationView.play()
                        }
                        .frame(height: geometry.size.width)
                }
                Spacer()
                
                // MARK: Button
                Button {
                    dismiss()
                } label: {
                    ProgressButtonLable()
                }
                .disabled(progress < 1)
            }
        }
        
        .padding(basePadding)
        .sheet(isPresented: $showHelp, onDismiss: didDismissHelp) {
            viewDonutsHelp(/*complexity: $complexity*/)
                //.accentColor(Color(uiColor: UIColor(named: "TextBlue")!))
        }
        .offset(x: animateWrongText ? -15 : 0)
        .onChange(of: foundWords) { value in
            withAnimation {
                progress = (CGFloat(value.count) / CGFloat(words.count))
            }
        }
        .onChange(of: progress) { value in
            if value == 1 {
                animationView.play()
            }
        }
        //.onChange(of: complexity) { value in
        //    gridSize = value == 2 ? 10 : 8
        //}
    }
    
    //
    func didDismissHelp() -> Void {
        
        self.gridSize = globalCurrentPutInWordsComplexity == 2 ? 10 : 8
        
        if progress < 1 {
            restartGame()
        }
    }
    
    // MARK: Restart
    func restartGame() -> Void {
        
        self.foundWords = []
        self.selected = []
        self.correctSelections = []
        //self.progress = 0
        
        (self.words, self.chars) = tryGenerate(ex: self.excerpt, rows: gridSize, columns: gridSize, easyMode: globalCurrentPutInWordsComplexity == 0)
    }
    
    // MARK: Quote func
    func highlightedText() -> Text {
        
        let str: String = excerpt
        //let searched: [String] =
        //let searched: [String] = words
        
        guard !str.isEmpty && !words.isEmpty else { return Text(str) }
        
        var result: Text!
        let parts = str.components(separatedBy: " ")
        
        for part_index in parts.indices {
            result = (result == nil ? Text("") : result + Text(" "))
            
            let word = parts[part_index].trimmingCharacters(in: .punctuationCharacters).uppercased()
            
            if foundWords.contains(word) {
                    result = result + Text(parts[part_index])
                        .bold()
            }
            else if words.contains(word) {
                result = result + Text(parts[part_index])
                    .bold()
                    .foregroundColor(Color(uiColor: UIColor(named: "AccentColorBright")!))
            }
            else {
                result = result + Text(parts[part_index])
            }
        }
        
        return result ?? Text(str)
    }
    
    // MARK: Animation wrong
    func animateWrong() {
        withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.2, blendDuration: 0.2)) {
            animateWrongText = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.2, blendDuration: 0.2)) {
                animateWrongText = false
            }
        }
    }
    
    // MARK: Progress Button
    @ViewBuilder func ProgressButtonLable() -> some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray)
                    .frame(width: proxy.size.width)
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(uiColor: UIColor(named: localAccentColor)!))
                    .frame(width: proxy.size.width * progress)
                
                    Text("Готово")
                        .font(.body)
                        .foregroundColor(Color(uiColor: UIColor(named: "\(localAccentColor)Text") ?? .white))
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(10)
                    
            }
        }
        .frame(height: 25)
    }
    
}

// MARK: Preview
struct viewTaskFindWords_Previews: PreviewProvider {
    static var previews: some View {
        viewTaskFindWords(task: lessons[1].taskGroups[1].tasks[1])
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
    }
}
