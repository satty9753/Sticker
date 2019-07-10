//
//  Sticker.swift
//  Others
//
//  Created by michelle on 2019/4/2.
//  Copyright © 2019 Stan Liu. All rights reserved.
//

protocol StickerDelegate{
    func getFrame(frame:CGRect)
    func getDeleteButton(point:CGPoint)
}

import Foundation

class StickerImageView:UIImageView, UIGestureRecognizerDelegate{
    private var topBorder: UIView!
    private var bottomBorder: UIView!
    private var leftBorder: UIView!
    private var rightBorder: UIView!
    
    var borders = [UIView]()
    
    var stickerDelegate: StickerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
     
    }
    
    func configure(){
        self.contentMode = .scaleAspectFill
        
        //set UIGeatureRecognizer for scale and rotation
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(zoomIn(sender:)))
        pinch.delegate = self
        self.addGestureRecognizer(pinch)
        
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(rotate(sender:)))
        rotate.delegate = self
        self.addGestureRecognizer(rotate)
        
        addBorders()
        
        startEditing()
    }
    
    private func addBorders(){
        let borderHeight:CGFloat = 2.0
        
        topBorder = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: borderHeight))
        topBorder.backgroundColor = .white
        addSubview(topBorder)
        
        bottomBorder = UIView(frame: CGRect(x: 0, y: self.frame.height - borderHeight, width: self.frame.width, height: borderHeight))
        bottomBorder.backgroundColor = .white
        addSubview(bottomBorder)
        
        leftBorder = UIView(frame: CGRect(x: 0, y: 0, width: borderHeight, height: self.frame.height))
        leftBorder.backgroundColor = .white
        addSubview(leftBorder)
        
        rightBorder = UIView(frame: CGRect(x: self.frame.width - borderHeight, y: 0, width: borderHeight, height: self.frame.height))
        rightBorder.backgroundColor = .white
        addSubview(rightBorder)
        
        borders = [topBorder, bottomBorder, leftBorder, rightBorder]
    }
    
    func setBorderWidth(length:CGFloat){
        topBorder.frame.size = CGSize(width: self.frame.width, height: length)
        bottomBorder.frame.size = CGSize(width: self.frame.width, height: length)
        leftBorder.frame.size  = CGSize(width: length, height: self.frame.height)
        rightBorder.frame.size = CGSize(width: length, height: self.frame.height)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startEditing(){
       self.isUserInteractionEnabled = true
        
       borders.forEach{ $0.isHidden = false }
        
    }
    
    func stopEditing(){
        self.isUserInteractionEnabled = false
        
        borders.forEach{ $0.isHidden = true }
    }
    
    @objc func zoomIn(sender: UIPinchGestureRecognizer) {
        if sender.state == .ended || sender.state == .changed{
            self.transform = self.transform.scaledBy(x: sender.scale, y: sender.scale)
            self.stickerDelegate?.getFrame(frame: self.frame)
            sender.scale = 1
        }
        if sender.state == .ended{
            let point = self.newTopRight
            self.stickerDelegate?.getDeleteButton(point: point)
        }
    }
    
    @objc func rotate(sender: UIRotationGestureRecognizer){
        if sender.state == .began || sender.state == .changed{
            self.transform = self.transform.rotated(by: sender.rotation)
            self.stickerDelegate?.getFrame(frame: self.frame)
            sender.rotation = 0
        }
        if sender.state == .ended{
            let point = self.newTopRight
            self.stickerDelegate?.getDeleteButton(point: point)
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}


