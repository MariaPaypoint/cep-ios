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
    
    var task: Task
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            viewBack() { dismiss() }
            baseCaption(text: "Просмотр видео")
            baseSubCaption(text: task.dataDescription, coral: false)
        }
        .padding(.horizontal, basePadding)
                    
        YouTubePlayerView(
            "https://youtube.com/watch?v=Ox8iNnGbnhM"
        )
    }
}

struct viewTaskWatchVideo_Previews: PreviewProvider {
    static var previews: some View {
        viewTaskWatchVideo(task: lessons[0].taskGroups[0].tasks[0])
    }
}
