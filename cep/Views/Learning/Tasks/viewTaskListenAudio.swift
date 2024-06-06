//  Created by Maria Novikova on 14.08.2022.

import SwiftUI
import AVFoundation

struct viewTaskListenAudio: View {
    
    let localAccentColor = "AccentColorCalm"
    var task: LessonTask
    @Environment(\.dismiss) var dismiss
    
    let player = AVPlayer()
    @State private var periodFrom: Double = 0
    @State private var periodTo: Double = 0
    @State private var errorDescription: String = ""
    @State private var textVerses: [BibleTextVerseFull] = []
    
    @State private var currentVerseId: Int = 0
    
    /*
    @State private var chapterText: String = "2"
    @State private var verseText: String = "1"
    */
    
    @State private var audioVerses: [BibleAudioVerseFull] = []
    
    var body: some View {
        
        VStack {
            viewBack() { dismiss() }
            baseCaption(text: "Прослушай аудио")
            baseSubCaption(task.dataDescription)
            
            AudioPlayerControlsView(player: player,
                                    timeObserver: PlayerTimeObserver(player: player),
                                    durationObserver: PlayerDurationObserver(player: player),
                                    itemObserver: PlayerItemObserver(player: player),
                                    localAccentColor: localAccentColor,
                                    periodFrom: periodFrom, periodTo: periodTo,
                                    audioVerses: audioVerses, onChangeCurrentVerse: ChangeCurrentVerse)
            
            
            ScrollView() {
                
                // Кнопки для отладки
                /*
                HStack {
                    TextField("chapter", text: $chapterText)
                    TextField("verse", text: $verseText)
                    Button {
                        let voice = globalBibleAudio.getCurrentVoice()
                        
                        let ex = "gen \(chapterText):\(verseText)"
                        textVerses = getExcerptStrings(excerpts: ex)
                        
                        let (from, to, err) = getExcerptPeriod(textVerses: textVerses)
                        
                        self.periodFrom = from
                        self.periodTo = to
                        self.errorDescription = err
                    } label: {
                        Text("Применить")
                    }
                    
                    Button {
                        verseText = String(Int(verseText)! + 1)
                    } label: {
                        Text("Up")
                    }
                }
                */
                
                if globalDebug && errorDescription != "" {
                    Text(errorDescription)
                        .foregroundColor(.red)
                }
                
                // Собственная отрисовка стихов, чтобы следить за аудио
                ForEach(textVerses, id: \.self) { verse in
                    
                    if verse.changedBook || verse.changedChapter || verse.skippedVerses {
                        Divider()
                    }
                    HStack(alignment: .top, spacing: 4) {
                        Text(String(verse.id))
                            .font(.footnote)
                            .foregroundColor(Color(uiColor: UIColor(named: "TextGray")!))
                            .frame(width: 20, alignment: .leading)
                            .padding(.top, 3)
                        Text(verse.text)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color(uiColor: UIColor(named: verse.id == currentVerseId ? "TextBlue" : "TextBase")!))
                    }
                    .padding(.top, 4)
                }
            }
            
            Button() {
                dismiss()
            } label: {
                baseButtonLabel("Готово!", colorName: localAccentColor)
            }
            .padding(.top, 10)
            .padding(.bottom, 5)
        }
        .padding(.horizontal, globalBasePadding)
        
        // MARK: onAppear
        .onAppear {
            
            textVerses = getExcerptTextVerses(excerpts: task.data)
            //let ex = "gen \(chapterText):\(verseText)"
            //textVerses = getExcerptStrings(excerpts: ex)
            
            let (audioVerses, err) = getExcerptAudioVerses(textVerses: textVerses)
            let (from, to) = getExcerptPeriod(audioVerses: audioVerses)
            
            if audioVerses.count > 0 {
                self.currentVerseId = audioVerses[0].id
            }
            
            self.audioVerses = audioVerses
            self.periodFrom = from
            self.periodTo = to
            self.errorDescription = err
            
            // MARK: Audio URL
            let voice = globalBibleAudio.getCurrentVoice()
            let (book, chapter) = getExcerptBookChapterDigitCode(verses: textVerses)
            
            //let address = "https://500:3490205720348012725@assets.christedu.ru/data/translations/ru/\(voice.translation)/audio/\(voice.code)/\(book)/\(chapter).mp3"
        
            let address = "https://4bbl.ru/data/\(voice.translation)-\(voice.code)/\(book)/\(chapter).mp3"
            
            guard let url = URL(string: address) else {
                self.errorDescription = "URL not found: \(address)"
                return
            }
            
            let playerItem = AVPlayerItem(url: url)
            self.player.replaceCurrentItem(with: playerItem)
        }
    }
    
    func ChangeCurrentVerse(_ cur: Int) {
        self.currentVerseId = cur
    }
}


