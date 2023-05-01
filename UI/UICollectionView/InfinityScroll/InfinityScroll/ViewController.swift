//
//  ViewController.swift
//  InfinityScroll
//
//  Created by Yongs Work on 2023/05/01.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var scrollCollectionView: UICollectionView = {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(_:)))
        longPressGesture.minimumPressDuration = 0
        longPressGesture.delegate = self
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: ReferenceValues.Size.Device.width - 32, height: 100)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.headerReferenceSize = .zero
        flowLayout.footerReferenceSize = .zero
        flowLayout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.bounces = false
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ScrollCell.self, forCellWithReuseIdentifier: "ScrollCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.addGestureRecognizer(longPressGesture)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .useRGB(red: 189, green: 189, blue: 189)
        pageControl.pageIndicatorTintColor = .useRGB(red: 224, green: 224, blue: 224)
        pageControl.hidesForSinglePage = true
        pageControl.numberOfPages = self.baseNumber
        pageControl.isUserInteractionEnabled = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        return pageControl
    }()
    
    var baseNumber: Int = 5
    lazy var totoalCount = self.baseNumber * 3
    
    var timer: Timer?
    lazy var realIndex: Int = self.baseNumber
    
    let texts: [String] = [
        "첫 번째",
        "두 번째",
        "세 번째",
        "네 번째",
        "다섯 번째",
    ].shuffled()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("shuffled texts: \(self.texts)")
        
        self.view.addSubview(self.scrollCollectionView)
        self.view.addSubview(self.pageControl)
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        // bannerCollectionView
        NSLayoutConstraint.activate([
            self.scrollCollectionView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 40),
            self.scrollCollectionView.heightAnchor.constraint(equalToConstant: 100),
            self.scrollCollectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            self.scrollCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16)
        ])
        
        // bannerPageControl
        NSLayoutConstraint.activate([
            self.pageControl.topAnchor.constraint(equalTo: self.scrollCollectionView.bottomAnchor, constant: 8),
            self.pageControl.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            self.scrollCollectionView.scrollToItem(at: IndexPath(row: self.baseNumber, section: 0), at: .centeredHorizontally, animated: false)
        }
        
        self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(timer(_:)), userInfo: nil, repeats: true)
    }
}

// MARK: - Extension for UICollectionViewDelegate, UICollectionViewDataSource
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.totoalCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScrollCell", for: indexPath) as! ScrollCell
        cell.setCell(text: self.texts[indexPath.item % self.baseNumber])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            //self.scrollCollectionView.isScrollEnabled = false
            let initialContentOffSetX = collectionView.contentOffset.x
            //self.scrollCollectionView.setContentOffset(CGPointMake(initialContentOffSetX, 0), animated: false)
            
            self.totoalCount += self.baseNumber
            
            var indexPaths = [IndexPath]()
            for leadingRow in 0..<self.baseNumber {
                let indexPath = IndexPath(row: leadingRow, section: 0)
                indexPaths.append(indexPath)
            }
            
            DispatchQueue.main.async {
                UIView.performWithoutAnimation {
                    self.scrollCollectionView.insertItems(at: indexPaths)
                    self.scrollCollectionView.scrollToItem(at: IndexPath(item: self.baseNumber, section: 0), at: .centeredHorizontally, animated: false)
                    self.scrollCollectionView.contentOffset.x += initialContentOffSetX
                    
                    //self.scrollCollectionView.isScrollEnabled = true
                }
            }
        }
        
        if indexPath.item == self.totoalCount - 1 {
            self.totoalCount += self.baseNumber
            
            var indexPaths = [IndexPath]()
            for leadingRow in (self.totoalCount-self.baseNumber)..<self.totoalCount {
                let indexPath = IndexPath(row: leadingRow, section: 0)
                indexPaths.append(indexPath)
            }
            
            DispatchQueue.main.async {
                UIView.performWithoutAnimation {
                    self.scrollCollectionView.insertItems(at: indexPaths)
                }
            }
        }
    }
    
    @objc func timer(_ timer: Timer) {
        self.realIndex += 1
        self.scrollCollectionView.scrollToItem(at: IndexPath(item: self.realIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    @objc func longPressGesture(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            print("began")
            self.timer?.invalidate()
        }
        
        if gesture.state == .ended {
            print("ended")
            self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(timer(_:)), userInfo: nil, repeats: true)
        }
    }
}

// MARK: - Extension for UIGestureRecognizerDelegate
extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - Extension for UIScrollViewDelegate
extension ViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let centerXPoint: CGFloat = scrollView.frame.width / 2
        let realIndex = Int(scrollView.contentOffset.x / (ReferenceValues.Size.Device.width - 32))
        let index = realIndex % self.baseNumber
        let currentFrameContentOffsetX = CGFloat(realIndex) * scrollView.frame.width
        print("index: \(index)")
        
        if scrollView.contentOffset.x >= currentFrameContentOffsetX + centerXPoint {
            //self.pageControl.currentPage = currentCount + 1
            self.pageControl.currentPage = index + 1
            
        } else {
            //self.pageControl.currentPage = currentCount
            self.pageControl.currentPage = index
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.realIndex = Int(scrollView.contentOffset.x / (ReferenceValues.Size.Device.width - 32))
        print("realIndex: \(self.realIndex)")
    }
}


