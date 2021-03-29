//
//  ChatMessageCell.swift
//  Casen
//
//  Created by Ebu Bekir Celik on 16.06.19.
//  Copyright © 2019 KeepEasy. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    
    var playerAudioBtnTapAction : (()->())?
    let screenSize = UIScreen.main.bounds
    
    let playerbtn: UIButton = {
        let cellPlayerBtn = UIButton(type: .custom)
        cellPlayerBtn.translatesAutoresizingMaskIntoConstraints = false
        cellPlayerBtn.clipsToBounds = true
        cellPlayerBtn.layer.cornerRadius = 10
        return cellPlayerBtn
    }()
    
    let sendedTime: UILabel = {
        let timeLabel = UILabel()
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.textAlignment = NSTextAlignment.center
        timeLabel.textColor = UIColor.lightGray
        timeLabel.font = UIFont(name: timeLabel.font.fontName, size: 12)
        return timeLabel
    }()
    
    let userImages: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.clipsToBounds = true
        img.layer.cornerRadius = 16.50
        return img
    }()
    
    let audioSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.clipsToBounds = true
        //slider.thumbTintColor = UIColor.black
        slider.setThumbImage(UIImage(named: "filledcircle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        slider.isUserInteractionEnabled = false
        return slider
    }()
    
    let audioPlayerSliderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    var playerBtnImagePlay: UIImage?
    var userImagesLeftAnchor: NSLayoutConstraint?
    var userImagesRightAnchor: NSLayoutConstraint?
    var audioSliderLeftAnchor: NSLayoutConstraint?
    var audioSliderRightAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(userImages)
        
        userImagesLeftAnchor = userImages.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10)
        userImagesLeftAnchor?.isActive = true
        
        userImages.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12.50).isActive = true
        userImages.heightAnchor.constraint(equalToConstant: 32.5).isActive = true
        userImages.widthAnchor.constraint(equalToConstant: 32.5).isActive = true
        
        userImagesRightAnchor = userImages.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10)
        userImagesRightAnchor?.isActive = true
        
        addSubview(audioPlayerSliderView)
        
        audioSliderLeftAnchor = audioPlayerSliderView.leftAnchor.constraint(equalTo: userImages.rightAnchor, constant: 5)
        audioSliderLeftAnchor?.isActive = true
        
        audioPlayerSliderView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        audioPlayerSliderView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        audioPlayerSliderView.widthAnchor.constraint(equalToConstant: (screenSize.width/2)-10).isActive = true
        
        audioSliderRightAnchor = audioPlayerSliderView.rightAnchor.constraint(equalTo: userImages.leftAnchor, constant: -5)
        audioSliderRightAnchor?.isActive = false
        
        playerbtn.addTarget(self, action: #selector(playAudio), for: .touchUpInside)
        
        audioPlayerSliderView.addSubview(audioSlider)
        
        audioSlider.centerYAnchor.constraint(equalTo: audioPlayerSliderView.centerYAnchor).isActive = true
        audioSlider.leftAnchor.constraint(equalTo: audioPlayerSliderView.leftAnchor, constant: 5).isActive = true
        audioSlider.widthAnchor.constraint(equalTo: audioPlayerSliderView.widthAnchor, constant: -45).isActive = true
        audioSlider.heightAnchor.constraint(equalToConstant: 32.5).isActive = true
        
        audioPlayerSliderView.addSubview(playerbtn)
        
        playerbtn.rightAnchor.constraint(equalTo: audioPlayerSliderView.rightAnchor, constant: -5).isActive = true
        playerbtn.centerYAnchor.constraint(equalTo: audioPlayerSliderView.centerYAnchor).isActive = true
        playerbtn.heightAnchor.constraint(equalToConstant: 32.5).isActive = true
        playerbtn.widthAnchor.constraint(equalToConstant: 32.5).isActive = true
        
        addSubview(sendedTime)
        
        sendedTime.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        sendedTime.heightAnchor.constraint(equalToConstant: 20).isActive = true
        sendedTime.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
    }
    
    @objc func playAudio(){
        playerAudioBtnTapAction?()
    }
    
    func setCellImage(playerBtnImage: UIImage){
        playerbtn.setImage(playerBtnImage.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
