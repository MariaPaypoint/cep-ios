//  Created by Maria Novikova on 02.01.2023.

import SwiftUI

struct SearchView: View {
    
    var winAction: (() -> Void)?
    var wrongAction: (() -> Void)?
    
    private var rowCount: Int
    private var colCount: Int

    private var chars: [[Character]]
    
    @Binding var words: [String]
    @Binding var foundWords: [String]
    @Binding var selected: [(Int, Int)]
    @Binding var correctSelections: [[(Int, Int)]]

    @State private var clicked: [Bool] = Array.init(repeating: false, count: 100)
    @GestureState private var location: CGPoint = .zero
    @State private var highlighted: (Int, Int)? = nil
    @State private var curWord: String = ""

    // MARK: Init
    init( chars:[[Character]], words: Binding<[String]>, foundWords: Binding<[String]>, selected: Binding<[(Int, Int)]>, correctSelections: Binding<[[(Int, Int)]]>) {
        
        self._words = words
        self._foundWords = foundWords
        self._selected = selected
        self._correctSelections = correctSelections
        
        self.chars = chars
        self.rowCount = chars.count
        self.colCount = chars[0].count
    }

    // MARK: View
    var body: some View {
        
        let highlightingWord = DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .updating($location) { (value, state, transaction) in
                state = value.location
            }.onChanged { _ in
                updateDisplayWord()
            }.onEnded {_ in
                DispatchQueue.main.async {
                    validateSelection()
                    self.selected = []
                    self.highlighted = nil
                }
            }
        
        GeometryReader { geometry in
            
            let horPads: CGFloat = 2
            let cellWidth: CGFloat = ( geometry.size.width - horPads*CGFloat(colCount-1) ) / CGFloat(colCount)
            //let _ = print(cellWidth)
            //let fullCellWidth: CGFloat = cellWidth + horPads*2
            
            VStack {
                
                /*
                Text("Found " + String(foundWords.count) + "/" + String(words.count))

                if selected.count > 0 {
                    Text(curWord.uppercased())
                }
                */
                
                let gr = Array.init(repeating: GridItem(.flexible(minimum: 25, maximum: .infinity), spacing: 0), count: colCount)
                
                LazyVGrid(columns: gr, alignment: .center, spacing: horPads, content: {
                    ForEach((0..<(rowCount * colCount)), id: \.self) { i in
                        let coord: (Int, Int) = (i / colCount, i % colCount)
                        let isSelected = self.selected.contains(where: {$0 == coord})
                        let countFound = self.correctSelections.flatMap { $0 }.filter{ $0 == (coord.0, coord.1) }.count
                        let bg = self.rectReader(row: coord.0, column: coord.1, isSelected: isSelected, countFound: countFound) // , selected: false, found: false
                        //let bg: Color = self.selected.contains(where: {$0 == coord}) ? .green : .gray
                        //let bg: Color = .green
                        Text(String(chars[coord.0][coord.1]).uppercased())
                            .fontWeight(isSelected ? .bold : .none)
                            .padding(horPads)
                            //.frame(minWidth: cellWidth, maxWidth: cellWidth, minHeight: 0, maxHeight: 200)
                            .frame(width: cellWidth, height: cellWidth)
                            .foregroundColor(Color(uiColor: UIColor(named: isSelected || countFound > 0 ? "FindWordTextFound" : "FindWordText")!))
                            .background(bg)
                            .cornerRadius(1)
                            //.scaleEffect(isSelected ? 1.5 : 1)
                            .font(.system(size: 16))
                    }
                })
                .gesture(highlightingWord)
            }
        }
    }
    
    // MARK: Reset
    func reset() {
        self.selected = []
        self.correctSelections = []
        self.highlighted = nil
    }
    
