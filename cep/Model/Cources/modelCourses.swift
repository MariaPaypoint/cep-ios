//
//  modelCourses.swift
//  23234234
//
//  Created by Maria Novikova on 05.06.2022.
//

import Foundation

var lessons: [Lesson] = load("CourseParables.json")

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle: \n\(error).")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
        
        //return CountValues(lessons_array: lessons_array as! [Lesson]) as! T
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self): \n\(error).")
    }
    
}

// высчитываем вычисляемые значения
/*
func CountValues(lessons_array: [Lesson]) -> [Lesson] {
    
    for lesson in lessons_array {
        
    }
    return lessons_array
}
*/
