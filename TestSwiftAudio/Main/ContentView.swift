//
//  ContentView.swift
//  TestSwiftAudio
//
//  Created by Nathan Bashaw on 11/13/19.
//  Copyright © 2019 Operator. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var audioPlayer: AudioPlayerManager
    var body: some View {
        VStack {
            Spacer()
            if audioPlayer.playerState == .none || audioPlayer.playerState == .paused {
                Button(action: {
                    self.audioPlayer.togglePlay()
                }) {
                    Text("Play")
                }
            } else if audioPlayer.playerState == .playing {
                Button(action: {
                    self.audioPlayer.togglePlay()
                }) {
                    Text("Pause")
                }
            }
            RateControls().environmentObject(audioPlayer).padding()
            Spacer()
        }
    }
}

struct RateControls: View {
    @EnvironmentObject var audioPlayer: AudioPlayerManager
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                self.audioPlayer.slowDown()
            }) {
                Image(systemName: "minus.circle.fill").padding()
            }
            Text(self.audioPlayer.playerRateStr).padding()
            Button(action: {
                self.audioPlayer.speedUp()
            }) {
                Image(systemName: "plus.circle.fill").padding()
            }
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
