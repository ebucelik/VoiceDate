//
//  PopupViewController.swift
//  Casen
//
//  Created by Ebu Bekir Celik on 31.05.19.
//  Copyright © 2019 KeepEasy. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {

    let popupview = UIView()
    let navtitle = UILabel()
    let dismissBtn = UIButton()
    let usertxt = UILabel()
    let titleRect = UILabel()
    let liker = UserDefaults.standard.value(forKey: "likedUsername")
    var match = String()
    var imgUrl = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.setGradientBackground(sender: view, colorOne: UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1).cgColor, colorTwo: UIColor.white.cgColor)
        
        createPopupView()
    }
    
    func getMatchedUsername(matchedUname: String){
        if(liker != nil){
            match = (liker as! String) + " & " + matchedUname
        }else{
            match = matchedUname
        }
    }
    
    func getImageUrl(url: String){
        self.imgUrl = url
    }
    
    let userImage: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.clipsToBounds = true
        img.layer.cornerRadius = 100
        img.layer.borderColor = UIColor.lightText.cgColor
        img.layer.borderWidth = CGFloat(2)
        img.layer.masksToBounds = true
        return img
    }()
    
    func createPopupView(){
        popupview.backgroundColor = UIColor.white
        popupview.translatesAutoresizingMaskIntoConstraints = false
        popupview.layer.cornerRadius = CGFloat(10)
        view.addSubview(popupview)
        popupview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popupview.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        popupview.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/2).isActive = true
        popupview.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        
        titleRect.translatesAutoresizingMaskIntoConstraints = false
        titleRect.backgroundColor = UIColor.red.withAlphaComponent(0.7)
        titleRect.layer.cornerRadius = CGFloat(10)
        titleRect.clipsToBounds = true
        popupview.addSubview(titleRect)
        titleRect.topAnchor.constraint(equalTo: popupview.topAnchor).isActive = true
        titleRect.centerXAnchor.constraint(equalTo: popupview.centerXAnchor).isActive = true
        titleRect.widthAnchor.constraint(equalTo: popupview.widthAnchor).isActive = true
        titleRect.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        navtitle.translatesAutoresizingMaskIntoConstraints = false
        navtitle.text = "It's a match!"
        navtitle.textColor = UIColor.white
        navtitle.font = UIFont(name: "Avenir-Black", size: 18)
        popupview.addSubview(navtitle)
        navtitle.topAnchor.constraint(equalTo: popupview.topAnchor, constant: 5).isActive = true
        navtitle.centerXAnchor.constraint(equalTo: popupview.centerXAnchor).isActive = true
        
        userImage.loadImageUsingCacheWithURLString(urlImg: self.imgUrl)
        popupview.addSubview(userImage)
        userImage.centerYAnchor.constraint(equalTo: popupview.centerYAnchor, constant: -20).isActive = true
        userImage.centerXAnchor.constraint(equalTo: popupview.centerXAnchor).isActive = true
        userImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        userImage.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        usertxt.translatesAutoresizingMaskIntoConstraints = false
        usertxt.text = match
        usertxt.font = UIFont(name: "Avenir-Black", size: 24)
        usertxt.textColor = UIColor.black
        popupview.addSubview(usertxt)
        usertxt.centerXAnchor.constraint(equalTo: popupview.centerXAnchor).isActive = true
        usertxt.centerYAnchor.constraint(equalTo: userImage.bottomAnchor, constant: 20).isActive = true
        
        dismissBtn.translatesAutoresizingMaskIntoConstraints = false
        dismissBtn.setTitle("OkayKey".localizableString(loc: ViewController.LANGUAGE), for: .normal)
        dismissBtn.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        dismissBtn.setTitleColor(UIColor.black, for: .normal)
        dismissBtn.layer.cornerRadius = CGFloat(10)
        dismissBtn.addTarget(self, action: #selector(dismissPopup), for: .touchUpInside)
        popupview.addSubview(dismissBtn)
        dismissBtn.bottomAnchor.constraint(equalTo: popupview.bottomAnchor).isActive = true
        dismissBtn.centerXAnchor.constraint(equalTo: popupview.centerXAnchor).isActive = true
        dismissBtn.widthAnchor.constraint(equalTo: popupview.widthAnchor).isActive = true
    }

    @objc func dismissPopup(){
        self.dismiss(animated: true, completion: nil)
    }
    
}
