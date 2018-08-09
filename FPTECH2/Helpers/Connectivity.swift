//
//  Connectivity.swift
//  FPTECH2
//
//  Created by Manoj Bojja on 09/08/18.
//  Copyright © 2018 Manoj Bojja. All rights reserved.
//

import Foundation
import Alamofire

struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet:Bool {
        return self.sharedInstance.isReachable
    }
}
