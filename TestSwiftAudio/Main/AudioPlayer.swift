//
//  AudioPlayer.swift
//  TestSwiftAudio
//
//  Created by Nathan Bashaw on 11/13/19.
//  Copyright © 2019 Operator. All rights reserved.
//

import Foundation
import AVFoundation
import SwiftAudio
import MediaPlayer

enum PlayerState {
    case playing, paused, none
}

class AudioPlayerManager: ObservableObject {
    @Published var playerState: PlayerState = .none
    @Published var playerRateStr: String = "1x"
    
    var playerRate: Float = 1.0 {
        didSet {
            playerRateStr = String(format: "%gx", playerRate)
        }
    }
    
    let player = AudioPlayer()
    let audioItem = DefaultAudioItem(audioUrl: "https://cdn.substack.com/public/audio/1bb160ef-9ddf-44f2-8ff4-02f77cd1efd0.mpga?post_id=45136", sourceType: .stream)
    
    
    init() {
        try? AudioSessionController.shared.set(category: .playback)
        player.event.stateChange.addListener(self, handleAudioPlayerStateChange)
        player.audioTimePitchAlgorithm = .varispeed
        setupPlayerRemoteCommands()
    }
    
    func togglePlay() {
        if playerState == .none {
            playStart()
        } else if playerState == .playing {
            pause()
        } else if playerState == .paused {
            play()
        }
        
    }
    
    func playStart() {
        do {
            if !AudioSessionController.shared.audioSessionIsActive {
                try AudioSessionController.shared.activateSession()
            }
            try player.load(item: audioItem, playWhenReady: true)
            playerState = .playing
        } catch {
            print("wrong")
        }
    }
    
    func pause() {
        print("custom pause")
        player.pause()
        playerState = .paused
    }
    
    func play() {
        print("custom play")
        player.play()
        player.rate = playerRate
        playerState = .playing
    }
    
    func speedUp() {
        let newRate = playerRate + 0.1
        playerRate = newRate
        player.rate = newRate
    }
    
    func slowDown() {
        let newRate = playerRate - 0.1
        playerRate = newRate
        player.rate = newRate
    }
    
    func skipForward() {
        print("custom skip foward")
        player.seek(to: Double(player.currentTime + 30.0))
    }
    
    func skipBackward() {
        print("custom skip back")
        player.seek(to: Double(player.currentTime - 15.0))
    }
    
    func setupRemoteCommands() {
        print("setting up remote commands")
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.addTarget { [unowned self] event in
            self.play()
            return .success
        }
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            self.pause()
            return .success
        }
        commandCenter.skipForwardCommand.addTarget { [unowned self] event in
            self.skipForward()
            return .success
        }
        commandCenter.skipBackwardCommand.addTarget { [unowned self] event in
            self.skipBackward()
            return .success
        }
        commandCenter.skipForwardCommand.preferredIntervals = [30]
        commandCenter.skipBackwardCommand.preferredIntervals = [15]
    }
    
    func setupPlayerRemoteCommands() {
        player.remoteCommands = [
          .play,
          .pause,
          .skipForward(preferredIntervals: [30]),
          .skipBackward(preferredIntervals: [15]),
        ]
        player.remoteCommandController.handlePlayCommand = { (event) in
            self.play()
            return .success
        }
        player.remoteCommandController.handlePauseCommand = { (event) in
            self.pause()
            return .success
        }
        player.remoteCommandController.handleSkipForwardCommand = { (event) in
            self.skipForward()
            return .success
        }
        player.remoteCommandController.handleSkipBackwardCommand = { (event) in
            self.skipBackward()
            return .success
        }
    }
    
    func handleAudioPlayerStateChange(state: AudioPlayerState) {
//        print(state)
    }
    
}
