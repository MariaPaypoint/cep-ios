//
//  viewProfile.swift
//  cep
//
//  Created by Maria Novikova on 20.12.2022.
//

import SwiftUI

struct viewProfile: View {
    
    @State private var showAuth = false
    
    var body: some View {
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
                            Text("User Longname")
                                .font(.title.weight(.thin))
                                .foregroundColor(Color(.sRGB, red: 14/255, green: 129/255, blue: 165/255))
                            Spacer()
                        }
                        HStack {
                            Text("Something about me")
                                .foregroundColor(.secondary)
                                .font(.body.weight(.thin))
                            Spacer()
                        }
                    }
                    .padding(.leading, 10)
                }
                .padding(.top)
                
                //MARK: 1 строка
                HStack {
                    Image(systemName: "star.fill")
                        .imageScale(.large)
                        .symbolRenderingMode(.multicolor)
                    VStack {
                        HStack {
                            Text("Звезды знаний:")
                                .font(.body.weight(.light))
                                .foregroundColor(.primary)
                            Text("315")
                                .font(.body.weight(.light))
                                .foregroundColor(Color(.sRGB, red: 210/255, green: 28/255, blue: 128/255))
                            Spacer()
                        }
                        HStack {
                            Text("За последнюю неделю:")
                                .foregroundColor(.secondary)
                                .font(.footnote.weight(.light))
                            Text("+22")
                                .font(.footnote)
                                .foregroundColor(Color(.sRGB, red: 0/255, green: 168/255, blue: 204/255))
                            Spacer()
                        }
                    }
                }
                .padding(.top)
                .padding(.leading, 35)
                
                //MARK: 2 строка
                HStack {
                    Image(systemName: "swift")
                        .imageScale(.large)
                        .symbolRenderingMode(.monochrome)
                        .foregroundColor(.red)
                    VStack {
                        HStack {
                            Text("Дней без перерыва:")
                                .font(.body.weight(.light))
                                .foregroundColor(.primary)
                            Text("199")
                                .font(.body.weight(.light))
                                .foregroundColor(Color(.sRGB, red: 210/255, green: 28/255, blue: 128/255))
                            Spacer()
                        }
                        HStack {
                            Text("В среднем по")
                                .foregroundColor(.secondary)
                                .font(.footnote.weight(.light))
                            Text("3")
                                .font(.footnote)
                                .foregroundColor(Color(.sRGB, red: 0/255, green: 168/255, blue: 204/255))
                            Text("звезды в день")
                                .foregroundColor(.secondary)
                                .font(.footnote.weight(.light))
                            Spacer()
                        }
                    }
                }
                .padding(.top)
                .padding(.leading, 35)
                
                //MARK: 3 строка
                HStack {
                    Image(systemName: "medal.fill")
                        .imageScale(.large)
                        .symbolRenderingMode(.monochrome)
                        .foregroundColor(Color(.sRGB, red: 66/255, green: 117/255, blue: 0/255))
                    VStack {
                        HStack {
                            Text("Получено наград:")
                                .font(.body.weight(.light))
                                .foregroundColor(.primary)
                            Text("25")
                                .font(.body.weight(.light))
                                .foregroundColor(Color(.sRGB, red: 210/255, green: 28/255, blue: 128/255))
                            Spacer()
                        }
                        HStack {
                            Text("В т.ч.")
                                .foregroundColor(.secondary)
                                .font(.footnote.weight(.light))
                            Text("4")
                                .font(.footnote)
                                .foregroundColor(Color(.sRGB, red: 0/255, green: 168/255, blue: 204/255))
                            Text("свои достигнутые цели ")
                                .foregroundColor(.secondary)
                                .font(.footnote.weight(.light))
                            Spacer()
                        }
                        
                    }
                    .padding(.top)
                    .padding(.leading, 35)
                }
                // MARK: 2 кнопки
                HStack {
                    Button() {
                        
                    } label: {
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
                    }
                    
                    Spacer()
                    Spacer()
                    
                    Button() {
                        showAuth = true
                    } label: {
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
                    }
                    
                    
                    
                }
                .padding(.top, 20)
                Spacer()
            }
            .padding()
        }
        .fullScreenCover(isPresented: $showAuth) {
            viewAuth()
        }
    }
}

struct viewProfile_Previews: PreviewProvider {
    static var previews: some View {
        viewProfile()
    }
}
