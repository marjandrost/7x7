//
//  GameDetailViewController.swift
//  7x7
//
//  Created by Marjan Drost on 13-05-15.
//  Copyright (c) 2015 MD. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class GameDetailViewController: UIViewController, MKMapViewDelegate {
    // IBoutlets
    @IBOutlet weak var btnThuisteam: UIButton!
    @IBOutlet weak var btnUitteam: UIButton!
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var lblTegen: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lblTekstDezeWedstrijd: UILabel!
    @IBOutlet weak var lblClub: UILabel!
    @IBOutlet weak var lblAdres: UILabel!
    @IBOutlet weak var lblDatum: UILabel!
    @IBOutlet weak var lblTijd: UILabel!
    @IBOutlet weak var lblCategorie: UILabel!
    // IBActions
    @IBAction func showThuisTeam(sender: AnyObject) {
        welkteam = "Thuis"
        showTeam(welkteam)
    }
    
    @IBAction func showUitTeam(sender: AnyObject) {
        welkteam = "Uit"
        showTeam(welkteam)
    }
    
    // Variables
    var gameInfo: Game? // meegegeven vanuit prepareForSegue
    //var locatie: ClubInfo?
    //var locatie = Club()
    var locatie = Locatie()
    var locatiedata: NSDictionary?
    var spelerdata: NSArray?
    var welkteam = ""
    var teamNaam = ""
    var teamQuery = ""
    let regionRadius: CLLocationDistance = 2000
    let team = Team()
    let club = Club()
    var datumTekst = ""
    var formatter: NSDateFormatter = NSDateFormatter()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewWillAppear() {
  
    }

    func configureView() {
        /*
        var locatiegegevens = (meta["locaties_googlemaps"]) as NSDictionary
        var lat = (locatiegegevens["lat"]) as CLLocationDegrees
        var lng = (locatiegegevens["lng"]) as CLLocationDegrees
        var coord: CLLocationCoordinate2D?
        coord!.latitude = lat
        coord!.longitude = lng
        locatie?.coordinate = coord!
        */
        
        // get locatie info via clubId
        setLocatie()
         
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        formatter.dateFormat = "dd-MM-yyyy"
        
        lblDatum.text = formatter.stringFromDate(gameInfo!.wedstrijdDatum!)
        lblDatum.font = UIFont(name: AppFontName, size: 18)
        lblTijd.text = gameInfo!.wedstrijdTijd!
        lblTijd.font = UIFont(name: AppFontName, size: 18)
        lblCategorie.text = gameInfo!.categorie!
        lblCategorie.font = UIFont(name: AppFontName, size: 18)
        btnThuisteam.setTitle(gameInfo?.thuisTeam?.teamNaam, forState: UIControlState.Normal)
        btnThuisteam.titleLabel?.font = UIFont(name: AppFontName, size: 20)
        btnThuisteam.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        
        lblTegen.font = UIFont(name: AppFontName, size: 20)
        
        btnUitteam.setTitle(gameInfo?.uitTeam?.teamNaam, forState: UIControlState.Normal)
        btnUitteam.titleLabel?.font = UIFont(name: AppFontName, size: 20)
        btnUitteam.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        lblTekstDezeWedstrijd.text = "deze wedstrijd wordt gespeeld bij: "
        lblTekstDezeWedstrijd.font = UIFont(name: AppFontName, size: 18)
        lblClub.text = gameInfo!.locatie!.clubNaam
        lblClub.font = UIFont(name: AppFontName, size: 18)
        lblAdres.text = self.locatie.straatNr  + " " + self.locatie.plaats
        lblAdres.font = UIFont(name: AppFontName, size: 18)
        
        setAnnotation()
    }
    
    func setLocatie() {
        let vclubId = gameInfo!.locatie!.clubId
        let clubQuery = qryLocatie + String(vclubId)
        // dit niet met dispatch ivm tijdsafhankelijkheid: anders kon mapview niet getoond worden: adres gegevens waren nog niet beschikbaar
        locatiedata = dataOfJson(clubQuery)
        
        if let meta = (locatiedata!["meta"]) as? NSDictionary {
            if let vstraatNr = (meta["locaties_straat_en_nummer"]) as? String {
                locatie.straatNr = vstraatNr
            }
            if let vplaats = (meta["locaties_plaats"]) as? String {
                locatie.plaats = vplaats
            }
        }
    }
    
    func showTeam(welkteam : String) {
        var teamId = 0
        switch welkteam {
            case "Thuis":
             teamId = gameInfo!.thuisTeam!.teamId!
             teamNaam = gameInfo!.thuisTeam!.teamNaam!
            case "Uit":
            teamId = gameInfo!.uitTeam!.teamId!
            teamNaam = gameInfo!.uitTeam!.teamNaam!
        default:
            showError()
        }
        
        team.fetchTeamPlayers(teamId) {
            dispatch_async(dispatch_get_main_queue()) {
               
                self.showPlayers()
            }
        }
    }
    func showError() {
     print("fout opgetreden")
    }
    
    func showPlayers() {
        var players = team.getPlayers()
        // toon spelers van team
        // Om de spelers onderin in het scherm te tonen kan de preferredStyle naar .ActionSheet gezet worden.
        let playersController: UIAlertController = UIAlertController(title: "Spelers \(teamNaam)", message: nil, preferredStyle: .Alert)
        var playerAction:UIAlertAction
        if players.count == 0 {
            playerAction = UIAlertAction(title: "Geen spelers bekend", style: .Default, handler: nil)
            playersController.addAction(playerAction)
        } else {
            for i in 0...(players.count - 1) {
                playerAction = UIAlertAction(title: "\(players[i].playerNaam)", style: .Default, handler: nil)
                playersController.addAction(playerAction)
            }
        }
        
        let OKAction:UIAlertAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        playersController.addAction(OKAction)
        self.presentViewController(playersController, animated: true, completion: nil)
    }
    
    
        // MARK
    // MApView methods
    func setAnnotation() {
        let geoCoder = CLGeocoder()
        
        let adres =  lblAdres.text
        geoCoder.geocodeAddressString(adres!, completionHandler:
            {(placemarks, error) in
                
                if error != nil {
                    print("Geocode failed with error: \(error!.localizedDescription)")
                } else if placemarks!.count > 0 {
                    let placemark = placemarks?[0]
                    let location = placemark!.location
                    let clubInfo = ClubInfo(
                        clubNaam: self.club.clubNaam,
                        straatNr: self.locatie.straatNr,
                        plaats: self.locatie.plaats,
                        coordinate: location!.coordinate)
                    self.centerMapOnLocation(location!)
                    self.mapView.addAnnotation(clubInfo)
                    
                }
        })
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var view: MKPinAnnotationView
        let identifier = "pin"
        if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            // view.canShowCallout = true
            // view.calloutOffset = CGPoint(x: -5, y: 5)
            // view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as UIView
        }
        
        return view
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    func dataOfJson(url: String) -> NSDictionary {
        let data = NSData(contentsOfURL: NSURL(string: url)!)
//var jsonError: NSError?
        return ((try! NSJSONSerialization.JSONObjectWithData(data!, options: [])) as! NSDictionary)
    }
    

}
