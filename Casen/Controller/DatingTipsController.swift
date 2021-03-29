//
//  DatingTipsController.swift
//  Casen
//
//  Created by Ebu Bekir Celik on 29.07.19.
//  Copyright © 2019 KeepEasy. All rights reserved.
//

import UIKit

class DatingTipsController: UIPageViewController, UIPageViewControllerDelegate, UIScrollViewDelegate{
    var screenSize = UIScreen.main.bounds
    let navigation = UIView()
    var navTitle = UILabel()
    var back = UIButton()
    let detectSizes = IphoneSize()
    var pages = [TipsController]()
    var timer: Timer!
    var pageControl = UIPageControl()
    var info = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detectWhichIphone()
        
        view.setGradientBackground(sender: view, colorOne: UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1).cgColor, colorTwo: UIColor.white.cgColor)
        
        navBar()
        
        addElements()
        
        addAllPages()
        
        configurePageControl()
        
        scrollView.delegate = self
    }

    let scrollView: UIScrollView = {
        let tipViews = UIScrollView()
        tipViews.translatesAutoresizingMaskIntoConstraints = false
        tipViews.clipsToBounds = true
        tipViews.backgroundColor = .clear
        tipViews.isPagingEnabled = true
        tipViews.contentSize.height = 1.0
        return tipViews
    }()
    
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
        
        info = UIButton(frame: CGRect(x: (screenSize.width-40), y: CGFloat(detectSizes.logoutY!), width: 30, height: 30))
        info.addTarget(self, action: #selector(showInfo), for: .touchUpInside)
        info.backgroundColor = UIColor.white
        info.setImage(UIImage(named: "info_dating")?.withRenderingMode(.alwaysTemplate), for: .normal)
        info.tintColor = UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1)
        info.layer.cornerRadius = 15
        
        navigation.addSubview(info)
    }
    
    @objc func showInfo(){
        let alert = UIAlertController(title: "InformationKey".localizableString(loc: ViewController.LANGUAGE), message: "TipsKey".localizableString(loc: ViewController.LANGUAGE), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OkayKey".localizableString(loc: ViewController.LANGUAGE), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func addElements(){
        navTitle = UILabel(frame: CGRect(x: Int(screenSize.width/2-90), y: detectSizes.navTitleY!, width: 180, height: 30))
        navTitle.text = "DatingTipsKey".localizableString(loc: ViewController.LANGUAGE)
        navTitle.textAlignment = .center
        navTitle.font = UIFont(name: "Avenir-Black", size: 20)
        navTitle.textColor = .black
        navigation.addSubview(navTitle)
        
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: navTitle.bottomAnchor, constant: CGFloat(detectSizes.logoY!)).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -30).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    func addAllPages(){
        if DatingController.genderSelf == "Male"{
            let page0 = addTips(datingTips: "Date1Key".localizableString(loc: ViewController.LANGUAGE))
            let page1 = addTips(datingTips: "Date2Key".localizableString(loc: ViewController.LANGUAGE))
            let page2 = addTips(datingTips: "Date3Key".localizableString(loc: ViewController.LANGUAGE))
            let page3 = addTips(datingTips: "Date4Key".localizableString(loc: ViewController.LANGUAGE))
            let page4 = addTips(datingTips: "Date5Key".localizableString(loc: ViewController.LANGUAGE))
            let page5 = addTips(datingTips: "Date6Key".localizableString(loc: ViewController.LANGUAGE))
            let page6 = addTips(datingTips: "Date7Key".localizableString(loc: ViewController.LANGUAGE))
            let page7 = addTips(datingTips: "Date8Key".localizableString(loc: ViewController.LANGUAGE))
            pages = [page0, page1, page2, page3, page4, page5, page6, page7]
            
            let views: [String: UIView] = ["view" : view, "page0" : page0.view, "page1" : page1.view, "page2" : page2.view, "page3" : page3.view, "page4" : page4.view, "page5" : page5.view, "page6" : page6.view, "page7" : page7.view]
            let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[page0(==view)]|", options: [], metrics: nil, views: views)
            let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[page0(==view)][page1(==view)][page2(==view)][page3(==view)][page4(==view)][page5(==view)][page6(==view)][page7(==view)]|", options: [.alignAllTop, .alignAllBottom], metrics: nil, views: views)
            NSLayoutConstraint.activate(verticalConstraints + horizontalConstraints)
        }else{
            let page0 = addTips(datingTips: "DateF1Key".localizableString(loc: ViewController.LANGUAGE))
            let page1 = addTips(datingTips: "DateF2Key".localizableString(loc: ViewController.LANGUAGE))
            let page2 = addTips(datingTips: "DateF3Key".localizableString(loc: ViewController.LANGUAGE))
            let page3 = addTips(datingTips: "DateF4Key".localizableString(loc: ViewController.LANGUAGE))
            let page4 = addTips(datingTips: "DateF5Key".localizableString(loc: ViewController.LANGUAGE))
            let page5 = addTips(datingTips: "DateF6Key".localizableString(loc: ViewController.LANGUAGE))
            let page6 = addTips(datingTips: "DateF7Key".localizableString(loc: ViewController.LANGUAGE))
            let page7 = addTips(datingTips: "DateF8Key".localizableString(loc: ViewController.LANGUAGE))
            pages = [page0, page1, page2, page3, page4, page5, page6, page7]
            
            let views: [String: UIView] = ["view" : view, "page0" : page0.view, "page1" : page1.view, "page2" : page2.view, "page3" : page3.view, "page4" : page4.view, "page5" : page5.view, "page6" : page6.view, "page7" : page7.view]
            let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[page0(==view)]|", options: [], metrics: nil, views: views)
            let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[page0(==view)][page1(==view)][page2(==view)][page3(==view)][page4(==view)][page5(==view)][page6(==view)][page7(==view)]|", options: [.alignAllTop, .alignAllBottom], metrics: nil, views: views)
            NSLayoutConstraint.activate(verticalConstraints + horizontalConstraints)
        }
    }
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 100,width: UIScreen.main.bounds.width,height: 50))
        self.pageControl.numberOfPages = pages.count
        self.pageControl.currentPage = 0
        self.pageControl.isUserInteractionEnabled = false
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.white
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.view.addSubview(pageControl)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }
    
    private func addTips(datingTips: String) -> TipsController{
        let tipController = TipsController()
        tipController.view.translatesAutoresizingMaskIntoConstraints = false
        tipController.view.clipsToBounds = true
        tipController.addDatingTip(tip: datingTips)
        
        scrollView.addSubview(tipController.view)
        
        addChild(tipController)
        tipController.didMove(toParent: self)
        
        return tipController
    }
    
    @objc func backToDating(){
        if timer != nil{
            timer.invalidate()
        }
        self.modalTransitionStyle = .flipHorizontal
        self.dismiss(animated: true, completion: nil)
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
                detectSizes.logoY = 35
                
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
                detectSizes.logoY = 0
                
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
                detectSizes.logoY = 0
                
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
                detectSizes.logoY = 0
                
            case 1792:
                print("iPhone XR")
                detectSizes.logoutY = 48
                detectSizes.navTitleY = 50
                detectSizes.updateY = 48
                detectSizes.userImg = 170
                detectSizes.userInfo = 50
                detectSizes.playerBtn = 50
                detectSizes.likeBtn = -120
                detectSizes.dontLikeBtn = -120
                detectSizes.logoY = 0
                
            default:
                print("Unknown")
            }
        }
    }
}


