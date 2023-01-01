//  Created by Maria Novikova on 05.06.2022

import SwiftUI
import OpenAPIClient

struct viewTaskPray: View {
    
    //let localAccentColor = "AccentColorBright"
    let localAccentColor = "AccentColorCalm"
    //let localAccentColor = "BaseOrange"
    
    var task: LessonTask
    @Environment(\.dismiss) var dismiss
    
    @State private var countMin = ""
    @State private var countSec = ""
    @FocusState private var countMinFieldIsFocused: Bool
    @FocusState private var countSecFieldIsFocused: Bool
    
    @State private var endSignal = true
    
    @State private var isMusicPlaying = true
    
    var body: some View {
        VStack(spacing: 0) {
            
            VStack(spacing: 0) {
                viewBack() { dismiss() }
                baseCaption(text: "Обсуди с Богом")
                baseSubCaption("Время для молитвенного поиска")
                    .padding(.bottom, 7)
                HStack {
                    Text("Читать Матфея 25:1-3")
                    Image("icon_link")
                }
                .foregroundColor(Color(uiColor: UIColor(named: localAccentColor)!))
            }
            Spacer()
            
            // MARK: Quote
            /*
            VStack(spacing: 5) {
                HStack {
                    Text("Матфея")
                        //.foregroundColor(Color(uiColor: UIColor(named: "BaseOrangePink")!))
                    Text("25:13")
                        //.foregroundColor(Color(uiColor: UIColor(named: "BaseMagenta")!))
                }
                .foregroundColor(Color(uiColor: UIColor(named: "BaseOrangePink")!))
                .font(.title3)
                Text("Итак, бодрствуйте, потому что не знаете ни дня, ни часа, в который приидет Сын Человеческий.")
                    .fontWeight(.light)
                    .foregroundColor(Color(uiColor: UIColor(named: "TextBase")!))
                    .multilineTextAlignment(.center)
                    //.font(.title3)
                    //.padding(.bottom, 12)
                HStack {
                    Text("Весь отрывок")
                        .foregroundColor(Color(uiColor: UIColor(named: "BaseBlue")!))
                    Image("icon_link")
                }
            }
             Spacer()
             */
            
            
            // MARK: Timer
            VStack {
                HStack {
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                    Spacer()
                    /*
                    TextField("", text: $countMin)
                        .keyboardType(.numberPad)
                        // чтобы сразу вводить число, без стирания
                        .focused($countMinFieldIsFocused)
                        .placeholder(when: countMin.isEmpty && !countMinFieldIsFocused) {
                            Text("15").foregroundColor(Color(uiColor: UIColor(named: "BaseOrangePink")!))
                                .frame(maxWidth: 100)
                            .multilineTextAlignment(.center)
                        }
                        .padding(.vertical, 20)
                        .frame(maxWidth: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color(uiColor: UIColor(named: "BaseOrangePink")!), lineWidth: 0.8)
                        )
                     */
                    buildTimeEdit(varValue: $countMin, varFocused: $countMinFieldIsFocused, defValue: "15")
                    Spacer()
                    Text(":")
                    Spacer()
                    buildTimeEdit(varValue: $countSec, varFocused: $countSecFieldIsFocused, defValue: "00")
                    Spacer()
                    Image(systemName: "play.circle.fill")
                }
                .font(.system(size: 48))
                .foregroundColor(Color(uiColor: UIColor(named: localAccentColor)!))
                .padding(.bottom, 10)
                
                HStack {
                    Spacer()
                    Toggle("Сигнал по завершении", isOn: $endSignal)
                        .labelsHidden()
                        .tint(Color(uiColor: UIColor(named: "TextBlue")!))
                    Text("Сигнал по завершении")
                        .foregroundColor(Color(uiColor: UIColor(named: "TextBlue")!))
                    Spacer()
                }
            }
            Spacer()
            
            // MARK: Illustration
            Image("illustration_music")
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .clipped()
            
            // MARK: Button Music
            Button() {
                isMusicPlaying.toggle()
            } label: {
                HStack {
                    Image(systemName: isMusicPlaying ? "play" : "pause")
                        .imageScale(.large)
                    Text("Включить легкую музыку")
                }
                .foregroundColor(Color(uiColor: UIColor(named: localAccentColor)!))
            }
            .padding(.top)
            
            Spacer()
            
            Button() {
                dismiss()
            } label: {
                HStack {
                    baseButtonLabel("Готово", colorName: localAccentColor)
                        .padding(.vertical)
                }
            }
        }
        .padding(.horizontal, basePadding)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
        }
        
    }
    
    // buildTimeEdit(varValue: countMin, varFocused: countMinFieldIsFocused)
    
    func buildTimeEdit(varValue: Binding<String>, varFocused: FocusState<Bool>.Binding, defValue: String) -> some View {
        return TextField("", text: varValue)
            .keyboardType(.numberPad)
            // чтобы сразу вводить число, без стирания
            .focused(varFocused)
            .placeholder(when: varValue.wrappedValue.isEmpty && !varFocused.wrappedValue) {
                Text(defValue).foregroundColor(Color(uiColor: UIColor(named: localAccentColor)!))
                    .frame(maxWidth: 100)
                .multilineTextAlignment(.center)
            }
            .padding(.vertical, 20)
            .frame(maxWidth: 100)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color(uiColor: UIColor(named: localAccentColor)!), lineWidth: 0.8)
            )
            .multilineTextAlignment(.center)
            .font(.system(size: 42))
    }
}

struct viewTaskPray_Previews: PreviewProvider {
    static var previews: some View {
        viewTaskPray(task: lessons[0].taskGroups[0].tasks[0])
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
    }
}



