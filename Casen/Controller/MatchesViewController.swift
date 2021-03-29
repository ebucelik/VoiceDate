//
//  MatchesViewController.swift
//  Casen
//
//  Created by Ebu Bekir Celik on 30.05.19.
//  Copyright © 2019 KeepEasy. All rights reserved.
//

import UIKit
import Firebase



class MatchesViewController: UITableViewController {
    
    var navTitle = UINavigationBar()
    let screenSize = UIScreen.main.bounds
    var liveMatchedUser = [MatchedUser]()
    let userUid = UserDefaults.standard.value(forKey: "UserID") //REGISTRIERT
    let loginUserID = UserDefaults.standard.value(forKey: "LoginUserID") //EINGELOGGT
    let loggedIN = UserDefaults.standard.bool(forKey: "loggedIN") //OB REGISTRIERT ODER EINGELOGGT
    var finalUserID = Auth.auth().currentUser?.uid
    var matchedUser = [String]()
    let cellID = "cellID"
    var fetchAllUser = [User]()
    var detectRotate = false
    var matchedImages = [UIImageView]()
    var checkIfOutOfRange = Array<Any>()
    let reloadController = UIRefreshControl()
    var deviceIDsend = String()
    var badgeValue = Int()
    var badgeValueUser = [BadgeValues]()
    var hideBadgeValue = Bool()
    var sumBadgeValues = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = UIColor.white
        
