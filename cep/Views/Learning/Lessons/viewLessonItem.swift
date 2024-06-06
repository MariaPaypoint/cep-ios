//
//  viewLessonItem.swift
//  23234234
//
//  Created by Maria Novikova on 05.06.2022.
//

import SwiftUI

struct viewLessonItem: View {
    var lesson: Lesson
    
    var body: some View {
        doItem()
    }
    
    func doItem() -> some View {
        
        let colorBorder: Color
        let colorAccent: Color
        let colorBack: Color
        
        // MARK: определяем цвет в зависимости от статуса
        if lesson.starsDone == 0 {
            colorBorder = designColors.lessonNewBorder
            //colorBorder = Color(.quaternaryLabel)
            colorAccent = designColors.lessonNewAccent
            colorBack = designColors.lessonNewBack
        }
        else if lesson.starsDone == lesson.starsAll {
            colorBorder = designColors.lessonDoneBorder
            colorAccent = designColors.lessonDoneAccent
            colorBack = designColors.lessonDoneBack
        }
        else {
            colorBorder = designColors.lessonProcessBorder
            colorAccent = designColors.lessonProcessAccent
            colorBack = designColors.lessonProcessBack
            
        }
        
        //guard colorBorder as? Color else {return}
        
        return VStack {
            ZStack {
                Circle()
                    .fill(colorBack)
                    .frame(width: 80, height: 80)
                Circle()
                    .fill(colorAccent)
                    .frame(width: 45, height: 45)
                lesson.image
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 69, height: 69)
                    .clipped()
                
                Circle()
                    .stroke(colorBorder, lineWidth: 7)
                    .frame(width: 100, height: 100)
                
                if lesson.starsDone == 0 {
                    // ?
                }
                else if lesson.starsDone == lesson.starsAll {
                    ZStack {
                        Image("star_bordered")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 33, height: 33, alignment: .center)
                        Text("\(lesson.starsAll)")
                            .font(.system(size: 10))
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.center)
                            .padding(.top, 2)
                            .padding(.leading, -1)
                            .frame(width: 20)
                            //.border(.black, width: 1)
                        
                    }
                    .padding(.leading, 70)
                    .padding(.top, 66)
                }
                else {
                        ZStack {
                            Image("book_bordered")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 33, height: 33, alignment: .center)
                            //HStack {
                                Text("\(lesson.starsDone)")
                                    .font(.system(size: 10))
                                    .foregroundColor(Color.white)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 20)
                                    //.border(.red, width: 1)
                                    .padding(.leading, -14)
                                Text("\(lesson.starsAll)")
                                    .font(.system(size: 10))
                                    .foregroundColor(designColors.lessonProcessBorder)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 20)
                                    //.border(.black, width: 1)
                                    .padding(.leading, 13)
                            //}.frame(width: 40)
                            
                        }
                        .padding(.leading, 70)
                        .padding(.top, 66)
                }
                    
            }
            Text(lesson.name)
                .fontWeight(.thin)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(width: 113.0, height: 34)
                .font(.system(size: 14))
                .foregroundColor(Color(uiColor: UIColor(named: "TextBase")!))
                //.background(.red)
        }
    }
}

struct viewLessonItem_Previews: PreviewProvider {
    static var previews: some View {
        //viewLessonItem(course: courses[2])
        Group {
            viewLessonItem(lesson: lessons[7])
            viewLessonItem(lesson: lessons[2])
            viewLessonItem(lesson: lessons[0])
                
        }
        .previewLayout(.fixed(width: 120, height: 160))
    }
}
