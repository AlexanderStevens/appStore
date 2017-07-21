//
//  Models.swift
//  appStore1
//
//  Created by AlexS on 21/09/2016.
//  Copyright © 2016 AStevensProductions. All rights reserved.
//

import Foundation

class FeaturedApps:NSObject {
    var bannerCategory: AppCategory?
    var appCategories: [AppCategory]?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "categories" {
            appCategories = [AppCategory]()
            
            for dict in value as! [[String:AnyObject]] {
                let appCategory = AppCategory()
                appCategory.setValuesForKeys(dict)
                appCategories?.append(appCategory)
            }
        }
        else if key == "bannerCategory" {
            bannerCategory = AppCategory()
            bannerCategory?.setValuesForKeys(value as! [String:AnyObject])
            
        }else {
            super.setValue(value, forKey: key)
        }
    }
}

class AppCategory: NSObject {
    var name: String?
    var apps: [App]?
    var type: String?
    fileprivate var appID:NSNumber = 1
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "apps" {
            apps = [App]()
            for dict in value as! [[String:AnyObject]] {
                let app = App()
                app.setValuesForKeys(dict)
                
                apps?.append(app)
            }
            
        } else {
            super.setValue(value, forKey: key)
        }
    }
    
    static func fetchFeaturedApps(_ completionHandler: @escaping (FeaturedApps)->()) {
    
    let urlString = "http://www.statsallday.com/appstore/featured"
    URLSession.shared.dataTask(with: URL(string: urlString)!, completionHandler: { (data, response, error) -> Void in
        
        if error != nil {
            print(error!)
            return
        }
        
        do {
            
            let json = try  JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:Any]
            
            let featuredApps = FeaturedApps()
            featuredApps.setValuesForKeys(json as [String:AnyObject])
            
            
            for dict in json["categories"] as! [[String:AnyObject]] {
                
                let appCategory = AppCategory()
                
            
                
                DispatchQueue.main.async(execute: { ()-> Void in
                    
                    completionHandler(featuredApps)
                })
            }
            
        } catch let error as NSError{
            print(error)        }
        }) .resume()
    }
    
    static func sampleAppCategories()-> [AppCategory] {
        var categoryArray = [AppCategory]()
        
        let bestNewAppsCategory = AppCategory()
        bestNewAppsCategory.name = "Best New Apps"
        
        var apps = [App]()
        
        let frozenApp = App()
        frozenApp.name = "frozen"
        frozenApp.category = "Entertainment"
        frozenApp.imageName = "Frozen"
        frozenApp.price = NSNumber(value: 3.99 as Float)
        apps.append(frozenApp)
        bestNewAppsCategory.apps = apps
        categoryArray.append(bestNewAppsCategory)
        
        apps = [App]()
        let thisApp = App()
        thisApp.name = "Sample App"
        thisApp.category = "Games"
        thisApp.imageName = "Frozen"
        thisApp.price = NSNumber(value: 2.99 as Float)
        apps.append(thisApp)
        apps.append(frozenApp)

                
        let bestNewGamesCatergory = AppCategory()
        bestNewGamesCatergory.name = "Best New Games"
        bestNewGamesCatergory.apps = apps
        categoryArray.append(bestNewGamesCatergory)
        
        return categoryArray
    }
    
}

class App : NSObject {
    var id: NSNumber?
    var name: String?
    var category: String?
    var imageName: String?
    var price: NSNumber?
    
    var screenshots :[String]?
    var desc: String?
    var appInformation: AnyObject?
    
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "description" {
            self.desc = value as? String
        }
        else {
            super.setValue(value, forKey: key)
        }
    }
    
}
