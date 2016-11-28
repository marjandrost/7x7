//
//  Game.swift
//  7x7
//
//  Created by Marjan Drost on 13-05-15.
//  Copyright (c) 2015 MD. All rights reserved.
//

import UIKit

class Game: NSObject {
    var wedstrijdDatum: NSDate?
    var wedstrijdTijd: String?
    var thuisTeam: Team?
    var uitTeam: Team?
    var locatie: Club?
    var categorie: String?
    
    override init() {
        super.init()
        
    }
    

}
