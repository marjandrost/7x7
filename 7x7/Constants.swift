//
//  Constants.swift
//  7x7
//
//  Created by Marjan Drost on 22-05-15.
//  Copyright (c) 2015 MD. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

let AppFontName = "AgencyFB-Bold"
let appColor = UIColor(red: 220/255, green: 41/255, blue: 41/255, alpha: 1)
//
let recipientsKey = "EmailOntvanger"
let vraagRecipient = "T.vanBeek@sportbedrijfdeventer.nl"
//
let qryGames = "http://7x7deventer.nl/wp-json/posts?type[]=wedstrijden"
let qryDates = "http://7x7deventer.nl/wp-json/posts?type%5B%5D=wedstrijddatum"
let qryClubs = "http://7x7deventer.nl/wp-json/posts?type[]=club"
let qrySpelersPerTeam = "http://7x7deventer.nl/spelers-per-team/?team=" // hieraan nog teamId toevoegen!
let qryLocaties = "http://7x7deventer.nl/wp-json/posts?type[]=locatie"
let qryLocatie = "http://7x7deventer.nl/wp-json/posts/" // hieraan nog clubId toevoegen!

// 7x7 tabblad teksten
let txtNog:String = "nog "
let txtTot:String = " tot de eerstvolgende wedstrijdronde"
let txtGeen:String = "de volgende wedstrijdronde is nog niet bekend "
let txtVandaag:String = " vandaag is de eerstvolgende speelronde"
let txtGeenInternet: String = "Zorg ervoor dat je toestel is verbonden met internet en probeer opnieuw"
let txtGeenWedstrijd:String = "Er zijn nog geen wedstrijden gepland, probeer het later nog eens!"

// Tbv Pickers voor speeldatum en club
var datumFrame = CGRect(x: 14, y: 250, width: 300, height: 162)
var clubFrame = CGRect(x: 14, y: 164, width: 300, height: 162)


// 
var gvCategorie:String = "35+"
let gvCategorie35 = "35+"
let gvCategorie45 = "45+"