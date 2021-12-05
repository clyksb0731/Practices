//
//  PeripheralCell.swift
//  BLEPractice
//
//  Created by Yongseok Choi on 2021/11/28.
//

import UIKit

class PeripheralCell: UITableViewCell {
    
    var peripheralNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.isUserInteractionEnabled = true
        self.selectionStyle = .none
        
        // subviews
        self.addSubview(self.peripheralNameLabel)
        self.addSubview(self.bottomLineView)
        
        // layouts
        let safeArea = self.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.peripheralNameLabel.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            self.peripheralNameLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            self.bottomLineView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.bottomLineView.heightAnchor.constraint(equalToConstant: 1),
            self.bottomLineView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.bottomLineView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
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
    
    func setCell(name: String?) {
        self.peripheralNameLabel.text = name
    }
}
