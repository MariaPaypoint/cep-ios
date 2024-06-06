//  Created by Maria Novikova on 20.12.2022.

import SwiftUI
import OpenAPIClient

struct viewProfile: View {
    
    @State private var showAuth = false
    @State private var successAuth = false
    
    //@State private var email = "unknown mail
    // https://github.com/MariaPaypoint/cep-ios-apiclient/blob/master/docs/User.md
    @State private var user: User = User()
    
    //@EnvironmentObject private var appGlobals: TopMessages
    @State private var toast: FancyToast? = nil
    
    var body: some View {
        
        // красиво на больших экранах и скролл на маленьких
        // https://stackoverflow.com/a/68465863/13514087
        GeometryReader { proxy in
            ScrollView {
                VStack {
                    // MARK: Фото и имя
                    HStack {
                        Image("temp_woman")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipped()
                            .mask { RoundedRectangle(cornerRadius: 60, style: .continuous) }
                        VStack {
                            HStack {
                                Text("\(user.fullName ?? "User Name")")
                                    .font(.title.weight(.thin))
                                    .foregroundColor(Color(.sRGB, red: 14/255, green: 129/255, blue: 165/255))
                                Spacer()
                            }
                            HStack {
                                
                                Text("\(user.email ?? "e-mail")")
                                    .foregroundColor(.secondary)
                                    .font(.body.weight(.thin))
                                Spacer()
                                
                            }
                        }
                        .padding(.leading, 10)
                    }
                    .padding(.top)
                    
                    //MARK: 3 строки
                    VStack {
                        buildRow(imageName: "top_icon_star", bigText: "Звезды знаний:", bigValue: "315", smallText: "За последнюю неделю:", smallValue: "+22", smallPostfix: "")
                        buildRow(imageName: "top_icon_fire", bigText: "Дней без перерыва:", bigValue: "199", smallText: "В среднем по", smallValue: "3", smallPostfix: "звезды в день")
                        buildRow(imageName: "top_icon_reward", bigText: "Получено наград:", bigValue: "25", smallText: "В т.ч.", smallValue: "4", smallPostfix: "свои достигнутые цели")
                    }
                    
                    // MARK: 2 кнопки
                    HStack {
                        Button() {
                            
                            
                            
                            
                        } label: {
                            /*
                            HStack {
                                Image("icon_edit")
                                Text("Редактировать")
                                    .font(.subheadline)
                            }
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(Color(uiColor: UIColor(named: "BaseOrange")!))
                            .cornerRadius(10)
                             */
                            baseButtonLabel("Изменить", colorName: "BaseOrange", imageName: "icon_edit")
                        }
                        
                        Spacer()
                        Spacer()
                        
                        Button() {
                            showAuth = true
                        } label: {
                            /*
                            HStack {
                                Text("Выйти")
                                    .font(.subheadline)
                                Image("icon_exit")
                            }
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(Color(uiColor: UIColor(named: "BaseRed")!))
                            .cornerRadius(10)
                             */
                            baseButtonLabel("Выйти", colorName: "BaseRed", imageName: "icon_exit")
                        }
                    }
                    .padding(.vertical, 20)
                    
                    Spacer()
                    
                    // MARK: О проекте
                    VStack {
                        builBlueText("Наша цель - помочь каждому христианину жить")
                        HStack(spacing: 0) {
                            buildAccentText("К")
                            builBlueText("ачественной")
                                .padding(.trailing, 7)
                            buildAccentText("Д")
                            builBlueText("уховной")
                                .padding(.trailing, 7)
                            buildAccentText("Ж")
                            builBlueText("изнью,")
                        }
                        builBlueText("ведь Бог меняет человека изнутри, а хорошие люди делают и весь мир лучше.")
                            .padding(.bottom, 6)
                        builBlueText("В нашем проекте нет рекламы, он бесплатный для всех и имеет открытый исходный код.\nКоманда работает над проектом благодаря участию неравнодушных людей. Вы тоже можете стать частью команды, или помочь материально.")
                            .padding(.bottom, 6)
                        builBlueText("Авторы курсов также нуждаются в поддержке, которая позволяет им создавать бесплатный качественный христианский образовательный контент.\nВы тоже можете стать автором!")
                            .padding(.bottom, 13)
                        
                        Button() {
                            showAuth = true
                        } label: {
                            HStack {
                                Image(systemName: "heart")
                                    .imageScale(.large)
                                    .symbolRenderingMode(.monochrome)
                                Text("Посмотрите, как вы можете участвовать")
                                    .font(.subheadline)
                            }
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(Color(uiColor: UIColor(named: "BaseBlue")!))
                            .cornerRadius(10)
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                .frame(minHeight: proxy.size.height)
            }
            //.fullScreenCover(isPresented: $showAuth) {
            .sheet(isPresented: $showAuth, onDismiss: didDismissAuth) {
                viewAuth(successAuth: $successAuth)
            }
            .toastView(toast: $toast)
            
        }
    }
    
    // MARK: Доп.функции контента
    func buildRow(imageName: String, bigText: String, bigValue: String, smallText: String, smallValue: String, smallPostfix: String) -> some View {
        return HStack(alignment: .center) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 26, height: 26)
                .clipped()
                .padding(.trailing, 10)
            VStack {
                HStack {
                    Text(bigText)
                        .font(.body.weight(.light))
                        .foregroundColor(.primary)
                    Text(bigValue)
                        .font(.body.weight(.light))
                        .foregroundColor(Color(.sRGB, red: 210/255, green: 28/255, blue: 128/255))
                    Spacer()
                }
                HStack() {
                    Text(smallText)
                        .foregroundColor(.secondary)
                        .font(.footnote.weight(.light))
                    Text(smallValue)
                        .font(.footnote)
                        .foregroundColor(Color(.sRGB, red: 0/255, green: 168/255, blue: 204/255))
                    Text(smallPostfix)
                        .foregroundColor(.secondary)
                        .font(.footnote.weight(.light))
                    Spacer()
                }
            }
        }
        .padding(.top, 5)
        .padding(.leading, 35)
    }
    
    func builBlueText(_ text: String) -> some View {
        return Text(text)
            .font(.subheadline.weight(.light))
            .foregroundColor(Color(uiColor: UIColor(named: "TextBlue")!))
            .multilineTextAlignment(.center)
    }
    func buildAccentText(_ text: String) -> some View {
        return Text(text)
            .font(.callout.weight(.regular))
            .foregroundColor(Color(uiColor: UIColor(named: "TextDarkBlue")!))
            .multilineTextAlignment(.center)
    }
    
    // MARK: После авторизации
    func didDismissAuth() {
        if successAuth {
            // чтобы при следующем просто закрытии авторизации не числился успехом
            successAuth = false
            
            toast = FancyToast(type: .success, title: "Слава Богу", message: "Авторизация успешная. Добро пожаловать!")
            
            // https://github.com/MariaPaypoint/cep-ios-apiclient/blob/master/docs/UsersAPI.md#readusermeapiv1usersmeget
            UsersAPI.readUserMeApiV1UsersMeGet() { (response, error) in
                guard error == nil else {
                    print(error!)
                    return
                }

                if ((response) != nil) {
                    dump(response)
                    
                    //self.email = response!.email!
                    self.user = response!
                }
            }
        }
    }
    
}

struct viewProfile_Previews: PreviewProvider {
    static var previews: some View {
        viewProfile()
    }
}

