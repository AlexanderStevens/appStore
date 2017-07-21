//
//  DescriptionCell.swift
//  appStore1
//
//  Created by AlexS on 11/01/2017.
//  Copyright © 2017 AStevensProductions. All rights reserved.
//

import UIKit

class DescriptionCell :BaseCell {
    
    let textView : UITextView = {
      let tv = UITextView()
        tv.isEditable = false
        return tv
    }()
    
    let dividerLineView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white:0.4,alpha: 0.8)
        return view
    }()
    
    
    override func setUpViews() {
        super.setUpViews()
        addSubview(textView)
        addSubview(dividerLineView)
        
        addConstraintsWithFormat("H:|-0-[v0]-0-|", views: textView)
        addConstraintsWithFormat("V:|-4-[v0]-10-[v1(1)]|", views: textView, dividerLineView)
        addConstraintsWithFormat("H:|-5-[v0]-5-|", views: dividerLineView)
        

    }
    
}

class AppInfoCell : BaseCell {
    
    let textView :UITextView = {
        let tv = UITextView()
        tv.text = "Sample"
        
        return tv
        
    }()
    
    override func setUpViews() {
        super.setUpViews()
        
        addSubview(textView)
        addConstraintsWithFormat("H:|[v0]|", views: textView)
        addConstraintsWithFormat("V:|[v0]|", views: textView)
        
    }
}
