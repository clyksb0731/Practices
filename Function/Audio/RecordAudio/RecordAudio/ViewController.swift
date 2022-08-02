//
//  ViewController.swift
//  RecordAudio
//
//  Created by Yongseok Choi on 2022/07/28.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var audioRecord: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var recordingFileUrl: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recordingSetting: [String:Any] = [
            AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue,
            AVFormatIDKey:Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey:12000,
            AVNumberOfChannelsKey:1
        ]
        
        let audioSession = AVAudioSession.sharedInstance()
        audioSession.requestRecordPermission { granted in
            if granted {
                print("Recording permitted")
                
            } else {
                print("Recording denied")
            }
        }
        
        do {
            //try audioSession.setCategory(.playAndRecord)
            try audioSession.setCategory(.playAndRecord, options: [.defaultToSpeaker])
            try audioSession.setActive(true)
        } catch {
            print("AudioSession Setting Error")
        }
        
//        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//        self.recordingFileUrl = URL(fileURLWithPath: path)
//        if let recordingFileUrl = self.recordingFileUrl?.appendingPathComponent("recording.m4a") {
//            self.audioRecord = try? AVAudioRecorder(url: recordingFileUrl, settings: recordingSetting)
//
//            self.audioRecord?.prepareToRecord()
//        }
        
        self.recordingFileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        self.recordingFileUrl?.appendPathComponent("recording.m4a")

        if let recordingFileUrl = recordingFileUrl {
            self.audioRecord = try? AVAudioRecorder(url: recordingFileUrl, settings: recordingSetting)

            //self.audioRecord?.prepareToRecord()
        }
    }

    @IBAction func recordButton(_ sender: UIButton) {
        self.audioRecord?.record()
        print("recordButton touched")
    }
    
    @IBAction func stopRecordingButton(_ sender: UIButton) {
        if self.audioRecord?.isRecording == true {
            self.audioRecord?.stop()
            
            print("recording stopped by touching stopRecordingButton")
        }
    }
    
    @IBAction func deleteRecordingFileButton(_ sender: UIButton) {
        if let recordingFileUrl = self.recordingFileUrl {
            if FileManager.default.fileExists(atPath: recordingFileUrl.path) {
                print("Recording file exists: \(recordingFileUrl.path)")
                
                if let _ = try? FileManager.default.removeItem(atPath: recordingFileUrl.path) {
                    print("Recording file deleted by touching deleteRecordingFileButton")
                    
                } else {
                    print("File hasn't been deleted")
                }
                
            } else {
                print("Recording file doesn't exist")
            }
        }
    }
    
    
    
    @IBAction func playButton(_ sender: UIButton) {
        if let recordingFileUrl = self.recordingFileUrl {
            if FileManager.default.fileExists(atPath: recordingFileUrl.path) {
                self.audioPlayer = try? AVAudioPlayer(contentsOf: recordingFileUrl)
                self.audioPlayer?.prepareToPlay()
                self.audioPlayer?.delegate = self
                self.audioPlayer?.play()

                print("audioPlayer started by touching playButton")
                
            } else {
                print("No recording file to play")
            }
        }
        
//        if let url = self.audioRecord?.url {
//            self.audioPlayer = try? AVAudioPlayer(contentsOf: url)
//            self.audioPlayer?.delegate = self
//            self.audioPlayer?.play()
//
//            print("audioPlayer started by touching playButton")
//        }
    }
    
    @IBAction func stopPlayingButton(_ sender: UIButton) {
        if self.audioPlayer?.isPlaying == true {
            self.audioPlayer?.stop()
            
            print("audioPlayer stopped by touching stopPlayingButton")
        }
    }
}

extension ViewController: AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("audioPlayerDidFinishPlaying")
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("audioPlayerDecodeErrorDidOccur")
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("audioRecorderDidFinishRecording")
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("audioRecorderEncodeErrorDidOccur")
    }
}

extension ViewController: FileManagerDelegate {
    func fileManager(_ fileManager: FileManager, shouldRemoveItemAt URL: URL) -> Bool {
        print("shouldRemoveItemAt")
        
        return true
    }
    
    func fileManager(_ fileManager: FileManager, shouldRemoveItemAtPath path: String) -> Bool {
        print("shouldRemoveItemAtPath")
        
        return true
    }
}

