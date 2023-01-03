//  Created by Maria Novikova on 02.01.2023.

import Foundation

/*
class WordsAPI {
    var words: [String] = ["jewel", "dozen", "witness", "slight", "polite", "curious", "defeat", "ambitious", "confidence", "sneaky", "laugh", "theory"]
    let endpoint = "https://raw.githubusercontent.com/bevacqua/correcthorse/master/wordlist.json"
    var loaded = false

    init() {
        getAllWords()
    }

    private func loadWords(completion: @escaping ([String]?) -> Void) {
        guard let url = URL(string: endpoint) else { return }

        let session = URLSession.shared

        let task = session.dataTask(with: url, completionHandler: {(data, response, error) in
            if let data = data {
                let jsonWords = try? JSONSerialization.jsonObject(with: data, options: [])
//                jsonWords = jsonWords as? [String] ?? self.words
                self.loaded = true
                completion(jsonWords as? [String] ?? self.words)
                return
//                    DispatchQueue.main.async {
//                        self.words = jsonWords as? [String] ?? self.words
//                        self.loaded = true
////                    completionHandler(words)
//                        print(self.words)
//                    }
            }
            print("Fetch failed")
            completion(nil)
        })
        task.resume()
    }

    func getAllWords() -> [String] {
        return ["мама", "вещдок", "солнце", "формат", "королева"]
        
        if loaded {
            return self.words
        } else {
            loadWords() { data in
                self.words = data ?? self.words
            }
            return self.words
        }
    }
}
*/

class WordsGenerator {
    //private var wordsAPI: WordsAPI = WordsAPI()

    func generate(source: String, minCount: Int, maxCount: Int, minLength: Int = 4, maxLength: Int = 12) -> [String] {
        
        var randomWords: [String] = []
        
        let wishCount = Int.random(in: minCount...maxCount)
        
        let allWords = source.components(separatedBy: " ")

        for _ in 0...100 {
            //let tmp: String = wordsAPI.getAllWords().randomElement()!
            let randomWord: String = allWords.randomElement()!.trimmingCharacters(in: .punctuationCharacters).uppercased()
            
            
            if minLength...maxLength ~= randomWord.count && !randomWords.contains(randomWord) {
                randomWords.append(randomWord)
            }

            if randomWords.count >= wishCount {
                return randomWords
            }
        }
        
        return randomWords
    }
}

