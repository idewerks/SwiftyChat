//
//  Constants.swift
//  Chatty McChatface
//
//  Created by kevin brennan on 5/31/16.
//  Copyright © 2016 kevin brennan. All rights reserved.
//

struct Constants {
  
  struct NotificationKeys {
    static let SignedIn = "onSignInCompleted"
  }
  
  struct Segues {
    static let SignInToChat = "SignInToChat"
    static let ChatToSignIn = "ChatToSignIn"
  }
  
  struct MessageFields {
    static let name = "name"
    static let text = "text"
    static let photoUrl = "photoUrl"
    static let imageUrl = "imageUrl"
    static let dateSent = "dateSent"
  }
}