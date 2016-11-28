//
//  UitlegDetailViewController.swift
//  7x7
//
//  Created by Marjan Drost on 13-05-15.
//  Copyright (c) 2015 MD. All rights reserved.
//

import UIKit

class UitlegDetailViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var tvUitlegDetail: UITextView!
    
    var detailtext: String?
     
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false // zodat tekst rechtsbovenaan start ipv na paar witregels
        let tekstRange = NSMakeRange(0, 0)
        tvUitlegDetail.scrollRangeToVisible(tekstRange) // zodat het eerste gedeelte van de tekst direct is te zien op iPhone4/5
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
 
        // put data on the screen
        tvUitlegDetail.text = detailtext
        tvUitlegDetail.font = UIFont(name: AppFontName, size: 22)
    }

    
    
}
