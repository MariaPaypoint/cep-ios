//
//  viewTaskWatchVideo.swift
//  cep
//
//  Created by Maria Novikova on 30.08.2022.
//

import SwiftUI

// File -> Add packages -> Search on top https://github.com/SvenTiigi/YouTubePlayerKit
import YouTubePlayerKit

struct viewTaskWatchVideo: View {
    
    //let localAccentColor = "AccentColorBright"
    let localAccentColor = "AccentColorCalm"
    //let localAccentColor = "BaseOrange"

    var task: LessonTask
    @Environment(\.dismiss) var dismiss
    
    let youTubePlayer: YouTubePlayer = "https://youtube.com/watch?v=Ox8iNnGbnhM"
    
    var body: some View {
        VStack(spacing: 0) {
            viewBack() { dismiss() }
            baseCaption(text: "Просмотр видео")
            baseSubCaption(task.dataDescription)
                .padding(.bottom, 15)
            
            
            YouTubePlayerView(
                "https://youtube.com/watch?v=Ox8iNnGbnhM"
            )
            .frame(height: 220)
            
            Spacer()
            
            Button() {
                dismiss()
            } label: {
                baseButtonLabel("Готово!", colorName: localAccentColor)
            }
        }
        .padding()
             
    }
}

struct viewTaskWatchVideo_Previews: PreviewProvider {
    static var previews: some View {
        viewTaskWatchVideo(task: lessons[0].taskGroups[0].tasks[0])
    }
}
