//
//  AudioView.swift
//  ios - Updating slider value in real time AVAudioPlayer SwiftUI - Stack Overflow
//  https://stackoverflow.com/questions/63324235/updating-slider-value-in-real-time-avaudioplayer-swiftui
//
//  Created by Masaaki Uno on 2021/05/04.
//

import SwiftUI
import AVKit

class AudioPlayerWrapper: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    enum Status {
        case Playing
        case Pause
        case Stop
    }
    
    var audioPlayer: AVAudioPlayer?
    @Published var status: Status = .Stop
    @Published var playValue: TimeInterval = 0.0
    var playerDuration: TimeInterval = 0
    var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    func playSound(content: String) {
        if status == .Playing { return }
        do {
            if (audioPlayer == nil) {
                let url = URL(string: content)
                let data = NSData(contentsOf: url!)
                audioPlayer = try AVAudioPlayer(data: data! as Data)
                audioPlayer?.delegate = self
            }
            
            audioPlayer?.prepareToPlay()
            if let duration = audioPlayer?.duration {
                playerDuration = duration
            }
            audioPlayer?.play()
            status = .Playing
            playValue = 0.0
            
        } catch {
            print("Could not find and play the sound file.")
        }
    }
    
    func stopSound() {
        if status == .Stop { return }
        audioPlayer?.stop()
        status = .Stop
        playValue = 0.0
    }
    
    func pauseSound() {
        if status == .Pause { return }
        audioPlayer?.pause()
        status = .Pause
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        status = .Stop
    }
}

struct AudioView: View {
    var content: String
    @ObservedObject var wrapper = AudioPlayerWrapper()
    @State var passed: Double = 0.0
    let TIMER_INTERVAL = 0.1

    var body: some View {
        HStack {
            switch wrapper.status {
            case .Playing:
                Button(action: {
                    self.wrapper.stopSound()
                    self.wrapper.playValue = 0.0
                    
                }) {
                    Image(systemName: "stop.circle.fill").resizable()
                        .frame(width: 50, height: 50)
                        .aspectRatio(contentMode: .fit)
                }
                
            case .Pause, .Stop:
                Button(action: {
                    self.wrapper.playSound(content: content)
                    self.wrapper.timer = Timer.publish(every: TIMER_INTERVAL, on: .main, in: .common).autoconnect()
                    
                }) {
                    Image(systemName: "play.circle.fill").resizable()
                        .frame(width: 50, height: 50)
                        .aspectRatio(contentMode: .fit)
                }

            }
            Text("\(String(format: "%.2f", passed))/\(String(format: "%.2f", wrapper.playerDuration))")
            Spacer()
            Slider(value: $wrapper.playValue, in: TimeInterval(0.0)...wrapper.playerDuration)
            .onReceive(wrapper.timer) { _ in
                switch wrapper.status {
                case .Playing:
                    passed += TIMER_INTERVAL
                    if let currentTime = self.wrapper.audioPlayer?.currentTime {
                        self.wrapper.playValue = currentTime
                    }
                case .Pause:
                    self.wrapper.timer.upstream.connect().cancel()
                case .Stop:
                    passed = 0.0
                    self.wrapper.playValue = 0.0
                    self.wrapper.timer.upstream.connect().cancel()
                }
            }
        }
        .padding()
    }
}

struct AudioView_Previews: PreviewProvider {
    static var previews: some View {
        AudioView(content: "https://music.futta.net/cgi-bin/download/download.cgi?name=futta-dream.mp3")
    }
}