struct AudioPlayerControlsView: View {
    private enum PlaybackState: Int {
        case waitingForSelection
        case waitingForPlay
        case buffering
        case playing
        case pausing
    }
    
    let player: AVPlayer
    let timeObserver: PlayerTimeObserver
    let durationObserver: PlayerDurationObserver
    let itemObserver: PlayerItemObserver
    let localAccentColor: String
    let periodFrom: Double
    let periodTo: Double
    
    @State private var currentTime: TimeInterval = 0
    @State private var currentDuration: TimeInterval = 0
    @State private var state = PlaybackState.waitingForSelection
    @State private var lastRate: Float = 1.0
    
    @State private var stopAtEnd = true
    
    let audioVerses: [BibleAudioVerseFull]
    @State private var currentVerseIndex: Int = 0
    
    var onChangeCurrentVerse: ((Int) -> Void)
    
    var body: some View {
        VStack {
            /*
            if state == .waitingForSelection {
                let _ = print("Select a song below")
            } else if state == .buffering {
                let _ = print("Buffering...")
            } else if state == .waitingForPlay {
                let _ = print("You can play now...")
            } else if state == .pausing {
                let _ = print("OK, we are waiting...")
            } else {
                let _ = print("Great choice!")
            }
            */
            
            // MARK: Player buttons
            
            HStack(spacing: 0) {
                
                HStack(spacing: 0) {
                    Text("\(Utility.formatSecondsToHMS(currentTime))")
                        .font(.system(size: 13))
                        .foregroundColor(Color(uiColor: UIColor(named: "TextGray")!))
                        .multilineTextAlignment(.leading)
                        //.frame(minWidth: 45)
                        
                    Spacer()
                }.frame(width: 50)
                
                Spacer()
                
                HStack{
                    
                    // MARK: повтор
                    Button {
                        stopAtEnd = true
                        //print("first. perdiodFrom=", periodFrom)
                        self.player.seek(to: CMTimeMake(value: Int64(periodFrom*100), timescale: 100))
                        self.state = .playing
                        self.player.play()
                    } label: {
                        Image(systemName: "repeat")
                    }
                    
                    Spacer()
                    
                    // MARK: назад на 15 секунд
                    /*
                    Button {
                        self.player.seek(to: CMTimeMake(value: Int64((currentTime-15)*100), timescale: 100))
                    } label: {
                        Image(systemName: "gobackward.15")
                    }
                    */
                    
                    // MARK: на предыдущих стих
                    Button {
                        if currentVerseIndex > 0 {
                            setCurrentVerseIndex(currentVerseIndex - 1)
                            
                            let begin = audioVerses[currentVerseIndex].begin
                            self.player.seek(to: CMTimeMake(value: Int64(begin*100), timescale: 100))
                            self.currentTime = begin
                        }
                    } label: {
                        Image(systemName: "chevron.backward.circle")
                    }
                    
                    Spacer()
                    
                    // MARK: старт / пауза
                    Button {
                        if state == .playing {
                            state = .pausing
                            player.pause()
                        } else {
                            if self.currentTime >= Double(periodTo) {
                                self.stopAtEnd = false
                            }
                            
                            state = .playing
                            player.play()
                            player.rate = lastRate
                        }
                    } label: {
                        Image(systemName: state != .playing ? "play.circle.fill" : "pause.circle.fill")
                            .font(.system(size: 55))
                            .foregroundColor(Color(uiColor: UIColor(named: state == .buffering ? "PlayerButtonDisabled" : "PlayerButton")!))
                    }
                    
                    Spacer()
                    
                    // MARK: вперед на 15 секунд
                    /*
                    Button {
                        self.player.seek(to: CMTimeMake(value: Int64((currentTime+15)*100), timescale: 100))
                    } label: {
                        Image(systemName: "goforward.15")
                    }
                    */
                    // MARK: на следующий стих
                    Button {
                        if currentVerseIndex+1 < audioVerses.count {
                            setCurrentVerseIndex(currentVerseIndex + 1)
                            let begin = audioVerses[currentVerseIndex].begin
                            self.player.seek(to: CMTimeMake(value: Int64(begin*100), timescale: 100))
                            self.currentTime = begin
                        }
                    } label: {
                        Image(systemName: "chevron.forward.circle")
                    }
                    Spacer()
                    
                    // MARK: скорость воспроизведения
                    Button {
                        if self.state == .playing {
                            if self.player.rate >= 2 || self.player.rate < 0.6 {
                                self.player.rate = 0.6
                            }
                            else {
                                self.player.rate += 0.2
                            }
                            lastRate = self.player.rate
                        }
                    } label: {
                        Text(lastRate == 1 ? "1x" : String(format: "%.1f", lastRate))
                            .font(.system(size: 18))
                        
                    }
                }
                .foregroundColor(Color(uiColor: UIColor(named: "PlayerButton")!))
                
                Spacer()
                
                HStack(spacing: 0) {
                    Spacer()
                    Text("\(Utility.formatSecondsToHMS(currentDuration))")
                        .font(.system(size: 13))
                        .foregroundColor(Color(uiColor: UIColor(named: "TextGray")!))
                }.frame(width: 50)
            }
            .padding(.top, 5)
            .padding(.bottom, 5)
            .font(.system(size: 22))
            
            // MARK: Timeline
            ZStack {
                
                Slider(value: $currentTime, in: 0...currentDuration, onEditingChanged: sliderEditingChanged)
                    .accentColor(Color(uiColor: UIColor(named: "PlayerButton")!))
                    .onAppear {
                        let progressCircleConfig = UIImage.SymbolConfiguration(scale: .small)
                        UISlider.appearance()
                            .setThumbImage(UIImage(systemName: "circle.fill",
                                                   withConfiguration: progressCircleConfig), for: .normal)
                    }
                    .disabled(state == .waitingForSelection || state == .buffering)
                
                if currentDuration > 0 {
                    
                    // https://stackoverflow.com/a/62641399
                    let frameWidth: Double = UIScreen.main.bounds.size.width - globalBasePadding*2
                    let point: Double = frameWidth / currentDuration
                    
                    let pointStart: Double = Double(periodFrom) * point
                    let pointCenter: Double = currentTime * point
                    let pointEnd: Double = Double(periodTo) * point
                    
                    let circleLeftSpace: Double = 13 * currentTime / currentDuration
                    let circleRightSpace: Double = 13 - circleLeftSpace
                    
                    let firstLeading: Double = pointStart
                    let firstTrailing: Double = frameWidth - (pointEnd > pointCenter - circleLeftSpace ? pointCenter - circleLeftSpace : pointEnd)
                    
                    let secondLeading: Double = (pointCenter + circleRightSpace > pointStart ? pointCenter + circleRightSpace : pointStart)
                    let secondTrailing: Double = frameWidth - pointEnd
                    
                    if pointCenter > pointStart {
                        Rectangle()
                            .fill(Color(uiColor: UIColor(named: "PlayerActivePartListened")!))
                            .padding(.leading, firstLeading)
                            .padding(.trailing, firstTrailing)
                            .frame(width: frameWidth, height: 4)
                            .padding(.top, -0.9)
                    }
                    
                    if pointEnd > pointCenter {
                        Rectangle()
                            .fill(Color(uiColor: UIColor(named: "TextGray")!))
                            .padding(.leading, secondLeading)
                            .padding(.trailing, secondTrailing)
                            .frame(width: frameWidth, height: 4)
                            .padding(.top, -0.9)
                    }
                }
            }
            
            // MARK: Translations
            HStack {
                Text("Читает Игорь Козлов (SYNO)")
                    .foregroundColor(Color(uiColor: UIColor(named: "TextGray")!))
                Spacer()
                Text("Версии")
                    .foregroundColor(Color(uiColor: UIColor(named: "PlayerButton")!))
            }
            .font(Font.system(.caption).lowercaseSmallCaps())
            
            .padding(.top, -5)
            .padding(.bottom, 20)
            
            /*
            Slider(value: $currentTime,
                   in: 0...currentDuration,
                   onEditingChanged: sliderEditingChanged,
                   minimumValueLabel: Text("\(Utility.formatSecondsToHMS(currentTime))"),
                   maximumValueLabel: Text("\(Utility.formatSecondsToHMS(currentDuration))")) {
                    // I have no idea in what scenario this View is shown...
                    Text("seek/progress slider")
            }
            .disabled(state != .playing)
            */
        }
        
        .onAppear() {
            try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        }
        
        // MARK: Observers
        
        // Listen out for the time observer publishing changes to the player's time
        .onReceive(timeObserver.publisher) { time in
            // Update the local var
            
            self.currentTime = time
            // And flag that we've started playback
            ///if time > 0 {
            ///    self.state = .playing
            ///}
            
            if time > Double(periodTo) && self.stopAtEnd {
                self.state = .pausing
                self.player.pause()
            }
            
            var cur = currentVerseIndex
            for (index, verse) in audioVerses.enumerated() {
                if time >= verse.begin && time < verse.end {
                    cur = index
                    break
                }
            }
            setCurrentVerseIndex(cur)
            
        }
        // Listen out for the duration observer publishing changes to the player's item duration
        .onReceive(durationObserver.publisher) { duration in
            // Update the local var
            //print("duration: \(duration)")
            self.currentDuration = duration
            if self.state == .buffering {
                self.state = .waitingForPlay
                self.player.seek(to: CMTimeMake(value: Int64(periodFrom*100), timescale: 100))
                //self.currentTime = periodFrom
            }
        }
        // Listen out for the item observer publishing a change to whether the player has an item
        .onReceive(itemObserver.publisher) { hasItem in
            //print("state: \(self.state)")
            self.state = hasItem ? .buffering : .waitingForSelection
            self.currentTime = 0
            self.currentDuration = 0
        }
        // TODO the below could replace the above but causes a crash
//        // Listen out for the player's item changing
//        .onReceive(player.publisher(for: \.currentItem)) { item in
//            self.state = item != nil ? .buffering : .waitingForSelection
//            self.currentTime = 0
//            self.currentDuration = 0
//        }
    }
    
    private func setCurrentVerseIndex(_ cur: Int) {
        if cur != currentVerseIndex {
            currentVerseIndex = cur
            onChangeCurrentVerse(audioVerses[cur].id)
        }
    }
    
    // MARK: Private functions
    private func sliderEditingChanged(editingStarted: Bool) {
        
        if editingStarted {
            // Tell the PlayerTimeObserver to stop publishing updates while the user is interacting
            // with the slider (otherwise it would keep jumping from where they've moved it to, back
            // to where the player is currently at)
            timeObserver.pause(true)
        }
        else {
            // Editing finished, start the seek
            ///state = .buffering
            let targetTime = CMTime(seconds: currentTime, preferredTimescale: 600)
            player.seek(to: targetTime) { _ in
                // Now the (async) seek is completed, resume normal operation
                self.timeObserver.pause(false)
                ///self.state = .playing
            }
            if currentTime >= Double(periodTo) {
                self.stopAtEnd = false
            }
        }
    }
}

// MARK: Main view

struct viewTaskListenAudio_Previews: PreviewProvider {
    static var previews: some View {
        viewTaskListenAudio(task: lessons[0].taskGroups[0].tasks[1])
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
            //.previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro Max"))
            //.preferredColorScheme(.dark)
        
    }
}

