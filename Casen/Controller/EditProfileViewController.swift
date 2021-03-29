//
//  EditProfileViewController.swift
//  Casen
//
//  Created by Ebu Bekir Celik on 28.06.19.
//  Copyright © 2019 KeepEasy. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class EditProfileViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let navigation = UIView()
    var navTitle = UILabel()
    let detectSizes = IphoneSize()
    var update = UIButton()
    var back = UIButton()
    let screenSize = UIScreen.main.bounds
    var userImageUrl = String()
    var audioUrlVoice = String()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let indicatorBackground = UIView()
    var timer: Timer!
    var counter = Int()
    var voiceCounter = Int()
    var currentUserID = String()
    var audioURL = String()
    var audioRecorded = false
    var imagePicked = false
    
    //audioSliderTimer
    var sliderTimer: Timer!
    
    var soundPlayer: AVAudioPlayer!
    var soundRecorder: AVAudioRecorder!
    var recordingSession: AVAudioSession!
    var filename = "audioVoiceFile.m4a"
    
    let userImage: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.clipsToBounds = true
        img.layer.cornerRadius = 10
        img.layer.shadowColor = UIColor.gray.cgColor
        img.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        img.layer.shadowOpacity = 1.0
        img.layer.shadowRadius = 5.0
        img.layer.masksToBounds = false
        img.layer.cornerRadius = 10
        return img
    }()
    
    let plus: UIImageView = {
        let changeImg = UIImageView(image: UIImage(named: "plus")?.withRenderingMode(.alwaysTemplate))
        changeImg.translatesAutoresizingMaskIntoConstraints = false
        changeImg.clipsToBounds = true
        changeImg.tintColor = UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1)//UIColor(red: 191/255, green: 239/255, blue: 255/255, alpha: 1)
        return changeImg
    }()
    
    let recordButton: UIButton = {
        let record = UIButton()
        record.translatesAutoresizingMaskIntoConstraints = false
        record.backgroundColor = UIColor.white//UIColor(red: 191/255, green: 239/255, blue: 255/255, alpha: 1)
        record.layer.cornerRadius = 30
        record.layer.shadowColor = UIColor.gray.cgColor
        record.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        record.layer.shadowOpacity = 1.0
        record.layer.shadowRadius = 5.0
        record.layer.masksToBounds = false
        record.setImage(UIImage(named: "record")?.withRenderingMode(.alwaysTemplate), for: .normal)
        record.tintColor = UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1)
        record.addTarget(self, action: #selector(recordAct), for: .touchDown)
        record.addTarget(self, action: #selector(stopRecordAct), for: [.touchUpInside, .touchUpOutside])
        return record
    }()
    
    let playerButton: UIButton = {
        let player = UIButton()
        player.translatesAutoresizingMaskIntoConstraints = false
        player.backgroundColor = UIColor.white//UIColor(red: 191/255, green: 239/255, blue: 255/255, alpha: 1)
        player.layer.cornerRadius = 30
        player.layer.shadowColor = UIColor.gray.cgColor
        player.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        player.layer.shadowOpacity = 1.0
        player.layer.shadowRadius = 5.0
        player.layer.masksToBounds = false
        player.setImage(UIImage(named: "play")?.withRenderingMode(.alwaysTemplate), for: .normal)
        player.tintColor = UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1)
        player.addTarget(self, action: #selector(playAct), for: .touchUpInside)
        player.isEnabled = false
        return player
    }()
    
    let myCurrentVoice: UIButton = {
        let voice = UIButton()
        voice.translatesAutoresizingMaskIntoConstraints = false
        voice.backgroundColor = UIColor.clear
        voice.setImage(UIImage(named: "play")?.withRenderingMode(.alwaysOriginal), for: .normal)
        voice.addTarget(self, action: #selector(playOwnVoice), for: .touchUpInside)
        voice.isEnabled = false
        return voice
    }()
    
    let info: UILabel = {
        let infoAudio = UILabel()
        infoAudio.translatesAutoresizingMaskIntoConstraints = false
        infoAudio.text = "IntroNewKey".localizableString(loc: ViewController.LANGUAGE)
        return infoAudio
    }()
    
    let userSavedInfo: UILabel = {
        let info = UILabel()
        info.translatesAutoresizingMaskIntoConstraints = false
        info.textAlignment = NSTextAlignment.center
        info.text = "Saved"
        info.textColor = UIColor.white
        info.backgroundColor = UIColor.clear
        info.isHidden = true
        info.font = UIFont(name: "Avenir-Black", size: 20)
        return info
    }()
    
    let audioSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.clipsToBounds = true
        //slider.thumbTintColor = UIColor.black
        slider.minimumTrackTintColor = UIColor.white//UIColor(red: 217/255, green: 219/255, blue: 220/255, alpha: 0.5)//UIColor(red: 191/255, green: 239/255, blue: 255/255, alpha: 1)
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
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.setGradientBackground(sender: view, colorOne: UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1).cgColor, colorTwo: UIColor.white.cgColor)
        
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .left
        
        view.addGestureRecognizer(edgePan)
        
        recordingSession = AVAudioSession.sharedInstance()
        do{
            try recordingSession.setCategory(.playAndRecord) //ZU WICHTIG
            try recordingSession.overrideOutputAudioPort(.speaker)
        }catch{
            print(error)
        }
        
        indicBackground()
        
        setupRecorder()
        
        detectWhichIphone()
        
        navBar()
        
        addElements()
    }

    func indicBackground(){
        indicatorBackground.frame = CGRect(x: 0, y: 0, width: 85, height: 85)
        indicatorBackground.center = view.center
        indicatorBackground.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        indicatorBackground.layer.cornerRadius = 10
        indicatorBackground.isHidden = true
        self.view.addSubview(indicatorBackground)
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
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        myCurrentVoice.setImage(UIImage(named: "play")?.withRenderingMode(.alwaysOriginal), for: .normal)
        playerButton.layer.borderWidth = 0
        playerButton.setImage(UIImage(named: "play")?.withRenderingMode(.alwaysTemplate), for: .normal)
        recordButton.isEnabled = true
        myCurrentVoice.isEnabled = true
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if timer != nil{
            timer.invalidate()
        }
        audioRecorded = true
        playerButton.isEnabled = true
        myCurrentVoice.isEnabled = true
        soundRecorder.stop()
        recordButton.layer.borderWidth = 0
        recordButton.setTitle(nil, for: .normal)
        recordButton.setImage(UIImage(named: "record")?.withRenderingMode(.alwaysTemplate), for: .normal)
    }
    
    @objc func playOwnVoice(){
        let iconImage = UIImage(named: "play")?.withRenderingMode(.alwaysOriginal)
        
        if myCurrentVoice.currentImage == iconImage && soundPlayer != nil{
            myCurrentVoice.setImage(UIImage(named: "pause")?.withRenderingMode(.alwaysOriginal), for: .normal)
            recordButton.isEnabled = false
            playerButton.isEnabled = false
            self.downloadAudioVoice()
            audioSlider.maximumValue = Float(soundPlayer.duration)
            sliderTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
            soundPlayer.play()
        }else if soundPlayer != nil{
            myCurrentVoice.setImage(UIImage(named: "play")?.withRenderingMode(.alwaysOriginal), for: .normal)
            recordButton.isEnabled = true
            if(self.audioRecorded){
                playerButton.isEnabled = true
            }
            soundPlayer.stop()
            
            if sliderTimer != nil{
                sliderTimer.invalidate()
            }
        }
    }
    
    @objc func stopRecordAct(){
        UIButton.animate(withDuration: 0.2, animations: {
            self.recordButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { (finish) in
            UIButton.animate(withDuration: 0.2, animations: {
                self.recordButton.transform = CGAffineTransform.identity
            })
        }
        
        if timer != nil{
            timer.invalidate()
        }
        voiceCounter = counter
        counter = 0
        playerButton.isEnabled = true
        myCurrentVoice.isEnabled = true
        audioRecorded = true
        soundRecorder.stop()
        recordButton.layer.borderWidth = 0
        recordButton.setTitle(nil, for: .normal)
        recordButton.setImage(UIImage(named: "record")?.withRenderingMode(.alwaysTemplate), for: .normal)
    }
    
    @objc func recordAct(){
        UIButton.animate(withDuration: 0.2, animations: {
            self.recordButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { (finish) in
            UIButton.animate(withDuration: 0.2, animations: {
                self.recordButton.transform = CGAffineTransform.identity
            })
        }
        
        let iconImage = UIImage(named: "record")?.withRenderingMode(.alwaysTemplate)
        
        if (recordButton.currentImage == iconImage){
            playerButton.isEnabled = false
            myCurrentVoice.isEnabled = false
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
            recordButton.setImage(UIImage(named: "record")?.withRenderingMode(.alwaysTemplate), for: .normal)
            
            if timer != nil{
                timer.invalidate()
            }
            if sliderTimer != nil{
                sliderTimer.invalidate()
            }
        }
    }
    
    @objc func updateSlider(){
        audioSlider.value = Float(soundPlayer.currentTime)
    }
    
    @objc func playAct(){
        UIButton.animate(withDuration: 0.2, animations: {
            self.playerButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { (finish) in
            UIButton.animate(withDuration: 0.2, animations: {
                self.playerButton.transform = CGAffineTransform.identity
            })
        }
        
        let iconImage = UIImage(named: "play")?.withRenderingMode(.alwaysTemplate)
        
        if playerButton.currentImage == iconImage{
            recordButton.isEnabled = false
            myCurrentVoice.isEnabled = false
            playerButton.setImage(UIImage(named: "pause")?.withRenderingMode(.alwaysTemplate), for: .normal)
            playerButton.layer.borderColor = UIColor.red.cgColor
            playerButton.layer.borderWidth = CGFloat(1)
            setupPlayer(audioFileName: getCacheDirectory().appendingPathComponent(filename))
            soundPlayer.play()
            
            if sliderTimer != nil{
                sliderTimer.invalidate()
            }
            
            audioSlider.value = 0
        }
        else{
            playerButton.layer.borderWidth = 0
            playerButton.setImage(UIImage(named: "play")?.withRenderingMode(.alwaysTemplate), for: .normal)
            recordButton.isEnabled = true
            myCurrentVoice.isEnabled = true
            soundPlayer.stop()
        }
        
        //WENN BEIDE BUTTONS GLEICHZEITIG GEDRÜCKT WERDEN
        if recordButton.isEnabled == false && playerButton.isEnabled == false{
            recordButton.isEnabled = true
            myCurrentVoice.isEnabled = true
            recordButton.setTitle(nil, for: .normal)
            soundRecorder.stop()
            recordButton.setImage(UIImage(named: "record")?.withRenderingMode(.alwaysTemplate), for: .normal)
            
            if timer != nil{
                timer.invalidate()
            }
            if sliderTimer != nil{
                sliderTimer.invalidate()
            }
        }
    }
    
    func getCacheDirectory() ->URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
    
    @objc func handleTimeForRecord(){
        if counter == 15{
            timer.invalidate()
            voiceCounter = counter
            counter = 0
            myCurrentVoice.isEnabled = true
            playerButton.isEnabled = true
            soundRecorder.stop()
            recordButton.setTitle(nil, for: .normal)
            recordButton.layer.borderWidth = 0
            recordButton.setImage(UIImage(named: "record")?.withRenderingMode(.alwaysTemplate), for: .normal)
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
    
    @objc func pickImage(){
        UIButton.animate(withDuration: 0.2, animations: {
            self.plus.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { (finish) in
            self.plus.transform = CGAffineTransform.identity
            
            let picker = UIImagePickerController()
            
            picker.delegate = self
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            picker.modalTransitionStyle = .flipHorizontal
            
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImg = info[.editedImage] as? UIImage{
            selectedImageFromPicker = editedImg
        }else if let originalImg = info[.originalImage] as? UIImage{
            selectedImageFromPicker = originalImg
        }
        
        if let profileImg = selectedImageFromPicker{
            self.userImage.image = profileImg
            self.userImage.layer.cornerRadius = 10
            self.userImage.clipsToBounds = true
            self.userImage.heightAnchor.constraint(equalToConstant: screenSize.width-20).isActive = true
            self.userImage.widthAnchor.constraint(equalToConstant: screenSize.width-20).isActive = true
            self.imagePicked = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func addElements(){
        navTitle = UILabel(frame: CGRect(x: Int(screenSize.width/2-90), y: detectSizes.navTitleY!, width: 180, height: 30))
        navTitle.text = "EditKey".localizableString(loc: ViewController.LANGUAGE)
        navTitle.textAlignment = .center
        navTitle.font = UIFont(name: "Avenir-Black", size: 20)
        navTitle.textColor = .black
        navigation.addSubview(navTitle)
        
        userImage.loadImageUsingCacheWithURLString(urlImg: self.userImageUrl)
        view.addSubview(userImage)
        userImage.topAnchor.constraint(equalTo: navigation.bottomAnchor, constant: CGFloat(detectSizes.logoY!)).isActive = true
        userImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userImage.widthAnchor.constraint(equalToConstant: screenSize.width-20).isActive = true
        userImage.heightAnchor.constraint(equalToConstant: screenSize.width-20).isActive = true
        
        plus.isUserInteractionEnabled = true
        plus.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickImage)))
        view.addSubview(plus)
        plus.topAnchor.constraint(equalTo: userImage.topAnchor, constant: 1).isActive = true
        plus.rightAnchor.constraint(equalTo: userImage.rightAnchor, constant: -1).isActive = true
        plus.heightAnchor.constraint(equalToConstant: 40).isActive = true
        plus.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(audioPlayerSliderView)
        audioPlayerSliderView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        audioPlayerSliderView.topAnchor.constraint(equalTo: userImage.bottomAnchor, constant: 5).isActive = true
        audioPlayerSliderView.heightAnchor.constraint(equalToConstant: detectSizes.playerBtn!).isActive = true
        audioPlayerSliderView.widthAnchor.constraint(equalTo: userImage.widthAnchor).isActive = true
        
        audioPlayerSliderView.addSubview(myCurrentVoice)
        myCurrentVoice.rightAnchor.constraint(equalTo: audioPlayerSliderView.rightAnchor, constant: -10).isActive = true
        myCurrentVoice.centerYAnchor.constraint(equalTo: audioPlayerSliderView.centerYAnchor).isActive = true
        myCurrentVoice.heightAnchor.constraint(equalTo: audioPlayerSliderView.heightAnchor).isActive = true
        myCurrentVoice.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        audioPlayerSliderView.addSubview(audioSlider)
        audioSlider.leftAnchor.constraint(equalTo: audioPlayerSliderView.leftAnchor, constant: 10).isActive = true
        audioSlider.centerYAnchor.constraint(equalTo: audioPlayerSliderView.centerYAnchor).isActive = true
        audioSlider.heightAnchor.constraint(equalTo: audioPlayerSliderView.heightAnchor).isActive = true
        audioSlider.rightAnchor.constraint(equalTo: myCurrentVoice.leftAnchor, constant: -10).isActive = true
        
        view.addSubview(info)
        info.topAnchor.constraint(equalTo: audioPlayerSliderView.bottomAnchor, constant: 45).isActive = true
        info.leftAnchor.constraint(equalTo: audioPlayerSliderView.leftAnchor).isActive = true
        info.heightAnchor.constraint(equalToConstant: 35).isActive = true
        info.widthAnchor.constraint(equalToConstant: screenSize.width-50).isActive = true
        
        view.addSubview(recordButton)
        recordButton.leftAnchor.constraint(equalTo: audioPlayerSliderView.leftAnchor, constant: 25).isActive = true
        recordButton.topAnchor.constraint(equalTo: info.bottomAnchor, constant: 5).isActive = true
        recordButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        recordButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        view.addSubview(playerButton)
        playerButton.rightAnchor.constraint(equalTo: audioPlayerSliderView.rightAnchor, constant: -25).isActive = true
        playerButton.topAnchor.constraint(equalTo: info.bottomAnchor, constant: 5).isActive = true
        playerButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        playerButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        view.addSubview(userSavedInfo)
        userSavedInfo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userSavedInfo.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        userSavedInfo.heightAnchor.constraint(equalToConstant: 20).isActive = true
        userSavedInfo.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        downloadAudioVoice()
    }
    
    func navBar(){
        navigation.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 80)
        navigation.backgroundColor = UIColor.clear
        view.addSubview(navigation)
        navigation.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        navigation.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        back = UIButton(frame: CGRect(x: 0.0, y: CGFloat(detectSizes.logoutY!), width: 32.5, height: 32.5))
        back.setImage(UIImage(named: "backToView")?.withRenderingMode(.alwaysTemplate), for: .normal)
        back.tintColor = UIColor.black
        back.addTarget(self, action: #selector(backToDating), for: .touchUpInside)
        
        navigation.addSubview(back)
        
        update = UIButton(frame: CGRect(x: Int(screenSize.width-50), y: detectSizes.updateY!, width: 50, height: 30))
        update.setImage(UIImage(named: "ok")?.withRenderingMode(.alwaysTemplate), for: .normal)
        update.tintColor = UIColor.black
        update.addTarget(self, action: #selector(doUpdate), for: .touchUpInside)
        
        navigation.addSubview(update)
    }
    
    func downloadAudioVoice(){
        if let audioUrl = URL(string: self.audioUrlVoice){
            //create documentfolder url
            let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            //create destination file url
            let destinationUrl = documentsDirectoryUrl.appendingPathComponent(audioUrl.lastPathComponent)
            
            //check if file exists
            if FileManager.default.fileExists(atPath: destinationUrl.path){
                setupPlayer(audioFileName: destinationUrl)
                self.myCurrentVoice.isEnabled = true
            }
            else{
                URLSession.shared.downloadTask(with: audioUrl) { (urlLocation, response, error) in
                    guard let location = urlLocation, error == nil else {
                        return
                    }
                    do{
                        //after downloading we move our audio to the destination directory
                        try FileManager.default.moveItem(at: location, to: destinationUrl)
                        self.setupPlayer(audioFileName: destinationUrl)
                        self.myCurrentVoice.isEnabled = true
                    }catch{
                        print(error.localizedDescription)
                    }
                    }.resume()
            }
            self.myCurrentVoice.isEnabled = true
        }
    }
    
    func getUserImageUrl(url: String, audio: String, currentUserUid: String){
        self.userImageUrl = url
        self.audioUrlVoice = audio
        self.currentUserID = currentUserUid
    }
    
    @objc func backToDating(){
        if timer != nil{
             timer.invalidate()
        }
        if sliderTimer != nil{
            sliderTimer.invalidate()
        }
        if soundPlayer != nil{
            soundPlayer.stop()
        }
        self.modalTransitionStyle = .flipHorizontal
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func doUpdate(){
        if (self.audioRecorded || self.imagePicked){
            if(self.audioRecorded){
                if(voiceCounter < 10){
                    self.audioRecorded = false
                    self.imagePicked = false
                    let alert = UIAlertController(title: "InvalidKey".localizableString(loc: ViewController.LANGUAGE), message: "RecordKey".localizableString(loc: ViewController.LANGUAGE), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OkayKey".localizableString(loc: ViewController.LANGUAGE), style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
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
        }else{
            self.backToDating()
        }
        
        UIButton.animate(withDuration: 0.9, animations: {
            self.update.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        }) { (finish) in
            self.update.transform = CGAffineTransform.identity
            
            let audio = self.getCacheDirectory().appendingPathComponent(self.filename)
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
                    
                    self.audioURL = (url?.absoluteString)!
                    
                    if(self.audioURL != "")
                    {
                        self.uploadImage(audioURL: self.audioURL)
                    }
                })
            }
        }
    }
    
    private func uploadImage(audioURL: String){
        var ref: DatabaseReference
        ref = Database.database().reference()
        
        var imageUrl = String()
        let profileImgUnique = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child(profileImgUnique + ".jpg")
        
        if let profileImg = userImage.image{
            if let uploadData = profileImg.jpegData(compressionQuality: 0.1){
                storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                    if error != nil{
                        print(error as Any)
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        self.indicatorBackground.isHidden = true
                        
                        //DIESE METHODE MUSS BEI NORMALEM REGISTRIEREN ZWEIMAL AUFGERUFEN WERDEN WEGEN UPLOADFEHLER BEIM ERSTEN MAL
                        self.activityIndicator.startAnimating()
                        UIApplication.shared.beginIgnoringInteractionEvents()
                        self.indicatorBackground.isHidden = false
                        self.uploadImage(audioURL: self.audioURL)
                        return
                    }
                    
                    storageRef.downloadURL(completion: { (url, error) in
                        if error != nil{
                            print(error as Any)
                            self.activityIndicator.stopAnimating()
                            UIApplication.shared.endIgnoringInteractionEvents()
                            self.indicatorBackground.isHidden = true
                            return
                        }
                        
                        imageUrl = (url?.absoluteString)!
                        
                        if(self.imagePicked && self.audioRecorded){
                            ref.child("User").child(self.currentUserID).updateChildValues(["image" : imageUrl, "audioVoice" : self.audioURL])
                            self.imagePicked = false
                            self.audioRecorded = false
                            if(UIApplication.shared.isIgnoringInteractionEvents)
                            {
                                UIApplication.shared.endIgnoringInteractionEvents()
                                self.activityIndicator.stopAnimating()
                                self.indicatorBackground.isHidden = true
                            }
                            self.indicatorBackground.isHidden = false
                            self.userSavedInfo.isHidden = false
                            self.view.bringSubviewToFront(self.indicatorBackground)
                            self.view.bringSubviewToFront(self.userSavedInfo)
                            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.backToDating), userInfo: nil, repeats: false)
                        }else if(!self.imagePicked && self.audioRecorded){
                            ref.child("User").child(self.currentUserID).updateChildValues(["audioVoice" : self.audioURL])
                            self.imagePicked = false
                            self.audioRecorded = false
                            if(UIApplication.shared.isIgnoringInteractionEvents)
                            {
                                UIApplication.shared.endIgnoringInteractionEvents()
                                self.activityIndicator.stopAnimating()
                                self.indicatorBackground.isHidden = true
                            }
                            self.indicatorBackground.isHidden = false
                            self.userSavedInfo.isHidden = false
                            self.view.bringSubviewToFront(self.indicatorBackground)
                            self.view.bringSubviewToFront(self.userSavedInfo)
                            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.backToDating), userInfo: nil, repeats: false)
                        }else if(self.imagePicked && !self.audioRecorded){
                            ref.child("User").child(self.currentUserID).updateChildValues(["image" : imageUrl])
                            self.imagePicked = false
                            self.audioRecorded = false
                            if(UIApplication.shared.isIgnoringInteractionEvents)
                            {
                                UIApplication.shared.endIgnoringInteractionEvents()
                                self.activityIndicator.stopAnimating()
                                self.indicatorBackground.isHidden = true
                            }
                            self.indicatorBackground.isHidden = false
                            self.userSavedInfo.isHidden = false
                            self.view.bringSubviewToFront(self.indicatorBackground)
                            self.view.bringSubviewToFront(self.userSavedInfo)
                            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.backToDating), userInfo: nil, repeats: false)
                        }
                    })
                }
            }
        }
    }
    
    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer){
        if recognizer.state == .recognized {
            if timer != nil{
                timer.invalidate()
            }
            if sliderTimer != nil{
                sliderTimer.invalidate()
            }
            if soundPlayer != nil{
                soundPlayer.stop()
            }
            self.modalTransitionStyle = .flipHorizontal
            self.dismiss(animated: true, completion: nil)
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
                detectSizes.logoY = 0
                
            case 1334:
                print("iPhone 6/6S/7/8")
                detectSizes.logoutY = 0
                detectSizes.navTitleY = 0
                detectSizes.updateY = 0
                detectSizes.userImg = 100
                detectSizes.userInfo = 50
                detectSizes.playerBtn = 50
                detectSizes.likeBtn = -60
                detectSizes.dontLikeBtn = -60
                detectSizes.logoY = 20
                
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
                detectSizes.logoY = 50
                
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
                detectSizes.logoY = 50
                
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
                detectSizes.logoY = 50
                
            case 1792:
                print("iPhone XR")
                detectSizes.logoutY = 48
                detectSizes.navTitleY = 50
                detectSizes.updateY = 48
                detectSizes.userImg = 170
                detectSizes.userInfo = 30
                detectSizes.playerBtn = 50
                detectSizes.likeBtn = -120
                detectSizes.dontLikeBtn = -120
                detectSizes.logoY = 50
                
            default:
                print("Unknown")
            }
        }
    }
}
