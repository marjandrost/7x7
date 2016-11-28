//
//  SchrijfInScrollViewController.swift
//  7x7
//
//  Created by Marjan Drost on 07-07-15.
//  Copyright (c) 2015 MD. All rights reserved.
//

import UIKit

class SchrijfInScrollViewController: UIViewController, UIScrollViewDelegate , UITextFieldDelegate {
    @IBOutlet weak var svScrollView: UIScrollView!
    
    @IBOutlet weak var tvText1: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        svScrollView.contentSize = svScrollView.bounds.size
        //foreground.delegate = self
        
    }
    @IBOutlet weak var tvText2: UITextField!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }


}
