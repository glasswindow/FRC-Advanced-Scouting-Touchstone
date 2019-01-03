//
//  CognitoAuthProvider.swift
//  FRC Advanced Scouting Touchstone
//
//  Created by Aaron Kampmeier on 12/19/18.
//  Copyright © 2018 Kampfire Technologies. All rights reserved.
//

import Foundation
import AWSAppSync
import AWSMobileClient

class FASTCognitoUserPoolsAuthProvider: AWSCognitoUserPoolsAuthProviderAsync {
    func getLatestAuthToken(_ callback: @escaping (String?, Error?) -> Void) {
        AWSMobileClient.sharedInstance().getTokens {tokens, error in
            callback(tokens?.accessToken?.tokenString, error)
        }
    }
}
