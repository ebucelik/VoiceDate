//
//  TabViewController.swift
//  Casen
//
//  Created by Ebu Bekir Celik on 14.04.19.
//  Copyright © 2019 KeepEasy. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController, UITabBarControllerDelegate {

    let datingViewController = DatingController()
    let matchesViewController = MatchesViewController()
    
    //if user register himself, then load the users if he finished with registration.
    override func viewDidAppear(_ animated: Bool) {
        datingViewController.doDownloadAgain()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        self.tabBar.tintColor = UIColor.white
        self.tabBar.barTintColor = UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1)//UIColor(red: 0/255, green: 178/255, blue: 238/255, alpha: 0.75)
        
        datingViewController.tabBarItem = UITabBarItem(title: "DatesTabKey".localizableString(loc: ViewController.LANGUAGE), image: nil, tag: 0)
        datingViewController.tabBarItem.image = UIImage(named: "people")
        
        matchesViewController.tabBarItem = UITabBarItem(title: "MatchesTabKey".localizableString(loc: ViewController.LANGUAGE), image: nil, tag: 1)
        matchesViewController.tabBarItem.image = UIImage(named: "speech_buble")
        matchesViewController.downloadMatchedUser()
        
        let tabBarList = [datingViewController, matchesViewController]
        
        viewControllers = tabBarList
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if(tabBar.items?.index(of: item) == 1 && item.badgeValue != nil){
            matchesViewController.tabBarItem.badgeValue = nil
            //matchesViewController.downloadMatchedUser()
        }
//        else if(tabBar.items?.index(of: item) == 1){
//            matchesViewController.downloadMatchedUser()
//        }
        else if(tabBar.items?.index(of: item) == 0){
            datingViewController.doDownloadAgain()
        }
    }
}
