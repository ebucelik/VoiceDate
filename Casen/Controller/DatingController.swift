//
//  DatingController.swift
//  Casen
//
//  Created by Ebu Bekir Celik on 06.04.19.
//  Copyright © 2019 KeepEasy. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import AVFoundation
import Alamofire

class DatingController: UIViewController, CLLocationManagerDelegate, AVAudioPlayerDelegate {
    
    let screenSize = UIScreen.main.bounds
    let manager = CLLocationManager() //LOCALIZATION
    var city = NSString()
    var postalCode = String()
    let userUid = UserDefaults.standard.value(forKey: "UserID") //REGISTRIERT
    let loginUserID = UserDefaults.standard.value(forKey: "LoginUserID") //EINGELOGGT
    let loggedIN = UserDefaults.standard.bool(forKey: "loggedIN") //OB REGISTRIERT ODER EINGELOGGT
    var extraData = UserDefaults.standard.bool(forKey: "extraDataFromDatingController")
    static var finalUserID = String()
    var navigationBar = UINavigationBar()
    let navItem = UINavigationItem()
    var latitude = Double()
    var longitude = Double()
    var distanceList = [String]()
    let navigation = UIView()
    var userDistance = [Userdistance]()
    var matchedUser = [String]()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let indicatorBackground = UIView()
    var timer: Timer!
    var choosenGenderSelf = String()
    var likeCounter = 0
    var user = [User]()
    var navTitle = UILabel()
    var latitudeCurrentPos = Double()
    var longitudeCurrentPos = Double()
    var cityCurrenPos = NSString()
    var plzCurrentPos = String()
    var sortedUser = [Userdistance]()
    var sortedDislikedUser = [Userdistance]()
    let likeButton = UIButton()
    let dontlikeButton = UIButton()
    let userImage = UIImageView()
    let userInfo = UILabel()
    let userInfoBackground = UIView()
    var accessUserUpdatePosition = false
    var userName = String()
    var matchedUsername = String()
    var badgeCounter = Int()
    var update = UIButton()
    var detectRotate = false
    var matchesController = MatchesViewController()
    var likeDislikeUser = [String]()
    var whenLikedUserExist = false
    var chooseGender = String()
    var checkIfOutOfRange = Array<Any>()
    var checkIfLogout = false
    var checkIfLiked = false
    let detectSizes = IphoneSize()
    var toggleMenu = false
    var sideMenuWidth: NSLayoutConstraint?
    let logoutBtn = UIButton()
    let datingTippsBtn = UIButton()
    let datingTippsImage = UIImageView()
    let pickUpBtn = UIButton()
    let pickUpImage = UIImageView()
    let deleteAccBtn = UIButton()
    let deleteAccImage = UIImageView()
    let sideMenu = UIView()
    let sideMenuProfileImg = UIImageView()
    let sideMenuExitImg = UIImageView()
    let sideMenuLikesImg = UIImageView()
    let profileSettingsBtn = UIButton()
    let dataProtection = UIButton()
    let moreLikesBtn = UIButton()
    let contact = UIButton()
    let sideMenuDataImg = UIImageView()
    let sideMenuContactImg = UIImageView()
    var gestureRecognizer = UIPanGestureRecognizer()
    var cardX = CGFloat()
    var cardY = CGFloat()
    var getImagePositionFirstTime = true
    static var checkIfNoUser = true
    var scaleX = CGFloat()
    var editProfileImageURL = String()
    var audioVoiceSelf = String()
    var timeToLike = Date()
    var timeFormatter = DateFormatter()
    var dateForm = DateFormatter()
    var formatter = DateFormatter()
    var getTimeToLike = String()
    static var hours = Int()
    static var minutes = Int()
    static var seconds = Int()
    var hoursLastLiked = Int()
    var minutesLastLiked = Int()
    var secondsLastLiked = Int()
    var hoursMinus = Int()
    var minutesMinus = Int()
    var secondsMinus = Int()
    static let popUpNoLike = PopUpUserImageViewController()
    static var lastLikedTime = Double()
    var replayUserUid = String()
    var replayUserDepartment = String()
    static var genderSelf = String()
    static var replayCnt: Int!
    var blocked = false
    
    //audioSliderTimer
    var sliderTimer: Timer!
    
    //audioplayer
    var playerButton = UIButton()
    var soundPlayer: AVAudioPlayer!
    
    //stream Audio
    var playerItem: AVPlayerItem!
    var player: AVPlayer!
    var destinationUrl: URL!
    
    let audioSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.clipsToBounds = true
        slider.minimumTrackTintColor = UIColor.white//UIColor(red: 217/255, green: 219/255, blue: 220/255, alpha: 1.0)//UIColor(red: 191/255, green: 239/255, blue: 255/255, alpha: 1)
        slider.maximumTrackTintColor = UIColor.white
        slider.setThumbImage(UIImage(named: "filledcircle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        slider.isUserInteractionEnabled = false
        return slider
    }()
    
    let audioPlayerSliderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        //view.backgroundColor = UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1)//UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowOpacity = 1.0
        view.layer.shadowRadius = 5.0
        view.layer.masksToBounds = false
        return view
    }()
    
    let likeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    let dontlikeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    //Wenn ich wieder ein Element - ARRAY brauche hier ein Bsp:
   /* let informationBtn: [UIButton] = {
        var info = [UIButton]()
        
        for i in 0 ... 1{
            var information = UIButton()
            information.tag = i
            information.setImage(UIImage(named: "info")?.withRenderingMode(.alwaysTemplate), for: .normal)
            information.translatesAutoresizingMaskIntoConstraints = false
            information.clipsToBounds = true
            information.tintColor = UIColor.white
            info.append(information)
        }
        
        return info
    }()*/
    
    let replay: UIButton = {
        let replayBtn = UIButton()
        replayBtn.translatesAutoresizingMaskIntoConstraints = false
        replayBtn.clipsToBounds = true
        replayBtn.addTarget(self, action: #selector(replayLike), for: .touchUpInside)
        replayBtn.backgroundColor = UIColor.white
        replayBtn.setImage(UIImage(named: "replay")?.withRenderingMode(.alwaysTemplate), for: .normal)
        replayBtn.tintColor = UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1)
        replayBtn.layer.shadowColor = UIColor.gray.cgColor
        replayBtn.layer.shadowOffset = CGSize(width: -3.0, height: 3.0)
        replayBtn.layer.shadowOpacity = 1.0
        replayBtn.layer.shadowRadius = 5.0
        replayBtn.layer.masksToBounds = false
        replayBtn.layer.cornerRadius = 20
        return replayBtn
    }()
    
    let infogeneral: UIButton = {
        let infoBtn = UIButton()
        infoBtn.translatesAutoresizingMaskIntoConstraints = false
        infoBtn.clipsToBounds = true
        infoBtn.addTarget(self, action: #selector(getInfo), for: .touchUpInside)
        infoBtn.backgroundColor = UIColor.white
        infoBtn.setImage(UIImage(named: "info_dating")?.withRenderingMode(.alwaysTemplate), for: .normal)
        infoBtn.tintColor = UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1)
        infoBtn.layer.shadowColor = UIColor.gray.cgColor
        infoBtn.layer.shadowOffset = CGSize(width: -3.0, height: 3.0)
        infoBtn.layer.shadowOpacity = 1.0
        infoBtn.layer.shadowRadius = 5.0
        infoBtn.layer.masksToBounds = false
        infoBtn.layer.cornerRadius = 20
        return infoBtn
    }()
    
    let logoImage: UIImageView = {
        let logo = UIImageView()
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.clipsToBounds = true
        logo.image = UIImage(named: "voicedate_logo")?.withRenderingMode(.alwaysOriginal)
        logo.isHidden = true
        return logo
    }()
    
