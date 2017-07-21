//
//  AppDetailViewController.swift
//  appStore1
//
//  Created by AlexS on 08/01/2017.
//  Copyright © 2017 AStevensProductions. All rights reserved.
//

import UIKit

class AppDetailViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let headerID = "headerID"
    fileprivate let cellID = "cellID"
    fileprivate let descritionCellID = "dCellId"
    fileprivate let appInfoCellId = "aICellID"
    var app :App? {
        didSet{
            
            if app?.screenshots != nil {
                return
            }
            if let id = app?.id {
                print(id)
                let urlString = "http://www.statsallday.com/appstore/appdetail?id=\(id)"
                
                URLSession.shared.dataTask(with: URL(string: urlString)!, completionHandler: {
                    (data, response, error)-> Void in
                    
                    if error != nil {
                        print(error)
                        return
                    }
                    
                    do {
                        let json = try(JSONSerialization.jsonObject(with: data!,
                            options: .mutableContainers))
                        
                        let appDetail = App()
                        appDetail.setValuesForKeys(json as! [String: AnyObject])
                        print("App id = \(self.app?.id)")
                        print("App Name =\(self.app?.name)")
                        
                        self.app = appDetail
                        
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.collectionView?.reloadData()
                        })
                        
                    }
                    catch let jsonError {
                        print(jsonError)
                    }
                    
                    
                }).resume()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("In View Did Load")
        
        collectionView?.backgroundColor = UIColor.white
        
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.register(AppDetailHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerID)
        collectionView?.register(ScreenShotCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.register(DescriptionCell.self, forCellWithReuseIdentifier: descritionCellID)
        collectionView?.register(AppInfoCell.self, forCellWithReuseIdentifier: appInfoCellId)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item == 1 {
            let size = CGSize(width: view.frame.width - 8 - 8 , height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
            let rect = descriptionAttributedText(indexPath).boundingRect(with: size, options: options, context: nil)
            
            return CGSize(width: view.frame.width, height: rect.height + 25)
        }
        
        return CGSize(width: view.frame.width, height: 170)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: descritionCellID, for: indexPath) as! DescriptionCell
            
            cell.textView.attributedText = descriptionAttributedText(indexPath)
           
            return cell
        }
        else if indexPath.item == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: appInfoCellId, for: indexPath) as! AppInfoCell
            
            cell.textView.attributedText = descriptionAttributedText(indexPath)
            
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ScreenShotCell
        cell.app = app
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    fileprivate func descriptionAttributedText(_ indexPath:IndexPath) -> NSAttributedString {
        if indexPath.item == 1 {
        let attributedText = NSMutableAttributedString(string: "Description:\n\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)])
        
            if let desc = app?.desc {
                attributedText.append(NSMutableAttributedString(string: "- \(desc)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor.darkGray]))
                }
                return attributedText
        }
        
        let attributedText = NSMutableAttributedString(string: "App Information:\n\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)])
        
        if let appInfo = app?.appInformation as? [[String:String]]{
            for info in appInfo {
                let name = info["Name"]
                let value = info["Value"]
                
                attributedText.append(NSMutableAttributedString(string: "\(name!) :", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor.darkGray]))
                attributedText.append(NSMutableAttributedString(string: "\(value!)\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor.darkGray]))
                
                
            }
        }
        
        return attributedText
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for:indexPath) as! AppDetailHeader
        header.app = app
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 170)
    }
    
}


class AppDetailHeader : BaseCell {
    
    var app:App? {
        didSet {
            if let imageName = app?.imageName{
            imageView.image = UIImage(named: imageName)
            }
            if let name = app?.name {
                nameLabel.text = name
            }
            if let price = app?.price?.stringValue {
                print("App has proce")
                buyButton.setTitle("$\(price)", for: UIControlState())
            }else {
                buyButton.titleLabel?.text = "Free"
            }
        }
    }
    
    let imageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let segmentedControll:UISegmentedControl = {
        let sc = UISegmentedControl(items:["Details","Reviews","Related"])
        sc.tintColor = UIColor.darkGray
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    let buyButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("BUY", for: UIControlState())
        button.layer.borderColor = UIColor(red: 0, green: 129/255, blue: 205/255, alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(UIColor(red: 0, green: 129/255, blue: 205/255, alpha: 0.85), for: UIControlState())
        return button
    }()
    
    let dividerLineView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white:0.4,alpha: 0.8)
        return view
    }()
    
    override func setUpViews() {
        super.setUpViews()
        
        addSubview(imageView)
        addSubview(nameLabel)
        
        addConstraintsWithFormat("H:|-14-[v0(100)]-8-[v1]|", views: imageView, nameLabel)
        addConstraintsWithFormat("V:|-14-[v0(100)]|", views: imageView)
        
        addConstraintsWithFormat("V:|-14-[v0(40)]|", views: nameLabel)
        
        addSubview(segmentedControll)
        addSubview(dividerLineView)

        addConstraintsWithFormat("H:|-44-[v0]-40-|", views: segmentedControll)
        addConstraintsWithFormat("H:|-5-[v0]-5-|", views: dividerLineView)
        addConstraintsWithFormat("V:[v0(34)]-15-[v1(1)]|", views: segmentedControll,dividerLineView)
        
        addSubview(buyButton)
        addConstraintsWithFormat("H:[v0(60)]-14-|", views: buyButton)
        addConstraintsWithFormat("V:[v0(32)]-56-|", views: buyButton)
        print(buyButton.titleLabel?.text!)
        
        
    }
    
}
extension UIView {
    func addConstraintsWithFormat(_ format: String, views:UIView...) {
        var viewDictionary = [String:UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewDictionary[key] = view
            
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewDictionary))
    }
}

class BaseCell :UICollectionViewCell {
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        
    }
}