    // MARK: Background
    func rectReader(row: Int, column: Int, isSelected: Bool, countFound: Int) -> some View {
        return GeometryReader { (geometry) -> AnyView in
            if geometry.frame(in: .global).contains(self.location) {
                DispatchQueue.main.async {
                    selected.removeAll(where: { $0 == (row, column) })
                    self.selected.append((row, column))
                    straightenLine()
                }
            }
            
            //let countFound = self.correctSelections.flatMap { $0 }.filter{ $0 == (row, column) }.count
            //let fillColor = Color.pink.opacity(0.5 * Double(countFound))
            //
            var fillColor: Color
            if isSelected {
                fillColor = Color(uiColor: UIColor(named: "AccentColorCalm")!)
            } else {
                fillColor = Color(uiColor: UIColor(named: countFound>0 ? "FindWordBgFound" : "FindWordBg")!)
            }
            return AnyView(Rectangle().fill(fillColor))
        }
    }

    // MARK: I don't know
    func straightenLine() -> Void {
        if selected.count < 1 { return }
        var newSelected: [(Int, Int)] = [selected.first!]
        var closestDistance: Double = 10000.0

        var dirX: Int = selected.last!.0 - selected.first!.0
        if dirX != 0 {
            dirX = dirX < 0 ? -1 : 1
        }

        var dirY = abs(selected.last!.1) - selected.first!.1
        if dirY != 0 {
            dirY = dirY < 0 ? -1 : 1
        }

        let possibleDirs = Direction.allCases.filter {
            [0, dirX].contains($0.vecDir.0) && [0, dirY].contains($0.vecDir.1)
        }

        let xRange = min(selected.first!.0, selected.last!.0)...max(selected.first!.0, selected.last!.0)

        let yRange = min(selected.first!.1, selected.last!.1)...max(selected.first!.1, selected.last!.1)

        for d in possibleDirs {
            var lastComp = 1000.0, x = selected.first!.0, y = selected.first!.1
            var tmpLine: [(Int, Int)] = []

            while xRange ~= x && yRange ~= y {
                tmpLine.append((x, y))

                let dist = distanceBetween(a: (x, y), b: selected.last!)

                if dist > lastComp {
                    break
                }

                if dist < closestDistance {
                    newSelected = tmpLine
                    closestDistance = dist
                }

                lastComp = dist
                x += d.vecDir.0
                y += d.vecDir.1
            }
        }

        self.selected = newSelected
    }

    func distanceBetween(a: (Int, Int), b: (Int, Int)) -> Double {
        return sqrt(pow(Double(a.0 - b.0), 2) + pow(Double(a.1 - b.1), 2))
    }

    func validateSelection() -> Void {
        let word = selected.map({
            String(chars[$0.0][$0.1])
        }).joined()

        let reversed = selected.reversed().map({
            String(chars[$0.0][$0.1])
        }).joined()

        var valid: String? = nil

        if words.contains(word) {
            valid = word.uppercased()
        } else if words.contains(reversed) {
            valid = reversed
        } else {
            if (wrongAction != nil) {
                wrongAction!()
            }
            return
        }

        self.correctSelections.append(self.selected)
        if !foundWords.contains(valid!) {
            self.foundWords.append(valid!)
            
            if foundWords.count == words.count {
                if (winAction != nil) {
                    winAction!()
                }
                return
            }
        }
    }

    func onWin(perform action: @escaping () -> Void) -> Self {
        var copy = self
        copy.winAction = action
        return copy
    }

    func onWrong(perform action: @escaping () -> Void) -> Self {
        var copy = self
        copy.wrongAction = action
        return copy
    }

    func updateDisplayWord() -> Void {
        self.curWord = selected.map({
            String(chars[$0.0][$0.1])
        }).joined()
    }

}

// MARK: Preview
struct SearchView_Previews: PreviewProvider {
    static let words = ["hello", "hallelujah", "bottle", "rosa"]
    //static let chars: [[Character]]
    
    static var previews: some View {
        ForEach(["iPhone SE (3rd generation)", "iPhone 13 Pro Max"], id: \.self) { deviceName in
            ZStack {
                //Color.black
                
                let (_, ch) = GridBuilder().build(words: self.words, rows: 10, columns: 10, easyMode: false)
                
                SearchView( chars: ch, words: .constant(words), foundWords: .constant([]), selected: .constant([]), correctSelections: .constant([]))
            }
            .previewDevice(PreviewDevice(rawValue: deviceName))
            .previewDisplayName(deviceName)
            
        }
    }
}
