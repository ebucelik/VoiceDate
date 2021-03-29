//
//  ViewController.swift
//  Casen
//
//  Created by Ebu Bekir Celik on 09.03.19.
//  Copyright © 2019 KeepEasy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var timer: Timer!
    let screenSize = UIScreen.main.bounds
    static var LANGUAGE = (Locale.current.languageCode)!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //TO SET NAV BAR TRANSPARENT
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true

        view.setGradientBackground(sender: view, colorOne: UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1).cgColor, colorTwo: UIColor.white.cgColor)
        
        let con = UIView()
        view.addSubview(con)
        con.translatesAutoresizingMaskIntoConstraints = false
        con.backgroundColor = UIColor.clear
        con.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        con.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        con.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
        con.heightAnchor.constraint(equalToConstant: 200).isActive = true
        createTitle(con: con)
        
        timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(openMain), userInfo: nil, repeats: false)
        
        if ViewController.LANGUAGE != "en" && ViewController.LANGUAGE != "de" && ViewController.LANGUAGE != "tr"{
            ViewController.LANGUAGE = "en"
        }
    }
    
    let voicedateLong: UIImageView = {
        let vd = UIImageView()
        vd.translatesAutoresizingMaskIntoConstraints = false
        vd.clipsToBounds = true
        vd.image = UIImage(named: "voicedate_long")?.withRenderingMode(.alwaysOriginal)
        return vd
    }()
    
    let logo: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.clipsToBounds = true
        img.image = UIImage(named: "voicedate_logo")?.withRenderingMode(.alwaysOriginal)
        return img
    }()
    
    let slogan: UILabel = {
        let txt = UILabel()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.clipsToBounds = true
        txt.text = "ViewControllerTitle".localizableString(loc: ViewController.LANGUAGE)
        txt.numberOfLines = 2
        txt.textAlignment = .center
        txt.textColor = UIColor.white
        txt.layer.shadowColor = UIColor.gray.cgColor
        txt.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        txt.layer.shadowOpacity = 1.0
        txt.layer.shadowRadius = 5.0
        txt.layer.masksToBounds = false
        txt.isUserInteractionEnabled = false
        return txt
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        if !CheckInternet.Connection() {
            let alert = UIAlertController(title: "Invalid", message: "Check your Internet Connection!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func createTitle(con: UIView)
    {
        con.addSubview(voicedateLong)
        voicedateLong.centerXAnchor.constraint(equalTo: con.centerXAnchor).isActive = true
        voicedateLong.centerYAnchor.constraint(equalTo: con.centerYAnchor).isActive = true
        voicedateLong.heightAnchor.constraint(equalToConstant: 200).isActive = true
        voicedateLong.widthAnchor.constraint(equalTo: con.widthAnchor, constant: -30).isActive = true
        
        con.addSubview(logo) //MUSS IMMER ALS ERSTES GETAN WERDEN SONST KLAPPTS NICHT!
        logo.rightAnchor.constraint(equalTo: con.leftAnchor).isActive = true
        logo.centerYAnchor.constraint(equalTo: con.centerYAnchor).isActive = true
        logo.heightAnchor.constraint(equalToConstant: 300).isActive = true
        logo.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        con.addSubview(slogan)
        slogan.leftAnchor.constraint(equalTo: con.rightAnchor).isActive = true
        slogan.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 50).isActive = true
        slogan.heightAnchor.constraint(equalToConstant: 50).isActive = true
        slogan.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    @objc func openMain(){
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.45, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.voicedateLong.transform = CGAffineTransform(translationX: -(self.voicedateLong.bounds.width + 60), y: 0)
            self.logo.transform = CGAffineTransform(translationX: ((self.screenSize.width/2) + (self.logo.bounds.width/2)-15), y: 0)
            self.slogan.transform = CGAffineTransform(translationX: -((self.screenSize.width/2) + (self.slogan.bounds.width/2)-15), y: 0)
            
            if self.timer != nil{
                self.timer.invalidate()
                self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.openNext), userInfo: nil, repeats: false)
            }
            
        }, completion: nil)
    }

    @objc func openNext(){
        if CheckInternet.Connection() {
            let tabViewController = TabViewController()
            present(tabViewController, animated: true, completion: nil)
        }
        
//                let extradatescontroller = ExtraDatesViewController()
//                present(extradatescontroller, animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
}

extension String{
    func localizableString(loc: String) -> String{
        let path = Bundle.main.path(forResource: loc, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
