//  Created by Maria Novikova on 05.06.2022

import SwiftUI
import OpenAPIClient

struct viewTaskPray: View {
    var body: some View {
        
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Обсуди с Богом"/*@END_MENU_TOKEN@*/)
                .font(.title)
            Text("Время для молитвенного обдумывания")
            
            Button {
                let username = "admin@cep.paypoint.pro" // String |
                let password = "4e679e90fcfd0f9a" // String |
                //let grantType = "grantType_example" // String |  (optional)
                //let scope = "scope_example" // String |  (optional) (default to "")
                //let clientId = "clientId_example" // String |  (optional)
                //let clientSecret = "clientSecret_example" // String |  (optional)

                // Login Access Token
                OpenAPIClientAPI.basePath = "https://api.christedu.ru"
                //LoginAPI.loginAccessTokenApiV1LoginAccessTokenPost(username: username, password: password, grantType: grantType, scope: scope, clientId: clientId, clientSecret: clientSecret) { (response, error) in
                LoginAPI.loginAccessTokenApiV1LoginAccessTokenPost(username: username, password: password) { (response, error) in
                    guard error == nil else {
                        print(error!)
                        return
                    }

                    if ((response) != nil) {
                        print("TOKEN SUCCESS:")
                        dump(response)
                        
                        OpenAPIClientAPI.customHeaders = ["Authorization": "Bearer \(response!.accessToken)"]
                        
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
                    }
                }
                
                
            } label: {
                Text("Test!")
            }
        }
        
    }
}

struct viewTaskPray_Previews: PreviewProvider {
    static var previews: some View {
        viewTaskPray()
    }
}
