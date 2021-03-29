//
//  ExtraDatesViewController.swift
//  Casen
//
//  Created by Ebu Bekir Celik on 09.04.19.
//  Copyright © 2019 KeepEasy. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import CoreLocation

class ExtraDatesViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate, CLLocationManagerDelegate {
    
    let firstname = UITextField()
    let lastname = UITextField()
    let birthday = UITextField()
    let birthdayPicker = UIDatePicker()
    let genderM = UIButton()
    let genderF = UIButton()
    var genderxPos = CGFloat()
    var genderyPos = CGFloat()
    let blackCircle = UIView()
    var genderFxPos = CGFloat()
    var genderFyPos = CGFloat()
    let genderMLabel = UIButton()
    let genderFLabel = UIButton()
    let chooseGender = UISegmentedControl()
    var counter = Int()
    var voiceCounter = Int()
    var timer: Timer!
    let formularTitle = UILabel()
    let chooseGenderTitle = UILabel()
    let explainYourselfTitle = UILabel()
    let registerUserEnd = UIButton()
    var genderText = String()
    var chooseErrorBorderColor = Int()
    var screenSize = UIScreen.main.bounds
    var gender: String = String()
    let userUid = Auth.auth().currentUser?.uid as! String//UserDefaults.standard.value(forKey: "UserID")
    let dismissOnce = UserDefaults.standard.bool(forKey: "extraDataFromDatingController")
    let manager = CLLocationManager() //LOCALIZATION
    var city = NSString()
    var postalCode = String()
    var latitude = Float()
    var longitude = Float()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let indicatorBackground = UIView()
    let detectSizes = IphoneSize()
    
    //SPRACHAUFNAHME CODE
    var recordButton = UIButton()
    var playerButton = UIButton()
    var soundPlayer: AVAudioPlayer!
    var soundRecorder: AVAudioRecorder!
    var recordingSession: AVAudioSession!
    var filename = "audioVoiceFile.m4a"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detectWhichIphone()
        
