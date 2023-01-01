//
//  viewTaskOrderWords.swift
//  cep
//
//  Created by Maria Novikova on 01.01.2023.
//

import SwiftUI
import Lottie

struct viewTaskOrderWords: View {
    
    @Environment(\.dismiss) var dismiss
    let localAccentColor = "AccentColorCalm"
    
    var task: LessonTask
    @State private var showHelp = false
    
    @State var characters: [Character] = []
    @State var progress: CGFloat = 0
    // for drag
    @State var shuffledRows: [[Character]] = []
    // for drop
    @State var rows: [[Character]] = []
    
    @State var animateWrongText: Bool = false
    @State var droppedCount: CGFloat = 0
    
    let animationView = LottieAnimationView()
    
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
            
            baseCaption(text: "Расставь по порядку")
            baseSubCaption(task.dataDescription)
                .padding(.bottom, 7)
            
            //ProgressNavBar()
            
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        Spacer()
                        DropArea()
                            .padding(.vertical, 15)
                        Spacer()
                        
                        if progress < 1 {
                            DragArea()
                                .padding(.top, 15)
                        }
                        else {
                            //GeometryReader { geometry in
                                LottieView(animationView: animationView)
                                    .frame(maxWidth: .infinity)
                                    .onTapGesture() {
                                        animationView.play()
                                    }
                                    .frame(height: geometry.size.width)
                                    //.background(.gray)
                            //}
                        }
                        Spacer()
                        
                    }
                    .frame(minHeight: geometry.size.height)
                }
                .frame(width: geometry.size.width)
            }
            
            
            
            Button {
                dismiss()
            } label: {
                ProgressButtonLable()
            }
            .disabled(progress < 1)
        }
        .padding(.horizontal, basePadding)
        .padding(.bottom, 10)
        .sheet(isPresented: $showHelp) {
            viewQuote(task: task)
                .accentColor(Color(uiColor: UIColor(named: "TextBlue")!))
        }
        .onAppear {
            if rows.isEmpty {
                // First creating shuffled one
                // then normal one
                characters = getCharacters(phrase: getExcerptText(excerpts: task.data, translationIndex: globalCurrentTranslationIndex))
                let characters_ = characters
                characters = characters.shuffled()
                shuffledRows = generateGrid()
                characters = characters_
                rows = generateGrid()
            }
        }
        .offset(x: animateWrongText ? -15 : 0)
        
        .onChange(of: progress) { value in
            if value == 1 {
                animationView.play()
            }
        }
        
    }
    
    // MARK: Drag
    @ViewBuilder func DragArea() -> some View {
        VStack(spacing: 12) {
            ForEach($shuffledRows, id: \.self) { $row in
                HStack(spacing: 10) {
                    ForEach($row) { $item in
                        Text(item.value)
                            .font(.system(size: item.fontSize))
                            .padding(.vertical, 5)
                            .padding(.horizontal, item.padding)
                            .background {
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .stroke(.gray)
                            }
                            .onTapGesture {
                                for index in characters.indices {
                                    if !characters[index].isShowing {
                                        if characters[index].value == item.value {
                                            characters[index].isShowing = true
                                            droppedCount += 1
                                            let progress = (droppedCount / CGFloat(characters.count))
                                            withAnimation {
                                                item.isShowing = true
                                                updateArray(character: characters[index])
                                                self.progress = progress
                                            }
                                        }
                                        else {
                                            animateVrong()
                                        }
                                        break
                                    }
                                }
                            }
                            .onDrag {
                                return .init(contentsOf: URL(string: item.id))!
                                //return .init(contentsOf: URL(string: item.value))!
                            }
                            .opacity(item.isShowing ? 0 : 1)
                            .background {
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(item.isShowing ? .gray.opacity(0.25) : .clear)
                            }
                    }
                }
            }
        }
    }
    
    // MARK: Drop
    @ViewBuilder func DropArea() -> some View {
        VStack(spacing: 12) {
            ForEach($rows, id: \.self) { $row in
                HStack(spacing: 10) {
                    ForEach($row) { $item in
                        Text(item.value)
                            .font(.system(size: item.fontSize))
                            .padding(.vertical, progress < 1 ? 5 : 0)
                            .padding(.horizontal, progress < 1 ? item.padding : 0)
                            .opacity(item.isShowing || progress == 1 ? 1 : 0)
                            .background {
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(.gray.opacity(0.25))
                                    .opacity(item.isShowing || progress == 1 ? 0 : 1)
                            }
                            .background {
                                // if item is dropped into correct place
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .stroke(.gray)
                                    .opacity(item.isShowing && progress < 1 ? 1 : 0)
                            }
                            // MARK: Adding drop operation
                            .onDrop(of: [.url], isTargeted: .constant(false)) { providers in
                                
                                if let first = providers.first {
                                    let _ = first.loadObject(ofClass: URL.self) { value, error in
                                        guard let url = value else { return }
                                        if item.id == "\(url)" {
                                        //if item.value == "\(url)" {
                                            droppedCount += 1
                                            let progress = (droppedCount / CGFloat(characters.count))
                                            withAnimation {
                                                item.isShowing = true
                                                updateShuffledArray(character: item)
                                                updateCharacters(character: item)
                                                self.progress = progress
                                            }
                                        }
                                        else {
                                            animateVrong()
                                        }
                                    }
                                }
                                
                                return false
                            }
                    }
                }
            }
        }
    }
    
    // MARK: Progress
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
    
    /*
    @ViewBuilder func ProgressNavBar() -> some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(.gray.opacity(0.25))
                    //.frame(height: 5)
                
                Capsule()
                    .fill(.green)
                    .frame(width: proxy.size.width * progress)
                    //.frame(height: 5)
            }
            //.frame(height: 5)
        }
        .frame(height: 5)
    }
    */
    
    // MARK: Gustom grid cols
    func generateGrid() -> [[Character]] {
        // Step 1
        // Identifying each text Width and update
        
        for item in characters.enumerated() {
            let textSize = textSize(character: item.element)
            characters[item.offset].textSize = textSize
        }
        
        var gridArray: [[Character]] = []
        var tempArray: [Character] = []
        
        // Current Width
        var currentWidth: CGFloat = 0
        let totalScreenWidth: CGFloat = UIScreen.main.bounds.width - 30
        
        for character in characters {
            currentWidth += character.textSize
            
            if currentWidth < totalScreenWidth {
                tempArray.append(character)
            }
            else {
                gridArray.append(tempArray)
                tempArray = []
                currentWidth = character.textSize
                tempArray.append(character)
            }
        }
        
        // Checking Exhaust
        if !tempArray.isEmpty {
            gridArray.append(tempArray)
        }
        
        return gridArray
    }
    
    // MARK: Identifying Text Size
    func textSize(character: Character) -> CGFloat {
        let font = UIFont.systemFont(ofSize: character.fontSize)
        
        let attributes = [NSAttributedString.Key.font : font]
        
        let size = (character.value as NSString).size(withAttributes: attributes)
        
        // Horizontal Padding
        return size.width + (character.padding * 2) + 15
    }
    
    // MARK: updating shuffled array
    
    
    func updateShuffledArray(character: Character) {
        for index in shuffledRows.indices {
            for subIndex in shuffledRows[index].indices {
                if shuffledRows[index][subIndex].id == character.id {
                    shuffledRows[index][subIndex].isShowing = true
                }
            }
        }
    }
    
    
    func updateArray(character: Character) {
        for index in rows.indices {
            for subIndex in rows[index].indices {
                if rows[index][subIndex].id == character.id {
                    rows[index][subIndex].isShowing = true
                }
            }
        }
    }
    
    func updateCharacters(character: Character) {
        for index in characters.indices {
            if characters[index].id == character.id {
                characters[index].isShowing = true
            }
        }
    }
    
    // MARK: Animation wrong
    func animateVrong() {
        withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.2, blendDuration: 0.2)) {
            animateWrongText = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.2, blendDuration: 0.2)) {
                animateWrongText = false
            }
        }
    }
}

struct viewTaskOrderWords_Previews: PreviewProvider {
    static var previews: some View {
        viewTaskOrderWords(task: lessons[1].taskGroups[1].tasks[2])
    }
}
