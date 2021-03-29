//
//  ChatViewController.swift
//  Casen
//
//  Created by Ebu Bekir Celik on 10.06.19.
//  Copyright © 2019 KeepEasy. All rights reserved.
//

//AdMob APP-ID: ca-app-pub-9878976878500940~6778650902
//AdMob UNIT-ID: ca-app-pub-9878976878500940/2013409384

import UIKit
import AVFoundation
import Firebase
import Alamofire
import GoogleMobileAds

class ChatViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    var cellID = "cellID"
    var navTitle = UINavigationBar()
    var userImage = UIImageView()
    var bottomTitle = UIView()
    var navTitleUsername: UILabel!
    let backButton = UIButton(type: .custom)
    let screenSize = UIScreen.main.bounds
    let sendButton = UIButton(type: .custom)
    static let finalUserUid = Auth.auth().currentUser?.uid
    static var userOppositeID = String()
    var fetchAllUser = [Userchat]()
    var sortedUserVoice = [Userchat]()
    var checkIfOutOfRange = Array<Any>()
    var selectedIndex = Int()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let indicatorBackground = UIView()
    let refreshControl = UIRefreshControl()
    let dateFormatter = DateFormatter()
    var date = Date()
    var cellAudioStop = IndexPath()
    var userName = String()
    var deviceIDsend = String()
    var tapGestureRecognizer = UITapGestureRecognizer()
    var popUpImageURL = String()
    var myImageURL = String()
    var refreshTimer: Timer!
    var badgeValue = Int()
    var saveOnceBadgeValue = false
    static var maxSendedMessage = 3
    
    //Sprachaufnahme Code
    let recordButton = UIButton(type: .custom)
    let playerButton = UIButton(type: .custom)
    var soundPlayer: AVAudioPlayer!
    var soundRecorder: AVAudioRecorder!
    var recordingSession: AVAudioSession!
    var audioSession: AVAudioSession!
    var filename = "audioVoiceFile.m4a"
    var counter = Int()
    var voiceCounter = Int()
    var timer: Timer!
    static var sendenMessagesCounter = Int()
    
    //audioSliderTimer
    var sliderTimer: Timer!
    
    //stream Audio
    var playerItem: AVPlayerItem!
    var player: AVPlayer!
    var destinationUrl: URL!
    
    let onlineBtn: UIButton = {
        let online = UIButton()
        online.translatesAutoresizingMaskIntoConstraints = false
        online.clipsToBounds = true
        online.layer.cornerRadius = 6
        online.isHidden = true
        online.backgroundColor = UIColor(red: 0/255, green: 204/255, blue: 0/255, alpha: 1)
        online.isUserInteractionEnabled = false
        return online
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)//UIColor(red: 191/255, green: 239/255, blue: 255/255, alpha: 1)
        view.setGradientBackgroundForChatView(sender: view, colorOne: UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1).cgColor, colorTwo: UIColor.white.cgColor, width: self.screenSize.width, height: 100)
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.alwaysBounceVertical = true
        collectionView.frame = CGRect(x: 0, y: 70, width: screenSize.width, height: screenSize.height-(100 + 70))
        collectionView.backgroundColor = UIColor.white
        
        //to make Profile Image bigger if on touch
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageBigger(tap:)))
        
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .left
        
        view.addGestureRecognizer(edgePan)
        
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "LoadingChatKey".localizableString(loc: ViewController.LANGUAGE))
        
        recordingSession = AVAudioSession.sharedInstance()
        do{
            try recordingSession.setCategory(.playAndRecord) //ZU WICHTIG
            try recordingSession.overrideOutputAudioPort(.speaker)
        }catch{
            print(error)
        }
        
        audioSession = AVAudioSession.sharedInstance()
        do{
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord)
            try audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            try audioSession.setActive(true)
        }catch{
            print(error)
        }
        
        indicBackground()
        
        setupRecorder()
        
        downloadSendedMessages()
        
        refreshData()
        
        _ = refreshOnce
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        IAPService.shared.getProducts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.downloadSendedMessages()
        
        //Wenn ich in meinen Chat gehe dann BadgeValue zurücksetzen
        var ref: DatabaseReference
        ref = Database.database().reference()
        ref.child("Chats").child(ChatViewController.finalUserUid!).child(ChatViewController.userOppositeID).child("badgeValue").updateChildValues(["value" : 0])
    }
    
    @objc func refreshData(){
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                
                if(self.refreshControl.isRefreshing){
                    
                    if(self.soundPlayer != nil){
                        if(self.soundPlayer.isPlaying){
                            self.soundPlayer.stop()
                        }
                    }
                    self.refreshControl.endRefreshing()
                }
                
                let item = self.collectionView(self.collectionView!, numberOfItemsInSection: 0) - 1
                let lastItemIndex = NSIndexPath(item: item, section: 0)
                self.collectionView?.scrollToItem(at: lastItemIndex as IndexPath, at: .top, animated: true)
            }
        }
    }
   
    @objc func imageBigger(tap: UITapGestureRecognizer){
        UIButton.animate(withDuration: 0.5, animations: {
            self.userImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { (finish) in
            self.userImage.transform = CGAffineTransform.identity
            
            let popUpImage = PopUpUserImageViewController()
            popUpImage.createImagePopUp(image: self.popUpImageURL)
            popUpImage.modalPresentationStyle = .overCurrentContext
            popUpImage.modalTransitionStyle = .crossDissolve
            self.present(popUpImage, animated: true, completion: nil)
        }
    }
    
    func indicBackground(){
        indicatorBackground.frame = CGRect(x: 0, y: 0, width: 85, height: 85)
        indicatorBackground.center = view.center
        indicatorBackground.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        indicatorBackground.layer.cornerRadius = 10
        indicatorBackground.isHidden = true
        self.view.addSubview(indicatorBackground)
    }
    
    func titleBar(username: String, imageURL: String, userID: String){
        ChatViewController.userOppositeID = userID
        popUpImageURL = imageURL
        
        var ref: DatabaseReference
        ref = Database.database().reference()
        
        //download my own image
        ref.child("User").child(ChatViewController.finalUserUid!).child("image").observe(.value) { (imagesnapshot) in
            if let value = imagesnapshot.value as? String{
                self.myImageURL = value
            }
        }
        
        navTitle = UINavigationBar(frame: CGRect(x: 0, y: 35, width: self.view.frame.size.width, height: 35))
        navTitle.setBackgroundImage(UIImage(), for: .default)
        navTitle.shadowImage = UIImage()
        navTitle.isTranslucent = true
        navTitle.backgroundColor = .clear
        
        view.addSubview(navTitle)
        
        navTitleUsername = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: 35))
        navTitleUsername.translatesAutoresizingMaskIntoConstraints = false
        navTitleUsername.clipsToBounds = true
        navTitleUsername.isUserInteractionEnabled = false
        navTitleUsername.font = UIFont(name: "Avenir-Black", size: 20)
        navTitleUsername.text = username
        navTitleUsername.textColor = UIColor.black
        navTitleUsername.sizeToFit()
        navTitle.addSubview(navTitleUsername)
        navTitleUsername.centerXAnchor.constraint(equalTo: navTitle.centerXAnchor).isActive = true
        navTitleUsername.centerYAnchor.constraint(equalTo: navTitle.centerYAnchor).isActive = true
        
        userImage.translatesAutoresizingMaskIntoConstraints = false
        userImage.clipsToBounds = true
        userImage.isUserInteractionEnabled = true
        userImage.addGestureRecognizer(tapGestureRecognizer)
        userImage.layer.cornerRadius = 16.50
        userImage.loadImageUsingCacheWithURLString(urlImg: imageURL)
        navTitle.addSubview(userImage)
        userImage.rightAnchor.constraint(equalTo: navTitle.rightAnchor, constant: -10).isActive = true
        userImage.topAnchor.constraint(equalTo: navTitle.topAnchor).isActive = true
        userImage.widthAnchor.constraint(equalToConstant: 32.5).isActive = true
        userImage.heightAnchor.constraint(equalToConstant: 32.5).isActive = true
        
        backButton.setImage(UIImage(named: "backToView"), for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.clipsToBounds = true
        backButton.contentMode = .scaleAspectFill
        backButton.addTarget(self, action: #selector(backToMatchesView), for: .touchUpInside)
        navTitle.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: navTitle.leftAnchor).isActive = true
        backButton.topAnchor.constraint(equalTo: navTitle.topAnchor).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 32.5).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 32.5).isActive = true
        
        navTitle.addSubview(onlineBtn)
        onlineBtn.centerYAnchor.constraint(equalTo: navTitleUsername.centerYAnchor, constant: 0).isActive = true
        onlineBtn.leftAnchor.constraint(equalTo: navTitleUsername.rightAnchor, constant: 5).isActive = true
        onlineBtn.heightAnchor.constraint(equalToConstant: 12).isActive = true
        onlineBtn.widthAnchor.constraint(equalToConstant: 12).isActive = true
        
        bottomTitle = UIView()
        bottomTitle.setGradientBackgroundForChatView(sender: bottomTitle, colorOne: UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1).cgColor, colorTwo: UIColor.white.cgColor, width: self.screenSize.width, height: 100)
        bottomTitle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomTitle)
        bottomTitle.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomTitle.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomTitle.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        bottomTitle.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
        sendButton.setImage(UIImage(named: "paper_plane")?.withRenderingMode(.alwaysTemplate), for: .normal)
        sendButton.tintColor = UIColor.white
        sendButton.isHidden = true
        sendButton.layer.cornerRadius = 27
        sendButton.addTarget(self, action: #selector(sendVoiceMail), for: .touchUpInside)
        bottomTitle.addSubview(sendButton)
        sendButton.centerXAnchor.constraint(equalTo: bottomTitle.centerXAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: bottomTitle.centerYAnchor, constant: -15).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 55).isActive = true
        
        playerButton.translatesAutoresizingMaskIntoConstraints = false
        playerButton.backgroundColor = .white
        playerButton.tintColor = UIColor.black
        playerButton.layer.cornerRadius = 27
        playerButton.setImage(UIImage(named: "play")?.withRenderingMode(.alwaysOriginal), for: .normal)
        playerButton.addTarget(self, action: #selector(playAct), for: .touchUpInside)
        playerButton.isEnabled = false
        playerButton.isHidden = true
        bottomTitle.addSubview(playerButton)
        playerButton.centerXAnchor.constraint(equalTo: bottomTitle.centerXAnchor).isActive = true
        playerButton.centerYAnchor.constraint(equalTo: bottomTitle.centerYAnchor, constant: -15).isActive = true
        playerButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        playerButton.widthAnchor.constraint(equalToConstant: 55).isActive = true
        
        recordButton.setImage(UIImage(named: "record")?.withRenderingMode(.alwaysOriginal), for: .normal)
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        recordButton.backgroundColor = .white
        recordButton.tintColor = UIColor.black
        recordButton.layer.cornerRadius = 27
        recordButton.addTarget(self, action: #selector(recordAct), for: .touchDown)
        recordButton.addTarget(self, action: #selector(stopRecordAct), for: [.touchUpInside, .touchUpOutside])
        bottomTitle.addSubview(recordButton)
        recordButton.centerXAnchor.constraint(equalTo: bottomTitle.centerXAnchor).isActive = true
        recordButton.centerYAnchor.constraint(equalTo: bottomTitle.centerYAnchor, constant: -15).isActive = true
        recordButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        recordButton.widthAnchor.constraint(equalToConstant: 55).isActive = true
        
        dateFormatter.timeZone = TimeZone(abbreviation: "CET") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MMM d" + ",  " + "HH:mm"//"HH:mm" //Specify your format that you want
    }
    
    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer){
        if recognizer.state == .recognized {
            if(soundPlayer != nil)
            {
                playerButton.layer.borderWidth = 0
                playerButton.setImage(UIImage(named: "play")?.withRenderingMode(.alwaysOriginal), for: .normal)
                soundPlayer.stop()
            }
            
            if(soundRecorder != nil){
                recordButton.layer.borderWidth = 0
                recordButton.setImage(UIImage(named: "record")?.withRenderingMode(.alwaysOriginal), for: .normal)
                soundRecorder.stop()
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func sendVoiceMail(){
        UIButton.animate(withDuration: 0.3, animations: {
            self.sendButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (finish) in
            UIButton.animate(withDuration: 0.3, animations: {
                self.sendButton.transform = CGAffineTransform.identity
            })
            
            UIButton.animate(withDuration: 1.5, animations: {
                self.sendButton.isHidden = true
                self.recordButton.transform = CGAffineTransform(translationX: 0, y: 0)
                self.playerButton.transform = CGAffineTransform(translationX: 0, y: 0)
            }) { (finish) in
                self.playerButton.isHidden = true
            }
        }
        
        if ChatViewController.sendenMessagesCounter < ChatViewController.maxSendedMessage{
            var ref: DatabaseReference
            ref = Database.database().reference()
            var audioURL = String()
            let audio = getCacheDirectory().appendingPathComponent(filename)
            let profileAudioUnique = NSUUID().uuidString
            let storage = Storage.storage().reference().child(profileAudioUnique + ".m4a")
            
            //UPLOAD AUDIO FILE INTO DATABASE
            storage.putFile(from: audio, metadata: nil) { (metadata, error) in
                if error != nil{
                    print(error as Any)
                    return
                }
                
                storage.downloadURL(completion: { (url, error) in
                    if error != nil{
                        print(error as Any)
                        return
                    }
                    
                    audioURL = (url?.absoluteString)!
                    
                    if(audioURL != "")
                    {
                        let expenseRef = ref.child("Chats").child(ChatViewController.finalUserUid!).child(ChatViewController.userOppositeID).child("messages").childByAutoId()
                        let dict = ["Audiovoice" : audioURL, "Timestamp" : NSDate().timeIntervalSince1970, "userUid" : ChatViewController.finalUserUid!] as [String : Any]
                        expenseRef.setValue(dict)
                        
                        ChatViewController.sendenMessagesCounter += 1
                        
                        ref.child("Chats").child(ChatViewController.finalUserUid!).child(ChatViewController.userOppositeID).child("sendCounter").setValue(ChatViewController.sendenMessagesCounter)
                        
                        ///Anzahl der Nachrichten
                        ref.child("Chats").child(ChatViewController.userOppositeID).child(ChatViewController.finalUserUid!).child("badgeValue").child("value").observe(.value, with: { (badgeValueShot) in
                            
                            if !badgeValueShot.exists(){
                                ref.child("Chats").child(ChatViewController.userOppositeID).child(ChatViewController.finalUserUid!).child("badgeValue").updateChildValues(["value" : 0])
                            }
                            
                            if let value = badgeValueShot.value as? Int{
                                if !self.saveOnceBadgeValue{
                                    self.badgeValue = value
                                    self.badgeValue += 1
                                    ref.child("Chats").child(ChatViewController.userOppositeID).child(ChatViewController.finalUserUid!).child("badgeValue").updateChildValues(["value" : self.badgeValue])
                                    self.saveOnceBadgeValue = true
                                }
                            }
                        })
                        
                        let sender = PushNotifications()
                        sender.sendPushNotification(to: self.deviceIDsend, title: "VoiceKey".localizableString(loc: ViewController.LANGUAGE), body: self.userName + "SentKey".localizableString(loc: ViewController.LANGUAGE))
                        
                        self.fetchAllUser.removeAll()
                        self.sortedUserVoice.removeAll()
                        self.saveOnceBadgeValue = false
                        
                        self.refreshData()
                    }
                })
            }
        }else{
            let popUpNoLike = PopUpUserImageViewController()
            popUpNoLike.detectWhichIphone()
            popUpNoLike.createNoLikesPopUp()
            popUpNoLike.detectIfTimeOrRelike(set: true)
            popUpNoLike.changeMoreLikesTitle(title: "MessageKey".localizableString(loc: ViewController.LANGUAGE))
            popUpNoLike.changeMoreLikesMainText(txt: "MessWatchKey".localizableString(loc: ViewController.LANGUAGE))
            popUpNoLike.changeMoreLikesImage(image: (UIImage(named: "notlovebig")?.withRenderingMode(.alwaysOriginal))!)
            popUpNoLike.videoButton.setTitle("VideoKey".localizableString(loc: ViewController.LANGUAGE), for: .normal)
            popUpNoLike.modalPresentationStyle = .overCurrentContext
            popUpNoLike.modalTransitionStyle = .crossDissolve
            self.present(popUpNoLike, animated: true, completion: nil)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fetchAllUser.count
    }
    
    func playVoice(cell: ChatMessageCell){
        let iconImage = UIImage(named: "play")?.withRenderingMode(.alwaysOriginal)
        
        if cell.playerbtn.currentImage == iconImage{
            self.playerItem = AVPlayerItem(url: self.destinationUrl)
            self.player = AVPlayer(playerItem: self.playerItem)
            cell.setCellImage(playerBtnImage: UIImage(named: "pause")!)
            self.player.play()
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItem)
            cell.audioSlider.maximumValue = Float(CMTimeGetSeconds(self.player.currentItem!.asset.duration))
            self.sliderTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)
        }
        else{
            self.player.pause()
            
            if sliderTimer != nil{
                sliderTimer.invalidate()
            }
            cell.setCellImage(playerBtnImage: UIImage(named: "play")!)
        }
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        if sliderTimer != nil{
            sliderTimer.invalidate()
        }
        
        guard let cell = collectionView.cellForItem(at: cellAudioStop) else { return }
        
        let cellStop = cell as! ChatMessageCell
        
        cellStop.setCellImage(playerBtnImage: UIImage(named: "play")!)
        cellStop.audioSlider.value = 0
        NotificationCenter.default.removeObserver(self.playerItem)
    }
    
    @objc func updateSlider(){
        guard let cell = collectionView.cellForItem(at: cellAudioStop) else { return }
        
        let cellStop = cell as! ChatMessageCell

        cellStop.audioSlider.value = Float(CMTimeGetSeconds(self.player.currentTime()))
    }
    
    //Weil im Chat manche Profilbilder nicht richtig geladen werden.
    private lazy var refreshOnce: Void = {
        self.refreshTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(refreshOneTime), userInfo: nil, repeats: false)
    }()
    
    @objc func refreshOneTime(){
        self.refreshData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenSize.width, height: 85)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ChatMessageCell
        
        if checkIfOutOfRange.getElement(at: indexPath.row) != nil{
            if(self.sortedUserVoice.count > 0){
                if(self.sortedUserVoice[indexPath.row].userUid == ChatViewController.finalUserUid){
                    cell.audioPlayerSliderView.backgroundColor = UIColor(red: 217/255, green: 219/255, blue: 220/255, alpha: 0.5)
                    cell.audioSlider.minimumTrackTintColor = UIColor(red: 217/255, green: 219/255, blue: 220/255, alpha: 0.5)//UIColor(red: 191/255, green: 239/255, blue: 255/255, alpha: 1)
                    cell.audioSliderLeftAnchor?.isActive = true
                    cell.audioSliderRightAnchor?.isActive = false
                    cell.userImagesRightAnchor?.isActive = false
                    cell.userImagesLeftAnchor?.isActive = true
                    cell.userImages.loadImageUsingCacheWithURLString(urlImg: self.myImageURL)
                    cell.playerbtn.setImage(UIImage(named: "play")?.withRenderingMode(.alwaysOriginal), for: .normal)
                    date = Date(timeIntervalSince1970: TimeInterval(self.sortedUserVoice[indexPath.row].timestamp!))
                    cell.sendedTime.text = dateFormatter.string(from: date)
                }else if(self.sortedUserVoice[indexPath.row].userUid == ChatViewController.userOppositeID){
                    cell.audioPlayerSliderView.backgroundColor = UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1)//UIColor(red: 191/255, green: 239/255, blue: 255/255, alpha: 1)
                    cell.audioSlider.minimumTrackTintColor = UIColor(red: 217/255, green: 219/255, blue: 220/255, alpha: 0.5)
                    cell.audioSliderLeftAnchor?.isActive = false
                    cell.audioSliderRightAnchor?.isActive = true
                    cell.userImagesRightAnchor?.isActive = true
                    cell.userImagesLeftAnchor?.isActive = false
                    cell.userImages.loadImageUsingCacheWithURLString(urlImg: self.popUpImageURL)
                    cell.playerbtn.setImage(UIImage(named: "play")?.withRenderingMode(.alwaysOriginal), for: .normal)
                    date = Date(timeIntervalSince1970: TimeInterval(self.sortedUserVoice[indexPath.row].timestamp!))
                    cell.sendedTime.text = dateFormatter.string(from: date)
                }
            }
        }else{
            self.downloadSendedMessages()
        }
        
        cell.playerAudioBtnTapAction = { () in
            //Wenn eine AudioVoice angehört wird und gleichzeitig eine andere abgespielt wird soll die vorherige gestoppt und zurückgesetzt werden.
            if self.player != nil{
                if(self.player.isPlaying){
                    self.sliderTimer.invalidate()
                    self.player.pause()
                    NotificationCenter.default.removeObserver(self.playerItem)
                    
                    guard let cell = collectionView.cellForItem(at: self.cellAudioStop) else { return }
                    
                    let cellStop = cell as! ChatMessageCell
                    
                    if(self.sortedUserVoice[self.selectedIndex].userUid == ChatViewController.finalUserUid){
                        cellStop.audioPlayerSliderView.backgroundColor = UIColor(red: 217/255, green: 219/255, blue: 220/255, alpha: 0.5)
                    }else{
                        cellStop.audioPlayerSliderView.backgroundColor = UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1)
                    }
                    
                    cellStop.setCellImage(playerBtnImage: UIImage(named: "play")!)
                    cellStop.audioSlider.value = 0
                    
                    return
                }
                
            }
            
            self.selectedIndex = indexPath.row
            self.cellAudioStop = indexPath
            
            if let audioUrl = URL(string: self.sortedUserVoice[indexPath.row].audiovoice!){
                self.destinationUrl = audioUrl
                self.playVoice(cell: cell)
            }
        }
        return cell
    }
    
    var audiovoice = String()
    var timestamp = NSNumber()
    var userUid = String()
    
    func downloadSendedMessages(){
        var ref: DatabaseReference
        ref = Database.database().reference()
        
        self.fetchAllUser.removeAll()
        self.sortedUserVoice.removeAll()
        
        ref.child("User").child(ChatViewController.finalUserUid!).child("firstname").observe(.value, with: { (snapshot) in
            if let value = snapshot.value as? String{
                self.userName = value
            }
        })
        
        ref.child("User").child(ChatViewController.userOppositeID).child("deviceID").observe(.value, with: { (snapshot) in
            if let value = snapshot.value as? String{
                self.deviceIDsend = value
            }
        })
        
        ref.child("User").child(ChatViewController.userOppositeID).child("Online").observeSingleEvent(of: .value) { (online) in
            if online.exists(){
                if let value = online.value as? Bool{
                    if value{
                        self.onlineBtn.isHidden = false
                    }else{
                        self.onlineBtn.isHidden = true
                    }
                }
            }
        }
        
        ref.child("Chats").child(ChatViewController.finalUserUid!).child(ChatViewController.userOppositeID).child("buyCompleted").observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                if let value = snapshot.value as? Int{
                    ChatViewController.maxSendedMessage = value
                }
            }
        }
        
        //Get send Messages Counter
        ref.child("Chats").child(ChatViewController.finalUserUid!).child(ChatViewController.userOppositeID).child("sendCounter").observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists(){
                if let value = snapshot.value as? Int{
                    ChatViewController.sendenMessagesCounter = value
                }
            }
        }
        
        ref.child("Chats").child(ChatViewController.finalUserUid!).child(ChatViewController.userOppositeID).child("messages").observe(.value) { (snapshot) in
            self.fetchAllUser.removeAll()
            self.sortedUserVoice.removeAll()
            
            guard snapshot.exists() else{
                
                ref.child("Chats").child(ChatViewController.userOppositeID).child(ChatViewController.finalUserUid!).child("messages").observe(.value) { (shot) in
                    guard shot.exists() else{
                        return
                    }
                    
                    self.fetchAllUser.removeAll()
                    self.sortedUserVoice.removeAll()
                    
                    let allUserIn = shot.children.allObjects as! [DataSnapshot]
                    
                    for allUser in allUserIn{
                        let userAll = Userchat()
                        
                        guard let allUserData = allUser.value as? [String : AnyObject] else{
                            return
                        }
                        if let audiovoice = allUserData["Audiovoice"]{
                            self.audiovoice = audiovoice as! String
                        }
                        if let timestamp = allUserData["Timestamp"]{
                            self.timestamp = timestamp as! NSNumber
                        }
                        if let userUid = allUserData["userUid"]{
                            self.userUid = userUid as! String
                        }
                        
                        userAll.audiovoice = self.audiovoice
                        userAll.timestamp = Double(exactly: self.timestamp)
                        userAll.userUid = self.userUid
                        
                        if(userAll.audiovoice != nil && userAll.timestamp != nil){
                            self.fetchAllUser.append(userAll)
                        }
                        
                        if(self.fetchAllUser.count == shot.childrenCount){
                            
                            self.sortChat(allUserAudios: self.fetchAllUser)
                            
                            self.refreshData()
                        }
                    }
                }
                return
            }
            
            let allUserIn = snapshot.children.allObjects as! [DataSnapshot]
            
            for allUser in allUserIn{
                let userAll = Userchat()
        
                guard let allUserData = allUser.value as? [String : AnyObject] else{
                    return
                }
                if let audiovoice = allUserData["Audiovoice"]{
                    self.audiovoice = audiovoice as! String
                }
                if let timestamp = allUserData["Timestamp"]{
                    self.timestamp = timestamp as! NSNumber
                }
                if let userUid = allUserData["userUid"]{
                    self.userUid = userUid as! String
                }
                
                userAll.audiovoice = self.audiovoice
                userAll.timestamp = Double(exactly: self.timestamp)
                userAll.userUid = self.userUid
                
                if(userAll.audiovoice != nil && userAll.timestamp != nil){
                    self.fetchAllUser.append(userAll)
                }
                
                if(self.fetchAllUser.count == snapshot.childrenCount){
                    ref.child("Chats").child(ChatViewController.userOppositeID).child(ChatViewController.finalUserUid!).child("messages").observe(.value) { (snap) in
                        guard snap.exists() else{
                            self.sortChat(allUserAudios: self.fetchAllUser)
                            
                            self.refreshData()
                            return
                        }
                        
                        let allUserIn = snap.children.allObjects as! [DataSnapshot]
                        
                        for allUser in allUserIn{
                            let userAll = Userchat()
                            
                            guard let allUserData = allUser.value as? [String : AnyObject] else{
                                return
                            }
                            if let audiovoice = allUserData["Audiovoice"]{
                                self.audiovoice = audiovoice as! String
                            }
                            if let timestamp = allUserData["Timestamp"]{
                                self.timestamp = timestamp as! NSNumber
                            }
                            if let userUid = allUserData["userUid"]{
                                self.userUid = userUid as! String
                            }
                            
                            userAll.audiovoice = self.audiovoice
                            userAll.timestamp = Double(exactly: self.timestamp)
                            userAll.userUid = self.userUid
                            
                            if(userAll.audiovoice != nil && userAll.timestamp != nil){
                                self.fetchAllUser.append(userAll)
                            }
                            
                            if(self.fetchAllUser.count == (snap.childrenCount + snapshot.childrenCount)){
                                
                                self.sortChat(allUserAudios: self.fetchAllUser)
                                
                                self.refreshData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func sortChat(allUserAudios: [Userchat]){
        sortedUserVoice = allUserAudios.sorted(by: {$0.timestamp! < $1.timestamp!})
        checkIfOutOfRange = sortedUserVoice
    }
    
    func setupRecorder(){
        let audioFileName = getCacheDirectory().appendingPathComponent(filename)
        
        let recordingSettings = [AVFormatIDKey : kAudioFormatAppleLossless,
                                 AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
                                 AVEncoderBitRateKey : 320000,
                                 AVNumberOfChannelsKey : 2,
                                 AVSampleRateKey : 44100.0] as [String : Any]
        
        do {
            soundRecorder = try AVAudioRecorder(url: audioFileName, settings: recordingSettings)
            soundRecorder.delegate = self
            soundRecorder.prepareToRecord()
        }catch{
            print(error)
        }
    }
    
    func setupPlayer(){
        let audioFileName = getCacheDirectory().appendingPathComponent(filename)
        
        do{
            soundPlayer = try AVAudioPlayer(contentsOf: audioFileName)
            soundPlayer.delegate = self
            soundPlayer.volume = 5.0
            soundPlayer.prepareToPlay()
        }catch{
            print(error)
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        playerButton.isEnabled = true
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordButton.isEnabled = true
        sendButton.isEnabled = true
        playerButton.setImage(UIImage(named: "play")?.withRenderingMode(.alwaysOriginal), for: .normal)
        playerButton.layer.borderWidth = 0
    }
    
    func getCacheDirectory() ->URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
    
    @objc func stopRecordAct(){
        if(timer != nil){
            timer.invalidate()
        }
        voiceCounter = counter
        counter = 0
        playerButton.isEnabled = true
        soundRecorder.stop()
        if recordButton.currentTitle != "00:00"{
            self.sendButton.isHidden = false
        }
        recordButton.layer.borderWidth = 0
        recordButton.setTitle(nil, for: .normal)
        recordButton.setImage(UIImage(named: "record")?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    @objc func recordAct(){
        UIButton.animate(withDuration: 1.5) {
            self.recordButton.transform = CGAffineTransform(translationX: -125, y: 0)
            self.playerButton.isHidden = false
            self.playerButton.transform = CGAffineTransform(translationX: 125, y: 0)
        }
        
        self.sendButton.isHidden = true
        
        let iconImage = UIImage(named: "record")?.withRenderingMode(.alwaysOriginal)
        
        if (recordButton.currentImage == iconImage){
            playerButton.isEnabled = false
            if !soundRecorder.isRecording {
                soundRecorder.record()
            }
            recordButton.setImage(nil, for: .normal)
            recordButton.setTitle("00:00", for: .normal)
            recordButton.setTitleColor(.red, for: .normal)
            recordButton.layer.borderColor = UIColor.red.cgColor
            recordButton.layer.borderWidth = CGFloat(1)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(handleTimeForRecord), userInfo: nil, repeats: true)
        }
        
        //WENN BEIDE BUTTONS GLEICHZEITIG GEDRÜCKT WERDEN
        if recordButton.isEnabled == false && playerButton.isEnabled == false{
            recordButton.isEnabled = true
            recordButton.setTitle(nil, for: .normal)
            soundRecorder.stop()
            recordButton.setImage(UIImage(named: "record")?.withRenderingMode(.alwaysOriginal), for: .normal)
            timer.invalidate()
        }
    }
    
    @objc func playAct(){
        let iconImage = UIImage(named: "play")?.withRenderingMode(.alwaysOriginal)
        
        if playerButton.currentImage == iconImage{
            recordButton.isEnabled = false
            playerButton.setImage(UIImage(named: "pause")?.withRenderingMode(.alwaysOriginal), for: .normal)
            playerButton.layer.borderColor = UIColor.red.cgColor
            playerButton.layer.borderWidth = CGFloat(1)
            sendButton.isEnabled = false
            
            if sliderTimer != nil{
                guard let cell = collectionView.cellForItem(at: cellAudioStop) else { return }
                
                let cellStop = cell as! ChatMessageCell
                
                cellStop.audioSlider.value = 0
                
                sliderTimer.invalidate()
            }
            
            setupPlayer()
            soundPlayer.play()
        }
        else{
            playerButton.layer.borderWidth = 0
            playerButton.setImage(UIImage(named: "play")?.withRenderingMode(.alwaysOriginal), for: .normal)
            recordButton.isEnabled = true
            sendButton.isEnabled = true
            if soundPlayer != nil{
                soundPlayer.stop()
            }
            
            if sliderTimer != nil{
                guard let cell = collectionView.cellForItem(at: cellAudioStop) else { return }
                
                let cellStop = cell as! ChatMessageCell
                
                cellStop.audioSlider.value = 0
                
                sliderTimer.invalidate()
            }
        }
        
        //WENN BEIDE BUTTONS GLEICHZEITIG GEDRÜCKT WERDEN
        if recordButton.isEnabled == false && playerButton.isEnabled == false{
            recordButton.isEnabled = true
            self.sendButton.isHidden = true
            recordButton.setTitle(nil, for: .normal)
            soundRecorder.stop()
            recordButton.setImage(UIImage(named: "record")?.withRenderingMode(.alwaysOriginal), for: .normal)
            if(timer != nil){
                timer.invalidate()
            }
        }
    }
    
    
    @objc func handleTimeForRecord(){
        if counter == 59{
            if(timer != nil){
                timer.invalidate()
            }
            self.sendButton.isHidden = false
            voiceCounter = counter
            counter = 0
            playerButton.isEnabled = true
            if soundRecorder != nil{
                soundRecorder.stop()
            }
            recordButton.setTitle(nil, for: .normal)
            recordButton.layer.borderWidth = 0
            recordButton.setImage(UIImage(named: "record")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        else{
            counter += 1
            if counter < 10{
                recordButton.setTitle("00:0" + String(counter), for: .normal)
            }
            else{
                recordButton.setTitle("00:" + String(counter), for: .normal)
            }
        }
    }
    
    @objc func backToMatchesView(){
        if(soundPlayer != nil)
        {
            playerButton.layer.borderWidth = 0
            playerButton.setImage(UIImage(named: "play")?.withRenderingMode(.alwaysOriginal), for: .normal)
            soundPlayer.stop()
        }
        
        if(soundRecorder != nil){
            recordButton.layer.borderWidth = 0
            recordButton.setImage(UIImage(named: "record")?.withRenderingMode(.alwaysOriginal), for: .normal)
            soundRecorder.stop()
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
//    fileprivate func setUpPushNotifications(fromDeviceID: String){
//        let message = self.userName + " has sent you a voice message."
//        let title = "New Message"
//        let toDeviceID = fromDeviceID
//        var headers:HTTPHeaders = HTTPHeaders()
//
//        headers = ["Content-Type":"application/json","Authorization":"key=\(AppDelegate.SERVER_KEY)"]
//
//        let notifications = ["to" : "\(toDeviceID)" , "notification":["body":message,"title":title,"badge":1,"sound":"default"]] as [String : Any]
//
//        request(AppDelegate.NOTIFICATION_KEY as URLConvertible, method: .post as HTTPMethod, parameters: notifications, encoding: JSONEncoding.default, headers: headers).response { (response) in
//            print(response.response?.statusCode)
//            if let httpStatus = response.response, httpStatus.statusCode != 200 {
//                print("statusCode should be 200, but is \(httpStatus.statusCode)")
//                print(response.response ?? "")
//            }
//        }
//    }
}

extension AVPlayer {
    var isPlaying: Bool {
        if (self.rate != 0 && self.error == nil) {
            return true
        } else {
            return false
        }
    }
}