        view.setGradientBackground(sender: view, colorOne: UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1).cgColor, colorTwo: UIColor.white.cgColor)
        
        addExtraElements()
        
        recordingSession = AVAudioSession.sharedInstance()
        do{
            try recordingSession.setCategory(.playAndRecord) //ZU WICHTIG
            try recordingSession.overrideOutputAudioPort(.speaker)
        }catch{
            print(error)
        }
        
        setupRecorder()
        
        findMyLocation()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(UIApplication.shared.isIgnoringInteractionEvents)
        {
            UIApplication.shared.endIgnoringInteractionEvents()
            self.activityIndicator.stopAnimating()
            self.indicatorBackground.isHidden = true
        }
    }
    
    func findMyLocation(){
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        latitude = Float(location.coordinate.latitude)
        longitude = Float(location.coordinate.longitude)
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if error != nil{
                print(error as Any)
                return
            }
            
            if (placemarks?.count)! > 0{ //WENN DAS ARRAY WERTE HAT
                
                let pm = placemarks![0] as CLPlacemark
                
                //LIEFERT NUR DEN BEZIRK
                //let city = pm.subAdministrativeArea
                
                //LIEFERT DIE GENAUE STADT
                self.city = (pm.addressDictionary!["City"] as? NSString)!
                self.postalCode = pm.postalCode!
            }
            else
            {
                print("Not location found")
            }
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
    
    func getCity(city: NSString) -> NSString{
        return city
    }
    
    func getPostalCode(postalCode: String) -> String{
        return postalCode
    }
    
    func detectWhichIphone(){
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                detectSizes.formularTitle = 0
                detectSizes.loginBtn = -20
                detectSizes.spaceAbove = 10
                
            case 1334:
                print("iPhone 6/6S/7/8")
                detectSizes.formularTitle = 0
                detectSizes.loginBtn = -50
                detectSizes.spaceAbove = 20
                
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                detectSizes.formularTitle = 50
                detectSizes.loginBtn = -100
                detectSizes.spaceAbove = 20
                
            case 2436:
                print("iPhone X, XS")
                detectSizes.formularTitle = 50
                detectSizes.loginBtn = -100
                detectSizes.spaceAbove = 20
                
            case 2688:
                print("iPhone XS Max")
                detectSizes.formularTitle = 50
                detectSizes.loginBtn = -100
                detectSizes.spaceAbove = 20
                
            case 1792:
                print("iPhone XR")
                detectSizes.formularTitle = 50
                detectSizes.loginBtn = -100
                detectSizes.spaceAbove = 20
                
            default:
                print("Unknown")
            }
        }
    }
    
    func addExtraElements(){
        
        //In general
        formularTitle.translatesAutoresizingMaskIntoConstraints = false
        formularTitle.text = "GeneralKey".localizableString(loc: ViewController.LANGUAGE)
        formularTitle.textAlignment = .left
        formularTitle.textColor = UIColor.darkText
        formularTitle.font = UIFont(name: "HelveticaNeue-Italic", size: 15)
        formularTitle.backgroundColor = .clear
        view.addSubview(formularTitle)
        formularTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        formularTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: detectSizes.formularTitle!).isActive = true
        formularTitle.heightAnchor.constraint(equalToConstant: 50).isActive = true
        formularTitle.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100).isActive = true
        
        firstname.translatesAutoresizingMaskIntoConstraints = false
        firstname.placeholder = "FirstKey".localizableString(loc: ViewController.LANGUAGE)
        firstname.textAlignment = .center
        firstname.layer.cornerRadius = 5
        firstname.layer.shadowColor = UIColor.gray.cgColor
        firstname.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        firstname.layer.shadowOpacity = 1.0
        firstname.layer.shadowRadius = 5.0
        firstname.layer.masksToBounds = false
        firstname.backgroundColor = .white
        view.addSubview(firstname)
        firstname.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        firstname.topAnchor.constraint(equalTo: formularTitle.bottomAnchor).isActive = true
        firstname.heightAnchor.constraint(equalToConstant: 50).isActive = true
        firstname.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100).isActive = true
        
        lastname.translatesAutoresizingMaskIntoConstraints = false
        lastname.placeholder = "LastKey".localizableString(loc: ViewController.LANGUAGE)
        lastname.textAlignment = .center
        lastname.layer.cornerRadius = 5
        lastname.backgroundColor = .white
        lastname.layer.shadowColor = UIColor.gray.cgColor
        lastname.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        lastname.layer.shadowOpacity = 1.0
        lastname.layer.shadowRadius = 5.0
        lastname.layer.masksToBounds = false
        view.addSubview(lastname)
        lastname.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lastname.topAnchor.constraint(equalTo: firstname.bottomAnchor, constant: detectSizes.spaceAbove!).isActive = true
        lastname.heightAnchor.constraint(equalToConstant: 50).isActive = true
        lastname.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100).isActive = true
        
        birthday.translatesAutoresizingMaskIntoConstraints = false
        birthday.placeholder = "BirthKey".localizableString(loc: ViewController.LANGUAGE)
        birthday.textAlignment = .center
        birthday.layer.cornerRadius = 5
        birthday.backgroundColor = .white
        birthday.layer.shadowColor = UIColor.gray.cgColor
        birthday.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        birthday.layer.shadowOpacity = 1.0
        birthday.layer.shadowRadius = 5.0
        birthday.layer.masksToBounds = false
        view.addSubview(birthday)
        birthday.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        birthday.topAnchor.constraint(equalTo: lastname.bottomAnchor, constant: detectSizes.spaceAbove!).isActive = true
        birthday.heightAnchor.constraint(equalToConstant: 50).isActive = true
        birthday.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100).isActive = true
        
        //DATUM AUSWÄHLEN
        birthdayPicker.datePickerMode = .date
        birthdayPicker.translatesAutoresizingMaskIntoConstraints = false
        birthdayPicker.maximumDate = Date()
        birthdayPicker.addTarget(self, action: #selector(chooseBirthday), for: .valueChanged)
        birthday.inputView = birthdayPicker
        
        genderM.translatesAutoresizingMaskIntoConstraints = false
        genderM.setTitle("", for: .normal)
        genderM.backgroundColor = UIColor.white
        genderM.layer.borderColor = UIColor.black.cgColor
        genderM.layer.borderWidth = CGFloat(1)
        genderM.layer.cornerRadius = 8
        genderM.addTarget(self, action: #selector(selectGenderM), for: .touchUpInside)
        view.addSubview(genderM)
        genderM.centerXAnchor.constraint(equalTo: birthday.leftAnchor, constant: 10).isActive = true
        genderM.topAnchor.constraint(equalTo: birthday.bottomAnchor, constant: detectSizes.spaceAbove!).isActive = true
        genderM.heightAnchor.constraint(equalToConstant: 15).isActive = true
        genderM.widthAnchor.constraint(equalToConstant: 15).isActive = true
        
        genderMLabel.translatesAutoresizingMaskIntoConstraints = false
        genderMLabel.setTitle("MKey".localizableString(loc: ViewController.LANGUAGE), for: .normal)
        genderMLabel.setTitleColor(.black, for: .normal)
        genderMLabel.backgroundColor = UIColor.clear
        genderMLabel.addTarget(self, action: #selector(selectGenderM), for: .touchUpInside)
        view.addSubview(genderMLabel)
        genderMLabel.centerXAnchor.constraint(equalTo: genderM.rightAnchor, constant: 25).isActive = true
        genderMLabel.topAnchor.constraint(equalTo: birthday.bottomAnchor, constant: detectSizes.spaceAbove!).isActive = true
        genderMLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        genderMLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        genderFLabel.translatesAutoresizingMaskIntoConstraints = false
        genderFLabel.setTitle("FKey".localizableString(loc: ViewController.LANGUAGE), for: .normal)
        genderFLabel.setTitleColor(.black, for: .normal)
        genderFLabel.backgroundColor = UIColor.clear
        genderFLabel.addTarget(self, action: #selector(selectGenderF), for: .touchUpInside)
        view.addSubview(genderFLabel)
        genderFLabel.rightAnchor.constraint(equalTo: birthday.rightAnchor, constant: 5).isActive = true
        genderFLabel.topAnchor.constraint(equalTo: birthday.bottomAnchor, constant: detectSizes.spaceAbove!).isActive = true
        genderFLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        genderFLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        genderF.translatesAutoresizingMaskIntoConstraints = false
        genderF.setTitle("", for: .normal)
        genderF.backgroundColor = UIColor.white
        genderF.layer.borderColor = UIColor.black.cgColor
        genderF.layer.borderWidth = CGFloat(1)
        genderF.layer.cornerRadius = 8
        genderF.addTarget(self, action: #selector(selectGenderF), for: .touchUpInside)
        view.addSubview(genderF)
        genderF.centerXAnchor.constraint(equalTo: genderFLabel.leftAnchor, constant: -2).isActive = true
        genderF.topAnchor.constraint(equalTo: birthday.bottomAnchor, constant: detectSizes.spaceAbove!).isActive = true
        genderF.heightAnchor.constraint(equalToConstant: 15).isActive = true
        genderF.widthAnchor.constraint(equalToConstant: 15).isActive = true
        
        //Interested In
        chooseGenderTitle.translatesAutoresizingMaskIntoConstraints = false
        chooseGenderTitle.text = "InterestKey".localizableString(loc: ViewController.LANGUAGE)
        chooseGenderTitle.textAlignment = .left
        chooseGenderTitle.textColor = UIColor.darkText
        chooseGenderTitle.font = UIFont(name: "HelveticaNeue-Italic", size: 15)
        chooseGenderTitle.backgroundColor = .clear
        view.addSubview(chooseGenderTitle)
        chooseGenderTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        chooseGenderTitle.topAnchor.constraint(equalTo: genderMLabel.bottomAnchor, constant: 10).isActive = true
        chooseGenderTitle.heightAnchor.constraint(equalToConstant: 50).isActive = true
        chooseGenderTitle.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100).isActive = true
        
        chooseGender.translatesAutoresizingMaskIntoConstraints = false
        chooseGender.insertSegment(withTitle: "MKey".localizableString(loc: ViewController.LANGUAGE), at: 0, animated: true)
        chooseGender.insertSegment(withTitle: "FKey".localizableString(loc: ViewController.LANGUAGE), at: 1, animated: true)
        chooseGender.insertSegment(withTitle: "BKey".localizableString(loc: ViewController.LANGUAGE), at: 2, animated: true)
        chooseGender.backgroundColor = .clear
        chooseGender.tintColor = .black
        view.addSubview(chooseGender)
        chooseGender.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        chooseGender.topAnchor.constraint(equalTo: chooseGenderTitle.bottomAnchor).isActive = true
        chooseGender.heightAnchor.constraint(equalToConstant: 50).isActive = true
        chooseGender.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100).isActive = true
        
        //Introduce yourself
        explainYourselfTitle.translatesAutoresizingMaskIntoConstraints = false
        explainYourselfTitle.text = "IntroKey".localizableString(loc: ViewController.LANGUAGE)
        explainYourselfTitle.textAlignment = .left
        explainYourselfTitle.textColor = UIColor.darkText
        explainYourselfTitle.font = UIFont(name: "HelveticaNeue-Italic", size: 15)
        explainYourselfTitle.backgroundColor = .clear
        view.addSubview(explainYourselfTitle)
        explainYourselfTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        explainYourselfTitle.topAnchor.constraint(equalTo: chooseGender.bottomAnchor, constant: 10).isActive = true
        explainYourselfTitle.heightAnchor.constraint(equalToConstant: 50).isActive = true
        explainYourselfTitle.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100).isActive = true
        
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        recordButton.backgroundColor = UIColor.white//UIColor(red: 191/255, green: 239/255, blue: 255/255, alpha: 1)
        recordButton.layer.cornerRadius = 30
        recordButton.layer.shadowColor = UIColor.gray.cgColor
        recordButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        recordButton.layer.shadowOpacity = 1.0
        recordButton.layer.shadowRadius = 5.0
        recordButton.layer.masksToBounds = false
        recordButton.setImage(UIImage(named: "record")?.withRenderingMode(.alwaysTemplate), for: .normal)
        recordButton.tintColor = UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1)
        recordButton.addTarget(self, action: #selector(recordAct), for: .touchDown)
        recordButton.addTarget(self, action: #selector(stopRecordAct), for: [.touchUpInside, .touchUpOutside])
        view.addSubview(recordButton)
        recordButton.leftAnchor.constraint(equalTo: chooseGender.leftAnchor).isActive = true
        recordButton.topAnchor.constraint(equalTo: explainYourselfTitle.bottomAnchor).isActive = true
        recordButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        recordButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        playerButton.translatesAutoresizingMaskIntoConstraints = false
        playerButton.backgroundColor = UIColor.white//UIColor(red: 191/255, green: 239/255, blue: 255/255, alpha: 1)
        playerButton.layer.cornerRadius = 30
        playerButton.layer.shadowColor = UIColor.gray.cgColor
        playerButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        playerButton.layer.shadowOpacity = 1.0
        playerButton.layer.shadowRadius = 5.0
        playerButton.layer.masksToBounds = false
        playerButton.setImage(UIImage(named: "play")?.withRenderingMode(.alwaysTemplate), for: .normal)
        playerButton.tintColor = UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1)
        playerButton.addTarget(self, action: #selector(playAct), for: .touchUpInside)
        playerButton.isEnabled = false
        view.addSubview(playerButton)
        playerButton.rightAnchor.constraint(equalTo: chooseGender.rightAnchor).isActive = true
        playerButton.topAnchor.constraint(equalTo: explainYourselfTitle.bottomAnchor).isActive = true
        playerButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        playerButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        registerUserEnd.translatesAutoresizingMaskIntoConstraints = false
        registerUserEnd.setTitle("CompleteRegKey".localizableString(loc: ViewController.LANGUAGE), for: .normal)
        registerUserEnd.backgroundColor = .green
        registerUserEnd.setTitleColor(.black, for: .normal)
        registerUserEnd.titleLabel?.font = UIFont(name: "Avenir-Black", size: 22)
        registerUserEnd.layer.cornerRadius = 20
        registerUserEnd.layer.shadowColor = UIColor.gray.cgColor
        registerUserEnd.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        registerUserEnd.layer.shadowOpacity = 0.5
        registerUserEnd.layer.shadowRadius = 0.0
        registerUserEnd.layer.masksToBounds = false
        registerUserEnd.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        view.addSubview(registerUserEnd)
        registerUserEnd.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerUserEnd.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: detectSizes.loginBtn!).isActive = true
        registerUserEnd.heightAnchor.constraint(equalToConstant: 50).isActive = true
        registerUserEnd.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100).isActive = true
    }
    
    @objc func handleRegistration(){
        
        UIButton.animate(withDuration: 0.2, animations: {
            self.registerUserEnd.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { (finish) in
            UIButton.animate(withDuration: 0.2, animations: {
                self.registerUserEnd.transform = CGAffineTransform.identity
            })
        }
        
        let notAllowedCharacter: String = "0123456789!§$%&/()=?`´*+'#-_.:,;€@^°<>[]¢¶“¡¿≠}{|«∑€®†Ω¨⁄øπ•æœ@∆ºª©ƒ∂‚å¥≈ç√∫~µ∞…–‘±"
        let notAllowedCharacterInDate: String = " abcdefghijklmnopqrstuvwxyzäöü!§$%&/()=?`´*+'#-_:,;€@^°<>[]¢¶“¡¿≠}{|«∑€®†Ω¨⁄øπ•æœ@∆ºª©ƒ∂‚å¥≈ç√∫~µ∞…–‘±"
        var name = firstname.text
        var last = lastname.text
        
        name = name?.trimmingCharacters(in: .whitespacesAndNewlines)
        last = last?.trimmingCharacters(in: .whitespacesAndNewlines)

        switch chooseGender.selectedSegmentIndex {
        case 0:
            gender = "Male"
        case 1:
            gender = "Female"
        case 2:
            gender = "Both"
        default:
            gender = ""
        }
        
        if !firstname.text!.isEmpty, !lastname.text!.isEmpty, !birthday.text!.isEmpty, !genderText.isEmpty, !gender.isEmpty{
            if let error = name!.rangeOfCharacter(from: CharacterSet(charactersIn: notAllowedCharacter)) {
                let alert = UIAlertController(title: "InvalidKey".localizableString(loc: ViewController.LANGUAGE), message: "AlphaKey".localizableString(loc: ViewController.LANGUAGE), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OkayKey".localizableString(loc: ViewController.LANGUAGE), style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                chooseErrorBorderColor = 0
                firstname.layer.borderColor = UIColor.red.cgColor
                firstname.layer.borderWidth = CGFloat(2)
                timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(handleBorderColorIfError), userInfo: nil, repeats: false)
                print(error)
            }
            else if let error = last!.rangeOfCharacter(from: CharacterSet(charactersIn: notAllowedCharacter))  {
                let alert = UIAlertController(title: "InvalidKey".localizableString(loc: ViewController.LANGUAGE), message: "AlphaKey".localizableString(loc: ViewController.LANGUAGE), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OkayKey".localizableString(loc: ViewController.LANGUAGE), style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                chooseErrorBorderColor = 1
                lastname.layer.borderColor = UIColor.red.cgColor
                lastname.layer.borderWidth = CGFloat(2)
                timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(handleBorderColorIfError), userInfo: nil, repeats: false)
                print(error)
            }
            else if let error = birthday.text!.rangeOfCharacter(from: CharacterSet(charactersIn: notAllowedCharacterInDate))  {
                let alert = UIAlertController(title: "InvalidKey".localizableString(loc: ViewController.LANGUAGE), message: "DateKey".localizableString(loc: ViewController.LANGUAGE), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OkayKey".localizableString(loc: ViewController.LANGUAGE), style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                chooseErrorBorderColor = 2
                birthday.layer.borderColor = UIColor.red.cgColor
                birthday.layer.borderWidth = CGFloat(2)
                timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(handleBorderColorIfError), userInfo: nil, repeats: false)
                print(error)
            }
            else if voiceCounter < 10{
                let alert = UIAlertController(title: "InvalidKey".localizableString(loc: ViewController.LANGUAGE), message: "RecordKey".localizableString(loc: ViewController.LANGUAGE), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OkayKey".localizableString(loc: ViewController.LANGUAGE), style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy"
                let date = dateFormatter.date(from: birthday.text!)
                let now = Date()
                let calender = Calendar.current
                let ageComponents = calender.dateComponents([.year], from: date!, to: now)
                let userAge = ageComponents.year
                
                if Int(userAge!) < 18{
                    let alert = UIAlertController(title: "InvalidKey".localizableString(loc: ViewController.LANGUAGE), message: "OlderKey".localizableString(loc: ViewController.LANGUAGE), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OkayKey".localizableString(loc: ViewController.LANGUAGE), style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }else{
                    firstname.text = name
                    lastname.text = last
                    
                    saveDataIntoDatabase()
                }
            }
        }
        else {
            let alert = UIAlertController(title: "InvalidKey".localizableString(loc: ViewController.LANGUAGE), message: "FillInKey".localizableString(loc: ViewController.LANGUAGE), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OkayKey".localizableString(loc: ViewController.LANGUAGE), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func saveDataIntoDatabase(){
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .whiteLarge
        activityIndicator.color = .black
        activityIndicator.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        UserDefaults.standard.set(false, forKey: "extraDataFromDatingController") //TO OPEN THIS VIEW CONTROLLER IF ITS EMPTY
        
        var ref: DatabaseReference
        ref = Database.database().reference()
        
        ref.child("User").child(userUid).updateChildValues(["firstname" : firstname.text!, "lastname" : lastname.text!, "birthday" : birthday.text!, "genderSelf" : genderText, "choosenGender" : gender, "city" : city, "postalCode" : postalCode, "latitude" : latitude, "longitude" : longitude, "deviceID" : AppDelegate.DEVICE_ID, "userUid" : userUid ])
        
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
                    ref.child("User").child((self.userUid) + "/audioVoice").setValue(audioURL)
                    
                    UserDefaults.standard.set(false, forKey: "loggedIN")
                    
                    if(UIApplication.shared.isIgnoringInteractionEvents)
                    {
                        UIApplication.shared.endIgnoringInteractionEvents()
                        self.activityIndicator.stopAnimating()
                    }
                    
                    let tabViewController = TabViewController()
                    tabViewController.modalTransitionStyle = .flipHorizontal
                    self.present(tabViewController, animated: true, completion: nil)
                    
                    if Auth.auth().currentUser?.uid != nil{
                        let pushManager = PushNotificationManager(userID: Auth.auth().currentUser?.uid as! String)
                        pushManager.registerForPushNotifications()
                    }
                }
            })
        }
    }
    
    @objc func handleBorderColorIfError(){
        switch chooseErrorBorderColor {
        case 0:
            firstname.layer.borderColor = UIColor.black.cgColor
            if timer != nil{
                timer.invalidate()
            }
        case 1:
            lastname.layer.borderColor = UIColor.black.cgColor
            if timer != nil{
                timer.invalidate()
            }
        case 2:
            birthday.layer.borderColor = UIColor.black.cgColor
            if timer != nil{
                timer.invalidate()
            }
        default:
            return
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
        recordButton.layer.borderWidth = 0
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordButton.isEnabled = true
        playerButton.layer.borderWidth = 0
        playerButton.setImage(UIImage(named: "play")?.withRenderingMode(.alwaysTemplate), for: .normal)
    }
    
    func getCacheDirectory() ->URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
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
            playerButton.setImage(UIImage(named: "pause")?.withRenderingMode(.alwaysTemplate), for: .normal)
            playerButton.layer.borderColor = UIColor.red.cgColor
            playerButton.layer.borderWidth = CGFloat(1)
            setupPlayer()
            if soundPlayer != nil{
                soundPlayer.play()
            }
        }
        else{
            playerButton.setImage(UIImage(named: "play")?.withRenderingMode(.alwaysTemplate), for: .normal)
            playerButton.layer.borderWidth = 0
            recordButton.isEnabled = true
            if soundPlayer != nil{
                soundPlayer.stop()
            }
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
        }
    }
    
    @objc func stopRecordAct(){
        if timer != nil{
            timer.invalidate()
        }
        voiceCounter = counter
        counter = 0
        playerButton.isEnabled = true
        soundRecorder.stop()
        recordButton.setTitle(nil, for: .normal)
        recordButton.layer.borderWidth = 0
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
            counter = 0
            playerButton.isEnabled = false
            soundRecorder.record()
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
        }
    }
    
    @objc func handleTimeForRecord(){
        if counter == 15{
            if timer != nil{
                timer.invalidate()
            }
            voiceCounter = counter
            playerButton.isEnabled = true
            soundRecorder.stop()
            recordButton.setTitle(nil, for: .normal)
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
    
    @objc func selectGenderF(){
        genderxPos = genderF.frame.origin.x + CGFloat(1.5)
        genderyPos = genderF.frame.origin.y + CGFloat(1.5)
        
        blackCircle.translatesAutoresizingMaskIntoConstraints = false
        blackCircle.backgroundColor = .black
        blackCircle.frame = CGRect(x: genderxPos, y: genderyPos, width: 12, height: 12)
        blackCircle.layer.cornerRadius = 6
        view.addSubview(blackCircle)
        
        genderText = "Female"
    }
    
    @objc func selectGenderM(){
        genderxPos = genderM.frame.origin.x + CGFloat(1.5)
        genderyPos = genderM.frame.origin.y + CGFloat(1.5)
        
        blackCircle.translatesAutoresizingMaskIntoConstraints = false
        blackCircle.backgroundColor = .black
        blackCircle.frame = CGRect(x: genderxPos, y: genderyPos, width: 12, height: 12)
        blackCircle.layer.cornerRadius = 6
        view.addSubview(blackCircle)
        
        genderText = "Male"
    }
    
    @objc func chooseBirthday(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        
        birthday.text = dateFormatter.string(from: birthdayPicker.date)
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
}
