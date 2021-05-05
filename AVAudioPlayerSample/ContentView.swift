//
//  ContentView.swift
//  AVAudioPlayerSample
//
//  Created by Masaaki Uno on 2021/04/19.
//

import SwiftUI
import AVKit


struct ContentView: View {
    
    var body: some View {
        
        VStack {
            AudioView(content: "https://music.futta.net/cgi-bin/download/download.cgi?name=futta-dream.mp3")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
