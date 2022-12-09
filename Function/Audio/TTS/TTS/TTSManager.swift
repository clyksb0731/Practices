//
//  TTSManager.swift
//  TTS
//
//  Created by Yongseok Choi on 2022/12/09.
//

import AVFoundation

class TTSManager {
    static let shared = TTSManager()
    
    private let speechSynthesizer = AVSpeechSynthesizer()
    
    private init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, options: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error as NSError {
            print("setCategory error: \(error.localizedDescription)")
        }
    }
    
    func play(withText text: String,
              speed: Float = 0.5,
              tone: Float = 1.0) {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        speechUtterance.rate = speed
        speechUtterance.pitchMultiplier = tone
        self.speechSynthesizer.stopSpeaking(at: .immediate)
        speechSynthesizer.speak(speechUtterance)
    }
    
    func stopSpeech() {
        self.speechSynthesizer.stopSpeaking(at: .immediate)
    }
}
