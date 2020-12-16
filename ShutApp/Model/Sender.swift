//
//  Sender.swift
//  ShutApp
//
//  Created by Alexander Jansson on 2020-12-07.
//  Copyright © 2020 ShutAppOrg. All rights reserved.
//

import Foundation
import MessageKit

struct Sender: SenderType {
    var senderId: String
    var displayName: String
    var senderEmail: String
}
