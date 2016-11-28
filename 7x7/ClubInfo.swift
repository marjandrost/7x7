//
//  ClubInfo.swift
//  7x7
//
//  Created by Marjan Drost on 13-05-15.
//  Copyright (c) 2015 MD. All rights reserved.
//
// Deze class wordt gebruikt voor het tonen van de MapKit bij GameDetailViewController

import UIKit
import MapKit

class ClubInfo: NSObject , MKAnnotation {
    var data: NSArray = []
    var clubNaam: String = ""
    var straatNr: String = ""
    var plaats: String = ""
    var coordinate: CLLocationCoordinate2D
    
    init(clubNaam: String, straatNr: String, plaats: String, coordinate: CLLocationCoordinate2D) {
        
        
        self.clubNaam = clubNaam
        self.straatNr = straatNr
        self.plaats = plaats
        self.coordinate = coordinate
        
    }
    var title: String? {
        return self.clubNaam
    }
    
    var subtitle: String? {
        return self.plaats    }
    
    
}
