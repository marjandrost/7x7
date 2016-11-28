//
//  InschrijvenViewController.swift
//  7x7
//
//  Created by Marjan Drost on 15-05-15.
//  Copyright (c) 2015 MD. All rights reserved.
//

import UIKit
import MessageUI

class InschrijvenViewController: UIViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate,  UIScrollViewDelegate {

    @IBOutlet weak var lblGroot: UILabel!
    @IBOutlet weak var lblKlein: UILabel!
    
    @IBOutlet weak var txtNaam: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPlaats: UITextField!
    @IBOutlet weak var txtGebDatum: UITextField!
    @IBOutlet weak var btnInschrijven: UIButton!
    @IBOutlet weak var txtClub: UITextField!
    @IBOutlet weak var txtSpeelDatum: UITextField!
    
    @IBOutlet weak var btnKiesClub: UIButton!
    @IBOutlet weak var svScrollView: UIScrollView!
    
    @IBOutlet weak var btnKiesGebdatum: UIButton!
    @IBAction func SelectClub(sender: UIButton) {
        txtClub.text = clubPickerData.selectedClub.clubNaam
        vEmailClub = clubPickerData.selectedClub.email
        self.view.endEditing(true)
    }
    
    @IBOutlet weak var btnKiesDatum: UIButton!
    
