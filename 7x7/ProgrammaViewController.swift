//
//  ProgrammaViewController.swift
//  7x7
//
//  Created by Marjan Drost on 19-05-15.
//  Copyright (c) 2015 MD. All rights reserved.
//

import UIKit

class ProgrammaViewController: UIViewController {

    @IBOutlet weak var imgHeaderLarge: UIImageView!
    
    @IBOutlet weak var lblGroot: UILabel!
    @IBOutlet weak var webview: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureView()
    }
    
    func viewWillAppear() {
        webview.reload()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func configureView() {
        let urlString = "http://7x7deventer.nl/wedstrijden-overzicht/"
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        webview.loadRequest(request)
        
        lblGroot.textAlignment = .Center
        lblGroot.font = UIFont(name: AppFontName, size: 40)
        lblGroot.textColor = UIColor.whiteColor()

    }
 
}
