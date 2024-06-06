//  Created by Maria Novikova on 05.06.2022.

/// АВТОРИЗАЦИЯ:
/// Дисаблить кнопку в момент запроса по API
/// Профиль до авторизации
/// Научиться отображать ошибки
///
/// SOMEDAY:
/// Расставь по порядку:
///  - скрывать подзаголовок для слишком длинных цитат (ради экономии места)
///  - при перетаскивании нельзя повторять
///  - может стоит делать сначала полную расстановку, а потом проверку? но это хуже с точки зрения запоминания (можно запомнить неверный вариант?)
///  - можно сделать сердечки с жизнями, типа не более трех ошибок, потом сначала начинать
///
/// ПРОВЕРИТЬ
///  - несуществующие отрывки - возможно приложение будет вылетать
///  - аудио 12 книга зафейлилась
///  - аудио - сменился формат текста
///
///  - настройка избранных переводов и озвучек
///  - для ускорения загрузки и уменьшения потребления озу можно сделать подгрузку не всего перевода, а только нужных глав из отдельных файликов (когда буду переделывать на загрузку перевода по сети и хранения на жестком диске )

import SwiftUI

//@available(iOS 16.0, *)
@main
struct _3234234App: App {
    
    init() {
        //let tabBarAppearance = UITabBarAppearance()
        
        // если надоест эта шняга, можно переделать на https://blckbirds.com/post/custom-tab-bar-in-swiftui/
        UITabBar.appearance().barTintColor = UIColor(named: "TabGrayDark")
        UITabBar.appearance().unselectedItemTintColor = .white
        UITabBar.appearance().backgroundColor = UIColor(named: "TabGray")
        
        /*
         tabBarAppearance.configureWithTransparentBackground()
         tabBarAppearance.backgroundColor = UIColor(named: "TabGray")
         tabBarAppearance.selectionIndicatorTintColor = UIColor(named: "AccentColor")
         tabBarAppearance.selectionIndicatorTintColor = .systemRed
         
         UITabBar.appearance().standardAppearance = tabBarAppearance
         UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
         */
        
        //UITabBar.appearance().barTintColor = UIColor(named: "TabGrayDark")
        //UITabBar.appearance().unselectedItemTintColor = .white
        //UITabBar.appearance().backgroundColor = UIColor(named: "TabGray")
        
        //UITabBar.appearance().tintColor = UIColor(named: "AccentColor")
        
        //UITabBar.appearance().isTranslucent = false
        //UITabBar.appearance().tintColor = UIColor(designColors.TabBlue)
        //UITabBar.appearance().color
        //UITabBar.appearance().isOpaque = true
    }
    
    @State private var isPres = true
    @State private var selection = 1
    ///@StateObject var appGlobalMessages = TopMessages()
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selection) {
                
                viewMyCourses()
                    .tabItem {
                        Image("tab_learning").renderingMode(.template)
                        Text("Обучение")
                    }.tag(1)
                    .accentColor(Color(uiColor: UIColor(named: "TextBlue")!))
                    
                
                Text("Church").tabItem {
                    Image("tab_church").renderingMode(.template)
                    Text("Церковь")
                }.tag(2)
                
                Text("Tab Content Targets").badge(0).tabItem {
                    Image("tab_target").renderingMode(.template)
                    Text("Достижения")
                }.tag(3)
                
                ZStack {
                    viewProfile()
                    
                    ///buildMessageView(success: appGlobalMessages.Success, showVariable: appGlobalMessages.Presented, messageVariable: appGlobalMessages.Message)
                }
                .tabItem {
                    Image("tab_profile").renderingMode(.template)
                    Text("Профиль")
                }
                ///.environmentObject(appGlobalMessages)
                .tag(4)
                
            }
            .accentColor(Color(uiColor: UIColor(named: "AccentColor")!))
        }
    }
}

/*
// MARK: Global object for messages
// https://stackoverflow.com/a/68876354/13514087
// вроде работало даже, но переделала на FancyToast
@MainActor class TopMessages: ObservableObject {
    
    @Published var Presented = false
    @Published var Success = false
    @Published var Message = "Something."
    
    var old = false
    
    func ShowMessage(success: Bool, message: String) {
        self.Success = success
        self.Message = message
        
        // наслоение, когда уже показано - включаем устаревание, тогда следующее скрытие не сработает (а сработает через одно)
        self.old = self.Presented ? true : false
        
        self.Presented = true
        
        Task {
            try await Task.sleep(nanoseconds: 3_500_000_000)
            if self.old {
                // сначала отключаем устаревание
                self.old = false
            }
            else {
                // только потом отключаем окно
                self.Presented = false
            }
        }
    }
}
*/