    @IBAction func SelectDate(sender: UIButton) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if let vselectedDate = datumPickerData.selectedDate {
            txtSpeelDatum.text = dateFormatter.stringFromDate(vselectedDate)
        }
        self.view.endEditing(true)
    }
    var vEmailClub: String = "" // Om emailadres van de club in te bewaren
    var datePickerView:UIDatePicker = UIDatePicker()
    var pickerHeight: CGFloat = 0.0
    var keyboardHeight: CGFloat = 0.0
    var toRect: CGRect = datumFrame

    @IBAction func SelectGebdatum(sender: UIButton) {
        self.view.endEditing(true)    }
    
    @IBAction func textFieldEditing(sender: UITextField) {
        datePickerView.datePickerMode = UIDatePickerMode.Date
        let dateformatter = NSDateFormatter()
        dateformatter.dateFormat = "dd-MM-yyyy"
        let defaultDate = "01-Jan-1970"
        datePickerView.date = dateformatter.dateFromString(defaultDate)!
        datePickerView.backgroundColor = UIColor.whiteColor()
        datePickerView.frame = datumFrame
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("datePickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        txtGebDatum.text = dateformatter.stringFromDate(datePickerView.date)
    }
    
    @IBAction func endEditingClub(sender: UITextField) {
        txtClub.text = clubPickerData.selectedClub.clubNaam
        vEmailClub = clubPickerData.selectedClub.email
        pickerHeight = clubFrame.height
        toRect = CGRectMake(0.0 , pickerHeight * -1 , svScrollView.contentSize.width, svScrollView.contentSize.height)
        svScrollView.scrollRectToVisible(toRect, animated: true)
    }
    
    @IBAction func endEditingDatum(sender: UITextField) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if let vselectedDate = datumPickerData.selectedDate {
        txtSpeelDatum.text = dateFormatter.stringFromDate(vselectedDate)
        }
        pickerHeight = datumFrame.height
        toRect = CGRectMake(0.0 , pickerHeight * -1 , svScrollView.contentSize.width, svScrollView.contentSize.height)
        svScrollView.scrollRectToVisible(toRect, animated: true)
    }
    
    @IBAction func startEditingClub(sender: UITextField) {
        // scroll om textfield in zicht te houden als picker tevoorschijn komt
        pickerHeight = clubFrame.height
        toRect = CGRectMake(0.0 , pickerHeight, svScrollView.contentSize.width, svScrollView.contentSize.height)
        svScrollView.scrollRectToVisible(toRect, animated: true)
    }
    
    @IBAction func starteditingDatum(sender: UITextField) {
        // scroll om textfield in zicht te houden als picker tevoorschijn komt
        pickerHeight = datumFrame.height
        toRect = CGRectMake(0.0 , pickerHeight, svScrollView.contentSize.width, svScrollView.contentSize.height)
        svScrollView.scrollRectToVisible(toRect, animated: true)
    }
    
    @IBAction func startEditingWoonplaats(sender: UITextField) {
        keyboardHeight = clubFrame.height
        toRect = CGRectMake(0.0 , keyboardHeight, svScrollView.contentSize.width, svScrollView.contentSize.height)
        svScrollView.scrollRectToVisible(toRect, animated: true)
    }
    
    @IBAction func endEditingWoonplaats(sender: UITextField) {
        keyboardHeight = clubFrame.height
        toRect = CGRectMake(0.0 , keyboardHeight * -1 , svScrollView.contentSize.width, svScrollView.contentSize.height)
        svScrollView.scrollRectToVisible(toRect, animated: true)
    }
    
    @IBAction func Inschrijven(sender: AnyObject) {
        // voor aanmelding is nodig dat alle velden zijn ingevuld
        var foutgevonden:Bool = false
        
        if txtNaam.text!.isEmpty {
            foutgevonden = true
        }
        if txtEmail.text!.isEmpty {
            foutgevonden = true
        }
        if txtPlaats.text!.isEmpty {
            foutgevonden = true
        }
        if txtGebDatum.text!.isEmpty {
            foutgevonden = true
        }
        if txtClub.text!.isEmpty {
            foutgevonden = true
        }
        if txtSpeelDatum.text!.isEmpty {
            foutgevonden = true
        }
        if foutgevonden {
            showError()
            return
        }
        
        // ingevulde waardes bewaren
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(txtNaam.text, forKey: "NameField")
        defaults.setValue(txtEmail.text, forKey: "EmailField")
        defaults.setValue(txtPlaats.text, forKey: "PlaceField")
        defaults.setValue(txtGebDatum.text, forKey: "AgeField")
        defaults.setValue(txtClub.text , forKey: "ClubField")
        defaults.setValue(vEmailClub, forKey: "ClubEmail")
        // mail versturen
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    // Tbv Pickers voor speeldatum en club
    var datumPickerView = UIPickerView()
    let datumPickerData = DatumPickerData()
    var clubPickerView = UIPickerView()
    let clubPickerData = ClubPickerData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ScollView 
        svScrollView.contentSize = svScrollView.bounds.size

        // Do any additional setup after loading the view.
        configureView()
        // alleen als er internet verbinding is kan onderstaande worden uitgevoerd!
        if Reachability.isConnectedToNetwork() == true {
        clubPickerData.fetchClubs {
            dispatch_async(dispatch_get_main_queue()) {
                self.clubPickerView.reloadAllComponents()
            }
        }
        datumPickerData.fetchDatums {
            dispatch_async(dispatch_get_main_queue()) {
                self.datumPickerView.reloadAllComponents()
            }
        }
        }
        else {
            // geen internetconnection
            let alert = UIAlertView(title: "Geen internet verbinding!", message: txtGeenInternet, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        
     }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getDefaults()
    }
    
    func configureView() {
        lblGroot.textAlignment = .Center
        lblGroot.font = UIFont(name: AppFontName, size: 40)
        lblGroot.textColor = UIColor.whiteColor()
        
        lblKlein.textAlignment = .Center
        lblKlein.font = UIFont(name: AppFontName, size: 20)
        lblKlein.textColor = UIColor.whiteColor()

        btnInschrijven.tintColor = UIColor.blackColor()
        btnInschrijven.titleLabel?.font = UIFont(name: AppFontName, size: 18)
        // Door deze class als delegate te benoemen, reageert het toetsenbord op 'return', het toetsenbord verdwijnt dan
        txtNaam.delegate = self
        txtNaam.font = UIFont(name: AppFontName, size: 18)
        txtEmail.delegate = self
        txtEmail.font = UIFont(name: AppFontName, size: 18)
        txtPlaats.delegate = self
        txtPlaats.font = UIFont(name: AppFontName, size: 18)
        txtGebDatum.font = UIFont(name: AppFontName, size: 18)
        // tbv selectie geboortedatum
        btnKiesGebdatum.titleLabel?.font = UIFont(name: AppFontName, size: 18)
        btnKiesGebdatum.tintColor = UIColor.blackColor()
        // tbv selectie speeldata
        datumPickerView.delegate = datumPickerData
        datumPickerView.dataSource = datumPickerData
        datumPickerView.frame = datumFrame
        datumPickerView.backgroundColor = UIColor.whiteColor()
        txtSpeelDatum.inputView = datumPickerView
        txtSpeelDatum.frame  = datumFrame
        txtSpeelDatum.font = UIFont(name: AppFontName, size: 18)
        txtSpeelDatum.text = "" // leegmaken voor nieuwe inschrijving
        // tbv selectie club
        clubPickerView.delegate = clubPickerData
        clubPickerView.dataSource = clubPickerData
        clubPickerView.frame = clubFrame
        clubPickerView.backgroundColor = UIColor.whiteColor()
        txtClub.inputView = clubPickerView
        txtClub.font = UIFont(name: AppFontName, size: 18)
        btnKiesClub.tintColor = UIColor.blackColor()
        btnKiesClub.titleLabel?.font = UIFont(name: AppFontName, size: 18)
        btnKiesDatum.tintColor = UIColor.blackColor()
        btnKiesDatum.titleLabel?.font = UIFont(name: AppFontName, size: 18)
    }
    
    func getDefaults() {
        // bepaal of er al UserDefaults zijn
        let defaults = NSUserDefaults.standardUserDefaults()
        if (defaults.objectForKey("NameField") != nil) {
            txtNaam.text = defaults.stringForKey("NameField")
        }
        if (defaults.objectForKey("EmailField") != nil) {
            txtEmail.text = defaults.stringForKey("EmailField")
        }
        if (defaults.objectForKey("PlaceField") != nil) {
            txtPlaats.text = defaults.stringForKey("PlaceField")
        }
        if (defaults.objectForKey("AgeField") != nil) {
            txtGebDatum.text = defaults.stringForKey("AgeField")
        }
        if (defaults.objectForKey("ClubField") != nil) {
            txtClub.text = defaults.stringForKey("ClubField")
        }
        if (defaults.objectForKey("ClubEmail") != nil) {
            vEmailClub = defaults.stringForKey("ClubEmail")!
        }
        txtSpeelDatum.text = "" // leeg maken voor nieuwe inschrijving
    }
    
    func datePickerValueChanged(sender: UIDatePicker) {
        let dateformatter = NSDateFormatter()
        dateformatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateformatter.dateFormat = "dd-MM-yyyy"
        txtGebDatum.text = dateformatter.stringFromDate(sender.date)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // Geeft foutmelding indien er fouten zijn gevonden
    func showError() {
        let actionController = UIAlertController(title: "Fout", message: "Niet alle velden zijn ingevuld", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        actionController.addAction(cancelAction)
        self.presentViewController(actionController, animated: true, completion: nil)
    }

    // MARK-
    // Mail functions
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        let recipients:String = getEmailSettings()
        let subject = "Ik wil me graag aanmelden voor 7 tegen 7 voetbal!"
        let body1 = "Mijn naam is " + txtNaam.text! +
            ", mijn emailadres is " + txtEmail.text!
        let body2 =
            ", ik woon in "  + txtPlaats.text! +
            " en mijn geboortedatum is " + txtGebDatum.text! + "."
        let body3 = " Ik wil graag spelen bij " + txtClub.text! + "."
        let body4 = " Ik kan spelen op " + txtSpeelDatum.text! + "."
        let body5 = "\n Graag ontvang ik verdere informatie!"
        let body = body1 + body2 + body3 + body4 + body5
        
        mailComposerVC.setToRecipients([recipients])
        mailComposerVC.setSubject(subject)
        mailComposerVC.setMessageBody(body, isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(
            title: "Kan geen email versturen!",
            message: "Dit apparaat kan geen email versturen.  Controleer de instellingen en probeer opnieuw.",
            delegate: self,
            cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    func getEmailSettings() -> String {
        #if DEBUG
            // read plist to obtain the recipients for the email
           let path = NSBundle.mainBundle().pathForResource("EmailSettings", ofType: "plist")
           let dict = NSDictionary(contentsOfFile: path!)
           let recipients = dict?.valueForKey(recipientsKey) as! String
        #else
            // in productie!
            var recipients = vEmailClub // Komt of uit bewaarde gegevens of uit de geselecteerde club
        #endif
        return recipients
    }
     
    // Email Delegate
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError?) {
        
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            let sendMailStatus = UIAlertView(
                title: "Mail geannuleerd",
                message: "Je aanmelding is niet verstuurd",
                delegate: self,
                cancelButtonTitle: "OK")
            sendMailStatus.show()
        case MFMailComposeResultSaved.rawValue:
            let sendMailStatus = UIAlertView(
                title: "Mail opgeslagen",
                message: "Je aanmelding is niet verstuurd, het concept is opgegeslagen",
                delegate: self,
                cancelButtonTitle: "OK")
            sendMailStatus.show()
        case MFMailComposeResultSent.rawValue:
            // Melding geven dat aanmelding is gelukt
            let sendMailStatus = UIAlertView(
                title: "Mail verstuurd",
                message: "Je aanmelding is verstuurd",
                delegate: self,
                cancelButtonTitle: "OK")
            sendMailStatus.show()
        case MFMailComposeResultFailed.rawValue:
            let sendMailStatus = UIAlertView(
                title: "FOUT",
                message: "Je aanmelding is niet verstuurd: \(error!.localizedDescription)",
                delegate: self,
                cancelButtonTitle: "OK")
            sendMailStatus.show()
        default:
            break
        }
        self.dismissViewControllerAnimated(false, completion: nil)
    }
}
