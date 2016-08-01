//
//  AppDelegate.swift
//  Chatty McChatface
//
//  Created by kevin brennan on 5/31/16.
//  Copyright © 2016 kevin brennan. All rights reserved.
//
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit

import Firebase
import GoogleSignIn
import FBSDKCoreKit
import Fabric
import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  
  
  func application(application: UIApplication, didFinishLaunchingWithOptions
    launchOptions: [NSObject: AnyObject]?) -> Bool {
    
  
    
      
    
    
    FIRApp.configure()
   // FIRDatabase.database().persistenceEnabled = true
    //-----------------
 // [END firebase_configure]
    
 //Facebook authentication
 FBSDKApplicationDelegate.sharedInstance().application(application,
 didFinishLaunchingWithOptions:launchOptions)
    
    
 //Twitter authentication
 let key = NSBundle.mainBundle().objectForInfoDictionaryKey("consumerKey"),
 secret = NSBundle.mainBundle().objectForInfoDictionaryKey("consumerSecret")
 if let key = key as? String, secret = secret as? String
 where key.characters.count > 0 && secret.characters.count > 0 {
 Twitter.sharedInstance().startWithConsumerKey(key, consumerSecret: secret)
 }
 
    return true
  }
  
  @available(iOS 9.0, *)
  func application(application: UIApplication, openURL url: NSURL, options: [String : AnyObject])
    -> Bool {
      return self.application(application,
                              openURL: url,
                              sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] as! String?,
                              annotation: [:])
  }
  
  func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
    if GIDSignIn.sharedInstance().handleURL(url,
                                            sourceApplication: sourceApplication,
                                            annotation: annotation) {
      return true
    }
    return FBSDKApplicationDelegate.sharedInstance().application(application,
                                                                 openURL: url,
                                                                 sourceApplication: sourceApplication,
                                                                 annotation: annotation)
  }
  

}