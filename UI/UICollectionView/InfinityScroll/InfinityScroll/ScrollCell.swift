//
//  ScrollCell.swift
//  InfinityScroll
//
//  Created by Yongs Work on 2023/05/01.
//

import UIKit

final class ScrollCell: UICollectionViewCell {
    
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .blue
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setViewFoundation()
        self.initializeObjects()
        self.setSubviews()
        self.setLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extension for essential methods
extension ScrollCell {
    func setViewFoundation() {
        self.backgroundColor = .white
        
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 1
    }
    
    func initializeObjects() {
        
    }
    
    func setSubviews() {
        self.addSubview(self.textLabel)
    }
    
    func setLayouts() {
        let safeArea = self.safeAreaLayoutGuide
        
        // specialImageView
        NSLayoutConstraint.activate([
            self.textLabel.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.textLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.textLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.textLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
}

// MARK: - Extension for methods added
extension ScrollCell {
    func setCell(text: String) {
        self.textLabel.text = text
    }
}
