//
//  TipIntroController.swift
//  Casen
//
//  Created by Ebu Bekir Celik on 04.08.19.
//  Copyright © 2019 KeepEasy. All rights reserved.
//

import UIKit

class TipIntroController: UIViewController {

    var screenSizes = UIScreen.main.bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        implementElements()
    }
    
    let introImage: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.clipsToBounds = true
        img.layer.cornerRadius = 10
        img.layer.shadowColor = UIColor.gray.cgColor
        img.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        img.layer.shadowOpacity = 1.0
        img.layer.shadowRadius = 5.0
        img.layer.masksToBounds = false
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    let introBackBtn: UIButton = {
        let screenSize = UIScreen.main.bounds
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.setTitle("StartKey".localizableString(loc: ViewController.LANGUAGE), for: .normal)
        btn.setGradientBackgroundForButton(sender: btn, colorOne: UIColor.green.cgColor, colorTwo: UIColor.white.cgColor, width: (screenSize.width-50), height: 50)
        btn.titleLabel?.font = UIFont(name: "Avenir-Black", size: 25)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.isHidden = true
        return btn
    }()
    
    func implementElements(){
        view.addSubview(introImage)
        introImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
        introImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        introImage.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -200).isActive = true
        introImage.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        
        introBackBtn.addTarget(self, action: #selector(backToDating), for: .touchUpInside)
        view.addSubview(introBackBtn)
        introBackBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        introBackBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        introBackBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        introBackBtn.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
    }
    
    func addImageTip(tip: UIImage){
        introImage.image = tip
    }
    
    func notHidden(){
        introBackBtn.isHidden = false
    }
    
    @objc func backToDating(){
        UIButton.animate(withDuration: 0.2, animations: {
            self.introBackBtn.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { (finish) in
            UIButton.animate(withDuration: 0.2, animations: {
                self.introBackBtn.transform = CGAffineTransform.identity
                
                self.modalTransitionStyle = .flipHorizontal
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
}
