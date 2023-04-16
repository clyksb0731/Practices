//
//  LastMessageCell.swift
//  InsertRowsOnTop
//
//  Created by Yongseok Choi on 2023/04/16.
//

import UIKit

class LastMessageCell: UITableViewCell {
    
    lazy var messageFrameView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setCellFoundation()
        self.initializeViews()
        self.setGestures()
        self.setNotificationCenters()
        self.setSubviews()
        self.setLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

// MARK: Extension for essential methods
extension LastMessageCell {
    // Set view foundation
    func setCellFoundation() {
        self.selectionStyle = .none
        self.contentView.isUserInteractionEnabled = true
    }
    
    // Initialize views
    func initializeViews() {
        
    }
    
    // Set gestures
    func setGestures() {
        
    }
    
    // Set notificationCenters
    func setNotificationCenters() {
        
    }
    
    // Set subviews
    func setSubviews() {
        self.addSubview(self.messageFrameView)
        self.messageFrameView.addSubview(self.messageLabel)
    }
    
    // Set layouts
    func setLayouts() {
        let safeArea = self.safeAreaLayoutGuide
        
        // messageFrameView
        NSLayoutConstraint.activate([
            self.messageFrameView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.messageFrameView.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
            self.messageFrameView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.messageFrameView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 100),
            self.messageFrameView.widthAnchor.constraint(greaterThanOrEqualToConstant: 10),
            self.messageFrameView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20)
        ])
        
        // messageLabel
        NSLayoutConstraint.activate([
            self.messageLabel.topAnchor.constraint(equalTo: self.messageFrameView.topAnchor, constant: 5),
            self.messageLabel.bottomAnchor.constraint(equalTo: self.messageFrameView.bottomAnchor, constant: -5),
            self.messageLabel.leadingAnchor.constraint(equalTo: self.messageFrameView.leadingAnchor, constant: 8),
            self.messageLabel.trailingAnchor.constraint(equalTo: self.messageFrameView.trailingAnchor, constant: -8)
        ])
    }
}

// MARK: - Methods added
extension LastMessageCell {
    func setCell(_ message: String) {
        self.messageLabel.text = message
    }
}
