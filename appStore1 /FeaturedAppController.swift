//
//  ViewController.swift
//  appStore1
//
//  Created by AlexS on 20/09/2016.
//  Copyright © 2016 AStevensProductions. All rights reserved.
//

import UIKit

class FeaturedAppController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellID = "cellID"
    fileprivate let largeCellID = "largeCellID"
    fileprivate let headerID = "headerID"
    
    var appCategories :[AppCategory]?
    var featuredApps:FeaturedApps?
    var myActivityIndicator : UIActivityIndicatorView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Featured Apps"
        
        myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        
        
        myActivityIndicator!.center = view.center
        myActivityIndicator!.startAnimating()
        view.addSubview(myActivityIndicator!)
        
      //  appCategories = AppCategory.sampleAppCategories()
        AppCategory.fetchFeaturedApps  {(featuredApps)-> () in
            self.featuredApps = featuredApps
            self.appCategories = featuredApps.appCategories
            self.collectionView?.reloadData()
            self.myActivityIndicator!.stopAnimating()
        }
        // Do any additional setup after loading the view, typically from a nib.
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(CatagoryCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.register(LargeCategoryCell.self, forCellWithReuseIdentifier: largeCellID)
        collectionView?.register(Header.self,forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerID)
        
        
    }
    
    
    
    
    func showAppDetailForApp(_ app:App) {
        
        let layout = UICollectionViewFlowLayout()
        let appDetailViewController = AppDetailViewController(collectionViewLayout: layout)
        appDetailViewController.app = app
        navigationController?.pushViewController(appDetailViewController, animated: true)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 2 {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: largeCellID, for: indexPath) as! LargeCategoryCell
            cell.appCategory = (appCategories?[indexPath.item])!
            cell.featuredAppsController = self
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CatagoryCell
        
        cell.appCategory = (appCategories?[indexPath.item])!
        cell.featuredAppsController = self
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = appCategories?.count {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 2 {
            return CGSize(width: view.frame.width, height: 160)
        }
        return CGSize(width: view.frame.width, height: 230)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as! Header
        
        header.appCategory = featuredApps?.bannerCategory
        
        return header
    }
}


class LargeCategoryCell: CatagoryCell {
    
    fileprivate let largeCellID = "largeCellID"
    
    override func setUpViews() {
        super.setUpViews()
        appsCollectionView.register(LargeAppCell.self, forCellWithReuseIdentifier: largeCellID)

    }

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: frame.height-32)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: largeCellID, for: indexPath) as! LargeAppCell
        cell.app = appCategory?.apps?[indexPath.item]
        return cell
    }
    
    fileprivate class LargeAppCell: AppCell {
        fileprivate override func setUpViews() {
            
            imageView.layer.cornerRadius = 16
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
           
           addSubview(imageView)
            
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":imageView]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-2-[v0]-14-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":imageView]))
        }
    }
}

class Header:CatagoryCell {
    
    let bannerID = "bannerCellID"
    override func setUpViews() {
        appsCollectionView.dataSource = self
        appsCollectionView.delegate = self
        
        appsCollectionView.register(BannerCell.self, forCellWithReuseIdentifier: bannerID)
        addSubview(appsCollectionView)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":appsCollectionView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":appsCollectionView]))
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 2 + 50, height: frame.height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: bannerID, for: indexPath) as! BannerCell
        cell.app = appCategory?.apps?[indexPath.item]
        return cell
    }
    
    fileprivate class BannerCell: AppCell {
        fileprivate override func setUpViews() {
            imageView.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).cgColor
            imageView.layer.borderWidth = 0.5
            imageView.layer.cornerRadius = 16
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(imageView)
            
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":imageView]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]-5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":imageView]))
        }
    }
}
