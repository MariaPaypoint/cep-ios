//
//  typeCharacters.swift
//  cep
//
//  Created by Maria Novikova on 01.01.2023.
//

import Foundation

struct Character: Identifiable,Hashable, Equatable {
    var id = UUID().uuidString
    var value: String
    var padding: CGFloat = 10
    var textSize: CGFloat = .zero
    var fontSize: CGFloat = 19
    var isShowing: Bool = false
}

func getCharacters(phrase: String) -> [Character] {
    
    var resCharacters: [Character] = []
    
    for str in phrase.trimmingCharacters(in: CharacterSet(charactersIn: " ,")).components(separatedBy: " ") {
        resCharacters.append(Character(value: str))
    }
    
    return resCharacters
}
