//
//  viewTaskComments.swift
//  cep
//
//  Created by Maria Novikova on 19.01.2023.
//

import SwiftUI

struct viewTaskComments: View {
    
    let localAccentColor = "AccentColorCalm"
    
    var task: LessonTask
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack() {
            
            VStack {
                viewBack() { dismiss() }
                baseCaption(text: "Комментарии")
                
                HStack {
                    Text("Читать Матфея 25:1-3")
                    Image("icon_link")
                }
                .foregroundColor(Color(uiColor: UIColor(named: localAccentColor)!))
            }
            
            VStack {
                //Divider()
                HStack {
                    Spacer()
                    Text("Популярные")
                    Image(systemName: "line.3.horizontal.decrease.circle")
                }
            }
            .padding(.top, 5)
            .foregroundColor(Color(uiColor: UIColor(named: "BaseBlue")!))
            
            Divider().padding(.bottom, 5)
            
            VStack {
                HStack(alignment: .top) {
                    Image("temp_user1")
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("Alise N.")
                                .foregroundColor(Color(uiColor: UIColor(named: "AccentColorBright")!))
                            Spacer()
                            Text("вчера, 21:33")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.bottom, 3)
                        Text("Относительно данной притчи мне пришла в голову такая мысль, что мы, люди, на самом деле... ")
                        +
                        Text("ДАЛЕЕ")
                            .foregroundColor(Color(uiColor: UIColor(named: "BaseOrange")!))
                            .font(.caption)
                        
                        
                    }
                    
                }
                .font(.subheadline)
                
                HStack {
                    Spacer()
                    
                    Button {
                        
                    }
                label: {
                    HStack {
                        Image("icon_comment")
                        Text("Ответы (5)")
                    }
                    .padding(7)
                    .font(.subheadline)
                    .foregroundColor(Color(uiColor: UIColor(named: "BaseOrange")!))
                    .background {
                        RoundedRectangle(cornerRadius: 7, style: .continuous)
                            .stroke(Color(uiColor: UIColor(named: "BaseOrange")!), lineWidth: 1)
                    }
                }
                    
                    Button {
                        
                    }
                label: {
                    HStack {
                        Image("icon_like_orange")
                        Text("13")
                    }
                    .padding(7)
                    .font(.subheadline)
                    .foregroundColor(Color(uiColor: UIColor(named: "BaseOrange")!))
                    .background {
                        RoundedRectangle(cornerRadius: 7, style: .continuous)
                            .stroke(Color(uiColor: UIColor(named: "BaseOrange")!), lineWidth: 1)
                    }
                }
                }
                Divider().padding(.vertical, 5)
            }
            
            VStack {
                HStack(alignment: .top) {
                    Image("temp_user2")
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("Вова Корабельников")
                                .foregroundColor(Color(uiColor: UIColor(named: "AccentColorBright")!))
                            Spacer()
                            Text("2 месяца назад")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.bottom, 3)
                        Text("В этой притче заложен относительно простой (на поверхности) смысл, но если задуматься и допустить... ") +
                        Text("ДАЛЕЕ")
                            .foregroundColor(Color(uiColor: UIColor(named: "BaseOrange")!))
                            .font(.caption)
                    }
                }
                .font(.subheadline)
                
                HStack {
                    Spacer()
                    
                    Button {
                        
                    }
                label: {
                    HStack {
                        Image("icon_comment")
                        Text("Ответить")
                    }
                    .padding(7)
                    .font(.subheadline)
                    .foregroundColor(Color(uiColor: UIColor(named: "BaseOrange")!))
                    .background {
                        RoundedRectangle(cornerRadius: 7, style: .continuous)
                            .stroke(Color(uiColor: UIColor(named: "BaseOrange")!), lineWidth: 1)
                    }
                }
                    
                    Button {
                        
                    }
                label: {
                    HStack {
                        Image("icon_like_white")
                        Text("13")
                    }
                    .padding(7)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .background(Color(uiColor: UIColor(named: "BaseOrange")!))
                    .mask { RoundedRectangle(cornerRadius: 7, style: .continuous) }
                }
                }
                Divider().padding(.vertical, 5)
            }
            Spacer()
        }
        .padding()
    }
}

struct viewTaskComments_Previews: PreviewProvider {
    static var previews: some View {
        viewTaskComments(task: lessons[1].taskGroups[2].tasks[1])
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
    }
}
