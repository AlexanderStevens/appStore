//
//  ScreenShot.swift
//  appStore1
//
//  Created by AlexS on 10/01/2017.
//  Copyright © 2017 AStevensProductions. All rights reserved.
//

import UIKit

class ScreenShotCell: BaseCell,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate, UICollectionViewDataSource {
    
    let cellID = "cellID"
    
    var app: App? {
        didSet{
            collectionView.reloadData()
        }
    }
    
    let collectionView :UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
       let cV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cV.backgroundColor = UIColor.white
        return cV
    }()
    
    
    let dividerLineView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white:0.4,alpha: 0.8)
        return view
    }()
    
    override func setUpViews() {
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        addSubview(collectionView)
        addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        addConstraintsWithFormat("V:|[v0]|", views: collectionView,dividerLineView)
        
        addSubview(dividerLineView)
        addConstraintsWithFormat("H:|-5-[v0]-5-|", views: dividerLineView)
        addConstraintsWithFormat("V:|-175-[v0(1)]|", views: dividerLineView)
        
        collectionView.backgroundColor = UIColor.white
        collectionView.register(ScreenShotImageCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = app?.screenshots?.count {
            return count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ScreenShotImageCell
        if let imageName = app?.screenshots?[indexPath.item] {
            cell.imageView.image = UIImage(named: imageName)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 240, height: frame.height-20)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0,left: 14,bottom: 0,right: 14)
    }
    
}

class ScreenShotImageCell : BaseCell{
    
    let imageView :UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        
        return iv
    }()
    
    override func setUpViews() {
        super.setUpViews()
        
        layer.masksToBounds = true
        addSubview(imageView)
        addConstraintsWithFormat("H:|[v0]|", views: imageView)
        addConstraintsWithFormat("V:|[v0]|", views: imageView)
    }
    
}