        setTableViewBackgroundGradient(sender: self, colorOne: UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1).cgColor, colorTwo: UIColor.white.cgColor)
        
        self.tabBarItem.badgeValue = nil
        self.sumBadgeValues = 0
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = reloadController
        } else {
            tableView.addSubview(reloadController)
        }
        
        reloadController.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        reloadController.attributedTitle = NSAttributedString(string: "LoadingKey".localizableString(loc: ViewController.LANGUAGE))
        
        titleBar()
        
        downloadMatchedUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Die Matches werden nicht richtig geladen wenn man aus der App raus geht und nochmal reingeht deshalb das hier.
        if !AppDelegate.EXITAPP{
            downloadMatchedUser()
        }else{
            AppDelegate.EXITAPP = false
        }
        
        self.tabBarItem.badgeValue = nil
        self.sumBadgeValues = 0
        self.hideBadgeValue = true
        
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //Zum wegkriegen von dem BadgeValue
        self.hideBadgeValue = false
        downloadMatchedUser()
    }
    
    func setTableViewBackgroundGradient(sender: UITableViewController, colorOne: CGColor, colorTwo: CGColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorOne, colorTwo]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.locations = [0.275, 1.0]
        gradientLayer.frame = sender.tableView.bounds
        
        let backgroundView = UIView(frame: sender.tableView.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        sender.tableView.backgroundView = backgroundView
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return liveMatchedUser.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    @objc func reloadData(){
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
                if(self.reloadController.isRefreshing){
                    self.reloadController.endRefreshing()
                    //self.downloadMatchedUser()
                }
            }
        }
    }
    
    private lazy var downloadOnce: Void = {
        self.downloadMatchedUser()
    }()
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Wird nur einmal aufgerufen.
        _ = downloadOnce
        
        let chatViewController = ChatViewController(collectionViewLayout: UICollectionViewFlowLayout())
        
        chatViewController.modalTransitionStyle = .flipHorizontal
        chatViewController.titleBar(username: liveMatchedUser[indexPath.row].firstname!, imageURL: liveMatchedUser[indexPath.row].imageURL!, userID: liveMatchedUser[indexPath.row].userUid!)
        present(chatViewController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellID)
        
        checkIfOutOfRange = liveMatchedUser
        
        if checkIfOutOfRange.getElement(at: indexPath.row) != nil{
            let userName = liveMatchedUser[indexPath.row].firstname
            let userLastname = liveMatchedUser[indexPath.row].lastname
            let cellText = UITextView(frame: CGRect(x: 0, y: 250, width: screenSize.width, height: 25))
            cellText.text = userName! + " " + userLastname!
            cellText.isEditable = false
            cellText.textAlignment = .center
            cellText.backgroundColor = .clear
            cell.addSubview(cellText)
        }
        
        checkIfOutOfRange = matchedImages
        
        if checkIfOutOfRange.getElement(at: indexPath.row) != nil{
            let cellImg = UIImageView(frame: CGRect(x: screenSize.width/2-90, y: 60, width: 180, height: 180))
            cellImg.layer.cornerRadius = 90
            cellImg.layer.borderColor = UIColor.lightText.cgColor
            cellImg.layer.borderWidth = CGFloat(2)
            cellImg.layer.masksToBounds = true
            cellImg.clipsToBounds = true
            cellImg.translatesAutoresizingMaskIntoConstraints = false
            cellImg.image = matchedImages[indexPath.row].image?.withRenderingMode(.alwaysOriginal)
            cell.addSubview(cellImg)
        }
        
        cell.textLabel?.textAlignment = .center

        if checkIfOutOfRange.getElement(at: indexPath.row) != nil{
            for badgeUsers in self.badgeValueUser{
                if badgeUsers.useruid == liveMatchedUser[indexPath.row].userUid{
                    let cellBadgeValue = UILabel(frame: CGRect(x: screenSize.width/2+50, y: 70, width: 25, height: 25))
                    cellBadgeValue.translatesAutoresizingMaskIntoConstraints = false
                    cellBadgeValue.clipsToBounds = true
                    cellBadgeValue.layer.cornerRadius = 12.5
                    cellBadgeValue.isHidden = true
                    if !badgeUsers.badgeValue!.isEmpty && badgeUsers.badgeValue != "0"{
                        cellBadgeValue.text = badgeUsers.badgeValue
                        cellBadgeValue.isHidden = false
                    }
                    cellBadgeValue.textColor = UIColor.white
                    cellBadgeValue.backgroundColor = UIColor.red
                    cellBadgeValue.textAlignment = .center
                    cell.addSubview(cellBadgeValue)
                }
            }
        }
        
        return cell
    }
    
    @objc func refreshData(){
        downloadMatchedUser()
    }
    
    func titleBar(){
        
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont(name: "Avenir-Black", size: 20)!
        ]
        
        navTitle = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 35))
        
        navTitle.setBackgroundImage(UIImage(), for: .default)
        navTitle.shadowImage = UIImage()
        navTitle.isTranslucent = true
        navTitle.backgroundColor = .clear
        navTitle.titleTextAttributes = attrs
        
        let navItems = UINavigationItem()
        navItems.title = "MatchesTitleKey".localizableString(loc: ViewController.LANGUAGE)
        navTitle.items = [navItems]
        view.addSubview(navTitle)
    }
    
    func downloadMatchedUser(){
        if finalUserID == nil{
            return
        }
        
        var ref: DatabaseReference
        
        ref = Database.database().reference()
       
        self.matchedUser = [String]()
        
        ref.child("Matches").child("Matched").child(finalUserID!).observe(.value) { (snapshot) in
            
            guard snapshot.exists() else{
                return
            }
            
            for child in snapshot.children{
                let snap = child as! DataSnapshot
                if(snap.value as! String != ""){
                    self.matchedUser.append(snap.value as! String)
                    
                    if(self.matchedUser.count == snapshot.childrenCount){
                        self.downloadDetails()
                    }
                }
            }
        }
    }
    
    var img = String()
    var firstname = String()
    var lastname = String()
    var userUidPerson = String()
    
    func downloadDetails(){
        
        var ref: DatabaseReference
        var matchedUserCounter = false
        
        self.liveMatchedUser = [MatchedUser]()
        self.fetchAllUser = [User]()
        self.badgeValueUser = [BadgeValues]()
        
        ref = Database.database().reference().child("Chats")
        
        ///WENN EINE NACHRICHT KOMMT DANN BADGE VALUE
        for user in self.matchedUser{
            ref.child(finalUserID!).child(user).child("badgeValue").child("value").observe(.value) { (badgeSnap) in
                if let value = badgeSnap.value as? Int{
                    let badge = BadgeValues()
                    badge.useruid = user
                    badge.badgeValue = String(value)
                    self.badgeValueUser.append(badge)
                    if(!self.hideBadgeValue){
                        self.sumBadgeValues += Int(badge.badgeValue!)!
                        if(self.sumBadgeValues > 0){
                            self.tabBarItem.badgeValue = "1"
                        }
                    }
                }
            }
        }

        ref = Database.database().reference().child("User")
        
        for user in self.matchedUser{
            ref.observe(.value, with: { (shot) in
                guard shot.exists() else{
                    return
                }
                
                let allUserIn = shot.children.allObjects as! [DataSnapshot]
                
                for allUser in allUserIn{
                    let userAll = User()
                    
                    guard let allUserData = allUser.value as? [String : AnyObject] else{
                        return
                    }
                    if let img = allUserData["image"]{
                        self.img = img as! String
                    }
                    if let firstname = allUserData["firstname"]{
                        self.firstname = firstname as! String
                    }
                    if let lastname = allUserData["lastname"]{
                        self.lastname = lastname as! String
                    }
                    if let userUidPerson = allUserData["userUid"]{
                        self.userUidPerson = userUidPerson as! String
                    }
                    
                    userAll.imageUrl = self.img
                    userAll.firstname = self.firstname
                    userAll.lastname = self.lastname
                    userAll.userUid = self.userUidPerson
                    
                    if self.fetchAllUser.count != self.matchedUser.count && user == userAll.userUid{
                        self.fetchAllUser.append(userAll)
                    }
                }
                
                if(self.fetchAllUser.count == self.matchedUser.count && !matchedUserCounter){
                    for fetch in self.fetchAllUser{
                        let userAppend = MatchedUser()
                        userAppend.imageURL = fetch.imageUrl
                        userAppend.firstname = fetch.firstname
                        userAppend.lastname = fetch.lastname
                        userAppend.userUid = fetch.userUid
                        
                        self.liveMatchedUser.append(userAppend)
                    }
                    self.downloadImages(matchesUserImage: self.liveMatchedUser)
                    matchedUserCounter = true
                    
                    DispatchQueue.global().async {
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }, withCancel: nil)
        }
    }
    
    func downloadImages(matchesUserImage: [MatchedUser]){
        matchedImages = [UIImageView]()
        
        for user in matchesUserImage{
            let userImg = UIImageView()
            userImg.loadImageUsingCacheWithURLString(urlImg: user.imageURL!)
            matchedImages.append(userImg)
        }
    }
}

//To check if Array is OutOfRange and Catch it
extension Array {
    func getElement(at index: Int) -> Element? {
        let isValidIndex = index >= 0 && index < count
        return isValidIndex ? self[index] : nil
    }
}