    let sideMenuVersionNum: UILabel = {
        let ver = UILabel()
        ver.translatesAutoresizingMaskIntoConstraints = false
        ver.clipsToBounds = true
        ver.text = "Version: 1.0\n2019 © Celik Ebu Bekir"
        ver.numberOfLines = 2
        ver.font = UIFont(name: ver.font.fontName, size: 10)
        ver.textColor = UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 0.8)
        ver.textAlignment = .center
        return ver
    }()
    
    let blockBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.backgroundColor = .white
        btn.setTitle("BlockTitle".localizableString(loc: ViewController.LANGUAGE), for: .normal)
        btn.setTitleColor(UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1), for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        btn.layer.shadowColor = UIColor.gray.cgColor
        btn.layer.shadowOffset = CGSize(width: -3.0, height: 3.0)
        btn.layer.shadowOpacity = 1.0
        btn.layer.shadowRadius = 5.0
        btn.layer.masksToBounds = false
        btn.layer.cornerRadius = 13
        btn.addTarget(self, action: #selector(block), for: .touchUpInside)
        return btn
    }()
    
    //privacy policy
    let message = "\n\nPrivacy Policy\n\nEffective date: August 02, 2019\n\nEbu Bekir Celik built the VoiceDate app. This app includes advertising in kind of videos to watch from AdMob by Google. This app will be ask users to share his location. No one will get these private user information. This app work with the firebase database. All user data will be saved in the firebase database from Google. In this app users can buy In-App Products.\n\nVoiceDate (\"us\", \"we\", or \"our\") operates the VoiceDate mobile application (the \"Service\").\n\nThis page informs you of our policies regarding the collection, use, and disclosure of personal data when you use our Service and the choices you have associated with that data. Our Privacy Policy for VoiceDate is created with the help of the Free Privacy Policy Generator.\n\nWe use your data to provide and improve the Service. By using the Service, you agree to the collection and use of information in accordance with this policy. Unless otherwise defined in this Privacy Policy, terms used in this Privacy Policy have the same meanings as in our Terms and Conditions.\n\nInformation Collection And Use\n\nWe collect several different types of information for various purposes to provide and improve our Service to you.\n\nTypes of Data Collected\n\nPersonal Data\n\nWhile using our Service, we may ask you to provide us with certain personally identifiable information that can be used to contact or identify you (\"Personal Data\"). Personally identifiable information may include, but is not limited to: \n•    Email address\n•    First name and last name\n•    Address, State, Province, ZIP/Postal code, City\n•    Cookies and Usage Data\n\nUsage Data\n\nWhen you access the Service by or through a mobile device, we may collect certain information automatically, including, but not limited to, the type of mobile device you use, your mobile device unique ID, the IP address of your mobile device, your mobile operating system, the type of mobile Internet browser you use, unique device identifiers and other diagnostic data (\"Usage Data\").\n\nTracking & Cookies Data\n\nWe use cookies and similar tracking technologies to track the activity on our Service and hold certain information.\nCookies are files with small amount of data which may include an anonymous unique identifier. Cookies are sent to your browser from a website and stored on your device. Tracking technologies also used are beacons, tags, and scripts to collect and track information and to improve and analyze our Service.\nYou can instruct your browser to refuse all cookies or to indicate when a cookie is being sent. However, if you do not accept cookies, you may not be able to use some portions of our Service.\n\nExamples of Cookies we use:\n•    Session Cookies. We use Session Cookies to operate our Service.\n•    Preference Cookies. We use Preference Cookies to remember your preferences and various settings.\n•    Security Cookies. We use Security Cookies for security purposes.\n\nUse of Data\n\nVoiceDate uses the collected data for various purposes:\n•    To provide and maintain the Service\n•    To notify you about changes to our Service\n•    To allow you to participate in interactive features of our Service when you choose to do so\n•    To provide customer care and support\n•    To provide analysis or valuable information so that we can improve the Service\n•    To monitor the usage of the Service\n•    To detect, prevent and address technical issues\n\nTransfer Of Data\n\nYour information, including Personal Data, may be transferred to — and maintained on — computers located outside of your state, province, country or other governmental jurisdiction where the data protection laws may differ than those from your jurisdiction.\nIf you are located outside Austria and choose to provide information to us, please note that we transfer the data, including Personal Data, to Austria and process it there.\nYour consent to this Privacy Policy followed by your submission of such information represents your agreement to that transfer.\nVoiceDate will take all steps reasonably necessary to ensure that your data is treated securely and in accordance with this Privacy Policy and no transfer of your Personal Data will take place to an organization or a country unless there are adequate controls in place including the security of your data and other personal information.\n\nDisclosure Of Data\n\nLegal Requirements\n\nVoiceDate may disclose your Personal Data in the good faith belief that such action is necessary to:\n•    To comply with a legal obligation\n•    To protect and defend the rights or property of VoiceDate\n•    To prevent or investigate possible wrongdoing in connection with the Service\n•    To protect the personal safety of users of the Service or the public\n•    To protect against legal liability\n\nSecurity Of Data\n\nThe security of your data is important to us, but remember that no method of transmission over the Internet, or method of electronic storage is 100% secure. While we strive to use commercially acceptable means to protect your Personal Data, we cannot guarantee its absolute security.\n\nService Providers\n\nWe may employ third party companies and individuals to facilitate our Service (\"Service Providers\"), to provide the Service on our behalf, to perform Service-related services or to assist us in analyzing how our Service is used.\nThese third parties have access to your Personal Data only to perform these tasks on our behalf and are obligated not to disclose or use it for any other purpose.\n\nLinks To Other Sites\nOur Service may contain links to other sites that are not operated by us. If you click on a third party link, you will be directed to that third party's site. We strongly advise you to review the Privacy Policy of every site you visit.\nWe have no control over and assume no responsibility for the content, privacy policies or practices of any third party sites or services.\n\nChildren's Privacy\n\nOur Service does not address anyone under the age of 18 (\"Children\").\nWe do not knowingly collect personally identifiable information from anyone under the age of 18. If you are a parent or guardian and you are aware that your Children has provided us with Personal Data, please contact us. If we become aware that we have collected Personal Data from children without verification of parental consent, we take steps to remove that information from our servers.\n\nChanges To This Privacy Policy\nWe may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.\nWe will let you know via email and/or a prominent notice on our Service, prior to the change becoming effective and update the \"effective date\" at the top of this Privacy Policy.\nYou are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page.\n\nContact Us\nIf you have any questions about this Privacy Policy, please contact us:\n•    By email: ebucelik1@hotmail.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.setGradientBackground(sender: view, colorOne: UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1).cgColor, colorTwo: UIColor.white.cgColor)
        
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .left
        
        view.addGestureRecognizer(edgePan)
        
        gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(swipeImage))
        
        detectWhichIphone()
        
        checkIfUserIsLoggedIn()
        
        checkIfUserHadSavedPersonalData()
        
        guard let finalUser = Auth.auth().currentUser?.uid else{
            return
        }
        
        DatingController.finalUserID = finalUser
        
        navTitle = UILabel(frame: CGRect(x: Int(screenSize.width/2-90), y: detectSizes.navTitleY!, width: 180, height: 30))
        
        indicBackground()
        
        navBar()
        
        findMyLocation()
        
        downloadOtherUser()
        
        matchesController.downloadMatchedUser()
        
        detectIfUserFirsttime()
        
        //Hole die angebotenen, kaufbaren Produkte (Likes auffüllen)
        IAPService.shared.getProducts()
    }
    
    func checkEula(){
        let eulaController = EulaViewController()
        eulaController.modalTransitionStyle = .flipHorizontal
        self.present(eulaController, animated: true, completion: nil)
    }
    
    func detectIfUserFirsttime(){
        if !extraData{
            var ref: DatabaseReference
            ref = Database.database().reference()
            
            ref.child("User").child(DatingController.finalUserID).child("firsttime").observeSingleEvent(of: .value) { (snap) in
                if !snap.exists(){
                    let introController = IntroductionController()
                    self.present(introController, animated: true, completion: nil)
                    ref.child("User").child(DatingController.finalUserID).child("firsttime").setValue(true)
                }else{
                    if let value = snap.value as? Bool{
                        if !value{
                            let introController = IntroductionController()
                            self.present(introController, animated: true, completion: nil)
                            ref.child("User").child(DatingController.finalUserID).child("firsttime").setValue(true)
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        accessUserUpdatePosition = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if(!checkIfLogout){
            doDownloadAgain()
        }
        
        if sliderTimer != nil{
            sliderTimer.invalidate()
            self.player.pause()
            audioSlider.value = 0
            playerButton.setImage(UIImage(named: "play_dating")?.withRenderingMode(.alwaysTemplate), for: .normal)
            NotificationCenter.default.removeObserver(self.playerItem)
        }
    }
    
    var deleteVal = Bool()
    var key = String()
    
    @objc func replayLike(){
        //Reverse liked User
        UIButton.animate(withDuration: 0.2, animations: {
            self.replay.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { (finish) in
            UIButton.animate(withDuration: 0.2, animations: {
                self.replay.transform = CGAffineTransform.identity
            })
        }
  
        if self.replayUserUid.isEmpty || self.replayUserUid == ""{
            DatingController.popUpNoLike.detectWhichIphone()
            DatingController.popUpNoLike.createNoLikesPopUp()
            DatingController.popUpNoLike.detectIfTimeOrRelike(set: false)
            DatingController.popUpNoLike.changeMoreLikesTitle(title: "SwipeKey".localizableString(loc: ViewController.LANGUAGE))
            DatingController.popUpNoLike.changeMoreLikesMainText(txt: "SwipeOneKey".localizableString(loc: ViewController.LANGUAGE))
            DatingController.popUpNoLike.changeMoreLikesImage(image: (UIImage(named: "lovebig")?.withRenderingMode(.alwaysOriginal))!)
            DatingController.popUpNoLike.purchaseButton.isHidden = true
            DatingController.popUpNoLike.videoButton.isHidden = true
            DatingController.popUpNoLike.modalPresentationStyle = .overCurrentContext
            DatingController.popUpNoLike.modalTransitionStyle = .crossDissolve
            self.present(DatingController.popUpNoLike, animated: true, completion: nil)
            return
        }
        
        if DatingController.replayCnt < 1{
            var ref: DatabaseReference
            ref = Database.database().reference()
            
            ref.child("Matches").child(self.replayUserDepartment).child(DatingController.finalUserID).observeSingleEvent(of: .value) { (snapshot) in
                if snapshot.exists(){
                    for child in snapshot.children{
                        let snap = child as! DataSnapshot
                        
                        if (snap.value as? String) == self.replayUserUid{
                            ref.child("Matches").child(self.replayUserDepartment).child(DatingController.finalUserID).child(snap.key).setValue(nil)
                            self.replayUserUid = ""
                            self.replayUserDepartment = ""
                            self.doDownloadAgain()
                            DatingController.replayCnt += 1
                            ref.child("Likeable").child(DatingController.finalUserID).child("ReplayCnt").setValue(DatingController.replayCnt)
                            ref.child("Likeable").child(DatingController.finalUserID).child("ReplayLikeID").setValue("")
                            
                            break
                        }
                    }
                }
            }
        }else{
            DatingController.popUpNoLike.detectWhichIphone()
            DatingController.popUpNoLike.createNoLikesPopUp()
            DatingController.popUpNoLike.detectIfTimeOrRelike(set: false)
            DatingController.popUpNoLike.changeMoreLikesTitle(title: "SwipeKey".localizableString(loc: ViewController.LANGUAGE))
            DatingController.popUpNoLike.changeMoreLikesMainText(txt: "SwipeAgainKey".localizableString(loc: ViewController.LANGUAGE))
            DatingController.popUpNoLike.changeMoreLikesImage(image: (UIImage(named: "notlovebig")?.withRenderingMode(.alwaysOriginal))!)
            DatingController.popUpNoLike.videoButton.setTitle("VideoKey".localizableString(loc: ViewController.LANGUAGE), for: .normal)
            DatingController.popUpNoLike.purchaseButton.isHidden = true
            DatingController.popUpNoLike.videoButton.isHidden = false
            DatingController.popUpNoLike.modalPresentationStyle = .overCurrentContext
            DatingController.popUpNoLike.modalTransitionStyle = .crossDissolve
            self.present(DatingController.popUpNoLike, animated: true, completion: nil)
        }
    }

    
    @objc func getInfo(){
        UIButton.animate(withDuration: 0.2, animations: {
            self.infogeneral.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { (finish) in
            UIButton.animate(withDuration: 0.2, animations: {
                self.infogeneral.transform = CGAffineTransform.identity
            })
        }
        
        var ref: DatabaseReference
        ref = Database.database().reference()
        
        let alert = UIAlertController(title: "ReportTitle".localizableString(loc: ViewController.LANGUAGE), message: "ReportUserKey".localizableString(loc: ViewController.LANGUAGE), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Report".localizableString(loc: ViewController.LANGUAGE), style: .default, handler: { (action: UIAlertAction!) in
            if self.userImage.image != UIImage(named: "iconProfile")?.withRenderingMode(.alwaysTemplate){
                ref.child("Reports").childByAutoId().setValue(self.sortedUser[self.likeCounter].userUid)
                self.blocked = true
                self.dislike()
                let alertCanc = UIAlertController(title: "Reported".localizableString(loc: ViewController.LANGUAGE), message: "ReportedTxt".localizableString(loc: ViewController.LANGUAGE), preferredStyle: .alert)
                alertCanc.addAction(UIAlertAction(title: "OkayKey".localizableString(loc: ViewController.LANGUAGE), style: .default, handler: nil))
                self.present(alertCanc, animated: true, completion: nil)
            }else{
                let alertCanc = UIAlertController(title: "NoUserKey".localizableString(loc: ViewController.LANGUAGE), message: "ReportNoUser".localizableString(loc: ViewController.LANGUAGE), preferredStyle: .alert)
                alertCanc.addAction(UIAlertAction(title: "OkayKey".localizableString(loc: ViewController.LANGUAGE), style: .default, handler: nil))
                self.present(alertCanc, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "RepCan".localizableString(loc: ViewController.LANGUAGE), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self.view)
            
            if(!toggleMenu && location.x >= screenSize.width/1.3){
                UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    self.sideMenuWidth?.isActive = false
                    self.sideMenuWidth = self.sideMenu.widthAnchor.constraint(equalToConstant: 0)
                    self.sideMenuWidth?.isActive = true
                    if(self.userImage.image != UIImage(named: "iconProfile")?.withRenderingMode(.alwaysTemplate)){
                        self.playerButton.isEnabled = true
                    }else{
                        self.playerButton.isEnabled = false
                    }
                    self.sideMenuProfileImg.isHidden = true
                    self.datingTippsImage.isHidden = true
                    self.pickUpImage.isHidden = true
                    self.sideMenuLikesImg.isHidden = true
                    self.sideMenuDataImg.isHidden = true
                    self.deleteAccImage.isHidden = true
                    self.sideMenuExitImg.isHidden = true
                    self.logoImage.isHidden = true
                    self.sideMenuVersionNum.isHidden = true
                    self.sideMenuContactImg.isHidden = true
                    self.userImage.addGestureRecognizer(self.gestureRecognizer)
                    self.view.layoutIfNeeded()
                    
                    self.toggleMenu = !self.toggleMenu
                }, completion: nil)
            }
        }
    }
    
    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer){
        if recognizer.state == .recognized {
            if(toggleMenu){
                UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    self.sideMenuWidth?.isActive = false
                    self.sideMenuWidth = self.sideMenu.widthAnchor.constraint(equalToConstant: self.screenSize.width/1.3)
                    self.sideMenuWidth?.isActive = true
                    self.playerButton.isEnabled = false
                    self.sideMenuProfileImg.isHidden = false
                    self.datingTippsImage.isHidden = false
                    self.pickUpImage.isHidden = false
                    self.sideMenuLikesImg.isHidden = false
                    self.sideMenuDataImg.isHidden = false
                    self.deleteAccImage.isHidden = false
                    self.sideMenuExitImg.isHidden = false
                    self.logoImage.isHidden = false
                    self.sideMenuVersionNum.isHidden = false
                    self.sideMenuContactImg.isHidden = false
                    self.userImage.removeGestureRecognizer(self.gestureRecognizer)
                    self.view.layoutIfNeeded()
                    self.toggleMenu = !self.toggleMenu
                }, completion: nil)
            }
        }
    }
    
    @objc func swipeImage(_ recognizer: UIPanGestureRecognizer){
        let card = recognizer.view! //Die View
        let point = recognizer.translation(in: view) //Die Koordinaten wo ich mit dem Finger im Moment hinswipe
        
        if getImagePositionFirstTime{
            cardX = card.center.x //Erste X Position des Bildes
            cardY = card.center.y //Erste Y Position des Bildes
            
            getImagePositionFirstTime = false
        }
        
        //Die View wird von der Mitte aus mit den X,Y Koordinaten neu berechnet und somit folgt die View meinem Finger
        card.center.x = cardX + point.x //CGPoint(x: , y: cardY + point.y)
        
        //Bild drehen und kleiner machen beim Swipen
        if card.center.x > cardX{
            card.transform = CGAffineTransform(rotationAngle: (card.center.x - (cardX/1.2)) / screenSize.width).scaledBy(x: cardX / card.center.x , y: cardX / card.center.x)
        }else if card.center.x < cardX{
            if card.center.x / cardX < 0.50{
                scaleX = 0.50
            }else{
                scaleX = card.center.x / cardX
            }

            card.transform = CGAffineTransform(rotationAngle: -(cardX - (card.center.x/1.2)) / screenSize.width).scaledBy(x: scaleX , y: scaleX)
        }
        
        if recognizer.state == .ended{
            if card.center.x >= screenSize.width - 25 && DatingController.checkIfNoUser{
                UIView.animate(withDuration: 0.5, animations: {
                    card.center = CGPoint(x: card.center.x + self.screenSize.width, y: card.center.y + 100)
                }) { (fin) in
                    if self.userImage.image != UIImage(named: "iconProfile")?.withRenderingMode(.alwaysTemplate){
                        self.like()
                    }
                    UIView.animate(withDuration: 1.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                        card.center = CGPoint(x: self.cardX, y: self.cardY)
                        card.transform = CGAffineTransform.identity
                        self.likeButton.alpha = (card.center.x - self.cardX) / self.screenSize.width
                        self.likeView.backgroundColor = UIColor.clear
                    }, completion: nil)
                }
            }else if card.center.x <= 0 && userImage.image != UIImage(named: "iconProfile")?.withRenderingMode(.alwaysTemplate){
                UIView.animate(withDuration: 0.5, animations: {
                    card.center = CGPoint(x: card.center.x - self.screenSize.width, y: card.center.y + 100)
                }) { (fin) in
                    if self.userImage.image != UIImage(named: "iconProfile")?.withRenderingMode(.alwaysTemplate){
                        self.dislike()
                    }
                    UIView.animate(withDuration: 1.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                        card.center = CGPoint(x: self.cardX, y: self.cardY)
                        card.transform = CGAffineTransform.identity
                        self.dontlikeButton.alpha = (self.cardX - card.center.x) / self.screenSize.width
                        self.dontlikeView.backgroundColor = UIColor.clear
                    }, completion: nil)
                }
            }else{
                UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    card.center = CGPoint(x: self.cardX, y: self.cardY)
                    card.transform = CGAffineTransform.identity
                }, completion: nil)
                
                if userImage.image != UIImage(named: "iconProfile")?.withRenderingMode(.alwaysTemplate){
                    if(AppDelegate.LIKESCOUNTER > 14){
                        DatingController.popUpNoLike.detectWhichIphone()
                        DatingController.popUpNoLike.createNoLikesPopUp()
                        if Date().timeIntervalSince1970 < TimeInterval(exactly: DatingController.lastLikedTime)!{
                            DatingController.checkIfNoUser = false
                            DatingController.popUpNoLike.detectIfTimeOrRelike(set: true)
                            DatingController.popUpNoLike.changeMoreLikesTitle(title: "LikesConsumed".localizableString(loc: ViewController.LANGUAGE))
                            DatingController.popUpNoLike.changeMoreLikesMainText(txt: "YouCanLikeFrom".localizableString(loc: ViewController.LANGUAGE) + self.formatter.string(from: Date(timeIntervalSince1970: DatingController.lastLikedTime)) + " 😝" + "DontWantToWait".localizableString(loc: ViewController.LANGUAGE))
                            DatingController.popUpNoLike.changeMoreLikesImage(image: (UIImage(named: "notlovebig")?.withRenderingMode(.alwaysOriginal))!)
                            DatingController.popUpNoLike.purchaseButton.isHidden = false
                            DatingController.popUpNoLike.videoButton.isHidden = false
                            DatingController.popUpNoLike.modalPresentationStyle = .overCurrentContext
                            DatingController.popUpNoLike.modalTransitionStyle = .crossDissolve
                            self.present(DatingController.popUpNoLike, animated: true, completion: nil)
                        }else if !DatingController.checkIfNoUser{
                            AppDelegate.LIKESCOUNTER = 0
                            var ref: DatabaseReference
                            ref = Database.database().reference()
                            ref.child("Likeable").child(DatingController.finalUserID).child("LikesCounter").setValue(AppDelegate.LIKESCOUNTER)
                            DatingController.checkIfNoUser = true
                            DatingController.popUpNoLike.changeMoreLikesTitle(title: "MoreLikes".localizableString(loc: ViewController.LANGUAGE))
                            DatingController.popUpNoLike.changeMoreLikesMainText(txt: "LikesFull".localizableString(loc: ViewController.LANGUAGE))
                            DatingController.popUpNoLike.changeMoreLikesImage(image: (UIImage(named: "lovebig")?.withRenderingMode(.alwaysOriginal))!)
                            DatingController.popUpNoLike.purchaseButton.isHidden = true
                            DatingController.popUpNoLike.videoButton.isHidden = true
                            DatingController.popUpNoLike.modalPresentationStyle = .overCurrentContext
                            DatingController.popUpNoLike.modalTransitionStyle = .crossDissolve
                            self.present(DatingController.popUpNoLike, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        if userImage.image != UIImage(named: "iconProfile")?.withRenderingMode(.alwaysTemplate){
            if((card.center.x - cardX) / (screenSize.width/3) < 0.70){
                likeView.backgroundColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: (card.center.x - cardX) / (screenSize.width/3))
            }else{
                likeView.backgroundColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 0.70)
            }
            
            if((cardX - card.center.x) / (screenSize.width/3) < 0.70){
                dontlikeView.backgroundColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: (cardX - card.center.x) / (screenSize.width/3))
            }else{
                dontlikeView.backgroundColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 0.70)
            }
        }
        
        likeButton.alpha = (card.center.x - cardX) / (screenSize.width/3)
        dontlikeButton.alpha = (cardX - card.center.x) / (screenSize.width/3)
    }
    
    func indicBackground(){
        indicatorBackground.frame = CGRect(x: 0, y: 0, width: 85, height: 85)
        indicatorBackground.center = view.center
        indicatorBackground.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        indicatorBackground.layer.cornerRadius = 10
        indicatorBackground.isHidden = true
        self.view.addSubview(indicatorBackground)
    }
    
    func distanceBetweenTwo(ownDistance: Double, ownDistance1: Double, otherDistance: Double, otherDistance1: Double, userID: String){
        
        let userDistanceList = Userdistance()
        
        let location1 = CLLocation(latitude: ownDistance, longitude: ownDistance1)
        
        let location2 = CLLocation(latitude: otherDistance, longitude: otherDistance1)
        
        let distanceMeter = Measurement(value: location1.distance(from: location2), unit: UnitLength.meters)
        
        var distanceKM = distanceMeter.converted(to: .kilometers).value
        
        distanceKM = round(distanceKM)
        
        userDistanceList.userUid = userID
        userDistanceList.distance = distanceKM
        
        userDistance.append(userDistanceList)
        //distanceList.append(String(distanceKM) + "-" + userID) //APPEND DISTANCE AND USERID
    }
    
    //KONNTE NUR SO LOGOUT BUTTON HINZUFÜGEN
    func navBar(){
        navigation.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 80)
        navigation.backgroundColor = UIColor.clear
        view.addSubview(navigation)
        navigation.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        navigation.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        let menuBar = UIButton(frame: CGRect(x: 0, y: detectSizes.logoutY!, width: 50, height: 30))
        menuBar.setImage(UIImage(named: "menu")?.withRenderingMode(.alwaysTemplate), for: .normal)
        menuBar.tintColor = UIColor.black
        menuBar.addTarget(self, action: #selector(handleSideMenu), for: .touchUpInside)
        
        navigation.addSubview(menuBar)
        
        update = UIButton(frame: CGRect(x: Int(screenSize.width-50), y: detectSizes.updateY!, width: 50, height: 30))
        update.setImage(UIImage(named: "refresh")?.withRenderingMode(.alwaysTemplate), for: .normal)
        update.tintColor = UIColor.black
        update.addTarget(self, action: #selector(doDownload), for: .touchUpInside)
        
        navigation.addSubview(update)
    }
    
    @objc func handleSideMenu(){
        if(toggleMenu){
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.sideMenuWidth?.isActive = false
                self.sideMenuWidth = self.sideMenu.widthAnchor.constraint(equalToConstant: self.screenSize.width/1.3)
                self.sideMenuWidth?.isActive = true
                if(self.userImage.image != UIImage(named: "iconProfile")?.withRenderingMode(.alwaysTemplate)){
                    self.playerButton.isEnabled = true
                }else{
                    self.playerButton.isEnabled = false
                }
                self.sideMenuProfileImg.isHidden = false
                self.datingTippsImage.isHidden = false
                self.pickUpImage.isHidden = false
                self.sideMenuLikesImg.isHidden = false
                self.sideMenuDataImg.isHidden = false
                self.deleteAccImage.isHidden = false
                self.sideMenuExitImg.isHidden = false
                self.logoImage.isHidden = false
                self.sideMenuVersionNum.isHidden = false
                self.sideMenuContactImg.isHidden = false
                self.userImage.removeGestureRecognizer(self.gestureRecognizer)
                self.view.layoutIfNeeded()
            }, completion: nil)
        }else{
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.sideMenuWidth?.isActive = false
                self.sideMenuWidth = self.sideMenu.widthAnchor.constraint(equalToConstant: 0)
                self.sideMenuWidth?.isActive = true
                if(self.userImage.image != UIImage(named: "iconProfile")?.withRenderingMode(.alwaysTemplate)){
                    self.playerButton.isEnabled = true
                }else{
                    self.playerButton.isEnabled = false
                }
                self.sideMenuProfileImg.isHidden = true
                self.datingTippsImage.isHidden = true
                self.pickUpImage.isHidden = true
                self.sideMenuLikesImg.isHidden = true
                self.sideMenuDataImg.isHidden = true
                self.deleteAccImage.isHidden = true
                self.sideMenuExitImg.isHidden = true
                self.logoImage.isHidden = true
                self.sideMenuVersionNum.isHidden = true
                self.sideMenuContactImg.isHidden = true
                self.userImage.addGestureRecognizer(self.gestureRecognizer)
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        
        toggleMenu = !toggleMenu
    }
    
    @objc func handleLogout(){
        UIButton.animate(withDuration: 0.2, animations: {
            self.logoutBtn.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { (finish) in
            UIButton.animate(withDuration: 0.2, animations: {
                self.logoutBtn.transform = CGAffineTransform.identity
                
                var ref: DatabaseReference
                ref = Database.database().reference()
                if Auth.auth().currentUser?.uid != nil{
                    ref.child("User").child(Auth.auth().currentUser?.uid as! String).child("Online").setValue(false)
                }
                
                do
                {
                    try Auth.auth().signOut()
                }
                catch let error{
                    print(error)
                }
                
                self.checkIfLogout = true
                
                let loginController = LoginController()
                self.present(loginController, animated: true, completion: nil)
            })
        }
    }
    
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser?.uid == nil{
            perform(#selector(goToLogin), with: nil, afterDelay: 0)
        }
    }
    
    func checkIfUserHadSavedPersonalData(){
        if extraData {
            self.perform(#selector(self.goToRegisterExtraData), with: nil, afterDelay: 0)
        }
    }
    
    @objc func goToRegisterExtraData(){
        checkIfLogout = true
        
        let extraDatesViewController = ExtraDatesViewController() //OPEN EXTRA VIEW CONTROLLER CAUSE HE CLOSED THE APP WITHOUT SAVING
        present(extraDatesViewController, animated: true, completion: nil)
    }
    
    @objc func goToLogin(){
        //TODO: Login/Register Controller
        do {
            try Auth.auth().signOut()
        }
        catch let error{
            print(error)
        }
        
        checkIfLogout = true
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
    func findMyLocation(){
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        //GET CURRENT POSITION FOR UPDATE
        latitudeCurrentPos = Double(location.coordinate.latitude)
        longitudeCurrentPos = Double(location.coordinate.longitude)
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if error != nil{
                print(error as Any)
                return
            }
            
            if (placemarks?.count)! > 0{
                let pm = placemarks![0] as CLPlacemark
                
                //LIEFERT DIE GENAUE STADT
                self.city = (pm.addressDictionary!["City"] as? NSString)!
                self.postalCode = pm.postalCode!
                
                //CURRENT FOR UPDATE
                self.cityCurrenPos = (pm.addressDictionary!["City"] as? NSString)!
                self.plzCurrentPos = pm.postalCode!
                
                if self.accessUserUpdatePosition{
                    //AKTUALISIERT POSITION IMMER BEI APP ÖFFNEN ODER NEUSTARTEN
                    self.updateUserPosition()
                    self.accessUserUpdatePosition = false
                }
            }
            else
            {
                print("Not location found")
            }
        }
    }
    
    //WENN ICH IN WIEN BIN WILL ICH LEUTE AUS WIEN SEHEN DESHALB IMMER POSITIONSUPDATE
    func updateUserPosition(){
        var ref: DatabaseReference
        ref = Database.database().reference()
        
        if !AppDelegate.DEVICE_ID.isEmpty{
            ref.child("User").child(DatingController.finalUserID).updateChildValues(["deviceID" : AppDelegate.DEVICE_ID, "latitude" : latitudeCurrentPos, "longitude" : longitudeCurrentPos, "city" : cityCurrenPos, "postalCode" : plzCurrentPos])
        }else{
            ref.child("User").child(DatingController.finalUserID).updateChildValues(["latitude" : latitudeCurrentPos, "longitude" : longitudeCurrentPos, "city" : cityCurrenPos, "postalCode" : plzCurrentPos])
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.denied{
            let alert = UIAlertController(title: "InvalidLocKey".localizableString(loc: ViewController.LANGUAGE), message: "LocationKey".localizableString(loc: ViewController.LANGUAGE), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "SettingKey".localizableString(loc: ViewController.LANGUAGE), style: .default, handler: { (action) in
                if let url = URL(string: UIApplication.openSettingsURLString){
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func customizeViewWithUser(user: [User]){
        //GET MY OWN POSITION
        if(user.count > 0){
            for users in user {
                if users.userUid == DatingController.finalUserID{
                    DatingController.genderSelf = users.gender!
                    choosenGenderSelf = users.choosenGender!
                    userName = users.firstname!
                    self.editProfileImageURL = users.imageUrl!
                    self.audioVoiceSelf = users.audioUrl!
                    self.latitude = Double(exactly: users.latitude!)!
                    self.longitude = Double(exactly: users.longitude!)!
                }
            }
            if(self.latitude != 0 && self.longitude != 0){
                //TO MESS KM BETWEEN OTHER USERS
                for users in user {
                    if users.userUid != DatingController.finalUserID && users.gender == choosenGenderSelf{
                        distanceBetweenTwo(ownDistance: self.latitude, ownDistance1: self.longitude, otherDistance: Double(exactly: users.latitude!)!, otherDistance1: Double(exactly: users.longitude!)!, userID: users.userUid!)
                    }else if users.userUid != DatingController.finalUserID && choosenGenderSelf == "Both"{
                        distanceBetweenTwo(ownDistance: self.latitude, ownDistance1: self.longitude, otherDistance: Double(exactly: users.latitude!)!, otherDistance1: Double(exactly: users.longitude!)!, userID: users.userUid!)
                    }
                }
            }
        }
        
        updateUser(user: user)
    }
    
    static var calculateLikesTimer: Timer!
    
    @objc func like(){
        if(soundPlayer != nil)
        {
            playerButton.setImage(UIImage(named: "play_dating")?.withRenderingMode(.alwaysTemplate), for: .normal)
            soundPlayer.stop()
        }
        
        var ref: DatabaseReference
        ref = Database.database().reference()
        
        ///TODO: BUY LIKES after 15 Likes or wait 6 DatingController.hours.
        if(AppDelegate.LIKESCOUNTER > 14){
            
            //Wartezeit einfügen
            if Date().timeIntervalSince1970 >= TimeInterval(exactly: DatingController.lastLikedTime)!{
                self.insertLastLikedTime()
            }
            
            DatingController.checkIfNoUser = false
            DatingController.popUpNoLike.detectWhichIphone()
            DatingController.popUpNoLike.createNoLikesPopUp()
            DatingController.popUpNoLike.detectIfTimeOrRelike(set: true)
            DatingController.popUpNoLike.changeMoreLikesTitle(title: "LikesConsumed".localizableString(loc: ViewController.LANGUAGE))
            DatingController.popUpNoLike.changeMoreLikesMainText(txt: "YouCanLikeFrom".localizableString(loc: ViewController.LANGUAGE) + self.formatter.string(from: Date(timeIntervalSince1970: DatingController.lastLikedTime)) + " 😝" + "DontWantToWait".localizableString(loc: ViewController.LANGUAGE))
            DatingController.popUpNoLike.changeMoreLikesImage(image: (UIImage(named: "notlovebig")?.withRenderingMode(.alwaysOriginal))!)
            DatingController.popUpNoLike.purchaseButton.isHidden = false
            DatingController.popUpNoLike.videoButton.isHidden = false
            DatingController.popUpNoLike.modalPresentationStyle = .overCurrentContext
            DatingController.popUpNoLike.modalTransitionStyle = .crossDissolve
            self.present(DatingController.popUpNoLike, animated: true, completion: nil)
        }else{
            AppDelegate.LIKESCOUNTER += 1

            //Save the UID from the User to use replay
            ref.child("Likeable").child(DatingController.finalUserID).child("ReplayDepartment").setValue("Liked")
            ref.child("Likeable").child(DatingController.finalUserID).child("ReplayLikeID").setValue(self.sortedUser[likeCounter].userUid)
            
            //Save how often I liked
            ref.child("Likeable").child(DatingController.finalUserID).child("LikesCounter").setValue(AppDelegate.LIKESCOUNTER)
            
            self.replayUserDepartment = "Liked"
            self.replayUserUid = (self.sortedUser[likeCounter].userUid)!
            
            likeCounter += 1
            
            checkIfMatch()
            
            updateUser(user: user)
        }
    }
    
    func insertLastLikedTime(){
        let date = NSDate()
        let calendar = NSCalendar.current
        var hours = calendar.component(.hour, from: date as Date)
        let minutes = calendar.component(.minute, from: date as Date)
        let seconds = calendar.component(.second, from: date as Date)
        let year = calendar.component(.year, from: date as Date)
        let month = calendar.component(.month, from: date as Date)
        let day = calendar.component(.day, from: date as Date)
        var dateNow = String(year) + "-" + String(month) + "-" + String(day)
        
        hours += 6
        
        if hours > 23{
            hours = hours - 24
            
            dateNow = dateForm.string(from: Date.tomorrow)
        }
        
        let timeNow = String(hours) + ":" + String(minutes) + ":" + String(seconds)
        
        let bothNow = dateNow + " " + timeNow
   
        DatingController.lastLikedTime = timeFormatter.date(from: bothNow)!.timeIntervalSince1970
        
        var ref: DatabaseReference
        ref = Database.database().reference()
        ref.child("Likeable").child(DatingController.finalUserID).child("LastedLikeTime").setValue(timeFormatter.date(from: bothNow)!.timeIntervalSince1970)
    }
    
    @objc func dislike(){
        if !blocked{
            var ref: DatabaseReference
            ref = Database.database().reference()
            ref.child("Likeable").child(DatingController.finalUserID).child("ReplayDepartment").setValue("Disliked")
            ref.child("Likeable").child(DatingController.finalUserID).child("ReplayLikeID").setValue(self.sortedUser[likeCounter].userUid)
            self.replayUserDepartment = "Disliked"
        }

        self.blocked = false
        
        likeCounter += 1
        
        if(soundPlayer != nil)
        {
            playerButton.setImage(UIImage(named: "play_dating")?.withRenderingMode(.alwaysTemplate), for: .normal)
            soundPlayer.stop()
        }
        
        checkDislike()
        
        updateUser(user: user)
    }
    
    func checkDislike(){
        var ref: DatabaseReference
        ref = Database.database().reference()
        ref.child("Matches").child("Disliked").child(DatingController.finalUserID).childByAutoId().setValue(self.sortedUser[self.likeCounter-1].userUid!)
    }
    
    func checkIfMatch(){
        var likedUserId = [String()]
        var ref: DatabaseReference
        
        ref = Database.database().reference()
        
        ref.child("Matches").child("Liked").child(DatingController.finalUserID).childByAutoId().setValue(self.sortedUser[self.likeCounter-1].userUid!)
        
        ref.child("Matches").child("Liked").child(sortedUser[likeCounter-1].userUid!).observe(.value) { (snapshot) in
            
            guard snapshot.exists() else{
                return
            }
            
            for child in snapshot.children{
                let snap = child as! DataSnapshot
                if(!(snap.value as! String).isEmpty){
                    likedUserId.append(snap.value as! String)
                }
            }
            
            if(likedUserId.count > 0)
            {
                for user in likedUserId{
                    if(user == DatingController.finalUserID){
                        self.badgeCounter += 1
                        
                        if let tabbaritem = self.tabBarController?.tabBar.items{
                            tabbaritem[1].badgeValue = String(self.badgeCounter)
                        }
                        
                        self.checkIfOutOfRange = self.sortedUser
                        
                        if(self.checkIfOutOfRange.getElement(at: self.likeCounter-1) != nil){
                            ref.child("User").child(self.sortedUser[self.likeCounter-1].userUid!).child("firstname").observe(.value, with: { (snapshot) in
                                if let value = snapshot.value as? String{
                                    ref.child("User").child(self.sortedUser[self.likeCounter-1].userUid!).child("image").observeSingleEvent(of: .value, with: { (snap) in
                                        if snap.exists(){
                                            if let valueImg = snap.value as? String{
                                                let popupView = PopupViewController()
                                                popupView.getImageUrl(url: valueImg)
                                                popupView.getMatchedUsername(matchedUname: value)
                                                popupView.modalPresentationStyle = .overCurrentContext
                                                popupView.modalTransitionStyle = .crossDissolve
                                                self.present(popupView, animated: true, completion: nil)
                                            }
                                        }
                                    })
                                    
                                    ref.child("User").child(self.sortedUser[self.likeCounter-1].userUid!).child("Online").observeSingleEvent(of: .value) { (online) in
                                        if online.exists(){
                                            if let value = online.value as? Bool{
                                                if value{
                                                    ref.child("Matches").child("Matched").child(self.sortedUser[self.likeCounter-1].userUid!).childByAutoId().setValue(DatingController.finalUserID)
                                                }else{
                                                    //Bei Matched finden wir alle User mit Ihren Matches.
                                                    ref.child("Matches").child("Matched").child(DatingController.finalUserID).childByAutoId().setValue(self.sortedUser[self.likeCounter-1].userUid!)
                                                    ref.child("Matches").child("Matched").child(self.sortedUser[self.likeCounter-1].userUid!).childByAutoId().setValue(DatingController.finalUserID)
                                                }
                                            }
                                        }
                                    }
                                    self.matchesController.downloadMatchedUser()
                                }
                            })
                            
                            //Set Replay Like to nil if he has a match
                            ref.child("Likeable").child(DatingController.finalUserID).child("ReplayLikeID").setValue("")
                            self.replayUserUid = ""
                            self.replayUserDepartment = ""
                            
                            ref.child("User").child(self.sortedUser[self.likeCounter-1].userUid!).child("deviceID").observe(.value, with: { (snapshot) in
                                if let value = snapshot.value as? String{
                                    let sender = PushNotifications()
                                    sender.sendPushNotification(to: value, title: "It's a match!", body: "MatchKey".localizableString(loc: ViewController.LANGUAGE))
                                }
                            })
                        }
                        
                        break
                    }
                }
            }
        }
    }
    
    @objc func block(){
        UIButton.animate(withDuration: 0.2, animations: {
            self.blockBtn.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { (finish) in
            UIButton.animate(withDuration: 0.2, animations: {
                self.blockBtn.transform = CGAffineTransform.identity
            })
        }
        
        var ref: DatabaseReference
        ref = Database.database().reference()
        
        let alert = UIAlertController(title: "BlockTitle".localizableString(loc: ViewController.LANGUAGE), message: "BlockUserKey".localizableString(loc: ViewController.LANGUAGE), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Block".localizableString(loc: ViewController.LANGUAGE), style: .default, handler: { (action: UIAlertAction!) in
            if self.userImage.image != UIImage(named: "iconProfile")?.withRenderingMode(.alwaysTemplate){
                ref.child("Blocked").childByAutoId().setValue(self.sortedUser[self.likeCounter].userUid)
                self.blocked = true
                self.dislike()
                let alertCanc = UIAlertController(title: "Blocked".localizableString(loc: ViewController.LANGUAGE), message: "BlockTxt".localizableString(loc: ViewController.LANGUAGE), preferredStyle: .alert)
                alertCanc.addAction(UIAlertAction(title: "OkayKey".localizableString(loc: ViewController.LANGUAGE), style: .default, handler: nil))
                self.present(alertCanc, animated: true, completion: nil)
            }else{
                let alertCanc = UIAlertController(title: "NoUserKey".localizableString(loc: ViewController.LANGUAGE), message: "BlockNoUser".localizableString(loc: ViewController.LANGUAGE), preferredStyle: .alert)
                alertCanc.addAction(UIAlertAction(title: "OkayKey".localizableString(loc: ViewController.LANGUAGE), style: .default, handler: nil))
                self.present(alertCanc, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "BlockCan".localizableString(loc: ViewController.LANGUAGE), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateUser(user: [User])
    {
        //Soll nur einmal sortieren weil sonst irgendwann sortedUser die doppelte Anzahl bekommt.
        if(sortedUser.count == 0)
        {
            self.indicatorBackground.isHidden = false
            UIApplication.shared.beginIgnoringInteractionEvents()
            self.activityIndicator.startAnimating()
            self.view.bringSubviewToFront(self.indicatorBackground)
            self.view.bringSubviewToFront(self.activityIndicator)
            
            sortedUser = userDistance.sorted(by: {$0.distance! < $1.distance!}) //SORTIERE DISTANZ
            
            self.updateOtherUser()
            
            //TODO: Bissl kompilizierter, ich will herausfinden welche ich Disliked habe damit diese nicht mehr zu sehen sind!
            navTitle.textAlignment = .center
            navTitle.font = UIFont(name: "Avenir-Black", size: 20)
            navTitle.textColor = .black
            navigation.addSubview(navTitle)
            
            userImage.translatesAutoresizingMaskIntoConstraints = false
            userImage.clipsToBounds = true
//            userImage.contentMode = .scaleAspectFill
            userImage.addGestureRecognizer(gestureRecognizer)
            userImage.isUserInteractionEnabled = true
            userImage.layer.shadowColor = UIColor.gray.cgColor
            userImage.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            userImage.layer.shadowOpacity = 1.0
            userImage.layer.shadowRadius = 5.0
            userImage.layer.masksToBounds = false
            userImage.layer.cornerRadius = 10
            view.addSubview(userImage)
            userImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            userImage.topAnchor.constraint(equalTo: view.topAnchor, constant: detectSizes.userImg!-5).isActive = true
            userImage.widthAnchor.constraint(equalToConstant: screenSize.width-20).isActive = true
            userImage.heightAnchor.constraint(equalToConstant: screenSize.width-20).isActive = true
            
            userImage.addSubview(likeView)
            likeView.centerXAnchor.constraint(equalTo: userImage.centerXAnchor).isActive = true
            likeView.centerYAnchor.constraint(equalTo: userImage.centerYAnchor).isActive = true
            likeView.widthAnchor.constraint(equalToConstant: screenSize.width-20).isActive = true
            likeView.heightAnchor.constraint(equalToConstant: screenSize.width-20).isActive = true
            
            userImage.addSubview(dontlikeView)
            dontlikeView.centerXAnchor.constraint(equalTo: userImage.centerXAnchor).isActive = true
            dontlikeView.centerYAnchor.constraint(equalTo: userImage.centerYAnchor).isActive = true
            dontlikeView.widthAnchor.constraint(equalToConstant: screenSize.width-20).isActive = true
            dontlikeView.heightAnchor.constraint(equalToConstant: screenSize.width-20).isActive = true
            
            view.addSubview(audioPlayerSliderView)
            audioPlayerSliderView.leftAnchor.constraint(equalTo: userImage.leftAnchor).isActive = true
            audioPlayerSliderView.topAnchor.constraint(equalTo: userImage.bottomAnchor, constant: 5).isActive = true
            audioPlayerSliderView.heightAnchor.constraint(equalToConstant: detectSizes.playerBtn!).isActive = true
            audioPlayerSliderView.widthAnchor.constraint(equalTo: userImage.widthAnchor).isActive = true
            
            userInfoBackground.translatesAutoresizingMaskIntoConstraints = false
            userInfoBackground.clipsToBounds = true
            userInfoBackground.layer.cornerRadius = 10
            userInfoBackground.layer.shadowColor = UIColor.gray.cgColor
            userInfoBackground.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            userInfoBackground.layer.shadowOpacity = 1.0
            userInfoBackground.layer.shadowRadius = 5.0
            userInfoBackground.layer.masksToBounds = false
            view.addSubview(userInfoBackground)
            userInfoBackground.leftAnchor.constraint(equalTo: userImage.leftAnchor).isActive = true
            userInfoBackground.topAnchor.constraint(equalTo: audioPlayerSliderView.bottomAnchor).isActive = true
            userInfoBackground.widthAnchor.constraint(equalTo: userImage.widthAnchor).isActive = true
            userInfoBackground.heightAnchor.constraint(equalToConstant: detectSizes.userInfo!).isActive = true
            
            userInfo.translatesAutoresizingMaskIntoConstraints = false
            userInfo.clipsToBounds = true
            userInfo.textAlignment = .center
            userInfo.textColor = UIColor.white
            userInfo.numberOfLines = 2
            userInfoBackground.addSubview(userInfo)
            userInfo.centerXAnchor.constraint(equalTo: userInfoBackground.centerXAnchor).isActive = true
            userInfo.centerYAnchor.constraint(equalTo: userInfoBackground.centerYAnchor).isActive = true
            
            playerButton.translatesAutoresizingMaskIntoConstraints = false
            playerButton.clipsToBounds = true
            playerButton.backgroundColor = UIColor.white
            playerButton.setImage(UIImage(named: "play_dating")?.withRenderingMode(.alwaysTemplate), for: .normal)
            playerButton.tintColor = UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1)
            playerButton.addTarget(self, action: #selector(playAct), for: .touchUpInside)
            playerButton.isEnabled = false
            playerButton.layer.shadowColor = UIColor.gray.cgColor
            playerButton.layer.shadowOffset = CGSize(width: -3.0, height: 3.0)
            playerButton.layer.shadowOpacity = 1.0
            playerButton.layer.shadowRadius = 5.0
            playerButton.layer.masksToBounds = false
            playerButton.layer.cornerRadius = 32.5
            view.addSubview(playerButton)
            playerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            playerButton.topAnchor.constraint(equalTo: userInfoBackground.bottomAnchor, constant: detectSizes.player!).isActive = true
            playerButton.heightAnchor.constraint(equalToConstant: 65).isActive = true
            playerButton.widthAnchor.constraint(equalToConstant: 65).isActive = true
            
            view.addSubview(replay)
            replay.centerYAnchor.constraint(equalTo: playerButton.centerYAnchor).isActive = true
            replay.rightAnchor.constraint(equalTo: playerButton.leftAnchor, constant: -45).isActive = true
            replay.heightAnchor.constraint(equalToConstant: 40).isActive = true
            replay.widthAnchor.constraint(equalToConstant: 40).isActive = true
            
            view.addSubview(infogeneral)
            infogeneral.centerYAnchor.constraint(equalTo: playerButton.centerYAnchor).isActive = true
            infogeneral.leftAnchor.constraint(equalTo: playerButton.rightAnchor, constant: 45).isActive = true
            infogeneral.heightAnchor.constraint(equalToConstant: 40).isActive = true
            infogeneral.widthAnchor.constraint(equalToConstant: 40).isActive = true
            
            view.addSubview(blockBtn)
            blockBtn.topAnchor.constraint(equalTo: playerButton.bottomAnchor, constant: detectSizes.block!).isActive = true
            blockBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
            audioPlayerSliderView.addSubview(audioSlider)
            audioSlider.leftAnchor.constraint(equalTo: audioPlayerSliderView.leftAnchor, constant: 10).isActive = true
            audioSlider.centerYAnchor.constraint(equalTo: audioPlayerSliderView.centerYAnchor).isActive = true
            audioSlider.heightAnchor.constraint(equalTo: audioPlayerSliderView.heightAnchor).isActive = true
            audioSlider.rightAnchor.constraint(equalTo: audioPlayerSliderView.rightAnchor, constant: -10).isActive = true
            
            likeButton.translatesAutoresizingMaskIntoConstraints = false
            likeButton.backgroundColor = .white
            likeButton.layer.cornerRadius = 50
            likeButton.layer.borderWidth = CGFloat(3)
            likeButton.alpha = 0
            likeButton.layer.borderColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0).cgColor
            likeButton.setImage(UIImage(named: "love")?.withRenderingMode(.alwaysOriginal), for: .normal)
            likeButton.contentMode = .scaleAspectFit
            likeButton.addTarget(self, action: #selector(like), for: .touchUpInside)
            userImage.addSubview(likeButton)
            likeButton.leftAnchor.constraint(equalTo: userImage.leftAnchor, constant: 5).isActive = true
            likeButton.topAnchor.constraint(equalTo: userImage.topAnchor, constant: 5).isActive = true
            likeButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
            likeButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
            
            dontlikeButton.translatesAutoresizingMaskIntoConstraints = false
            dontlikeButton.backgroundColor = .white
            dontlikeButton.layer.cornerRadius = 50
            dontlikeButton.layer.borderWidth = CGFloat(3)
            dontlikeButton.alpha = 0
            dontlikeButton.layer.borderColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0).cgColor
            dontlikeButton.setImage(UIImage(named: "notlove")?.withRenderingMode(.alwaysOriginal), for: .normal)
            dontlikeButton.contentMode = .scaleAspectFit
            dontlikeButton.addTarget(self, action: #selector(dislike), for: .touchUpInside)
            userImage.addSubview(dontlikeButton)
            dontlikeButton.rightAnchor.constraint(equalTo: userImage.rightAnchor, constant: -5).isActive = true
            dontlikeButton.topAnchor.constraint(equalTo: userImage.topAnchor, constant: 5).isActive = true
            dontlikeButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
            dontlikeButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
            
            sideMenu.setGradientBackgroundForSideMenu(sender: sideMenu, colorOne: UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1).cgColor, colorTwo: UIColor.white.cgColor, width: self.screenSize.width/1.2, height: (self.screenSize.height-80))
            sideMenu.translatesAutoresizingMaskIntoConstraints = false
            sideMenu.clipsToBounds = true
            view.addSubview(sideMenu)
            sideMenu.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            sideMenu.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            sideMenu.topAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(detectSizes.sideMenuY!)).isActive = true
            sideMenu.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            
            sideMenuWidth?.isActive = false
            sideMenuWidth = self.sideMenu.widthAnchor.constraint(equalToConstant: 0)
            sideMenuWidth?.isActive = true
            
            profileSettingsBtn.setTitle("ProfileKey".localizableString(loc: ViewController.LANGUAGE), for: .normal)
            profileSettingsBtn.setTitleColor(.black, for: .normal)
            profileSettingsBtn.translatesAutoresizingMaskIntoConstraints = false
            profileSettingsBtn.layer.cornerRadius = 5
            profileSettingsBtn.backgroundColor = .white
            profileSettingsBtn.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
            profileSettingsBtn.layer.shadowColor = UIColor.gray.cgColor
            profileSettingsBtn.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            profileSettingsBtn.layer.shadowOpacity = 1.0
            profileSettingsBtn.layer.shadowRadius = 5.0
            profileSettingsBtn.layer.masksToBounds = false
            sideMenu.addSubview(profileSettingsBtn)
            profileSettingsBtn.centerXAnchor.constraint(equalTo: sideMenu.centerXAnchor).isActive = true
            profileSettingsBtn.topAnchor.constraint(equalTo: sideMenu.topAnchor, constant: 30).isActive = true
            profileSettingsBtn.widthAnchor.constraint(equalTo: sideMenu.widthAnchor, constant: -25).isActive = true
            profileSettingsBtn.heightAnchor.constraint(equalToConstant: 35).isActive = true
            
            sideMenuProfileImg.image = UIImage(named: "user_group_man_woman")?.withRenderingMode(.alwaysTemplate)
            sideMenuProfileImg.tintColor = .black
            sideMenuProfileImg.translatesAutoresizingMaskIntoConstraints = false
            sideMenuProfileImg.isHidden = true
            profileSettingsBtn.addSubview(sideMenuProfileImg)
            sideMenuProfileImg.leftAnchor.constraint(equalTo: profileSettingsBtn.leftAnchor, constant: 5).isActive = true
            sideMenuProfileImg.centerYAnchor.constraint(equalTo: profileSettingsBtn.centerYAnchor).isActive = true
            sideMenuProfileImg.widthAnchor.constraint(equalToConstant: 30).isActive = true
            sideMenuProfileImg.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            datingTippsBtn.setTitle("DatingTipsKey".localizableString(loc: ViewController.LANGUAGE), for: .normal)
            datingTippsBtn.setTitleColor(.black, for: .normal)
            datingTippsBtn.translatesAutoresizingMaskIntoConstraints = false
            datingTippsBtn.clipsToBounds = true
            datingTippsBtn.layer.cornerRadius = 5
            datingTippsBtn.backgroundColor = .white
            datingTippsBtn.layer.shadowColor = UIColor.gray.cgColor
            datingTippsBtn.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            datingTippsBtn.layer.shadowOpacity = 1.0
            datingTippsBtn.layer.shadowRadius = 5.0
            datingTippsBtn.layer.masksToBounds = false
            datingTippsBtn.addTarget(self, action: #selector(openDatingTippsView), for: .touchUpInside)
            sideMenu.addSubview(datingTippsBtn)
            datingTippsBtn.centerXAnchor.constraint(equalTo: sideMenu.centerXAnchor).isActive = true
            datingTippsBtn.topAnchor.constraint(equalTo: profileSettingsBtn.bottomAnchor, constant: 20).isActive = true
            datingTippsBtn.widthAnchor.constraint(equalTo: sideMenu.widthAnchor, constant: -25).isActive = true
            datingTippsBtn.heightAnchor.constraint(equalToConstant: 35).isActive = true
            
            datingTippsImage.image = UIImage(named: "training")?.withRenderingMode(.alwaysTemplate)
            datingTippsImage.tintColor = .black
            datingTippsImage.translatesAutoresizingMaskIntoConstraints = false
            datingTippsImage.isHidden = true
            datingTippsBtn.addSubview(datingTippsImage)
            datingTippsImage.leftAnchor.constraint(equalTo: datingTippsBtn.leftAnchor, constant: 5).isActive = true
            datingTippsImage.centerYAnchor.constraint(equalTo: datingTippsBtn.centerYAnchor).isActive = true
            datingTippsImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
            datingTippsImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            moreLikesBtn.setTitle("MoreLikes".localizableString(loc: ViewController.LANGUAGE), for: .normal)
            moreLikesBtn.setTitleColor(.black, for: .normal)
            moreLikesBtn.translatesAutoresizingMaskIntoConstraints = false
            moreLikesBtn.layer.cornerRadius = 5
            moreLikesBtn.backgroundColor = .white
            moreLikesBtn.layer.shadowColor = UIColor.gray.cgColor
            moreLikesBtn.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            moreLikesBtn.layer.shadowOpacity = 1.0
            moreLikesBtn.layer.shadowRadius = 5.0
            moreLikesBtn.layer.masksToBounds = false
            moreLikesBtn.addTarget(self, action: #selector(buyLikes), for: .touchUpInside)
            sideMenu.addSubview(moreLikesBtn)
            moreLikesBtn.centerXAnchor.constraint(equalTo: sideMenu.centerXAnchor).isActive = true
            moreLikesBtn.topAnchor.constraint(equalTo: datingTippsBtn.bottomAnchor, constant: 20).isActive = true
            moreLikesBtn.widthAnchor.constraint(equalTo: sideMenu.widthAnchor, constant: -25).isActive = true
            moreLikesBtn.heightAnchor.constraint(equalToConstant: 35).isActive = true
            
            sideMenuLikesImg.image = UIImage(named: "us_dollar")?.withRenderingMode(.alwaysTemplate)
            sideMenuLikesImg.tintColor = .black
            sideMenuLikesImg.translatesAutoresizingMaskIntoConstraints = false
            sideMenuLikesImg.isHidden = true
            moreLikesBtn.addSubview(sideMenuLikesImg)
            sideMenuLikesImg.leftAnchor.constraint(equalTo: moreLikesBtn.leftAnchor, constant: 5).isActive = true
            sideMenuLikesImg.centerYAnchor.constraint(equalTo: moreLikesBtn.centerYAnchor).isActive = true
            sideMenuLikesImg.widthAnchor.constraint(equalToConstant: 30).isActive = true
            sideMenuLikesImg.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            pickUpBtn.setTitle("PickUpKey".localizableString(loc: ViewController.LANGUAGE), for: .normal)
            pickUpBtn.setTitleColor(.black, for: .normal)
            pickUpBtn.translatesAutoresizingMaskIntoConstraints = false
            pickUpBtn.clipsToBounds = true
            pickUpBtn.layer.cornerRadius = 5
            pickUpBtn.backgroundColor = .white
            pickUpBtn.layer.shadowColor = UIColor.gray.cgColor
            pickUpBtn.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            pickUpBtn.layer.shadowOpacity = 1.0
            pickUpBtn.layer.shadowRadius = 5.0
            pickUpBtn.layer.masksToBounds = false
            pickUpBtn.addTarget(self, action: #selector(openPickUpLinesView), for: .touchUpInside)
            sideMenu.addSubview(pickUpBtn)
            pickUpBtn.centerXAnchor.constraint(equalTo: sideMenu.centerXAnchor).isActive = true
            pickUpBtn.topAnchor.constraint(equalTo: moreLikesBtn.bottomAnchor, constant: 20).isActive = true
            pickUpBtn.widthAnchor.constraint(equalTo: sideMenu.widthAnchor, constant: -25).isActive = true
            pickUpBtn.heightAnchor.constraint(equalToConstant: 35).isActive = true
            
            pickUpImage.image = UIImage(named: "order")?.withRenderingMode(.alwaysTemplate)
            pickUpImage.tintColor = .black
            pickUpImage.translatesAutoresizingMaskIntoConstraints = false
            pickUpImage.isHidden = true
            pickUpBtn.addSubview(pickUpImage)
            pickUpImage.leftAnchor.constraint(equalTo: pickUpBtn.leftAnchor, constant: 5).isActive = true
            pickUpImage.centerYAnchor.constraint(equalTo: pickUpBtn.centerYAnchor).isActive = true
            pickUpImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
            pickUpImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            dataProtection.setTitle("PrivacyKey".localizableString(loc: ViewController.LANGUAGE), for: .normal)
            dataProtection.setTitleColor(.black, for: .normal)
            dataProtection.translatesAutoresizingMaskIntoConstraints = false
            dataProtection.layer.cornerRadius = 5
            dataProtection.backgroundColor = .white
            dataProtection.layer.shadowColor = UIColor.gray.cgColor
            dataProtection.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            dataProtection.layer.shadowOpacity = 1.0
            dataProtection.layer.shadowRadius = 5.0
            dataProtection.layer.masksToBounds = false
            dataProtection.addTarget(self, action: #selector(showDataPrivacyPolicy), for: .touchUpInside)
            sideMenu.addSubview(dataProtection)
            dataProtection.centerXAnchor.constraint(equalTo: sideMenu.centerXAnchor).isActive = true
            dataProtection.topAnchor.constraint(equalTo: pickUpBtn.bottomAnchor, constant: 20).isActive = true
            dataProtection.widthAnchor.constraint(equalTo: sideMenu.widthAnchor, constant: -25).isActive = true
            dataProtection.heightAnchor.constraint(equalToConstant: 35).isActive = true
            
            sideMenuDataImg.image = UIImage(named: "security_checked")?.withRenderingMode(.alwaysTemplate)
            sideMenuDataImg.tintColor = .black
            sideMenuDataImg.translatesAutoresizingMaskIntoConstraints = false
            sideMenuDataImg.isHidden = true
            dataProtection.addSubview(sideMenuDataImg)
            sideMenuDataImg.leftAnchor.constraint(equalTo: dataProtection.leftAnchor, constant: 5).isActive = true
            sideMenuDataImg.centerYAnchor.constraint(equalTo: dataProtection.centerYAnchor).isActive = true
            sideMenuDataImg.widthAnchor.constraint(equalToConstant: 30).isActive = true
            sideMenuDataImg.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            deleteAccBtn.setTitle("DeleteAccKey".localizableString(loc: ViewController.LANGUAGE), for: .normal)
            deleteAccBtn.setTitleColor(.black, for: .normal)
            deleteAccBtn.translatesAutoresizingMaskIntoConstraints = false
            deleteAccBtn.clipsToBounds = true
            deleteAccBtn.layer.cornerRadius = 5
            deleteAccBtn.backgroundColor = .white
            deleteAccBtn.layer.shadowColor = UIColor.gray.cgColor
            deleteAccBtn.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            deleteAccBtn.layer.shadowOpacity = 1.0
            deleteAccBtn.layer.shadowRadius = 5.0
            deleteAccBtn.layer.masksToBounds = false
            deleteAccBtn.addTarget(self, action: #selector(deleteAccount), for: .touchUpInside)
            sideMenu.addSubview(deleteAccBtn)
            deleteAccBtn.centerXAnchor.constraint(equalTo: sideMenu.centerXAnchor).isActive = true
            deleteAccBtn.topAnchor.constraint(equalTo: dataProtection.bottomAnchor, constant: 20).isActive = true
            deleteAccBtn.widthAnchor.constraint(equalTo: sideMenu.widthAnchor, constant: -25).isActive = true
            deleteAccBtn.heightAnchor.constraint(equalToConstant: 35).isActive = true
            
            deleteAccImage.image = UIImage(named: "literature")?.withRenderingMode(.alwaysTemplate)
            deleteAccImage.tintColor = .black
            deleteAccImage.translatesAutoresizingMaskIntoConstraints = false
            deleteAccImage.isHidden = true
            deleteAccBtn.addSubview(deleteAccImage)
            deleteAccImage.leftAnchor.constraint(equalTo: deleteAccBtn.leftAnchor, constant: 5).isActive = true
            deleteAccImage.centerYAnchor.constraint(equalTo: deleteAccBtn.centerYAnchor).isActive = true
            deleteAccImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
            deleteAccImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            contact.setTitle("ContactKey".localizableString(loc: ViewController.LANGUAGE), for: .normal)
            contact.setTitleColor(.black, for: .normal)
            contact.translatesAutoresizingMaskIntoConstraints = false
            contact.layer.cornerRadius = 5
            contact.backgroundColor = .white
            contact.layer.shadowColor = UIColor.gray.cgColor
            contact.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            contact.layer.shadowOpacity = 1.0
            contact.layer.shadowRadius = 5.0
            contact.layer.masksToBounds = false
            contact.addTarget(self, action: #selector(showContact), for: .touchUpInside)
            sideMenu.addSubview(contact)
            contact.centerXAnchor.constraint(equalTo: sideMenu.centerXAnchor).isActive = true
            contact.topAnchor.constraint(equalTo: deleteAccBtn.bottomAnchor, constant: 20).isActive = true
            contact.widthAnchor.constraint(equalTo: sideMenu.widthAnchor, constant: -25).isActive = true
            contact.heightAnchor.constraint(equalToConstant: 35).isActive = true
            
            sideMenuContactImg.image = UIImage(named: "cont")?.withRenderingMode(.alwaysTemplate)
            sideMenuContactImg.tintColor = .black
            sideMenuContactImg.translatesAutoresizingMaskIntoConstraints = false
            sideMenuContactImg.isHidden = true
            contact.addSubview(sideMenuContactImg)
            sideMenuContactImg.leftAnchor.constraint(equalTo: contact.leftAnchor, constant: 5).isActive = true
            sideMenuContactImg.centerYAnchor.constraint(equalTo: contact.centerYAnchor).isActive = true
            sideMenuContactImg.widthAnchor.constraint(equalToConstant: 30).isActive = true
            sideMenuContactImg.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            logoutBtn.setTitle("LogoutKey".localizableString(loc: ViewController.LANGUAGE), for: .normal)
            logoutBtn.titleLabel?.font = UIFont(name: "Avenir-Black", size: 20)
            logoutBtn.setTitleColor(.black, for: .normal)
            logoutBtn.contentHorizontalAlignment = .center
            logoutBtn.translatesAutoresizingMaskIntoConstraints = false
            logoutBtn.backgroundColor = UIColor.red.withAlphaComponent(0.75)
            logoutBtn.layer.cornerRadius = 5
            logoutBtn.layer.shadowColor = UIColor.gray.cgColor
            logoutBtn.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            logoutBtn.layer.shadowOpacity = 1.0
            logoutBtn.layer.shadowRadius = 5.0
            logoutBtn.layer.masksToBounds = false
            logoutBtn.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
            sideMenu.addSubview(logoutBtn)
            logoutBtn.centerXAnchor.constraint(equalTo: sideMenu.centerXAnchor).isActive = true
            logoutBtn.topAnchor.constraint(equalTo: contact.bottomAnchor, constant: 20).isActive = true
            logoutBtn.heightAnchor.constraint(equalToConstant: 35).isActive = true
            logoutBtn.widthAnchor.constraint(equalTo: sideMenu.widthAnchor, constant: -25).isActive = true
            
            sideMenuExitImg.image = UIImage(named: "exit")?.withRenderingMode(.alwaysTemplate)
            sideMenuExitImg.tintColor = .black
            sideMenuExitImg.translatesAutoresizingMaskIntoConstraints = false
            sideMenuExitImg.isHidden = true
            logoutBtn.addSubview(sideMenuExitImg)
            sideMenuExitImg.leftAnchor.constraint(equalTo: logoutBtn.leftAnchor, constant: 5).isActive = true
            sideMenuExitImg.centerYAnchor.constraint(equalTo: logoutBtn.centerYAnchor).isActive = true
            sideMenuExitImg.widthAnchor.constraint(equalToConstant: 30).isActive = true
            sideMenuExitImg.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            sideMenu.addSubview(logoImage)
            logoImage.topAnchor.constraint(equalTo: logoutBtn.bottomAnchor, constant: 40).isActive = true
            logoImage.centerXAnchor.constraint(equalTo: sideMenu.centerXAnchor).isActive = true
            logoImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
            logoImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
            
            sideMenu.addSubview(sideMenuVersionNum)
            sideMenuVersionNum.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 30).isActive = true
            sideMenuVersionNum.centerXAnchor.constraint(equalTo: logoImage.centerXAnchor).isActive = true
            sideMenuVersionNum.widthAnchor.constraint(equalToConstant: 150).isActive = true
            sideMenuVersionNum.heightAnchor.constraint(equalToConstant: 25).isActive = true
            
            timeFormatter.timeZone = TimeZone(abbreviation: "CET")//TimeZone(abbreviation: "CET") //Set timezone that you want
            timeFormatter.locale = NSLocale.current
            timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            dateForm.timeZone = TimeZone(abbreviation: "CET") //Set timezone that you want
            dateForm.locale = NSLocale.current
            dateForm.dateFormat = "yyyy-MM-dd"
            
            formatter.timeZone = TimeZone(abbreviation: "CET") //Set timezone that you want
            formatter.locale = NSLocale.current
            formatter.dateFormat = "HH:mm"
//            formatter.amSymbol = "am"
//            formatter.pmSymbol = "pm"
        }
        
        if likeCounter < sortedUser.count{
            updateOtherUser()

            playerButton.isEnabled = true
            DatingController.checkIfNoUser = true
        }else{
            
            userImage.image = UIImage(named: "iconProfile")?.withRenderingMode(.alwaysTemplate)
            userImage.tintColor = UIColor.black
            
            if(UIApplication.shared.isIgnoringInteractionEvents)
            {
                UIApplication.shared.endIgnoringInteractionEvents()
                self.activityIndicator.stopAnimating()
                self.indicatorBackground.isHidden = true
            }
            
            var rotatePos = CGFloat(0)
            
            if !detectRotate{
                rotatePos = CGFloat.pi
                detectRotate = true
            }else{
                rotatePos = 0
                detectRotate = false
            }
            
            UIButton.animate(withDuration: 0.85, animations: {
                self.update.transform = CGAffineTransform(rotationAngle: rotatePos)
            })
            
            //Bringt das Bild wieder auf die ursprünglich eingestellte Position.
            UIButton.animate(withDuration: 0.2, animations: {
                self.userImage.transform = CGAffineTransform.identity
            })
        
            playerButton.isEnabled = false
            DatingController.checkIfNoUser = false
            
            userInfo.text = "PressKey".localizableString(loc: ViewController.LANGUAGE)
            
            navTitle.text = "NoUserKey".localizableString(loc: ViewController.LANGUAGE)
        }
        
        if(UIApplication.shared.isIgnoringInteractionEvents)
        {
            UIApplication.shared.endIgnoringInteractionEvents()
            self.activityIndicator.stopAnimating()
            self.indicatorBackground.isHidden = true
        }
    }
    
    @objc func deleteAccount(){
        UIButton.animate(withDuration: 0.2, animations: {
            self.deleteAccBtn.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { (finish) in
            UIButton.animate(withDuration: 0.2, animations: {
                self.deleteAccBtn.transform = CGAffineTransform.identity
                
                if ViewController.LANGUAGE == "en"{
                    let alert = UIAlertController(title: "Delete Account", message: "Feature is coming soon..", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else if ViewController.LANGUAGE == "de"{
                    let alert = UIAlertController(title: "Account löschen", message: "Dieses Feature ist noch nicht bereit zum Ausführen..", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else if ViewController.LANGUAGE == "tr"{
                    let alert = UIAlertController(title: "Hesabı sil", message: "Bu Özellik yakında geliyor..", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Tamam", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    @objc func openDatingTippsView(){
        UIButton.animate(withDuration: 0.2, animations: {
            self.datingTippsBtn.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { (finish) in
            UIButton.animate(withDuration: 0.2, animations: {
                self.datingTippsBtn.transform = CGAffineTransform.identity
                
                let tipsController = DatingTipsController()
                tipsController.modalTransitionStyle = .flipHorizontal
                self.present(tipsController, animated: true, completion: nil)
            })
        }
    }
    
    @objc func openPickUpLinesView(){
        UIButton.animate(withDuration: 0.2, animations: {
            self.pickUpBtn.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { (finish) in
            UIButton.animate(withDuration: 0.2, animations: {
                self.pickUpBtn.transform = CGAffineTransform.identity
                
                let pickUpController = PickUpController()
                pickUpController.modalTransitionStyle = .flipHorizontal
                self.present(pickUpController, animated: true, completion: nil)
            })
        }
    }
    
    @objc func editProfile(){
        UIButton.animate(withDuration: 0.2, animations: {
            self.profileSettingsBtn.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { (finish) in
            UIButton.animate(withDuration: 0.2, animations: {
                self.profileSettingsBtn.transform = CGAffineTransform.identity
                
                let editProfile = EditProfileViewController()
                editProfile.getUserImageUrl(url: self.editProfileImageURL, audio: self.audioVoiceSelf, currentUserUid: DatingController.finalUserID)
                editProfile.modalTransitionStyle = .flipHorizontal
                self.present(editProfile, animated: true, completion: nil)
            })
        }
        
        self.doDownloadAgain()
    }
    
    @objc func buyLikes(){
        UIButton.animate(withDuration: 0.2, animations: {
            self.moreLikesBtn.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { (finish) in
            UIButton.animate(withDuration: 0.2, animations: {
                self.moreLikesBtn.transform = CGAffineTransform.identity
                
                if(!self.toggleMenu){
                    UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                        self.sideMenuWidth?.isActive = false
                        self.sideMenuWidth = self.sideMenu.widthAnchor.constraint(equalToConstant: 0)
                        self.sideMenuWidth?.isActive = true
                        self.playerButton.isEnabled = true
                        self.sideMenuProfileImg.isHidden = true
                        self.datingTippsImage.isHidden = true
                        self.pickUpImage.isHidden = true
                        self.sideMenuDataImg.isHidden = true
                        self.deleteAccImage.isHidden = true
                        self.sideMenuContactImg.isHidden = true
                        self.sideMenuExitImg.isHidden = true
                        self.logoImage.isHidden = true
                        self.sideMenuVersionNum.isHidden = true
                        self.sideMenuLikesImg.isHidden = true
                        self.view.layoutIfNeeded()
                    }, completion: nil)
                }
                
                DatingController.popUpNoLike.detectWhichIphone()
                DatingController.popUpNoLike.createNoLikesPopUp()
                
                if Date().timeIntervalSince1970 < TimeInterval(exactly: DatingController.lastLikedTime)!{
                    DatingController.popUpNoLike.detectIfTimeOrRelike(set: true)
                    DatingController.popUpNoLike.changeMoreLikesTitle(title: "LikesConsumed".localizableString(loc: ViewController.LANGUAGE) + " ☹️")
                    DatingController.popUpNoLike.changeMoreLikesMainText(txt: "YouCanLikeFrom".localizableString(loc: ViewController.LANGUAGE) + self.formatter.string(from: Date(timeIntervalSince1970: DatingController.lastLikedTime)) + " 😝" + "DontWantToWait".localizableString(loc: ViewController.LANGUAGE))
                    DatingController.popUpNoLike.changeMoreLikesImage(image: (UIImage(named: "notlovebig")?.withRenderingMode(.alwaysOriginal))!)
                    DatingController.popUpNoLike.purchaseButton.isHidden = false
                    DatingController.popUpNoLike.videoButton.isHidden = false
                }else{
                    DatingController.checkIfNoUser = true
                    DatingController.popUpNoLike.detectIfTimeOrRelike(set: true)
                    DatingController.popUpNoLike.changeMoreLikesTitle(title: "MoreLikes".localizableString(loc: ViewController.LANGUAGE))
                    DatingController.popUpNoLike.changeMoreLikesMainText(txt: "LikesFull".localizableString(loc: ViewController.LANGUAGE))
                    DatingController.popUpNoLike.changeMoreLikesImage(image: (UIImage(named: "lovebig")?.withRenderingMode(.alwaysOriginal))!)
                    DatingController.popUpNoLike.purchaseButton.isHidden = true
                    DatingController.popUpNoLike.videoButton.isHidden = true
                }
                DatingController.popUpNoLike.modalPresentationStyle = .overCurrentContext
                DatingController.popUpNoLike.modalTransitionStyle = .crossDissolve
                self.present(DatingController.popUpNoLike, animated: true, completion: nil)
            })
        }
        
        //This method because if I click on a sidemenu then I cannot swipe with the image and the playerbutton is also enabled.
        self.doDownloadAgain()
    }
    
    @objc func showDataPrivacyPolicy(){
        UIButton.animate(withDuration: 0.2, animations: {
            self.dataProtection.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { (finish) in
            UIButton.animate(withDuration: 0.2, animations: {
                self.dataProtection.transform = CGAffineTransform.identity
                
                if(!self.toggleMenu){
                    UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                        self.sideMenuWidth?.isActive = false
                        self.sideMenuWidth = self.sideMenu.widthAnchor.constraint(equalToConstant: 0)
                        self.sideMenuWidth?.isActive = true
                        self.playerButton.isEnabled = true
                        self.sideMenuProfileImg.isHidden = true
                        self.datingTippsImage.isHidden = true
                        self.pickUpImage.isHidden = true
                        self.sideMenuDataImg.isHidden = true
                        self.deleteAccImage.isHidden = true
                        self.sideMenuContactImg.isHidden = true
                        self.sideMenuExitImg.isHidden = true
                        self.logoImage.isHidden = true
                        self.sideMenuVersionNum.isHidden = true
                        self.sideMenuLikesImg.isHidden = true
                        self.view.layoutIfNeeded()
                    }, completion: nil)
                }
                
                let alert = UIAlertController(title: "PrivacyKey".localizableString(loc: ViewController.LANGUAGE), message: self.message, preferredStyle: .alert)
                let height:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.60)
                
                alert.view.addConstraint(height)
                let okayAction = UIAlertAction(title: "UnderKey".localizableString(loc: ViewController.LANGUAGE), style: .default, handler: nil)
                
                alert.addAction(okayAction)
                
                self.present(alert, animated: true, completion: nil)
            })
        }
        
        //This method because if I click on a sidemenu then I cannot swipe with the image and the playerbutton is also enabled.
        self.doDownloadAgain()
    }
    
    @objc func showContact(){
        UIButton.animate(withDuration: 0.2, animations: {
            self.contact.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { (finish) in
            UIButton.animate(withDuration: 0.2, animations: {
                self.contact.transform = CGAffineTransform.identity
                
                if(!self.toggleMenu){
                    UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                        self.sideMenuWidth?.isActive = false
                        self.sideMenuWidth = self.sideMenu.widthAnchor.constraint(equalToConstant: 0)
                        self.sideMenuWidth?.isActive = true
                        self.playerButton.isEnabled = true
                        self.sideMenuProfileImg.isHidden = true
                        self.datingTippsImage.isHidden = true
                        self.pickUpImage.isHidden = true
                        self.sideMenuDataImg.isHidden = true
                        self.deleteAccImage.isHidden = true
                        self.sideMenuContactImg.isHidden = true
                        self.sideMenuExitImg.isHidden = true
                        self.logoImage.isHidden = true
                        self.sideMenuVersionNum.isHidden = true
                        self.sideMenuLikesImg.isHidden = true
                        self.view.layoutIfNeeded()
                    }, completion: nil)
                }
                
                self.toggleMenu = !self.toggleMenu
                
                let contactView = ContactViewController()
                contactView.modalTransitionStyle = .flipHorizontal
                self.present(contactView, animated: true, completion: nil)
            })
        }
        
        //This method because if I click on a sidemenu then I cannot swipe with the image and the playerbutton is also enabled.
        self.doDownloadAgain()
    }
    
    @objc func doDownload(){
        toggleMenu = false
        self.doDownloadAgain()
    }
    
    func doDownloadAgain(){
        //Wenn ein neuer User gefunden wird soll es angezeigt werden.
        var rotatePos = CGFloat(0)
        
        if !detectRotate{
            rotatePos = CGFloat.pi
            detectRotate = true
        }else{
            rotatePos = 0
            detectRotate = false
        }
        
        UIButton.animate(withDuration: 0.85, animations: {
            self.update.transform = CGAffineTransform(rotationAngle: rotatePos)
        })
        
        DatingController.finalUserID = String()
        latitude = Double()
        longitude = Double()
        distanceList = [String]()
        userDistance = [Userdistance]()
        matchedUser = [String]()
        choosenGenderSelf = String()
        likeCounter = 0
        user = [User]()
        latitudeCurrentPos = Double()
        longitudeCurrentPos = Double()
        sortedUser = [Userdistance]()
        sortedDislikedUser = [Userdistance]()
        accessUserUpdatePosition = false
        userName = String()
        matchedUsername = String()
        badgeCounter = Int()
        matchesController = MatchesViewController()
        likeDislikeUser = [String]()
        whenLikedUserExist = false
        chooseGender = String()
        checkIfOutOfRange = Array<Any>()
        //getImagePositionFirstTime = false
        toggleMenu = true
//        DatingController.checkIfNoUser = true
        logoImage.isHidden = true
        
        if sliderTimer != nil{
            sliderTimer.invalidate()
            self.player.pause()
            audioSlider.value = 0
            playerButton.setImage(UIImage(named: "play_dating")?.withRenderingMode(.alwaysTemplate), for: .normal)
            NotificationCenter.default.removeObserver(self.playerItem)
        }
        
        downloadOtherUser()
    }
    
    func updateOtherUser(){
        //DER NÄHERSTE USER SOLL ANGEZEIGT WERDEN, SPÄTER WENN LIKE DANN MIT ZÄHLER DEN INDEX ERHÖHEN!
        for users in user {
            checkIfOutOfRange = sortedUser
            
            if checkIfOutOfRange.getElement(at: likeCounter) != nil{
                if users.userUid == sortedUser[likeCounter].userUid{
                    navTitle.text = users.firstname!
                    
                    matchedUsername = users.firstname!
                    
                    userImage.loadImageUsingCacheWithURLString(urlImg: users.imageUrl!)
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd.MM.yyyy"
                    let date = dateFormatter.date(from: users.birthday!)
                    
                    let now = Date()
                    let calender = Calendar.current
                    let ageComponents = calender.dateComponents([.year], from: date!, to: now)
                    let userAge = ageComponents.year
                    
                    userInfo.text = String(userAge!) + ", " + users.city! + "\n" + String(sortedUser[likeCounter].distance!) + "km"
                    
                    if let audioUrl = URL(string: users.audioUrl!){
                        //create destination file url
                        self.destinationUrl = audioUrl
                    }
                }
            }
        }
        if(userImage.image != nil){
            UIButton.animate(withDuration: 0.2, animations: {
                self.userImage.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }) { (finish) in
                UIButton.animate(withDuration: 0.2, animations: {
                    self.userImage.transform = CGAffineTransform.identity
                })
            }
        }
        
        if(UIApplication.shared.isIgnoringInteractionEvents)
        {
            UIApplication.shared.endIgnoringInteractionEvents()
            self.activityIndicator.stopAnimating()
            self.indicatorBackground.isHidden = true
        }
    }
    
    func setupPlayer(audioFileName: URL){
        do{
            soundPlayer = try AVAudioPlayer(contentsOf: audioFileName)
            soundPlayer.delegate = self
            soundPlayer.volume = 5.0
            soundPlayer.prepareToPlay()
        }catch{
            print(error)
        }
    }
    
    @objc func updateSlider(){
        audioSlider.value = Float(CMTimeGetSeconds((self.player.currentItem?.currentTime())!))
    }
    
    @objc func playAct(){
        
        UIButton.animate(withDuration: 0.2, animations: {
            self.playerButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { (finish) in
            UIButton.animate(withDuration: 0.2, animations: {
                self.playerButton.transform = CGAffineTransform.identity
            })
        }
        
        self.playerItem = AVPlayerItem(url: self.destinationUrl)
        self.player = AVPlayer(playerItem: self.playerItem)
        
        let iconImage = UIImage(named: "play_dating")?.withRenderingMode(.alwaysTemplate)

        if playerButton.currentImage == iconImage && self.player != nil{
            audioSlider.maximumValue = Float(CMTimeGetSeconds((self.player.currentItem?.asset.duration)!))
            sliderTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
            playerButton.setImage(UIImage(named: "pause_dating")?.withRenderingMode(.alwaysTemplate), for: .normal)
//            soundPlayer.play()
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItem)
            self.player.play()
        }
        else{
            if sliderTimer != nil{
                sliderTimer.invalidate()
            }
            playerButton.setImage(UIImage(named: "play_dating")?.withRenderingMode(.alwaysTemplate), for: .normal)
//            soundPlayer.stop()
            self.player.pause()
        }
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        if sliderTimer != nil{
            sliderTimer.invalidate()
        }
        audioSlider.value = 0
        playerButton.setImage(UIImage(named: "play_dating")?.withRenderingMode(.alwaysTemplate), for: .normal)
        NotificationCenter.default.removeObserver(self.playerItem)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playerButton.setImage(UIImage(named: "play_dating")?.withRenderingMode(.alwaysTemplate), for: .normal)
    }
    
    func downloadOtherUser(){
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .whiteLarge
        activityIndicator.color = .white
        activityIndicator.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        view.addSubview(activityIndicator)
        
        self.indicatorBackground.isHidden = false
        UIApplication.shared.beginIgnoringInteractionEvents()
        self.activityIndicator.startAnimating()
        self.view.bringSubviewToFront(self.indicatorBackground)
        self.view.bringSubviewToFront(self.activityIndicator)
        
        self.likeDislikeUser = [String]()
        
        var ref: DatabaseReference
        ref = Database.database().reference()
        
        self.user = [User]()
        
        guard let finalUser = Auth.auth().currentUser?.uid else{
            return
        }
        
        DatingController.finalUserID = finalUser
        
        ref.child("User").child(DatingController.finalUserID).child("EULA").observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists(){
                if let value = snapshot.value as? Bool{
                    if !value{
                        self.checkEula()
                    }
                }
            }else{
                self.checkEula()
            }
        }
        
        ref.child("Likeable").child(DatingController.finalUserID).child("ReplayCnt").observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists(){
                if let value = snapshot.value as? Int{
                    DatingController.replayCnt = value
                }
            }else{
                DatingController.replayCnt = 0
            }
        }
        
        ref.child("Likeable").child(DatingController.finalUserID).child("LikesCounter").observeSingleEvent(of: .value) { (snap) in
            if snap.exists(){
                if let value = snap.value as? Int{
                    AppDelegate.LIKESCOUNTER = value
                }
            }
        }
        
        //Get time to Like again
        ref.child("Likeable").child(DatingController.finalUserID).child("Timestamp").observeSingleEvent(of: .value) { (snap) in
            if snap.exists(){
                if let value = snap.value as? String{
                    self.getTimeToLike = value
                }
            }
        }
        
        //Get last liked time
        ref.child("Likeable").child(DatingController.finalUserID).child("LastedLikeTime").observeSingleEvent(of: .value) { (snap) in
            if snap.exists(){
                if let value = snap.value as? Double{
                    DatingController.lastLikedTime = value
                }
            }
        }
        
        //get Replay User UID
        ref.child("Likeable").child(DatingController.finalUserID).child("ReplayLikeID").observeSingleEvent(of: .value) { (snap) in
            if snap.exists(){
                if let value = snap.value as? String{
                    self.replayUserUid = value
                }
            }
        }
        
        //get Replay User UID
        ref.child("Likeable").child(DatingController.finalUserID).child("ReplayDepartment").observeSingleEvent(of: .value) { (snap) in
            if snap.exists(){
                if let value = snap.value as? String{
                    self.replayUserDepartment = value
                }
            }
        }
        
        ref.child("Matches").child("Matched").child(DatingController.finalUserID).observe(.value) { (snapshot) in
            
            guard snapshot.exists() else{
                return
            }
            
            for child in snapshot.children{
                let snap = child as! DataSnapshot
                if(snap.value as! String != "" && self.matchedUser.count != snapshot.childrenCount){
                    self.matchedUser.append(snap.value as! String)
                }
            }
        }
        
        ref.child("User").child(DatingController.finalUserID).child("Online").observeSingleEvent(of: .value) { (snapshot) in
            if !snapshot.exists(){
                ref.child("User").child(DatingController.finalUserID).child("Online").setValue(true)
            }else{
                ref.child("User").child(DatingController.finalUserID).child("Online").setValue(true)
            }
        }
        
        ref.child("User").child(DatingController.finalUserID).child("choosenGender").observe(.value) { (snapshot) in
            guard snapshot.exists() else{
                return
            }
            
            if let value = snapshot.value as? String{
                self.chooseGender = value
            }
        }
        
        ref.child("Matches").child("Liked").child(DatingController.finalUserID).observe(.value) { (snapshot) in
            
            guard snapshot.exists() else{
                ref.child("Matches").child("Disliked").child(DatingController.finalUserID).observe(.value) { (snap) in
                    
                    guard snap.exists() else{
                        self.downloadRestUser()
                        return
                    }
                    
                    for child in snap.children{
                        let snapi = child as! DataSnapshot
                        self.likeDislikeUser.append(snapi.value as! String)
                        
                        if(self.likeDislikeUser.count == (snap.childrenCount + snapshot.childrenCount)){
                            self.downloadRestUser()
                        }
                    }
                }
                return
            }
            
            for child in snapshot.children{
                let snap = child as! DataSnapshot
               
                if(self.likeDislikeUser.count != snapshot.childrenCount){
                    self.likeDislikeUser.append(snap.value as! String)
                }
                
                if(self.likeDislikeUser.count == snapshot.childrenCount){
                    ref.child("Matches").child("Disliked").child(DatingController.finalUserID).observe(.value) { (snapDis) in
                        
                        guard snapDis.exists() else{
                            self.downloadRestUser()
                            return
                        }
                        
                        for child in snapDis.children{
                            let snapi = child as! DataSnapshot
                            self.likeDislikeUser.append(snapi.value as! String)

                            if(self.likeDislikeUser.count == (snapDis.childrenCount + snapshot.childrenCount)){
                                self.downloadRestUser()
                            }
                        }
                    }
                }
            }
        }
    }
    
    var allUserData = [String : AnyObject]()

    func downloadRestUser(){
        
        self.whenLikedUserExist = false
        var ref: DatabaseReference
        ref = Database.database().reference()
        
        ref.child("User").observe(.value) { (snapshot) in
            if snapshot.childrenCount > 0{
                let allUserIn = snapshot.children.allObjects as! [DataSnapshot]
                
                for allUser in allUserIn{
                    let userAppend = User()
                    
                    self.allUserData = allUser.value as! [String : AnyObject]
                    
                    if let latitude = self.allUserData["latitude"], let longitude = self.allUserData["longitude"], let firstname = self.allUserData["firstname"], let lastname = self.allUserData["lastname"], let birthday = self.allUserData["birthday"], let gender = self.allUserData["genderSelf"], let genderChoosen = self.allUserData["choosenGender"], let city = self.allUserData["city"], let imageUrl = self.allUserData["image"], let audioUrl = self.allUserData["audioVoice"], let deviceID = self.allUserData["deviceID"], let userID = self.allUserData["userUid"]{
                        if !String(describing: audioUrl).isEmpty || String(describing: audioUrl) != ""{
                            for noSeeUser in self.likeDislikeUser{
                                if(String(describing: userID) == noSeeUser){
                                    self.whenLikedUserExist = true
                                    break
                                }
                            }
                            
                            if (String(describing: gender) == self.chooseGender || String(describing: userID) == DatingController.finalUserID) && !self.whenLikedUserExist{
                                userAppend.latitude = Double(exactly: latitude as! NSNumber)!
                                userAppend.longitude = Double(exactly: longitude as! NSNumber)!
                                userAppend.firstname = String(describing: firstname)
                                userAppend.lastname = String(describing: lastname)
                                userAppend.birthday = String(describing: birthday)
                                userAppend.gender = String(describing: gender)
                                userAppend.choosenGender = String(describing: genderChoosen)
                                userAppend.city = String(describing: city)
                                userAppend.imageUrl = String(describing: imageUrl)
                                userAppend.audioUrl = String(describing: audioUrl)
                                userAppend.deviceID = String(describing: deviceID)
                                userAppend.userUid = String(describing: userID)
                                
                                if self.user.count != snapshot.childrenCount{
                                    self.user.append(userAppend)
                                }
                            }else if self.chooseGender == "Both" && !self.whenLikedUserExist{
                                userAppend.latitude = Double(exactly: latitude as! NSNumber)!
                                userAppend.longitude = Double(exactly: longitude as! NSNumber)!
                                userAppend.firstname = String(describing: firstname)
                                userAppend.lastname = String(describing: lastname)
                                userAppend.birthday = String(describing: birthday)
                                userAppend.gender = String(describing: gender)
                                userAppend.choosenGender = String(describing: genderChoosen)
                                userAppend.city = String(describing: city)
                                userAppend.imageUrl = String(describing: imageUrl)
                                userAppend.audioUrl = String(describing: audioUrl)
                                userAppend.deviceID = String(describing: deviceID)
                                userAppend.userUid = String(describing: userID)
                                
                                if self.user.count != snapshot.childrenCount{
                                    self.user.append(userAppend)
                                }
                            }
                            self.whenLikedUserExist = false
                        }
                    }
                }
                
                if(self.user.count > 0){
                    self.customizeViewWithUser(user: self.user)
                }
                else{
                    if(UIApplication.shared.isIgnoringInteractionEvents)
                    {
                        UIApplication.shared.endIgnoringInteractionEvents()
                        self.activityIndicator.stopAnimating()
                        self.indicatorBackground.isHidden = true
                    }
                }
            }
        }
    }
    
    func detectWhichIphone(){
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                detectSizes.logoutY = 0
                detectSizes.navTitleY = 0
                detectSizes.updateY = 0
                detectSizes.userImg = 40
                detectSizes.userInfo = 30
                detectSizes.playerBtn = 30
                detectSizes.likeBtn = -60
                detectSizes.dontLikeBtn = -60
                detectSizes.sideMenuY = 34
                detectSizes.block = 7
                detectSizes.player = 5
                
            case 1334:
                print("iPhone 6/6S/7/8")
                detectSizes.logoutY = 0
                detectSizes.navTitleY = 0
                detectSizes.updateY = 0
                detectSizes.userImg = 50
                detectSizes.userInfo = 50
                detectSizes.playerBtn = 50
                detectSizes.likeBtn = -60
                detectSizes.dontLikeBtn = -60
                detectSizes.sideMenuY = 30
                detectSizes.block = 12
                detectSizes.player = 5
                
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                detectSizes.logoutY = 0
                detectSizes.navTitleY = 0
                detectSizes.updateY = 0
                detectSizes.userImg = 50
                detectSizes.userInfo = 50
                detectSizes.playerBtn = 50
                detectSizes.likeBtn = -70
                detectSizes.dontLikeBtn = -70
                detectSizes.sideMenuY = 30
                detectSizes.block = 20
                detectSizes.player = 5
                
            case 2436:
                print("iPhone X, XS")
                detectSizes.logoutY = 50
                detectSizes.navTitleY = 50
                detectSizes.updateY = 50
                detectSizes.userImg = 150
                detectSizes.userInfo = 50
                detectSizes.playerBtn = 50
                detectSizes.likeBtn = -120
                detectSizes.dontLikeBtn = -120
                detectSizes.sideMenuY = 80
                detectSizes.block = 15
                detectSizes.player = 5
                
            case 2688:
                print("iPhone XS Max")
                detectSizes.logoutY = 50
                detectSizes.navTitleY = 50
                detectSizes.updateY = 50
                detectSizes.userImg = 150
                detectSizes.userInfo = 50
                detectSizes.playerBtn = 50
                detectSizes.likeBtn = -120
                detectSizes.dontLikeBtn = -120
                detectSizes.sideMenuY = 80
                detectSizes.block = 35
                detectSizes.player = 25
                
            case 1792:
                print("iPhone XR")
                detectSizes.logoutY = 50
                detectSizes.navTitleY = 50
                detectSizes.updateY = 48
                detectSizes.userImg = 170
                detectSizes.userInfo = 50
                detectSizes.playerBtn = 30
                detectSizes.likeBtn = -120
                detectSizes.dontLikeBtn = -120
                detectSizes.sideMenuY = 80
                detectSizes.block = 35
                detectSizes.player = 25
                
            default:
                print("Unknown")
            }
        }
    }
    
//    fileprivate func setUpPushNotifications(fromDeviceID: String){
//        let message = "Begin to talk with your match."
//        let title = "It's a match!"
//        let toDeviceID = fromDeviceID
//        var headers:HTTPHeaders = HTTPHeaders()
//
//        headers = ["Content-Type":"application/json","Authorization":"key=\(AppDelegate.SERVER_KEY)"]
//
//        let notifications = ["to" : "\(toDeviceID)" , "notification":["body":message,"title":title,"badge":1,"sound":"default"]] as [String : Any]
//
//        request(AppDelegate.NOTIFICATION_KEY as URLConvertible, method: .post as HTTPMethod, parameters: notifications, encoding: JSONEncoding.default, headers: headers).response { (response) in
//            print(response)
//        }
//    }
}

extension UIView {
    func setGradientBackground(sender: UIView, colorOne: CGColor, colorTwo: CGColor){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorOne, colorTwo]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.locations = [0.2, 1.0]
        gradientLayer.frame = bounds
        sender.layer.addSublayer(gradientLayer)
    }
    
    func setGradientBackgroundForSideMenu(sender: UIView, colorOne: CGColor, colorTwo: CGColor, width: CGFloat, height: CGFloat){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorOne, colorTwo]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.locations = [0.2, 1.0]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        gradientLayer.cornerRadius = 15
        sender.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setGradientBackgroundForButton(sender: UIView, colorOne: CGColor, colorTwo: CGColor, width: CGFloat, height: CGFloat){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorOne, colorTwo]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.locations = [0.0, 0.85]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        gradientLayer.cornerRadius = 15
        sender.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setGradientBackgroundForChatView(sender: UIView, colorOne: CGColor, colorTwo: CGColor, width: CGFloat, height: CGFloat){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorOne, colorTwo]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.locations = [0.2, 1.0]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        sender.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}
