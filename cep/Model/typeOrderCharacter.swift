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
    var fontSize: CGFloat = 19
    var isShowing: Bool = false
}

func getOrderCharacters(phrase: String) -> [OrderCharacter] {
    
    var resCharacters: [OrderCharacter] = []
    
    for str in phrase.components(separatedBy: " ") {
        resCharacters.append(OrderCharacter(value: str))
    }
    
    return resCharacters
}
