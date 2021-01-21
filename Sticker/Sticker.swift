//
//  Sticker.swift
//  Others
//
//  Created by michelle on 2019/3/29.
//  Copyright © 2019 Stan Liu. All rights reserved.
//

import UIKit

public class Sticker: UIView, UIGestureRecognizerDelegate {
    
    private var stickerImageView:StickerImageView!

    fileprivate var deleteButton: UIButton!
    
    fileprivate var deleteButtonRadius: CGFloat = 15.0
    
    fileprivate var span: CGFloat = 18.0
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure(){
        //set stickerImageView
        stickerImageView = StickerImageView(frame: CGRect(x: self.frame.origin.x + span/2, y: self.frame.origin.y + span/2, width: self.frame.width - span, height: self.frame.height - span))
        stickerImageView.stickerDelegate = self
        stickerImageView.center = center
        self.addSubview(stickerImageView)
        
        //set UIGeatureRecognizer for translation
        let pan = UIPanGestureRecognizer(target: self, action: #selector(moveTo(sender:)))
        pan.delegate = self
        self.addGestureRecognizer(pan)
        
        addDeleteButton(point:CGPoint(x: stickerImageView.frame.origin.x + stickerImageView.frame.width-deleteButtonRadius, y: stickerImageView.frame.origin.y-deleteButtonRadius))
        
        self.startEditing()
        
        addToScreen()
    }
    
    
    public func startEditing(){
        self.isUserInteractionEnabled = true
        deleteButton.isHidden = false
        stickerImageView.startEditing()
    }
    
    public func stopEditing(){
        self.isUserInteractionEnabled = false
        deleteButton.isHidden = true
        stickerImageView.stopEditing()
    }
    
    @objc func moveTo(sender:UIPanGestureRecognizer) {
        if sender.state == .began || sender.state == .changed{
            let translation = sender.translation(in: self.superview)
            self.transform = self.transform.translatedBy(x: translation.x, y: translation.y)
            sender.setTranslation(CGPoint(x: 0, y: 0), in: self.superview)
        }
    }
    
    public func setImage(_ image:UIImage?){
        stickerImageView.image = image
    }

    public func setDeleteButtonImage(_ image:UIImage?){
        deleteButton.setImage(image, for: .normal)
    }
    
    public func setBorderWidth(_ length: CGFloat){
        stickerImageView.setBorderWidth(length: length)
    }
    
    
    private func addDeleteButton(point:CGPoint){
        deleteButton = UIButton(frame: CGRect(origin: point, size: CGSize(width: deleteButtonRadius*2, height: deleteButtonRadius*2)))
        deleteButton.backgroundColor = .clear
        let bundle = Bundle(for: self.classForCoder)
        deleteButton.setImage(UIImage(named: "delete_demo", in: bundle, with: nil), for: .normal)
        
        deleteButton.addTarget(self, action: #selector(removeFromSuperview), for: .touchUpInside)
        deleteButton.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
        self.addSubview(self.deleteButton)
    }
    
    //animate to show adding new sticker
    private func addToScreen(){
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: { _ in
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    @objc func deleteFromSuperView() {
        self.removeFromSuperview()
    }

}

//MARK: - StickerDelegate
extension Sticker: StickerDelegate{
    func getDeleteButton(point: CGPoint) {
        if !self.subviews.contains(deleteButton){
            addDeleteButton(point: CGPoint(x: point.x - deleteButtonRadius, y: point.y - deleteButtonRadius))
        }
    }
    
    func getFrame(frame: CGRect) {
        
        if self.subviews.contains(deleteButton){
            deleteButton.removeFromSuperview()
        }
        self.bounds = CGRect(x: frame.origin.x - span/2, y: frame.origin.y - span/2, width: frame.width + span, height: frame.height + span)
    }
    

}

