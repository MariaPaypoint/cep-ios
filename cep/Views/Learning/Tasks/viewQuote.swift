//
//  viewQuote.swift
//  cep
//
//  Created by Maria Novikova on 29.12.2022.
//

import SwiftUI

struct viewQuote: View {
    
    @Environment(\.dismiss) var dismiss
    let localAccentColor = "AccentColorCalm"
    
    var task: LessonTask
    
    var body: some View {
        
        GeometryReader { metrics in
            VStack {
                
                
                viewBack() { dismiss() }
                
                Spacer()
                
                baseCaption(text: "Постарайся запомнить")
                baseSubCaption(task.dataDescription)
                
                Spacer()
                
                ZStack {
                    Image("illustration_quote")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        //.border(.red)
                    
                    VStack(alignment: .center) {
                        //let verses = getExcerptStrings(excerpts: task.data, translationIndex: 0)
                        //ForEach(verses.sorted(by: <), id: \.key) {key, value in
                        //    Text("\(value)")
                        //        .frame(width: metrics.size.width * 0.65)
                        //        .border(.green)
                        //}
                        //ForEach(Array(verses.keys), id: \.self) {
                        //    Text(verses[$0]!)
                        //}
                        
                        let excerpt = getExcerptText(excerpts: task.data, translationIndex: globalCurrentTranslationIndex)
                        Text(excerpt.trimmingCharacters(in: CharacterSet(charactersIn: " ,")))
                            .multilineTextAlignment(.center)
                            .font(excerpt.count > 200 ? .body.weight(.regular) : .title3.weight(.regular))
                            .padding(.top, metrics.size.width * 0.05)
                            .frame(width: metrics.size.width * 0.65)
                            .foregroundColor(.black)
                            //.border(.green)
                    }
                    //.padding(.horizontal, metrics.size.width * 0.175)
                    
                }
                .padding(.horizontal, -basePadding)
                
                Spacer()
                Spacer()
                Button() {
                    dismiss()
                } label: {
                    baseButtonLabel("Продолжить", colorName: localAccentColor)
                }
            }
            .padding(basePadding)
        }
    }
}

struct viewQuote_Previews: PreviewProvider {
    static var previews: some View {
        viewQuote(task: lessons[1].taskGroups[1].tasks[0])
    }
}
