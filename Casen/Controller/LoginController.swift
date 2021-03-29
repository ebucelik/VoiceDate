//
//  LoginController.swift
//  Casen
//
//  Created by Ebu Bekir Celik on 06.04.19.
//  Copyright © 2019 KeepEasy. All rights reserved.
//
import Foundation
import UIKit
import Firebase

class LoginController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let items = UISegmentedControl()
    let loginElement = UITextField()
    let passwordElement = UITextField()
    let passwordRepeat = UITextField()
    let imageElement = UIImageView()
    let loginBtn = UIButton()
    var imageExist = false
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var screenSize = UIScreen.main.bounds
    let indicatorBackground = UIView()
    var timer: Timer!
    var userExist = Bool()
    var userExistAgain = Bool()
    let detectSizes = IphoneSize()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.setGradientBackground(sender: view, colorOne: UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1).cgColor, colorTwo: UIColor.white.cgColor)

        detectWhichIphone()
        
        addElements()
        
        indicBackground() //IndicatorBackground (Loading Symbol)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        view.addGestureRecognizer(tap)
        
    }
    
    let goToLoginBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.setTitle("ToLoginKey".localizableString(loc: ViewController.LANGUAGE), for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = .clear
        btn.titleLabel?.font =  UIFont(name: "Avenir-Black", size: 15)
        btn.addTarget(self, action: #selector(lookToSelectedItem), for: .touchUpInside)
        btn.layer.shadowColor = UIColor.gray.cgColor
        btn.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        btn.layer.shadowOpacity = 1.0
        btn.layer.shadowRadius = 5.0
        btn.layer.masksToBounds = false
        return btn
    }()
    
    let logoImage: UIImageView = {
        let logo = UIImageView()
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.clipsToBounds = true
        logo.image = UIImage(named: "voicedate_logo")?.withRenderingMode(.alwaysOriginal)
        logo.isHidden = true
        return logo
    }()
    
    let plus: UIImageView = {
        let changeImg = UIImageView(image: UIImage(named: "plus")?.withRenderingMode(.alwaysTemplate))
        changeImg.translatesAutoresizingMaskIntoConstraints = false
        changeImg.clipsToBounds = true
        changeImg.tintColor = UIColor.white//UIColor(red: 191/255, green: 239/255, blue: 255/255, alpha: 1)
        return changeImg
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        if(UIApplication.shared.isIgnoringInteractionEvents)
        {
            UIApplication.shared.endIgnoringInteractionEvents()
            self.activityIndicator.stopAnimating()
            self.indicatorBackground.isHidden = true
        }
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    func detectWhichIphone(){
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                detectSizes.imgY = -70
                detectSizes.imgHeight = 100
                detectSizes.imgWidth = 100
                detectSizes.loginBtn = -60
                detectSizes.logoY = 20
                
            case 1334:
                print("iPhone 6/6S/7/8")
                detectSizes.imgY = -90
                detectSizes.imgHeight = 150
                detectSizes.imgWidth = 150
                detectSizes.loginBtn = -50
                detectSizes.logoY = 40
                
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                detectSizes.imgY = -110
                detectSizes.imgHeight = 150
                detectSizes.imgWidth = 150
                detectSizes.loginBtn = -100
                detectSizes.logoY = 100
                
            case 2436:
                print("iPhone X, XS")
                detectSizes.imgY = -150
                detectSizes.imgHeight = 150
                detectSizes.imgWidth = 150
                detectSizes.loginBtn = -100
                detectSizes.logoY = 100
                
            case 2688:
                print("iPhone XS Max")
                detectSizes.imgY = -150
                detectSizes.imgHeight = 150
                detectSizes.imgWidth = 150
                detectSizes.loginBtn = -100
                detectSizes.logoY = 100
                
            case 1792:
                print("iPhone XR")
                detectSizes.imgY = -115
                detectSizes.imgHeight = 150
                detectSizes.imgWidth = 150
                detectSizes.loginBtn = -100
                detectSizes.logoY = 100
                
            default:
                print("Unknown")
            }
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
    
    func addElements(){
        view.addSubview(logoImage)
        logoImage.topAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(detectSizes.logoY!)).isActive = true
        logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        logoImage.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        //Login element
        view.addSubview(loginElement)
        loginElement.translatesAutoresizingMaskIntoConstraints = false
        loginElement.placeholder = "E - Mail"
        loginElement.textAlignment = .center
        loginElement.backgroundColor = UIColor.white
        loginElement.textColor = UIColor.black
        loginElement.layer.cornerRadius = 5
        loginElement.layer.shadowColor = UIColor.gray.cgColor
        loginElement.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        loginElement.layer.shadowOpacity = 1.0
        loginElement.layer.shadowRadius = 5.0
        loginElement.layer.masksToBounds = false
        loginElement.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginElement.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20).isActive = true
        loginElement.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginElement.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100).isActive = true
        
        //Password element
        view.addSubview(passwordElement)
        passwordElement.translatesAutoresizingMaskIntoConstraints = false
        passwordElement.placeholder = "PasswordKey".localizableString(loc: ViewController.LANGUAGE)
        passwordElement.isSecureTextEntry = true
        passwordElement.textAlignment = .center
        passwordElement.backgroundColor = UIColor.white
        passwordElement.textColor = UIColor.black
        passwordElement.layer.cornerRadius = 5
        passwordElement.layer.shadowColor = UIColor.gray.cgColor
        passwordElement.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        passwordElement.layer.shadowOpacity = 1.0
        passwordElement.layer.shadowRadius = 5.0
        passwordElement.layer.masksToBounds = false
        passwordElement.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordElement.centerYAnchor.constraint(equalTo: loginElement.bottomAnchor, constant: 30).isActive = true
        passwordElement.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passwordElement.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100).isActive = true
        
        //Password repeat
        view.addSubview(passwordRepeat)
        passwordRepeat.translatesAutoresizingMaskIntoConstraints = false
        passwordRepeat.placeholder = "PasswordKeyRepeat".localizableString(loc: ViewController.LANGUAGE)
        passwordRepeat.isSecureTextEntry = true
        passwordRepeat.textAlignment = .center
        passwordRepeat.backgroundColor = UIColor.white
        passwordRepeat.textColor = UIColor.black
        passwordRepeat.layer.cornerRadius = 5
        passwordRepeat.layer.shadowColor = UIColor.gray.cgColor
        passwordRepeat.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        passwordRepeat.layer.shadowOpacity = 1.0
        passwordRepeat.layer.shadowRadius = 5.0
        passwordRepeat.layer.masksToBounds = false
        passwordRepeat.isHidden = false
        passwordRepeat.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordRepeat.centerYAnchor.constraint(equalTo: passwordElement.bottomAnchor, constant: 30).isActive = true
        passwordRepeat.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passwordRepeat.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100).isActive = true
        
        //Profile - Image
        view.addSubview(imageElement)
        imageElement.translatesAutoresizingMaskIntoConstraints = false
        imageElement.image = UIImage(named: "iconProfile")
        imageElement.tintColor = UIColor.white
        imageElement.contentMode = .scaleAspectFill
        imageElement.image = imageElement.image?.withRenderingMode(.alwaysTemplate)
        imageElement.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(grabProfileImage)))
        imageElement.isUserInteractionEnabled = true
        imageElement.isHidden = false
        imageElement.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageElement.bottomAnchor.constraint(equalTo: loginElement.topAnchor, constant: detectSizes.imgY!).isActive = true
        imageElement.heightAnchor.constraint(equalToConstant: detectSizes.imgHeight!).isActive = true
        imageElement.widthAnchor.constraint(equalToConstant: detectSizes.imgWidth!).isActive = true
        
        imageElement.addSubview(plus)
        plus.topAnchor.constraint(equalTo: imageElement.topAnchor, constant: 5).isActive = true
        plus.rightAnchor.constraint(equalTo: imageElement.rightAnchor, constant: -5).isActive = true
        plus.heightAnchor.constraint(equalToConstant: 30).isActive = true
        plus.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        //Login/Register - Button
        view.addSubview(loginBtn)
        loginBtn.translatesAutoresizingMaskIntoConstraints = false
        loginBtn.setTitle("LoginBtnKey".localizableString(loc: ViewController.LANGUAGE), for: .normal)
        loginBtn.setTitleColor(.black, for: .normal)
        loginBtn.titleLabel?.font = UIFont(name: "Avenir-Black", size: 22)
        loginBtn.backgroundColor = UIColor.green
        loginBtn.layer.cornerRadius = 20
        loginBtn.layer.shadowColor = UIColor.gray.cgColor
        loginBtn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        loginBtn.layer.shadowOpacity = 0.5
        loginBtn.layer.shadowRadius = 0.0
        loginBtn.layer.masksToBounds = false
        loginBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: detectSizes.loginBtn!).isActive = true
        loginBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginBtn.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100).isActive = true
        loginBtn.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        view.addSubview(goToLoginBtn)
        goToLoginBtn.topAnchor.constraint(equalTo: loginBtn.bottomAnchor, constant: 20).isActive = true
        goToLoginBtn.centerXAnchor.constraint(equalTo: loginBtn.centerXAnchor).isActive = true
        goToLoginBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        goToLoginBtn.widthAnchor.constraint(equalTo: loginBtn.widthAnchor).isActive = true
    }
    
    @objc func handleLoginRegister(){
        
        UIButton.animate(withDuration: 0.2, animations: {
            self.loginBtn.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { (finish) in
            UIButton.animate(withDuration: 0.2, animations: {
                self.loginBtn.transform = CGAffineTransform.identity
            })
        }
        
        if loginBtn.titleLabel?.text == "LoginBtnKey".localizableString(loc: ViewController.LANGUAGE){
            userExist = false
            userExistAgain = false
            handleRegister()
        }else{
            handleLogin()
            if Auth.auth().currentUser?.uid != nil{
                let pushManager = PushNotificationManager(userID: Auth.auth().currentUser?.uid as! String)
                pushManager.registerForPushNotifications()
            }
        }
    }
    
    func handleLogin(){
        
        indicatorBackground.isHidden = false
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .whiteLarge
        activityIndicator.color = .white
        activityIndicator.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //GUARD SCHAUT OB EIN WERT VORHANDEN IST ANSONSTEN ELSE ZWEIG
        guard let email = loginElement.text, let password = passwordElement.text else{
            let alert = UIAlertController(title: "InvalidKey".localizableString(loc: ViewController.LANGUAGE), message: "WrongMailKey".localizableString(loc: ViewController.LANGUAGE), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OkayKey".localizableString(loc: ViewController.LANGUAGE), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            indicatorBackground.isHidden = true
            
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil{
                print(error as Any)
                let alert = UIAlertController(title: "InvalidKey".localizableString(loc: ViewController.LANGUAGE), message: "WrongMailKey".localizableString(loc: ViewController.LANGUAGE), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OkayKey".localizableString(loc: ViewController.LANGUAGE), style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                self.indicatorBackground.isHidden = true
                return
            }
            else
            {
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                self.indicatorBackground.isHidden = true
                
                guard let userID = Auth.auth().currentUser?.uid else{
                    return
                }
                
                UserDefaults.standard.set(userID, forKey: "LoginUserID")
                UserDefaults.standard.set(true, forKey: "loggedIN")
                let tabViewController = TabViewController()
                tabViewController.modalTransitionStyle = .flipHorizontal
                self.present(tabViewController, animated: true, completion: nil)
            }
        }
    }
    
    func handleRegister(){
        indicatorBackground.isHidden = false
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .whiteLarge
        activityIndicator.color = .white
        activityIndicator.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        guard let email = loginElement.text, let password = passwordElement.text, let passwordRepeat = passwordRepeat.text else{
            let alert = UIAlertController(title: "InvalidKey".localizableString(loc: ViewController.LANGUAGE), message: "InitsKey".localizableString(loc: ViewController.LANGUAGE), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OkayKey".localizableString(loc: ViewController.LANGUAGE), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            indicatorBackground.isHidden = true
            return
        }
        
        if password != passwordRepeat{
            let alert = UIAlertController(title: "InvalidKey".localizableString(loc: ViewController.LANGUAGE), message: "PassCheckKey".localizableString(loc: ViewController.LANGUAGE), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OkayKey".localizableString(loc: ViewController.LANGUAGE), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            indicatorBackground.isHidden = true
            return
        }
        else if password.count < 8
        {
            let alert = UIAlertController(title: "InvalidKey".localizableString(loc: ViewController.LANGUAGE), message: "CharKey".localizableString(loc: ViewController.LANGUAGE), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OkayKey".localizableString(loc: ViewController.LANGUAGE), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            indicatorBackground.isHidden = true
            return
        }
        else if !imageExist{
            let alert = UIAlertController(title: "InvalidKey".localizableString(loc: ViewController.LANGUAGE), message: "ImgKey".localizableString(loc: ViewController.LANGUAGE), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OkayKey".localizableString(loc: ViewController.LANGUAGE), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            indicatorBackground.isHidden = true
            return
        }
        else {
            if(!userExistAgain) //WEIL DER COMPILER ÖFTERS REIN GEHT
            {
                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                    if error != nil{
                        print(error as Any)
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        self.indicatorBackground.isHidden = true
                        if(!self.userExist){
                            let alert = UIAlertController(title: "InvalidKey".localizableString(loc: ViewController.LANGUAGE), message: "ExistKey".localizableString(loc: ViewController.LANGUAGE), preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OkayKey".localizableString(loc: ViewController.LANGUAGE), style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            self.userExist = true
                            self.userExistAgain = true
                            return
                        }
                        return
                    }
                    else
                    {
                        //WENN DER USER REGISTRIERBAR IST
                        self.uploadImage(email: email, password: password)
                    }
                }
            }
        }
    }
    
    private func uploadImage(email: String, password: String){
        var imageUrl = String()
        let profileImgUnique = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child(profileImgUnique + ".jpg")
        
        if let profileImg = imageElement.image{
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
                        self.uploadImage(email: email, password: password)
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
                        
                        if(imageUrl != "")
                        {
                            self.registerUser(email: email, password: password, imageUrl: imageUrl)
                        }
                    })
                }
            }
        }
    }
    
    private func registerUser(email: String, password: String, imageUrl: String)
    {
        var ref: DatabaseReference
        ref = Database.database().reference()
        
        guard let userID = Auth.auth().currentUser?.uid else{
            return
        }
        
        UserDefaults.standard.set(true, forKey: "extraDataFromDatingController") //TO OPEN EXTRADATINGVIEWCONTROLLER IF APP IS CLOSED
        
        UserDefaults.standard.set(userID, forKey: "UserID")
        
        UserDefaults.standard.set(false, forKey: "loggedIN")
        
        ref.child("User").child(userID).setValue(["email": email, "password": password, "image": imageUrl])
        
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        indicatorBackground.isHidden = true
        
        if Auth.auth().currentUser?.uid != nil{
            let pushManager = PushNotificationManager(userID: Auth.auth().currentUser?.uid as! String)
            pushManager.registerForPushNotifications()
        }
        
        let extradatescontroller = ExtraDatesViewController()
        self.present(extradatescontroller, animated: true, completion: nil)
    }
    
    //NUR UM DIE GALERIE ZU ÖFFNEN UND DAS BILD AUSZUSUCHEN
    @objc func grabProfileImage(){
        UIButton.animate(withDuration: 0.2, animations: {
            self.imageElement.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { (finish) in
            UIButton.animate(withDuration: 0.2, animations: {
                self.imageElement.transform = CGAffineTransform.identity
            })
        }
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.modalTransitionStyle = .flipHorizontal
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImg = info[.editedImage] as? UIImage{
            selectedImageFromPicker = editedImg
        }else if let originalImg = info[.originalImage] as? UIImage{
            selectedImageFromPicker = originalImg
        }
        
        if let profileImg = selectedImageFromPicker{
            imageElement.image = profileImg
            imageElement.layer.cornerRadius = 30
            imageElement.clipsToBounds = true
            imageElement.heightAnchor.constraint(equalToConstant: 150).isActive = true
            imageElement.widthAnchor.constraint(equalToConstant: 150).isActive = true
            
            imageExist = true
        }else{
            imageExist = false
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func lookToSelectedItem()
    {
        UIButton.animate(withDuration: 0.2, animations: {
            self.goToLoginBtn.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { (finish) in
            UIButton.animate(withDuration: 0.2, animations: {
                self.goToLoginBtn.transform = CGAffineTransform.identity
                
                if(self.goToLoginBtn.titleLabel?.text == "ToRegsiterKey".localizableString(loc: ViewController.LANGUAGE))
                {
                    self.passwordRepeat.isHidden = false
                    self.imageElement.isHidden = false
                    self.loginBtn.setTitle("LoginBtnKey".localizableString(loc: ViewController.LANGUAGE), for: .normal)
                    self.goToLoginBtn.setTitle("ToLoginKey".localizableString(loc: ViewController.LANGUAGE), for: .normal)
                    self.logoImage.isHidden = true
                }
                else
                {
                    self.passwordRepeat.isHidden = true
                    self.imageElement.isHidden = true
                    self.loginBtn.setTitle("RegisterBtnKey".localizableString(loc: ViewController.LANGUAGE), for: .normal)
                    self.goToLoginBtn.setTitle("ToRegsiterKey".localizableString(loc: ViewController.LANGUAGE), for: .normal)
                    self.logoImage.isHidden = false
                }
            })
        }
    }
    
}

extension UIImagePickerController{
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
}
