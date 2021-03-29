//
//  PopUpUserImageViewController.swift
//  Casen
//
//  Created by Ebu Bekir Celik on 26.06.19.
//  Copyright © 2019 KeepEasy. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

class PopUpUserImageViewController: UIViewController, GADRewardBasedVideoAdDelegate {
    
    let screenSize = UIScreen.main.bounds
    var timeFormatter = DateFormatter()
    var dateForm = DateFormatter()
    var formatter = DateFormatter()
    var timeOrRelike: Bool!
    
    let popupview: UIView = {
        let popup = UIView()
        popup.translatesAutoresizingMaskIntoConstraints = false
        return popup
    }()
    
    let userImage: UIImageView = {
        let userImg = UIImageView()
        userImg.translatesAutoresizingMaskIntoConstraints = false
        userImg.layer.cornerRadius = CGFloat(10)
        userImg.clipsToBounds = true
        return userImg
    }()
    
    let navTitle: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont(name: "Avenir-Black", size: 20)
        title.backgroundColor = UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1)//UIColor(red: 191/255, green: 239/255, blue: 255/255, alpha: 1)
        title.textColor = UIColor.black
        title.textAlignment = NSTextAlignment.center
        title.clipsToBounds = true
        title.layer.cornerRadius = CGFloat(10)
        return title
    }()
    
    let mainText: UITextView = {
        let main = UITextView()
        main.translatesAutoresizingMaskIntoConstraints = false
        main.clipsToBounds = true
        main.isEditable = false
        main.isSelectable = false
        main.textAlignment = NSTextAlignment.center
        main.autoresizesSubviews = true
        main.isScrollEnabled = false
        main.backgroundColor = .clear
        main.font = UIFont(name: "Avenir-Black", size: 12)
        return main
    }()
    
    let purchaseButton: UIButton = {
        let screenSize = UIScreen.main.bounds
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        //btn.layer.cornerRadius = 15
        //btn.backgroundColor = UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1)//UIColor(red: 191/255, green: 239/255, blue: 255/255, alpha: 1)
        btn.setGradientBackgroundForButton(sender: btn, colorOne: UIColor.green.cgColor, colorTwo: UIColor.white.cgColor, width: (screenSize.width-70), height: 35)
        btn.titleLabel?.font = UIFont(name: "Avenir-Black", size: 18)
        btn.setTitle("FillUpKey".localizableString(loc: ViewController.LANGUAGE), for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        return btn
    }()
    
    let videoButton: UIButton = {
        let screenSize = UIScreen.main.bounds
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        //btn.layer.cornerRadius = 15
        //btn.backgroundColor = UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1)//UIColor(red: 191/255, green: 239/255, blue: 255/255, alpha: 1)
        btn.setGradientBackgroundForButton(sender: btn, colorOne: UIColor.green.cgColor, colorTwo: UIColor.white.cgColor, width: (screenSize.width-70), height: 35)
        btn.titleLabel?.font = UIFont(name: "Avenir-Black", size: 18)
        btn.setTitle("ReduceKey".localizableString(loc: ViewController.LANGUAGE), for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        return btn
    }()
    
    let noLikes: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.clipsToBounds = true
        return img
    }()
    
    let detectSizes = IphoneSize()
    //Google Video AD
    var rewardedVideoAd: GADRewardBasedVideoAd!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        detectWhichIphone()
        
        //Google Video Ad
        GADRewardBasedVideoAd.sharedInstance().delegate = self
        rewardedVideoAd = GADRewardBasedVideoAd.sharedInstance()
        rewardedVideoAd.delegate = self
        rewardedVideoAd.load(GADRequest(), withAdUnitID: "ca-app-pub-7410173106752410/2559199677")
    }
    
    func detectWhichIphone(){
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                detectSizes.moreLikesHY = 3/3.5
                
            case 1334:
                print("iPhone 6/6S/7/8")
                detectSizes.moreLikesHY = 2/3
                
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                detectSizes.moreLikesHY = 2/3
                
            case 2436:
                print("iPhone X, XS")
                detectSizes.moreLikesHY = 2/4
                
            case 2688:
                print("iPhone XS Max")
                detectSizes.moreLikesHY = 2/4
                
            case 1792:
                print("iPhone XR")
                detectSizes.moreLikesHY = 2/4
                
            default:
                print("Unknown")
            }
        }
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        var ref: DatabaseReference
        ref = Database.database().reference()
        
        if self.timeOrRelike{
            if Int(truncating: reward.amount) > 0{
                
                if navTitle.text != "MessageKey".localizableString(loc: ViewController.LANGUAGE){
                    ref.child("Likeable").child(DatingController.finalUserID).child("LastedLikeTime").observeSingleEvent(of: .value) { (snap) in
                        if snap.exists(){
                            if let value = snap.value as? Double{
                                let timeWait = self.formatter.string(from: Date(timeIntervalSince1970: value))
                                var hoursIndex = timeWait.index(timeWait.startIndex, offsetBy: 2)
                                let waitHours = Int(timeWait[..<hoursIndex])
                                var minutesIndex = timeWait.index(timeWait.endIndex, offsetBy: -2)
                                var waitMinutes = Int(timeWait[minutesIndex...])
                                
                                let timeCurrent = self.formatter.string(from: Date(timeIntervalSince1970: Date().timeIntervalSince1970))
                                hoursIndex = timeCurrent.index(timeCurrent.startIndex, offsetBy: 2)
                                let currentHours = Int(timeCurrent[..<hoursIndex])
                                minutesIndex = timeCurrent.index(timeCurrent.endIndex, offsetBy: -2)
                                let currentMinutes = Int(timeCurrent[minutesIndex...])
                                
                                var newHour = Int()
                                var newMinutes = Int()
                                var today = false
                                
                                if waitHours! < currentHours!{
                                    newHour = waitHours! + (24 - currentHours!)
                                    
                                    if waitMinutes! == 0 && currentMinutes! != 0{
                                        waitMinutes = 60
                                    }
                                    
                                    if waitMinutes! >= currentMinutes!{
                                        newMinutes = waitMinutes! - currentMinutes!
                                    }else{
                                        newMinutes = currentMinutes! - waitMinutes!
                                    }
                                    
                                    if newHour > 0{
                                        if newHour > 1{
                                            newHour = waitHours! - (newHour/2)
                                            if newHour == 0{
                                                newHour = 1
                                            }
                                            if newHour < 0{
                                                newHour *= -1
                                                //                                            newHour = newHour - waitHours!
                                                newHour = 24 - newHour
                                                today = true
                                            }
                                            else{
                                                newHour = waitHours! - newHour
                                                today = false
                                            }
                                        }else{
                                            newHour = waitHours! - 1
                                        }
                                        
                                        if newMinutes > 1{
                                            newMinutes = waitMinutes! - (newMinutes/2)
                                        }else{
                                            newMinutes = waitMinutes! - 1
                                        }
                                    }else{
                                        if newMinutes > 1{
                                            newMinutes = waitMinutes! - (newMinutes/2)
                                        }else{
                                            newMinutes = waitMinutes! - 1
                                        }
                                    }
                                }else{
                                    newHour = waitHours! - currentHours!
                                    
                                    if waitMinutes! == 0 && currentMinutes! != 0{
                                        waitMinutes = 60
                                    }
                                    if waitMinutes! >= currentMinutes!{
                                        newMinutes = waitMinutes! - currentMinutes!
                                    }else{
                                        newMinutes = currentMinutes! - waitMinutes!
                                    }
                                    
                                    if newHour > 0{
                                        if newHour > 1{
                                            newHour = waitHours! - (newHour/2)
                                        }else{
                                            newHour = waitHours! - 1
                                        }
                                        
                                        if newMinutes > 1{
                                            newMinutes = waitMinutes! - (newMinutes/2)
                                        }else{
                                            newMinutes = waitMinutes! - 1
                                        }
                                    }else{
                                        if newMinutes > 1{
                                            newMinutes = waitMinutes! - (newMinutes/2)
                                        }else{
                                            newMinutes = waitMinutes! - 1
                                        }
                                    }
                                }
                                
                                if newHour < 0 {
                                    newHour *= -1
                                }
                                if newMinutes < 0{
                                    newMinutes *= -1
                                }
                                
                                var reverseTime = Date()
                                
                                if today{
                                    reverseTime = self.timeFormatter.date(from: self.dateForm.string(from: Date(timeIntervalSince1970: Date().timeIntervalSince1970)) + " " + String(newHour) + ":" + String(newMinutes) + ":" + String(0))!
                                }else{
                                    reverseTime = self.timeFormatter.date(from: self.dateForm.string(from: Date(timeIntervalSince1970: value)) + " " + String(newHour) + ":" + String(newMinutes) + ":" + String(0))!
                                }
                                
                                ref.child("Likeable").child(DatingController.finalUserID).child("LastedLikeTime").setValue(reverseTime.timeIntervalSince1970)
                                
                                DatingController.lastLikedTime = reverseTime.timeIntervalSince1970
                            }
                        }
                    }
                }else{
                    ChatViewController.sendenMessagesCounter = 0
                    ChatViewController.maxSendedMessage = 3
                    
                    ref.child("Chats").child(ChatViewController.finalUserUid!).child(ChatViewController.userOppositeID).child("buyCompleted").setValue(3)
                    ref.child("Chats").child(ChatViewController.finalUserUid!).child(ChatViewController.userOppositeID).child("sendCounter").setValue(ChatViewController.sendenMessagesCounter)
                }
            }
        }else{
            DatingController.replayCnt = 0
            ref.child("Likeable").child(DatingController.finalUserID).child("ReplayCnt").setValue(DatingController.replayCnt)
        }
    }
    
    func detectIfTimeOrRelike(set: Bool){
        self.timeOrRelike = set
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        rewardedVideoAd.load(GADRequest(), withAdUnitID: "ca-app-pub-7410173106752410/2559199677")
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didFailToLoadWithError error: Error) {
        print("Reward based video ad failed to load.")
    }
    
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd:GADRewardBasedVideoAd) {
        print("Reward based video ad is received.")
    }
    
    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Opened reward based video ad.")
    }
    
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad started playing.")
    }
    
    func rewardBasedVideoAdDidCompletePlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad has completed.")
    }
    
    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad will leave application.")
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func createImagePopUp(image: String){
        view.addSubview(popupview)
        popupview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popupview.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        popupview.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2/5).isActive = true
        popupview.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        
        userImage.loadImageUsingCacheWithURLString(urlImg: image)
        popupview.addSubview(userImage)
        userImage.centerYAnchor.constraint(equalTo: popupview.centerYAnchor).isActive = true
        userImage.centerXAnchor.constraint(equalTo: popupview.centerXAnchor).isActive = true
        userImage.heightAnchor.constraint(equalTo: popupview.heightAnchor).isActive = true
        userImage.widthAnchor.constraint(equalTo: popupview.widthAnchor).isActive = true
    }
    
    func createNoLikesPopUp(){
        popupview.setGradientBackgroundForSideMenu(sender: popupview, colorOne: UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1).cgColor, colorTwo: UIColor.white.cgColor, width: (screenSize.width-20), height: (screenSize.height*(detectSizes.moreLikesHY!)))
        view.addSubview(popupview)
        popupview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popupview.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        popupview.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: detectSizes.moreLikesHY!).isActive = true
        popupview.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
        
        popupview.addSubview(navTitle)
        navTitle.centerXAnchor.constraint(equalTo: popupview.centerXAnchor).isActive = true
        navTitle.topAnchor.constraint(equalTo: popupview.topAnchor).isActive = true
        navTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        navTitle.widthAnchor.constraint(equalTo: popupview.widthAnchor).isActive = true
        
        popupview.addSubview(noLikes)
        noLikes.topAnchor.constraint(equalTo: navTitle.bottomAnchor, constant: 40).isActive = true
        noLikes.centerXAnchor.constraint(equalTo: popupview.centerXAnchor).isActive = true
        noLikes.heightAnchor.constraint(equalToConstant: 100).isActive = true
        noLikes.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        popupview.addSubview(mainText)
        mainText.centerXAnchor.constraint(equalTo: popupview.centerXAnchor).isActive = true
        mainText.topAnchor.constraint(equalTo: noLikes.bottomAnchor, constant: 35).isActive = true
        mainText.heightAnchor.constraint(equalToConstant: 100).isActive = true
        mainText.widthAnchor.constraint(equalTo: popupview.widthAnchor).isActive = true
        
        purchaseButton.addTarget(self, action: #selector(buyLikes), for: .touchUpInside)
        popupview.addSubview(purchaseButton)
        purchaseButton.bottomAnchor.constraint(equalTo: popupview.bottomAnchor, constant: -20).isActive = true
        purchaseButton.centerXAnchor.constraint(equalTo: popupview.centerXAnchor).isActive = true
        purchaseButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        purchaseButton.widthAnchor.constraint(equalTo: popupview.widthAnchor, constant: -50).isActive = true
        
        videoButton.addTarget(self, action: #selector(lookVideo), for: .touchUpInside)
        popupview.addSubview(videoButton)
        videoButton.bottomAnchor.constraint(equalTo: purchaseButton.topAnchor, constant: -20).isActive = true
        videoButton.centerXAnchor.constraint(equalTo: popupview.centerXAnchor).isActive = true
        videoButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        videoButton.widthAnchor.constraint(equalTo: popupview.widthAnchor, constant: -50).isActive = true
        
        timeFormatter.timeZone = TimeZone(abbreviation: "CET") //Set timezone that you want
        timeFormatter.locale = NSLocale.current
        timeFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        
        dateForm.timeZone = TimeZone(abbreviation: "CET") //Set timezone that you want
        dateForm.locale = NSLocale.current
        dateForm.dateFormat = "yyy-MM-dd"
        
        formatter.timeZone = TimeZone(abbreviation: "CET") //Set timezone that you want
        formatter.locale = NSLocale.current
        formatter.dateFormat = "HH:mm"
    }
    
    @objc func buyLikes(){
        UIButton.animate(withDuration: 0.2, animations: {
            self.purchaseButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { (finish) in
            UIButton.animate(withDuration: 0.2, animations: {
                self.purchaseButton.transform = CGAffineTransform.identity
            })
        }

        if navTitle.text != "MessageKey".localizableString(loc: ViewController.LANGUAGE){
            IAPService.shared.purchase(product: .consumable)
            IAPService.shared.restoresPurchases()
            self.dismiss(animated: true, completion: nil)
        }else{
            IAPService.shared.purchase(product: .messagesConsumable)
            IAPService.shared.restoresPurchases()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func lookVideo(){
        UIButton.animate(withDuration: 0.2, animations: {
            self.videoButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { (finish) in
            UIButton.animate(withDuration: 0.2, animations: {
                self.videoButton.transform = CGAffineTransform.identity
            })
        }
        
        if rewardedVideoAd.isReady{
            rewardedVideoAd.present(fromRootViewController: self)
        }
    }
    
    func changeMoreLikesTitle(title: String){
        navTitle.text = title
    }
    
    func changeMoreLikesImage(image: UIImage){
        noLikes.image = image
    }
    
    func changeMoreLikesMainText(txt: String){
        mainText.text = txt
        mainText.font = UIFont(name: mainText.font!.fontName, size: 15)
    }
}
