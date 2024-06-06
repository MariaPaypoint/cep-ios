//
//  viewSearchCourses.swift
//  cep
//
//  Created by Maria Novikova on 02.07.2023.
//

import SwiftUI
import OpenAPIClient

struct viewSearchCourses: View {
    
    @State private var toast: FancyToast? = nil
    //@StateObject private var userService = UserService()
    @State private var coursesInfo: [CourseInfo] = []
    @State private var wantCourseIndex = 0
    @State private var isLoading = false

    @State private var showCourseDetails = false
    
    var body: some View {
        ScrollView {
            VStack {
                
                Text("Выберите курс")
                    .font(.largeTitle)
                    .foregroundColor(Color(uiColor: UIColor(named: "TextBlue")!))
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
                    .frame(alignment: .center)
                
                VStack {
                    
                    if isLoading {
                        ProgressView()
                    } else {
                        
                        //ForEach(coursesInfo, id: \.self) { courseInfo in
                        //    CourseItem(courseInfo: courseInfo)
                        //}
                        
                        ForEach(0..<coursesInfo.count, id: \.self) { courseIndex in
                            CourseItem(courseIndex: courseIndex)
                        }
                    }
                }
                .onAppear {
                    isLoading = true
                    
                    OpenAPIClientAPI.basePath = "https://api.christedu.ru"
                    OpenAPIClientAPI.customHeaders = ["Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2ODkwMTMzNjUsInN1YiI6IjEifQ.bIyC8VmUeqkQCJk7Zxf8LuNDtAqGJOZ2lHvXTyWsyVU"]
                    CoursesAPI.searchCoursesApiV1CoursesSearchGet(language: "ru") { (response, error) in
                        //sleep(1)
                        isLoading = false
                        
                        guard error == nil else {
                            let errorText = analyze_error(e: error!)
                            toast = FancyToast(type: .error, title: "Ошибка", message: errorText)
                            return
                        }
                        
                        if ((response) != nil) {
                            dump(response)
                            
                            //response?.first?.name
                            
                            coursesInfo = response!
                        }
                    }
                    
                }
                Spacer()
                
                
            }
            .padding()
        }
        
        //.fullScreenCover(isPresented: $showAuth) {
        .sheet(isPresented: $showCourseDetails, onDismiss: didDismissCourseInfo) {
            viewCourseInfo(courseInfo: coursesInfo[wantCourseIndex])
        }
        .toastView(toast: $toast)
    }
    
    // MARK: После авторизации
    func didDismissCourseInfo() {
        /*
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
         */
    }
    
    // MARK: элемент списка
    @ViewBuilder func CourseItem(courseIndex: Int) -> some View {
        
        let courseInfo = coursesInfo[courseIndex]
        
        let is_completed = Bool.random()
        let is_process = Bool.random()
        let lessons_count = Int.random(in: 1...100)

        Button {
            wantCourseIndex = courseIndex
            showCourseDetails = true
        } label: {
            HStack(alignment: .top) {
                // MARK: image
                AsyncImage(url: URL(string: courseInfo.image!)) { image in
                //AsyncImage(url: URL(string: "https://500:3490205720348012725@assets.christedu.ru/data/images/sheperd.png")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .mask { RoundedRectangle(cornerRadius: 10, style: .continuous) }
                } placeholder: {
                    // Placeholder view
                    Color.teal
                    .mask { RoundedRectangle(cornerRadius: 35, style: .continuous) }
                }
                .frame(width: 70, height: 70)
                .padding(.trailing, 10)
                
                let crl = getProgressColor(is_completed: is_completed, is_process: is_process)
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text(courseInfo.name!)
                            .fontWeight(.regular)
                            .foregroundColor(.primary)
                            .font(.headline)
                            .lineLimit(2)
                        Spacer()
                        
                        Text("уроков: \(lessons_count)")
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .font(.subheadline)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 3)
                            .background {
                                    RoundedRectangle(cornerRadius: 100, style: .continuous)
                                        .fill(crl)
                                }
                    }
                    Text(courseInfo.description!)
                        .fontWeight(.light)
                        .foregroundColor(.secondary)
                        .lineLimit(4)
                        .multilineTextAlignment(.leading)
                        .padding(.top, 4)
                    
                    if is_completed {
                        Text("Курс был завершен 22.12.2023")
                            .foregroundColor(crl)
                            .padding(.top, 4)
                    }
                    else if is_process {
                        Text("В процессе прохождения")
                            .foregroundColor(crl)
                            .padding(.top, 4)
                    }
                    
                }
                .padding(.top, 5)
                
                //Image(Bool.random() ? "star_enabled" : "star_disabled")
                //    .foregroundColor(.yellow)
                //.padding(.top, 15)
            }
            .padding(.top, 15)
            //Spacer()
        }
    }
}

struct viewSearchCourses_Previews: PreviewProvider {
    static var previews: some View {
        viewSearchCourses()
    }
}
