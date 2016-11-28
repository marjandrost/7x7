//
//  Club.swift
//  7x7
//
//  Created by Marjan Drost on 13-05-15.
//  Copyright (c) 2015 MD. All rights reserved.
//

import UIKit

class Club: NSObject {
    var clubId: Int = 0
    var clubNaam: String = ""
    var contactPersoon: String = ""
    var email: String = ""
    var telefoon: String = ""
    var locatie = Locatie()
    
    override init() {
        super.init()
    }
 
}
