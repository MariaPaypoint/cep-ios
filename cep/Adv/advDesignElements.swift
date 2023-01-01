//
//  advDesignElements.swift
//  cep
//
//  Created by Maria Novikova on 14.08.2022.
//

import SwiftUI


@ViewBuilder func viewBack(action: @escaping () -> Void) -> some View {
    
    HStack{
        
        Button(action: action) {
            Image(systemName: "chevron.backward")
                .font(.system(size: 24))
                .foregroundColor(Color(uiColor: UIColor(named: "TextBlue")!))
        }
        
        Spacer()
    }
    .padding(.top, 5)
    .padding(.bottom, 0)
    
}

@ViewBuilder func baseCaption(text: String) -> some View {
    Text(text)
        .font(.largeTitle)
        .fontWeight(.thin)
        .foregroundColor(Color(uiColor: UIColor(named: "TextBlue")!))
        //.foregroundColor(Color(uiColor: UIColor(named: "BaseBlue")!))
        // Без этого подзаголовок куда-то улетает вниз
        .padding(.bottom, 0.1)
}

@ViewBuilder func baseSubCaption(_ text: String) -> some View {
    Text(text)
        .fontWeight(.light)
        .foregroundColor(Color(uiColor: UIColor(named: "TextBlue")!))
        //.foregroundColor(Color(uiColor: UIColor(named: "BaseBlue")!))
        .multilineTextAlignment(.center)
        .padding(.top, 3)
    /*
     , coral: Bool = false
     
        .fontWeight(.light)
        .foregroundColor(Color(uiColor: UIColor(named: coral ? "BaseCoral" : "TextMagenta")!))
        .padding(.top, 3)
        .padding(.bottom, 12)
        .multilineTextAlignment(.center)
     */
}
@ViewBuilder func baseButtonLabel(_ text: String, colorName: String) -> some View {
    
    Text(text)
        .font(.body)
        .foregroundColor(Color(uiColor: UIColor(named: "\(colorName)Text") ?? .white))
        .padding(.vertical, 10)
        //.frame(maxWidth: 180)
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: UIColor(named: colorName)!))
        .cornerRadius(10)
    /*
     .font(.body)
     .foregroundColor(.white)
     .padding(.vertical, 10)
     .frame(maxWidth: 180)
     .background(Color(uiColor: UIColor(named: "BaseBlue")!))
     .cornerRadius(10)
     */
}


@ViewBuilder func baseFullOrangeButtonLabel(text: String) -> some View {
    Text(text)
        .font(.body)
        .foregroundColor(.white)
        .padding(.vertical, 15)
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: UIColor(named: "BaseOrange")!))
        .cornerRadius(15)
}



// MARK: Colored Placeholder
// https://stackoverflow.com/a/57715771/13514087

// example usage:
// TextField("", text: $login)
//     .placeholder(when: login.isEmpty) {
//         Text("E-mail").foregroundColor(Color(uiColor: UIColor(named: "TextBlue")!))
//     }

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

