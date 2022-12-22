//  Created by Maria Novikova on 21.12.2022.

import SwiftUI
import OpenAPIClient

struct viewAuth: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var login: String = ""
    @State private var password: String = ""
    //@FocusState private var emailFieldIsFocused: Bool
    
    var body: some View {
        /*
         Form {
         //TextField("E-mail или телефон", text: $login)
         //TextField("Пароль", text: $password)
         
         Section {
         TextField(
         "User name (email address)",
         text: $login
         )
         .focused($emailFieldIsFocused)
         .onSubmit {
         //validate(name: username)
         }
         .disableAutocorrection(true)
         //.border(.secondary)
         }
         Section {
         Text(login)
         .foregroundColor(emailFieldIsFocused ? .red : .blue)
         }
         .padding(-10)
         }
         */
        
        VStack {
            Spacer()
            
            Image("temp_login")
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .clipped()
            //.padding(.horizontal, 50)
                .padding(.bottom, 25)
                .onTapGesture(count: 2) {
                    login = "admin@cep.paypoint.pro"
                    password = "4e679e90fcfd0f9a"
                }
            
            TextField("mail@example.com", text: $login)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
            //.placeholder(when: login.isEmpty) {
            //    Text("E-mail").foregroundColor(Color(uiColor: UIColor(named: "TextGray")!))
            //}
                .foregroundColor(Color(uiColor: UIColor(named: "BaseOrange")!))
            
                .padding(15)
            //.background(Color(uiColor: UIColor(named: "BgLightPurple")!))
            //.cornerRadius(6.0)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(uiColor: UIColor(named: "BaseOrange")!), lineWidth: 0.8)
                )
                .padding(.bottom, 10)
            
            SecureField("password", text: $password)
                .foregroundColor(Color(uiColor: UIColor(named: "BaseOrange")!))
                .padding(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(uiColor: UIColor(named: "BaseOrange")!), lineWidth: 0.8)
                )
                .padding(.bottom, 10)
            
            Spacer()
            Spacer()
            
            Button() {
                dismiss()
            } label: {
                baseFullOrangeButtonLabel(text: "Войти")
            }
            .padding(.bottom, 5)
            
        }
        .padding(basePadding)
    }
    
    
    func auth() {
        
        OpenAPIClientAPI.basePath = "https://api.christedu.ru"
        LoginAPI.loginAccessTokenApiV1LoginAccessTokenPost(username: login, password: password) { (response, error) in
            guard error == nil else {
                print(error!)
                return
            }
            
            if ((response) != nil) {
                print("TOKEN SUCCESS:")
                dump(response)
                
                OpenAPIClientAPI.customHeaders = ["Authorization": "Bearer \(response!.accessToken)"]
                //dismiss()
                
                /*
                print("START TEST")
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
    static var previews: some View {
        viewAuth()
    }
}
