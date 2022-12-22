//
//  viewTaskListenAudio.swift
//  cep
//
//  Created by Maria Novikova on 14.08.2022.
//


import SwiftUI
import AVFoundation

//let periodFrom: Int64 = 18
let periodFrom: Double = 18.0
let periodTo: Double = 248.5 // 248

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
    
    @State private var currentTime: TimeInterval = 0
    @State private var currentDuration: TimeInterval = 0
    @State private var state = PlaybackState.waitingForSelection
    @State private var lastRate: Float = 1.0
    
    @State private var stopAtEnd = true
    
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
                    //.foregroundColor(designColors.TextGray)
                        .multilineTextAlignment(.leading)
                        //.frame(minWidth: 45)
                        
                    Spacer()
                }.frame(width: 50)
                
                Spacer()
                
                HStack{
                    
                    Button {
                        stopAtEnd = true
                        self.player.seek(to: CMTimeMake(value: Int64(periodFrom*100), timescale: 100))
                        self.state = .playing
                        self.player.play()
                    } label: {
                        Image(systemName: "repeat")
                    }
                    
                    Spacer()
                    
                    Button {
                        self.player.seek(to: CMTimeMake(value: Int64((currentTime-15)*100), timescale: 100))
                    } label: {
                        Image(systemName: "gobackward.15")
                    }
                    
                    Spacer()
                    
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
                            .foregroundColor(Color(uiColor: UIColor(named: state == .buffering ? "BaseMagentaDisabled" : "BaseMagenta")!))
                    }
                    
                    Spacer()
                    
                    Button {
                        self.player.seek(to: CMTimeMake(value: Int64((currentTime+15)*100), timescale: 100))
                    } label: {
                        Image(systemName: "goforward.15")
                    }
                    
                    Spacer()
                    
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
                
                Spacer()
                
                HStack(spacing: 0) {
                    Spacer()
                    Text("\(Utility.formatSecondsToHMS(currentDuration))")
                        .font(.system(size: 13))
                        //.foregroundColor(designColors.TextGray)
                }.frame(width: 50)
                
                
            }
            .padding(.top, 5)
            .padding(.bottom, 5)
            .font(.system(size: 22))
            .foregroundColor(Color(uiColor: UIColor(named: "BaseDarkPurple")!))
            
            // MARK: Timeline
            
            ZStack {
                
                Slider(value: $currentTime, in: 0...currentDuration, onEditingChanged: sliderEditingChanged)
                    .accentColor(Color(uiColor: UIColor(named: "BaseDarkPurple")!))
                    .onAppear {
                        let progressCircleConfig = UIImage.SymbolConfiguration(scale: .small)
                        UISlider.appearance()
                            .setThumbImage(UIImage(systemName: "circle.fill",
                                                   withConfiguration: progressCircleConfig), for: .normal)
                        
                    }
                    .disabled(state == .waitingForSelection || state == .buffering)
                    //.blendMode(.multiply)
                
                if currentDuration > 0 {
                    
                    // https://stackoverflow.com/a/62641399
                    let frameWidth: Double = UIScreen.main.bounds.size.width - basePadding*2
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
                            .fill(Color(uiColor: UIColor(named: "BasePurple")!))
                            .padding(.leading, firstLeading)
                            .padding(.trailing, firstTrailing)
                            .frame(width: frameWidth, height: 4)
                            .padding(.top, -0.9)
                            //.blendMode(.multiply)
                    }
                    
                    if pointEnd > pointCenter {
                        Rectangle()
                            .fill(Color(uiColor: UIColor(named: "BaseLightPurple")!))
                            .padding(.leading, secondLeading)
                            .padding(.trailing, secondTrailing)
                            .frame(width: frameWidth, height: 4)
                            .padding(.top, -0.9)
                            //.blendMode(.multiply)
                    }
                }
            }
            
            // MARK: Translations
            
            HStack {
                Text("Читает Игорь Козлов (SYNO)")
                    .foregroundColor(Color(uiColor: UIColor(named: "BaseDarkPurple")!))
                Spacer()
                Text("Версии")
                    .foregroundColor(Color(uiColor: UIColor(named: "TextMagenta")!))
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
        
        // MARK: Observers
        
        // Listen out for the time observer publishing changes to the player's time
        .onReceive(timeObserver.publisher) { time in
            // Update the local var
            //print("time: \(time)")
            self.currentTime = time
            // And flag that we've started playback
            ///if time > 0 {
            ///    self.state = .playing
            ///}
            
            if time > Double(periodTo) && self.stopAtEnd {
                self.state = .pausing
                self.player.pause()
            }
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

struct viewTaskListenAudio: View {
    
    var task: Task
    
    @Environment(\.dismiss) var dismiss
    
    @State var currentTranslationIndex: Int = globalCurrentTranslationIndex
    @State private var currentPosition = 0.0
    
    let player = AVPlayer()
    
    var body: some View {
        
        VStack {
            viewBack() { dismiss() }
            baseCaption(text: "Прослушай аудио")
            baseSubCaption(text: task.dataDescription, coral: false)
            
            AudioPlayerControlsView(player: player,
                                    timeObserver: PlayerTimeObserver(player: player),
                                    durationObserver: PlayerDurationObserver(player: player),
                                    itemObserver: PlayerItemObserver(player: player))
            
            ScrollView() {
                viewExcerpt(task: task, translationIndex: currentTranslationIndex)
            }
            
            Button() {
                dismiss()
            } label: {
                baseButtonLabel(text: "Готово!")
            }
            .padding(.top, 10)
            .padding(.bottom, 5)
        }
        .padding(.horizontal, basePadding)
        .onAppear {
            guard let url = URL(string: "https://4bbl.ru/data/syn-bondarenko/40/13.mp3") else {
                return
            }
            let playerItem = AVPlayerItem(url: url)
            self.player.replaceCurrentItem(with: playerItem)
            
            //self.player.seek(to: CMTimeMake(value: Int64(periodFrom*100), timescale: 100))
        }
    }
}

struct viewTaskListenAudio_Previews: PreviewProvider {
    static var previews: some View {
        viewTaskListenAudio(task: lessons[0].taskGroups[0].tasks[0])
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
            //.previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro Max"))
            //.preferredColorScheme(.dark)
        
    }
}

