//
//  ViewController.swift
//  TTS
//
//  Created by Yongseok Choi on 2022/12/09.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var inputTextBaseView: UIView!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var speedSlider: UISlider!
    @IBOutlet weak var toneSlider: UISlider!
    @IBOutlet weak var valueOfUtteranceLabel: UILabel!
    
    let defaultTestText = """
    안녕하세요? 스피치 테스트 중입니다. 속도 테스트 중입니다. 톤 테스트 중입니다. 만나서 반값습니다. 오늘 날씨 참 좋죠? 추운가요? 아무튼 테스트 중입니다.
    """
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.inputTextBaseView.layer.cornerRadius = 12
        self.inputTextBaseView.layer.borderColor = UIColor.black.cgColor
        self.inputTextBaseView.layer.borderWidth = 2
        self.inputTextView.text = self.defaultTestText
        self.inputTextView.becomeFirstResponder()
        
        self.valueOfUtteranceLabel.text = "속도: \(self.speedSlider.value) | 톤: \(self.toneSlider.value)"
    }
    
    @IBAction func speedSlider(_ sender: UISlider) {
        self.valueOfUtteranceLabel.text = "속도: \(sender.value) | 톤: \(self.toneSlider.value)"
    }
    @IBAction func touchSpeedSlider(_ sender: Any) {
        TTSManager.shared.stopSpeech()
    }
    
    @IBAction func toneSlider(_ sender: UISlider) {
        self.valueOfUtteranceLabel.text = "속도: \(self.speedSlider.value) | 톤: \(sender.value)"
    }
    
    @IBAction func selectToneSlider(_ sender: Any) {
        TTSManager.shared.stopSpeech()
    }
    
    @IBAction func makeSpeedToneDefaultValue(_ sender: Any) {
        TTSManager.shared.stopSpeech()
        
        self.speedSlider.value = 0.5
        self.toneSlider.value = 1.0
        
        self.valueOfUtteranceLabel.text = "속도: \(self.speedSlider.value) | 톤: \(self.toneSlider.value)"
    }
    
    @IBAction func play(_ sender: Any) {
        self.inputTextView.resignFirstResponder()
        
        //TTSManager.shared.play(withText: self.inputTextView.text)
        TTSManager.shared.play(withText: self.inputTextView.text, speed: self.speedSlider.value, tone: self.toneSlider.value)
    }
    
    @IBAction func stop(_ sender: Any) {
        TTSManager.shared.stopSpeech()
    }
}

