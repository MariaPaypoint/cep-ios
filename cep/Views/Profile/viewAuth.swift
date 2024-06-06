//  Created by Maria Novikova on 21.12.2022.

import SwiftUI
import OpenAPIClient
import Combine

struct viewAuth: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var successAuth: Bool
    
    @State private var login: String = ""
    @State private var password: String = ""
    //@FocusState private var emailFieldIsFocused: Bool
    
    // для отображения сообщений
    ///@EnvironmentObject private var appGlobalMessages: TopMessages
    
    @State private var toast: FancyToast? = nil
    
    var body: some View {
        
       
        ZStack {
            // общие сообщения не перекрывают
            ///buildMessageView(success: appGlobalMessages.Success, showVariable: appGlobalMessages.Presented, messageVariable: appGlobalMessages.Message)

            VStack {
                Spacer()
                
                Image("illustration_login")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    //.padding(.horizontal, 50)
                    //.padding(.bottom, 25)
                    .padding()
                    .onTapGesture(count: 2) {
                        login = "admin@cep.paypoint.pro"
                        password = "4e679e90fcfd0f9a"
                        toast = FancyToast(type: .info, title: "Дебаг!", message: "Тестовые логин и пароль подставлены")
                    }
                
                TextField("Электронная почта", text: $login)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    //.placeholder(when: login.isEmpty) {
                    //    Text("E-mail").foregroundColor(Color(uiColor: UIColor(named: "TextGray")!))
                    //}
                    .foregroundColor(Color(uiColor: UIColor(named: "BaseBlue")!))
                
                    .padding(15)
                //.background(Color(uiColor: UIColor(named: "BgLightPurple")!))
                //.cornerRadius(6.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(uiColor: UIColor(named: "BaseBlue")!), lineWidth: 0.8)
                    )
                    .padding(.bottom, 10)
                
                SecureField("Пароль", text: $password)
                    .foregroundColor(Color(uiColor: UIColor(named: "BaseBlue")!))
                    .padding(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(uiColor: UIColor(named: "BaseBlue")!), lineWidth: 0.8)
                    )
                    .padding(.bottom, 10)
                
                Spacer()
                Spacer()
                
                Button() {
                    auth()
                } label: {
                    baseButtonLabel("Войти")
                        .padding(.bottom)
                }
                
                Button() {
                    toast = FancyToast(type: .warning, title: "Пока не реализовано", message: "Но скоро будет. Не теряйтесь.")
                } label: {
                    Text("Еще нет аккаунта? Зарегистрируйтесь!")
                        .foregroundColor(Color(uiColor: UIColor(named: "BaseOrange")!))
                }
                
            }
            .padding(globalBasePadding)
            .toastView(toast: $toast)
        }
    }
    
    
    
    func auth() {
        
        OpenAPIClientAPI.basePath = "https://api.christedu.ru"
        LoginAPI.loginAccessTokenApiV1LoginAccessTokenPost(username: login, password: password) { (response, error) in
            guard error == nil else {
                let errorText = analyze_error(e: error!)
                toast = FancyToast(type: .error, title: "Ошибка", message: errorText)
                return
            }
            
            if ((response) != nil) {
                print("TOKEN SUCCESS: ", response!.accessToken)
                
                OpenAPIClientAPI.customHeaders = ["Authorization": "Bearer \(response!.accessToken)"]
                
                successAuth = true
                dismiss()
                
                ///appGlobalMessages.ShowMessage(success: true, message: "Слава Богу, вы снова здесь!")
                
                /*
                print("START TOKEN CHECKING")
                LoginAPI.testTokenApiV1LoginTestTokenPost() { (response, error) in
                    guard error == nil else {
                        print("TEST ERROR")
                        print(error!)
                        return
                    }
                     
                    if ((response) != nil) {
                        print("TEST SUCCESS:")
                        dump(response)
                    }
                }
                */
            }
        }
        
    }
    
}

struct viewAuth_Previews: PreviewProvider {
    //@State private var successAuth = false
    static var previews: some View {
        viewAuth(successAuth:  .constant(false))
    }
}


//extension Error {
//    var errorReponseBS: HTTPValidationError? {
//        guard let errorResponse = self as? ErrorResponse else { return nil }
//        switch errorResponse {
//        case let .error(_, data, _, _):
//            if let data = data, let errorResponseBS = try? JSONDecoder().decode(HTTPValidationError.self, from: data) {
//                return errorResponseBS
//            }
//        }
//        return nil
//    }
//}
