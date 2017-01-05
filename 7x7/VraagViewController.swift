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
    @IBAction func sendAction(_ sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtBodyField.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureView() {
        lblGroot.textAlignment = .center
        lblGroot.font = UIFont(name: AppFontName, size: 40)
        lblGroot.textColor = UIColor.white
   
        lblKlein.textAlignment = .center
        lblKlein.font = UIFont(name: AppFontName, size: 20)
        lblKlein.textColor = UIColor.white

        txtSubjectField.delegate = self
        txtSubjectField.font = UIFont(name: AppFontName, size: 20)
        txtSubjectField.text     = "Ik heb een vraag over 7 tegen 7 voetbal"
        
        lblVraag.font = UIFont(name: AppFontName, size: 20)
        
        txtBodyField.delegate    = self
        txtBodyField.font = UIFont(name: AppFontName, size: 18)
        txtBodyField.text = ""
        
        btnSend.tintColor = UIColor.black
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
            let path = Bundle.main.path(forResource: "EmailSettings", ofType: "plist")
            let dict = NSDictionary(contentsOfFile: path!)
            let recipients = dict?.value(forKey: recipientsKey) as! String
        #else
            // in productie!
            let recipients = vraagRecipient
        #endif
        return recipients
    }
    
    // Email Delegate
    func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result:MFMailComposeResult, error:Error?) {
        
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            let sendMailStatus = UIAlertView(
                title: "Mail geannuleerd",
                message: "Je vraag is niet verstuurd",
                delegate: self,
                cancelButtonTitle: "OK")
            sendMailStatus.show()
        case MFMailComposeResult.saved.rawValue:
            let sendMailStatus = UIAlertView(
                title: "Mail opgeslagen",
                message: "Je vraag is niet verstuurd, het concept is opgegeslagen",
                delegate: self,
                cancelButtonTitle: "OK")
            sendMailStatus.show()
        case MFMailComposeResult.sent.rawValue:
            // Melding geven dat aanmelding is gelukt
            let sendMailStatus = UIAlertView(
                title: "Gelukt!",
                message: "Je vraag is verstuurd",
                delegate: self,
                cancelButtonTitle: "OK")
            sendMailStatus.show()
        case MFMailComposeResult.failed.rawValue:
            let sendMailStatus = UIAlertView(
                title: "FOUT",
                message: "Je vraag is niet verstuurd: \(error!.localizedDescription)",
                delegate: self,
                cancelButtonTitle: "OK")
            sendMailStatus.show()
            
        default:
            break
        }
        self.dismiss(animated: false, completion: nil)
        
    }
    
    
    //UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //UITextViewDelegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        txtBodyField.text = textView.text
        // when enter key is pressed, the keyboard wil hide
        if text == "\n" {
            textView.resignFirstResponder()
            
            return false
        }
        
        return true
    }
    
}
