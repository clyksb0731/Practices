//
//  ViewController.swift
//  InsertRowsOnTop
//
//  Created by Yongseok Choi on 2023/04/16.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(red: 0, green: 1, blue: 0, alpha: 0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var chatableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.bounces = false
        tableView.separatorStyle = .none
        tableView.register(MessageCell.self, forCellReuseIdentifier: "MessageCell")
        tableView.register(LastMessageCell.self, forCellReuseIdentifier: "LastMessageCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderTopPadding = 0
        tableView.keyboardDismissMode = .interactive
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(red: 0, green: 0, blue: 1, alpha: 0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var bottomSafeAreaView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(red: 0, green: 0, blue: 1, alpha: 0.3)
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    lazy var textViewLineView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 15, weight: .regular)
        textView.textAlignment = .left
        textView.textColor = .black
        textView.bounces = false
        textView.backgroundColor = .clear
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    lazy var sendButtonLineView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.backgroundColor = .cyan
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("보내기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(sendMessage(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.tintColor = .red
        activityIndicator.isHidden = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        return activityIndicator
    }()
    
    var bottomViewBottomAnchor: NSLayoutConstraint!
    
    var messages: [String] = ["$$$$ 테스트", "테스트테스트테스트테스트", "테스트테스트테스트테스트", "테스트테스트테스트테스트", "테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트", "테스트테스트테스트테스트테스트테스트테스트테스트", "테스트", "테스트테스트테스트테스트", "테스트테스트테스트테스트", "테스트테스트테스트테스트", "테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트", "테스트테스트테스트테스트테스트테스트테스트테스트", "테스트", "테스트테스트테스트테스트", "테스트테스트테스트테스트", "테스트테스트테스트테스트", "테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트", "테스트테스트테스트테스트테스트테스트테스트테스트", "테스트", "테스트테스트테스트테스트", "테스트테스트테스트테스트", "테스트테스트테스트테스트", "테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트", "테스트테스트테스트테스트테스트테스트테스트테스트"]
    
    var oldMessages: [String] = ["#### 추가테스트", "추가테스트추가테스트추가테스트", "추가테스트", "추가테스트추가테스트추가테스트추가테스트추가테스트", "추가테스트추가테스트추가테스트추가테스트추가테스트추가테스트추가테스트", "추가테스트추가테스트", "추가테스트", "추가테스트추가테스트추가테스트추가테스트", "추가테스트추가테스트", "추가테스트추가테스트추가테스트추가테스트", "추가테스트추가테스트추가테스트추가테스트추가테스트추가테스트추가테스트", "추가테스트", "추가테스트", "추가테스트추가테스트추가테스트추가테스트", "추가테스트추가테스트", "추가테스트추가테스트추가테스트추가테스트추가테스트추가테스트추가테스트", "추가테스트추가테스트추가테스트추가테스트추가테스트", "추가테스트추가테스트추가테스트", "추가테스트", "추가테스트", "추가테스트추가테스트추가테스트", "추가테스트추가테스트", "추가테스트추가테스트", "추가테스트추가테스트추가테스트추가테스트", "추가테스트추가테스트추가테스트추가테스트추가테스트추가테스트추가테스트추가테스트추가테스트추가테스트추가테스트추가테스트"]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initializeViews()
        self.setTargets()
        self.setGestures()
        self.setNotificationCenters()
        self.setSubviews()
        self.setLayouts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("messageCount: \(self.messages.count)")
        print("oldMessageCount: \(self.oldMessages.count)")
        
        self.setViewFoundation()
        
        let bottomIndexPath = IndexPath(row: self.messages.count - 1, section: 0)
        
        DispatchQueue.main.async {
            self.chatableView.scrollToRow(at: bottomIndexPath, at: .bottom, animated: false)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    deinit {
            print("----------------------------------- ViewController disposed -----------------------------------")
    }
}

// MARK: - Extension for essential methods
extension ViewController {
    // Set view foundation
    func setViewFoundation() {
        self.view.backgroundColor = .white
    }
    
    // Initialize views
    func initializeViews() {
        
    }
    
    // Set targets
    func setTargets() {
        
    }
    
    // Set gestures
    func setGestures() {
        
    }
    
    // Set notificationCenters
    func setNotificationCenters() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    // Set subviews
    func setSubviews() {
        self.view.addSubview(self.topView)
        self.view.addSubview(self.chatableView)
        self.view.addSubview(self.bottomView)
        self.view.addSubview(self.bottomSafeAreaView)
        self.bottomView.addSubview(self.textViewLineView)
        self.textViewLineView.addSubview(self.textView)
        self.textViewLineView.addSubview(self.sendButtonLineView)
        self.sendButtonLineView.addSubview(self.sendButton)
        self.view.addSubview(self.activityIndicator)
    }
    
    // Set layouts
    func setLayouts() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        // topView
        NSLayoutConstraint.activate([
            self.topView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.topView.bottomAnchor.constraint(equalTo: safeArea.topAnchor),
            self.topView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.topView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        // chatableView
        NSLayoutConstraint.activate([
            self.chatableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.chatableView.bottomAnchor.constraint(equalTo: self.bottomView.topAnchor),
            self.chatableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.chatableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        // bottomView
        self.bottomViewBottomAnchor = self.bottomView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        NSLayoutConstraint.activate([
            self.bottomViewBottomAnchor,
            self.bottomView.heightAnchor.constraint(equalToConstant: 40),
            self.bottomView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.bottomView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        // bottomSafeAreaView
        NSLayoutConstraint.activate([
            self.bottomSafeAreaView.topAnchor.constraint(equalTo: self.bottomView.bottomAnchor),
            self.bottomSafeAreaView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.bottomSafeAreaView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.bottomSafeAreaView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        // textViewLineView
        NSLayoutConstraint.activate([
            self.textViewLineView.topAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 5),
            self.textViewLineView.bottomAnchor.constraint(equalTo: self.bottomView.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            self.textViewLineView.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
            self.textViewLineView.leadingAnchor.constraint(equalTo: self.bottomView.leadingAnchor, constant: 16),
            self.textViewLineView.trailingAnchor.constraint(equalTo: self.bottomView.trailingAnchor, constant: -16)
        ])
        
        // textView
        NSLayoutConstraint.activate([
            self.textView.topAnchor.constraint(equalTo: self.textViewLineView.topAnchor, constant: 5),
            self.textView.bottomAnchor.constraint(equalTo: self.textViewLineView.bottomAnchor, constant: -5),
            self.textView.leadingAnchor.constraint(equalTo: self.textViewLineView.leadingAnchor, constant: 8),
            self.textView.trailingAnchor.constraint(equalTo: self.sendButtonLineView.leadingAnchor, constant: -8)
        ])
        
        // sendButtonLineView
        NSLayoutConstraint.activate([
            self.sendButtonLineView.bottomAnchor.constraint(equalTo: self.textViewLineView.bottomAnchor, constant: -5),
            self.sendButtonLineView.heightAnchor.constraint(equalToConstant: 20),
            self.sendButtonLineView.trailingAnchor.constraint(equalTo: self.textViewLineView.trailingAnchor, constant: -8),
            self.sendButtonLineView.widthAnchor.constraint(greaterThanOrEqualToConstant: 10)
        ])
        
        // sendButton
        NSLayoutConstraint.activate([
            self.sendButton.topAnchor.constraint(equalTo: self.sendButtonLineView.topAnchor),
            self.sendButton.bottomAnchor.constraint(equalTo: self.sendButtonLineView.bottomAnchor),
            self.sendButton.trailingAnchor.constraint(equalTo: self.sendButtonLineView.trailingAnchor, constant: -5),
            self.sendButton.leadingAnchor.constraint(equalTo: self.sendButtonLineView.leadingAnchor, constant: 5)
        ])
        
        // activityIndicator
        NSLayoutConstraint.activate([
            self.activityIndicator.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            self.activityIndicator.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
    }
}

// MARK: - Extension for methods added
extension ViewController {
    func loadMoreMessage() {
        self.messages.insert(contentsOf: self.oldMessages, at: 0)
        let initialContentOffSetY = self.chatableView.contentOffset.y
        
        UIView.performWithoutAnimation {
            var indexPaths = [IndexPath]()
            for oldMessageRow in 0..<self.oldMessages.count {
                let indexPath = IndexPath(row: oldMessageRow, section: 0)
                indexPaths.append(indexPath)
            }
            self.chatableView.insertRows(at: indexPaths, with: .none)
            DispatchQueue.main.async {
                self.chatableView.reloadData()
                DispatchQueue.main.async {
                    self.chatableView.scrollToRow(at: IndexPath(row: self.oldMessages.count, section: 0), at: .top, animated: false)
                    self.chatableView.contentOffset.y += initialContentOffSetY
                }
            }
        }
    }
}

// MARK: - Extension for Selector methods
extension ViewController {
    @objc func keyboardWillAppear(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            
            self.bottomViewBottomAnchor.constant = -(keyboardSize.height - ReferenceValues.keyWindow.safeAreaInsets.bottom)
            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
                
            } completion: { finished in
                
            }
            
            DispatchQueue.main.async {
                UIView.performWithoutAnimation {
                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                    
                    self.chatableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
        }
    }
    
    @objc func keyboardWillDisappear(_ notification: Notification) {
        if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            
            self.bottomViewBottomAnchor.constant = 0
            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
                
            } completion: { finished in
                
            }
        }
    }
    
    @objc func keyboardWillChangeFrame(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print("keyboardSize: \(keyboardSize)")
        }
    }
    
    @objc func sendMessage(_ sender: UIButton) {
        self.textView.resignFirstResponder()
    }
}

// MARK: - Extension for UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell!
        
        if indexPath.row == self.messages.count - 1 {
            let lastMessageCell = tableView.dequeueReusableCell(withIdentifier: "LastMessageCell", for: indexPath) as! LastMessageCell
            lastMessageCell.setCell(self.messages[indexPath.row])
            
            cell = lastMessageCell
            
        } else {
            let messageCell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
            messageCell.setCell(self.messages[indexPath.row])
            
            cell = messageCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.activityIndicator.startAnimating()
            self.activityIndicator.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                
                self.loadMoreMessage()
            }
        }
    }
}

// MARK: - Extension for UITextViewDelegate
extension ViewController: UITextViewDelegate {
    
}

