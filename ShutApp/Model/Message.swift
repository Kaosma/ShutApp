//
//  Message.swift
//  ShutApp
//
//  Created by Alexander Jansson on 2020-12-07.
//  Copyright © 2020 ShutAppOrg. All rights reserved.
//

import Foundation
import MessageKit

struct Message:MessageType {
    var sender : SenderType
    var messageId : String
    var sentDate : Date
    var kind : MessageKind
}

