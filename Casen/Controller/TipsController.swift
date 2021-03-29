//
//  TipsController.swift
//  Casen
//
//  Created by Ebu Bekir Celik on 29.07.19.
//  Copyright © 2019 KeepEasy. All rights reserved.
//

import UIKit

class TipsController: UIViewController {

    var screenSizes = UIScreen.main.bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        implementElements()
    }
    
    //sehr wichtig zum Positionieren des Textes genau Vertikal in die Mitte
    override func viewDidLayoutSubviews() {
        textSheet.centerVertically()
    }
    
    let textSheet: UITextView = {
        let txt = UITextView()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.textAlignment = NSTextAlignment.center
        txt.layer.cornerRadius = 20
        txt.layer.shadowColor = UIColor.gray.cgColor
        txt.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        txt.layer.shadowOpacity = 1.0
        txt.layer.shadowRadius = 5.0
        txt.layer.masksToBounds = false
        txt.backgroundColor = UIColor.white
        txt.isEditable = false
        txt.isSelectable = false
        txt.font = UIFont.italicSystemFont(ofSize: 18)
        return txt
    }()
    
    func implementElements(){
        view.addSubview(textSheet)
        textSheet.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -90).isActive = true
        textSheet.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textSheet.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2/3).isActive = true
        textSheet.widthAnchor.constraint(equalToConstant: screenSizes.width-50).isActive = true
    }
    
    func addDatingTip(tip: String){
        textSheet.text = tip
    }

}

extension UITextView {
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
}
