//
//  7x7ViewController.swift
//  7x7
//
//  Created by Marjan Drost on 11-05-15.
//  Copyright (c) 2015 MD. All rights reserved.
//

import UIKit



class _x7ViewController: UIViewController {

    @IBOutlet weak var lblDagenTekst: UILabel!

    let datumPickerData = DatumPickerData()
    let userCalendar = Calendar.current
    let days:NSCalendar.Unit = .day
    let today = Date()
    var dagenText:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureView() {
        // set Font for the textlabel
        lblDagenTekst.font = UIFont(name: AppFontName, size: 22)
        // alleen als er internet verbinding is kan onderstaande worden uitgevoerd!
        if Reachability.isConnectedToNetwork() == true {
        // get future gamedates, to calculate numberofdays before next game
        datumPickerData.fetchDatums {
            DispatchQueue.main.async {
                if let nextGame = self.datumPickerData.speelData[0].speelDatum {
                    let numberOfDays = self.calculateNumberOfDays(nextGame as Date)
                    if numberOfDays == 0 {
                        // speeldatum is vandaag
                        self.lblDagenTekst.text = txtVandaag
                        let vandaagAttr = [NSForegroundColorAttributeName : UIColor.black]
                        let myTekst = NSMutableAttributedString(string: txtVandaag, attributes: vandaagAttr)
                        myTekst.addAttribute(NSForegroundColorAttributeName, value: appColor, range: NSRange(location:1,length:8))
                        self.lblDagenTekst.attributedText = myTekst
                    } else {
                        self.lblDagenTekst.text = " nog \(numberOfDays) dagen tot de volgende speelronde"
                        if numberOfDays > 1 {
                           self.dagenText = "\(numberOfDays) dagen"
                        }
                        else {
                            self.dagenText = "\(numberOfDays) dag"
                        }
                        let tempText  = txtNog + self.dagenText + txtTot
                        //let rangeNog = NSRange(location: 0, length: count(txtNog))
                        //let rangeTot = NSRange(location: count(txtNog), length: count(dagenText))
                        let nogAttr = [NSForegroundColorAttributeName: UIColor.black]
                        let myText = NSMutableAttributedString(string: tempText, attributes: nogAttr)
                        myText.addAttribute(NSForegroundColorAttributeName, value: appColor, range: NSRange(location:txtNog.characters.count,length:self.dagenText.characters.count))
                        self.lblDagenTekst.attributedText = myText 
                    }
                } else {
                    // geen speeldatum gevonden: 
                    self.lblDagenTekst.text = txtGeen
                }
            }
        }
        }
        
        else {
            // geen internetconnection
            self.lblDagenTekst.text = txtGeenInternet
            let alert = UIAlertView(title: "Geen internet verbinding!", message: txtGeenInternet, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    func calculateNumberOfDays(_ nextGame:Date) -> Int {
        let diff = (Calendar.current as NSCalendar).components(days, from: today, to: nextGame, options: [])
        return diff.day! 
        
    }
    
 }
