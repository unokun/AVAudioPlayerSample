//
//  ContentViewModel.swift
//  AVAudioPlayerSample
//
//  Created by Masaaki Uno on 2021/05/03.
//

import Foundation
import AVFoundation

class ContentViewModel: NSObject, ObservableObject, AVAudioPlayerDelegate {
    var audioPlayer: AVAudioPlayer?
    
    func playAudio(content: String) {
        guard let url = URL(string: content) else { return }
        print("The url is \(url)")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Did finish Playing")
    }
}
