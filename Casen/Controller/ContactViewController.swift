//
//  ContactViewController.swift
//  Casen
//
//  Created by Ebu Bekir Celik on 27.06.19.
//  Copyright © 2019 KeepEasy. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {

    var screenSizes = UIScreen.main.bounds
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ContactKey".localizableString(loc: ViewController.LANGUAGE)
        label.font = UIFont(name: "Avenir-Black", size: 20)
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    let contactProfile: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.clipsToBounds = true
        img.image = UIImage(named: "ebu_userimg")?.withRenderingMode(.alwaysOriginal)
        img.layer.cornerRadius = 75
        img.layer.borderWidth = 1
        img.layer.borderColor = UIColor.lightText.cgColor
        return img
    }()
    
    let textSheet: UITextView = {
        let txt = UITextView()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.text = "Hi, my name is Ebu and I am the developer of VoiceDate.\n\nI want that people meet new people in a new way. Not only text messaging anymore. I hope I can help a lot of people with that kind of idea. If you have any questions do not hesitate to contact me via E-Mail or Instagram.\n\nE-Mail: ebucelik1@hotmail.com\nInstagram: ebu.celik\n\nYour Developer Ebu"
        txt.textAlignment = NSTextAlignment.center
        txt.layer.cornerRadius = 20
        txt.layer.shadowColor = UIColor.gray.cgColor
        txt.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        txt.layer.shadowOpacity = 1.0
        txt.layer.shadowRadius = 5.0
        txt.layer.masksToBounds = false
        txt.backgroundColor = UIColor.white
        txt.isEditable = false
        txt.isSelectable = false
        return txt
    }()
    
    let back: UIButton = {
        let backBtn = UIButton()
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        backBtn.setImage(UIImage(named: "backToView"), for: .normal)
        backBtn.backgroundColor = UIColor.clear
        backBtn.addTarget(self, action: #selector(backToDating), for: .touchUpInside)
        return backBtn
    }()
    
    let detectSizes = IphoneSize()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .left
        
        view.addGestureRecognizer(edgePan)
        
        view.setGradientBackground(sender: view, colorOne: UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1).cgColor, colorTwo: UIColor.white.cgColor)
        
        detectWhichIphone()
        
        implementElements()
    }
    
    func detectWhichIphone(){
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                detectSizes.logoY = 20
                
            case 1334:
                print("iPhone 6/6S/7/8")
                detectSizes.logoY = 35
                
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                detectSizes.logoY = 50
                
            case 2436:
                print("iPhone X, XS")
                detectSizes.logoY = 80
                
            case 2688:
                print("iPhone XS Max")
                detectSizes.logoY = 100
                
            case 1792:
                print("iPhone XR")
                detectSizes.logoY = 100
                
            default:
                print("Unknown")
            }
        }
    }

    func implementElements(){
        view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(detectSizes.logoY!)).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        view.addSubview(contactProfile)
        contactProfile.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50).isActive = true
        contactProfile.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        contactProfile.heightAnchor.constraint(equalToConstant: 150).isActive = true
        contactProfile.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        view.addSubview(textSheet)
        textSheet.topAnchor.constraint(equalTo: contactProfile.bottomAnchor, constant: 30).isActive = true
        textSheet.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textSheet.heightAnchor.constraint(equalToConstant: 190).isActive = true
        textSheet.widthAnchor.constraint(equalToConstant: screenSizes.width-50).isActive = true
        
        view.addSubview(back)
        back.topAnchor.constraint(equalTo: textSheet.bottomAnchor, constant: 40).isActive = true
        back.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        back.heightAnchor.constraint(equalToConstant: 45).isActive = true
        back.widthAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer){
        if recognizer.state == .recognized {
            self.modalTransitionStyle = .flipHorizontal
            self.dismiss(animated: true, completion: nil)
        }
    }
 
    @objc func backToDating(){
        self.modalTransitionStyle = .flipHorizontal
        self.dismiss(animated: true, completion: nil)
    }
    
}
