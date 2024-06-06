//
//  Utility.swift
//  AVPlayer-SwiftUI
//
//  Created by Chris Mash on 11/09/2019.
//  Copyright © 2019 Chris Mash. All rights reserved.
//

import Foundation

//import SwiftUI
import OpenAPIClient
//import Combine

class Utility: NSObject {
    
    private static var timeHMSFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        return formatter
    }()
    
    static func formatSecondsToHMS(_ seconds: Double) -> String {
        guard !seconds.isNaN,
            let text = timeHMSFormatter.string(from: seconds) else {
                return "00:00"
        }
         
        return text
    }
    
}


struct HTTPError: Decodable {
    let detail: String
}

// https://github.com/swagger-api/swagger-codegen/issues/2110#issuecomment-320907231
func analyze_error(e: Error) -> String {
    var errorText = ""
    if e is ErrorResponse {
        
        switch e as! ErrorResponse {
            case let .error(statusCode, data, _, _):
            
            switch statusCode {
            case 422:
                // здесь надо сделать парсинг, но в целом нет большого смысла в том, чтобы протаскивать апишное название параметра наверх. А программист может и в принте посмотреть проблему.
                let bodyJson = data.flatMap { String(data: $0, encoding: .utf8) } ?? ""
                print("statusCode: ", dump(statusCode))
                print("body:", bodyJson)
                errorText = "Неверные параметры"
            default:
                let httpErr = try! JSONDecoder().decode(HTTPError.self, from: data!)
                errorText = httpErr.detail
            }
            break
        }
    }
    return errorText
}
