//
//  FlickrLoader.swift
//  Flickr
//
//  Created by matt_spb on 05.03.2020.
//  Copyright © 2020 matt_spb_dev. All rights reserved.
//

import UIKit

class FlickrLoader: UIView {
    
    let redView = UIView()
    let blueView = UIView()
    
    var hideIfStopAnimate = false //скрывает лоадер при остановке анимации
    var canAnimate = false //перестает анимировать анимировать вьюху если скрываем лоадер
    var isBlueTop = false //флаг для изменения позиции по глубине
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        backgroundColor = UIColor.clear
        redView.frame.origin = CGPoint(x: 0, y: bounds.midY - CGFloat(Layout.viewWidth / 2))
        redView.frame.size = CGSize(width: Layout.viewWidth, height: Layout.viewWidth)
        redView.backgroundColor = Color.red
        redView.layer.cornerRadius = Layout.viewCornerRadius
        addSubview(redView)
        
        blueView.frame.origin = CGPoint(x: bounds.width - Layout.viewWidth / 2, y: bounds.midY - Layout.viewWidth / 2)
        blueView.frame.size = CGSize(width: Layout.viewWidth, height: Layout.viewWidth)
        blueView.backgroundColor = Color.blue
        blueView.layer.cornerRadius = Layout.viewCornerRadius
        addSubview(blueView)
        
    }
}


extension FlickrLoader {
    
    func startAnimation() {
        
        canAnimate = true
        isHidden = false
        animate()
    }
    
    func stopAnimation() {
        if hideIfStopAnimate {
            self.isHidden = true
        }
        canAnimate = false
    }
    
    fileprivate func animate() {
        
        blueView.layer.zPosition = isBlueTop ? 999 : 1000
        redView.layer.zPosition = isBlueTop ? 1000 : 999
        
        isBlueTop.toggle()
        
        UIView.animate(withDuration: 0.8, animations: {
            let redCenter = self.redView.center
            let blueCenter = self.blueView.center
            
            self.blueView.center = redCenter
            self.redView.center = blueCenter
        }) { (finished) in
            if finished && self.canAnimate {
                self.animate()
            }
        }
            
    }
}

extension FlickrLoader {
    enum Layout {
        static let viewWidth: CGFloat = 20
        static var viewCornerRadius: CGFloat {
            CGFloat(viewWidth / 2)
        }
    }
    
    enum Color {
        static let blue = UIColor.blue
        static let red = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
    }
}


//extension TimeInterval {
//    var flickrAnomationDuration = 1.0
//}
