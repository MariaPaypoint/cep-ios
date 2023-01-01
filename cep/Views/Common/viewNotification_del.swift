//  Created by Maria Novikova on 23.12.2022.

import SwiftUI

struct viewNotification: View {
    
    ///@EnvironmentObject private var appGlobalMessages: TopMessages
    
    var body: some View {
        
        VStack(alignment: .leading) {
            /*
            HStack {
                Text(appGlobalMessages.Success ? "Успех" : "Ошибка")
                    .font(.title3.weight(.medium))
                    .foregroundColor(Color(uiColor: UIColor(named: appGlobalMessages.Success ? "SuccessText" : "ErrorText")!))
                    .padding(.horizontal)
                .padding(.top)
                Spacer()
            }
            
            Text("\(appGlobalMessages.Message)")
                .font(.subheadline.weight(.light))
                .foregroundColor(Color(uiColor: UIColor(named: appGlobalMessages.Success ? "SuccessText" : "ErrorText")!))
                .padding(.horizontal)
                .padding(.bottom)
        }
        .background {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(Color(uiColor: UIColor(named: appGlobalMessages.Success ? "SuccessText" : "ErrorText")!), lineWidth: 0.5)
                .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color(uiColor: UIColor(named: appGlobalMessages.Success ? "SuccessBg" : "ErrorBg")!)))
             */
        }
        .frame(maxWidth: .infinity)
        .padding()
        
    }
}

// MARK: Preview
struct viewNotification_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            viewNotification()
            viewNotification()
        }
    }
}


// MARK: Build views func
func buildMessageView(success: Bool, showVariable: Bool, messageVariable: String) -> some View {
    
    return (viewNotification())
        .offset(y: showVariable ? -UIScreen.main.bounds.height/2+100 : -UIScreen.main.bounds.height)
        .animation(.interpolatingSpring(mass: 1, stiffness: 100, damping: 10, initialVelocity: 0), value: showVariable)
}
