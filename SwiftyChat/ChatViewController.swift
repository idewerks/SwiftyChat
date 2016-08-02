//
//  ChatViewController.swift
//  SwiftyChat
//
//  Created by kevin brennan on 7/31/16.
//  Copyright © 2016 kevin brennan. All rights reserved.
//

import UIKit
import Firebase




class ChatViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  @IBAction func signOut(sender: UIButton) {

    
    let firebaseAuth = FIRAuth.auth()
    do {
      try firebaseAuth?.signOut()
      AppState.sharedInstance.signedIn = false
      performSegueWithIdentifier(Constants.Segues.ChatToSignIn, sender: nil)
    } catch let signOutError as NSError {
      print ("Error signing out: \(signOutError)")
    }
    
    
    
    
    
    
  }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
