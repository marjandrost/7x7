//
//  UitlegViewController.swift
//  7x7
//
//  Created by Marjan Drost on 12-05-15.
//  Copyright (c) 2015 MD. All rights reserved.
//

import UIKit

class UitlegViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var uitleg: [[String: String]]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let path = NSBundle.mainBundle().pathForResource("Uitleg", ofType: "plist")!
        let algemeenInfo = NSDictionary(contentsOfFile: path)!
        uitleg = algemeenInfo["WatIsGegevens"]! as! [NSDictionary] as! [[String: String]]
        self.navigationItem.title = "uitleg"
      }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

 
    // MARK: - Table view data source
    
      
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return uitleg.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)as! WatIsCell
        
        // Configure the cell...
        let info = uitleg[indexPath.row]
        let imagename = info["plaatje"]
        cell.lblHeaderText.text = info["kopregel"]
        cell.lblHeaderText.textAlignment = NSTextAlignment.Center
        cell.lblHeaderText.font = UIFont(name: AppFontName, size: 28)
        let appColor = UIColor(red: 220/255, green: 41/255, blue: 41/255, alpha: 1)
        cell.lblHeaderText.textColor = appColor
        cell.imgPicture.image = UIImage(named: imagename!)
        return cell
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let indexPath = self.tableView.indexPathForSelectedRow
        let row = indexPath!.row
        let info = uitleg[row]
        let detailViewController = segue.destinationViewController as! UitlegDetailViewController
        detailViewController.detailtext = info["langetekst"]
        detailViewController.title = info["kopregel"]
        tableView.deselectRowAtIndexPath(indexPath!, animated: true)
    }
    


}
