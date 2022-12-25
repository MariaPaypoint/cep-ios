//
//  Cources.swift
//  23234234
//
//  Created by Maria Novikova on 05.06.2022.
//

import Foundation
import SwiftUI

struct LessonTask: Hashable, Codable {
    var type: String
    var done: Bool
    var data: String
    var dataDescription: String
}

struct TaskGroup: Hashable, Codable {
    var name: String
    var tasks: [LessonTask]
}

struct Lesson: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var nameFull: String
    //var starsAll: Int
    //var starsDone: Int
    var row: Int
    
    // временно
    //var rowIndex: Int {
    //    1
    //}
    
    var image: Image {
        Image(imageName)
    }
    
    private var imageName: String
    var imageNameFull: String {
        // надо бы добавить проверку существования файла
        return imageName + "_full"
    }
    
    var taskGroups: [TaskGroup]
    
    var starsAll: Int {
        var r = 0
        for taskgroup in taskGroups {
            r += taskgroup.tasks.count
        }
        return r
    }
    var starsDone: Int {
        var r = 0
        for taskgroup in taskGroups {
            for task in taskgroup.tasks {
                if task.done { r += 1 }
            }
        }
        return r
    }
    
}
