//
//  MyScrollView.swift
//  ZoomSubview
//
//  Created by Yongseok Choi on 2023/04/16.
//

import UIKit

class MyScrollView: UIScrollView {
    override func setContentOffset(_ contentOffset: CGPoint, animated: Bool) {
        var contentOffset = contentOffset
        let contentSize = self.contentSize
        let scrollViewSize = self.bounds.size
        
        if contentSize.width < scrollViewSize.width {
            contentOffset.x = -(scrollViewSize.width - contentSize.width) / 2.0
        }

        if contentSize.height < scrollViewSize.height {
            contentOffset.y = -(scrollViewSize.height - contentSize.height) / 2.0
        }
        
        super.setContentOffset(contentOffset, animated: animated)
    }
}
