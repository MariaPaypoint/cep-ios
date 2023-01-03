//
//  GridBuilder.swift
//  donuts
//
//  Created by Maria Novikova on 29.12.2022.
//

import Foundation


enum Direction: CaseIterable {
    case UP, DOWN, LEFT, RIGHT, UPRIGHT, UPLEFT, DOWNRIGHT, DOWNLEFT

    var vecDir:(Int, Int) {
        switch self {
            case .UP:        return ( 0,  1)
            case .DOWN:      return ( 0, -1)
            case .RIGHT:     return ( 1,  0)
            case .LEFT:      return (-1,  0)
            case .UPRIGHT:   return ( 1,  1)
            case .UPLEFT:    return (-1,  1)
            case .DOWNRIGHT: return ( 1, -1)
            case .DOWNLEFT:  return (-1, -1)
        }
    }
}

class GridBuilder: ObservableObject {
    
    @Published var grid = [[Character]]()
    

    private var words:[String] = []
    private var totalRows:Int = 0
    private var totalColumns:Int = 0
    
    /*
    func parametrize(words: [String], rows:Int, columns:Int) {
        self.words = words
        self.grid = Array.init(repeating: Array.init(repeating: "-", count: columns), count: rows)
        self.totalRows = rows
        self.totalColumns = columns
    }
    */
    
    func build(words: [String], rows:Int, columns:Int, easyMode: Bool) -> (Bool, [[Character]]) {
        
        //let chars = "aaabcdeeefghiiijklllmnooopqrrssstttuuuvwxyz"
        let chars = easyMode ? "*" : "аааббввггддееежзииийккклллмммннноооппрррссстттуфхцчшщъыьэюя"
        
        self.words = words
        self.grid = Array.init(repeating: Array.init(repeating: "-", count: columns), count: rows)
        self.totalRows = rows
        self.totalColumns = columns
        
        self.grid = Array.init(repeating: Array.init(repeating: "*", count: self.totalColumns), count: self.totalRows)
        
        var generated = false
        trialLoop: for _ in (0...10) {
            
            for word in words.shuffled() {
                if !insertWord(word: word) {
                    continue trialLoop
                }
            }
            generated = true
            //print("Generation success on \(words.count) words from the \(attempt) attempt")
            break
        }
        
        if !generated {
            //print("Generation fail on \(words.count) words")
            self.grid = Array.init(repeating: Array.init(repeating: "*", count: self.totalColumns), count: self.totalRows)
            return (false, self.grid)
        }
        
        for r in (0..<self.totalRows) {
            for c in (0..<self.totalColumns) {
                if self.grid[r][c] == "*" {
                    self.grid[r][c] = chars.randomElement() ?? "*"
                }
            }
        }
        
        return (true, self.grid)

    }

    func insertWordAt(word:String, rowNum:Int, columNum:Int, dir:Direction) -> Void {
        let (deltaX, deltaY) = dir.vecDir
        var curX = columNum, curY = rowNum

        for char in word {
            if char != self.grid[curY][curX] {
                self.grid[curY][curX] = char
            }
            curX += deltaX
            curY += deltaY
        }
    }

    func insertWord(word:String) -> Bool {
        for _ in (0...200) {
            let c = Int(arc4random_uniform(UInt32(self.totalColumns)))
            let r = Int(arc4random_uniform(UInt32(self.totalRows)))
            // let d = Direction.allCases.randomElement()!

            for d in Direction.allCases.shuffled() {
                if canInsertAt(rowNum: r, columnNum: c, word: word, dir: d) {
                    insertWordAt(word: word, rowNum: r, columNum: c, dir: d)
                    return true
                }
            }
        }
        return false
    }

    func canInsertAt(rowNum:Int, columnNum:Int, word:String, dir:Direction) -> Bool {
        let (xDir, yDir) = dir.vecDir
        var curX = columnNum, curY = rowNum
        
        //for char in word {
        for _ in word {
            if curX < 0 || curX > (self.totalColumns - 1) || curY < 0 || curY > (self.totalRows - 1) {
                return false
            }
            
            // закомментировано, чтобы одни и те же символы в разных словах не использовались
            if self.grid[curY][curX] == "*" /*|| self.grid[curY][curX] == char*/ {
                curX += xDir
                curY += yDir
            } else {
                return false
            }
        }
        return true
    }
}


func tryGenerate(ex: String, rows: Int, columns: Int, easyMode: Bool) -> ([String], [[Character]]) {
    
    let minCount = 3
    let maxCount = rows
    
    let wo = WordsGenerator().generate(source: ex, minCount: minCount, maxCount: maxCount, minLength: 2, maxLength: min(rows, columns))
    
    let (success, ch) = GridBuilder().build(words: wo, rows: rows, columns: columns, easyMode: easyMode)
    
    if !success {
        for _ in (0...10) {
            
            let wo = WordsGenerator().generate(source: ex, minCount: minCount, maxCount: maxCount, minLength: 2, maxLength: min(rows, columns))
            
            let (success, ch) = GridBuilder().build(words: wo, rows: rows, columns: columns, easyMode: easyMode)
            
            if success {
                //print(attempt)
                return (wo, ch)
            }
        }
    }
    
    return (wo, ch)
}
