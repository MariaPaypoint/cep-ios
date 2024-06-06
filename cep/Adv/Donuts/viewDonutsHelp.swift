//
//  viewDonutsHelp.swift
//  cep
//
//  Created by Maria Novikova on 03.01.2023.
//

import SwiftUI

struct viewDonutsHelp: View {
    
    //@Binding var complexity: Int
    @State var complexity: Int = globalCurrentPutInWordsComplexity
    
    @Environment(\.dismiss) var dismiss
    
    let localAccentColor = "AccentColorCalm"
    
    var body: some View {
        VStack {
            viewBack() { dismiss() }
            
            baseCaption(text: "Уровень сложности")
            viewSegmentedButtons(arr: ["Легкий", "Средний", "Сложный"], selIndex: complexity, baseColor: Color(uiColor: UIColor(named: localAccentColor)!)) { selectedIndex in
                withAnimation {
                    complexity = selectedIndex
                    globalCurrentPutInWordsComplexity = selectedIndex
                }
            }
            
            Spacer()
            
            baseCaption(text: "Правила игры")
            
            VStack {
                Text("Найдите все слова из цитаты, выделенные ") + Text("ярким").bold().foregroundColor(Color(uiColor: UIColor(named: "AccentColorBright")!)) + Text(" цветом.")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 5)
            
            Text("Слова могут располагаться по горизонтали, вертикали или диагонали.")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 15)
            
            VStack {
                Image("illustration_findwords_example")
                    .resizable()
                    .clipped()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 300, maxHeight: 300)
                    .rotationEffect(.degrees(-10))
                   
            }
            .background(Color(uiColor: UIColor(named: "FindWordBg")!))
            .padding(.bottom, 15)
            
            Spacer()
            
            Button() {
                dismiss()
            } label: {
                baseButtonLabel("Понятно", colorName: localAccentColor)
            }
        }
        .padding(globalBasePadding)
    }
}

struct viewDonutsHelp_Previews: PreviewProvider {
    static var previews: some View {
        viewDonutsHelp(/*complexity: .constant(1)*/)
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
    }
}
