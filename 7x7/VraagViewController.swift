//
//  VraagViewController.swift
//  7x7
//
//  Created by Marjan Drost on 15-05-15.
//  Copyright (c) 2015 MD. All rights reserved.
//

import UIKit
import MessageUI

class VraagViewController: UIViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var lblGroot: UILabel!

    @IBOutlet weak var lblKlein: UILabel!
    @IBOutlet weak var txtSubjectField: UITextField!
    
    @IBOutlet weak var lblVraag: UILabel!
    @IBOutlet weak var txtBodyField: UITextView!
    
    @IBOutlet weak var btnSend: UIButton!
    @IBAction func sendAction(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        txtBodyField.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureView() {
        lblGroot.textAlignment = .Center
        lblGroot.font = UIFont(name: AppFontName, size: 40)
        lblGroot.textColor = UIColor.whiteColor()
   
        lblKlein.textAlignment = .Center
        lblKlein.font = UIFont(name: AppFontName, size: 20)
        lblKlein.textColor = UIColor.whiteColor()

        txtSubjectField.delegate = self
        txtSubjectField.font = UIFont(name: AppFontName, size: 20)
        txtSubjectField.text     = "Ik heb een vraag over 7 tegen 7 voetbal"
        
        lblVraag.font = UIFont(name: AppFontName, size: 20)
        
        txtBodyField.delegate    = self
        txtBodyField.font = UIFont(name: AppFontName, size: 18)
        txtBodyField.text = ""
        
        btnSend.tintColor = UIColor.blackColor()
        btnSend.titleLabel?.font = UIFont(name: AppFontName, size: 18)  
    }

    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        let recipients:String = getEmailSettings()
        mailComposerVC.setToRecipients([recipients])
        mailComposerVC.setSubject(txtSubjectField.text!)
        mailComposerVC.setMessageBody(txtBodyField.text, isHTML: false)
        
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
            var recipients = vraagRecipient
        #endif
        return recipients
    }
    
    // Email Delegate
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError?) {
        
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            let sendMailStatus = UIAlertView(
                title: "Mail geannuleerd",
                message: "Je vraag is niet verstuurd",
                delegate: self,
                cancelButtonTitle: "OK")
            sendMailStatus.show()
        case MFMailComposeResultSaved.rawValue:
            let sendMailStatus = UIAlertView(
                title: "Mail opgeslagen",
                message: "Je vraag is niet verstuurd, het concept is opgegeslagen",
                delegate: self,
                cancelButtonTitle: "OK")
            sendMailStatus.show()
        case MFMailComposeResultSent.rawValue:
            // Melding geven dat aanmelding is gelukt
            let sendMailStatus = UIAlertView(
                title: "Gelukt!",
                message: "Je vraag is verstuurd",
                delegate: self,
                cancelButtonTitle: "OK")
            sendMailStatus.show()
        case MFMailComposeResultFailed.rawValue:
            let sendMailStatus = UIAlertView(
                title: "FOUT",
                message: "Je vraag is niet verstuurd: \(error!.localizedDescription)",
                delegate: self,
                cancelButtonTitle: "OK")
            sendMailStatus.show()
            
        default:
            break
        }
        self.dismissViewControllerAnimated(false, completion: nil)
        
    }
    
    
    //UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //UITextViewDelegate
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        txtBodyField.text = textView.text
        // when enter key is pressed, the keyboard wil hide
        if text == "\n" {
            textView.resignFirstResponder()
            
            return false
        }
        
        return true
    }
    
}
