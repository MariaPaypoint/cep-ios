//
//  typeCharacters.swift
//  cep
//
//  Created by Maria Novikova on 01.01.2023.
//

import Foundation

struct OrderCharacter: Identifiable,Hashable, Equatable {
    var id = UUID().uuidString
    var value: String
    var padding: CGFloat = 10
    var textSize: CGFloat = .zero
    var fontSize: CGFloat = 16
    var isShowing: Bool = false
}

func getOrderCharacters(phrase: String) -> [OrderCharacter] {
    
    var resCharacters: [OrderCharacter] = []
    
    let arrWords = phrase.components(separatedBy: " ")
    let fontSize: CGFloat = arrWords.count > 25 ? 14 : (arrWords.count > 15 ? 16 : 19)
    let padding: CGFloat = arrWords.count > 25 ? 8 : 10
    for str in arrWords {
        resCharacters.append(OrderCharacter(value: str, padding: padding, fontSize: fontSize))
    }
    
    return resCharacters
}
