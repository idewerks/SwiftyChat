//
//  Copyright (c) 2015 Google Inc.
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

import FirebaseAuth
import TwitterKit
import FBSDKCoreKit
import FBSDKLoginKit

@objc(SignInViewController)
class SignInViewController: UIViewController {
  
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  
  override func viewDidAppear(animated: Bool) {
    if let user = FIRAuth.auth()?.currentUser {
      self.signedIn(user)
    }
  }
  
  @IBAction func didTapSignIn(sender: AnyObject) {
    // Sign In with credentials.
    let email = emailField.text
    let password = passwordField.text
    FIRAuth.auth()?.signInWithEmail(email!, password: password!) { (user, error) in
      if let error = error {
        print(error.localizedDescription)
        return
      }
      self.signedIn(user!)
    }
  }
  
  
  
  @IBAction func didTapSignUp(sender: AnyObject) {
    let email = emailField.text
    let password = passwordField.text
    FIRAuth.auth()?.createUserWithEmail(email!, password: password!) { (user, error) in
      if let error = error {
        print(error.localizedDescription)
        return
      }
      self.setDisplayName(user!)
    }
  }
  
  
  
  
  
  func setDisplayName(user: FIRUser) {
    let changeRequest = user.profileChangeRequest()
    changeRequest.displayName = user.email!.componentsSeparatedByString("@")[0]
    changeRequest.commitChangesWithCompletion(){ (error) in
      if let error = error {
        print(error.localizedDescription)
        return
      }
      self.signedIn(FIRAuth.auth()?.currentUser)
    }
  }
  
  
  
  
  
  
  
  @IBAction func didRequestPasswordReset(sender: AnyObject) {
    let prompt = UIAlertController.init(title: nil, message: "Email:", preferredStyle: UIAlertControllerStyle.Alert)
    let okAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Default) { (action) in
      let userInput = prompt.textFields![0].text
      if (userInput!.isEmpty) {
        return
      }
      FIRAuth.auth()?.sendPasswordResetWithEmail(userInput!) { (error) in
        if let error = error {
          print(error.localizedDescription)
          return
          
        }
      }
    }
    
    prompt.addTextFieldWithConfigurationHandler(nil)
    prompt.addAction(okAction)
    presentViewController(prompt, animated: true, completion: nil)
  }
 
  @IBAction func TwitterLoginButton(sender: AnyObject) {
    
    Twitter.sharedInstance().logInWithCompletion { session, error in
      if (session != nil) {
        print("signed in as \(session!.userName)")
        let credential = FIRTwitterAuthProvider.credentialWithToken(session!.authToken, secret: session!.authTokenSecret)
       
        FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
          
          if (user != nil){
           self.signedIn(FIRAuth.auth()?.currentUser)
            
          }else{
           print("user nil error: \(error!.localizedDescription)")
          }
        }//-
      
      } else {
        print("session error: \(error!.localizedDescription)")
      }
    }
  }
  
  
  
  @IBAction func FacebookLoginButton(sender: AnyObject) {
    
    let loginManager = FBSDKLoginManager()
    loginManager.logInWithReadPermissions(["email"], fromViewController: self, handler: { (result, error) in
      if let error = error {
        print(error.localizedDescription)
      } else if(result.isCancelled) {
        print("FBLogin cancelled")
      } else {
        // [START headless_facebook_auth]
        let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
        // [END headless_facebook_auth]
        self.firebaseLogin(credential)
        
        
      }
    })

}
  
  func firebaseLogin(credential: FIRAuthCredential) {
    
      if let user = FIRAuth.auth()?.currentUser {
        user.linkWithCredential(credential) { (user, error) in
       
            if let error = error {
              print(error.localizedDescription)
              return
            }
          }
        }else {
        //link success
        FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
            //if let error = error {
              //print(error.localizedDescription)
              //return
           // }
          if (user != nil){
            self.signedIn(FIRAuth.auth()?.currentUser)
            
          }else{
            print("user nil error: \(error!.localizedDescription)")
          }
          
   
          }//-[sign in with credential]
        
        
        
        
        
        
        }
      }

  
  
  
  
  
  
  
  
  
  
  func signedIn(user: FIRUser?) {
    MeasurementHelper.sendLoginEvent()
    
    AppState.sharedInstance.displayName = user?.displayName ?? user?.email
    AppState.sharedInstance.photoUrl = user?.photoURL
    
    AppState.sharedInstance.signedIn = true
    NSNotificationCenter.defaultCenter().postNotificationName(Constants.NotificationKeys.SignedIn, object: nil, userInfo: nil)
    performSegueWithIdentifier(Constants.Segues.SignInToChat, sender: nil)
  }
  
  
  
}

