//
//  GamesViewController.swift
//  7x7
//
//  Created by Marjan Drost on 13-05-15.
//  Copyright (c) 2015 MD. All rights reserved.
//

import UIKit

class GamesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let gameStore = GameStore()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var scCategorie: UISegmentedControl!
    
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch scCategorie.selectedSegmentIndex
        {
        case 0:
            gvCategorie = "35+";
        case 1:
            gvCategorie = "45+";
        default:
            break;
        }
        gameStore.setGamesForCategorie()
        self.tableView.reloadData()
    }
    
     override func viewDidLoad() {
        super.viewDidLoad()
        // alleen als er internet verbinding is kan onderstaande worden uitgevoerd!
        gvCategorie = "35+"
        //scCategorie.titleLabel?.font = UIFont(name: AppFontName, size: 18)
        let attr = NSDictionary(object: UIFont(name: AppFontName, size: 18.0)!, forKey: NSFontAttributeName)
        scCategorie.setTitleTextAttributes(attr as [NSObject : AnyObject], forState: .Normal)
        if Reachability.isConnectedToNetwork() == true
        {
        // Do any additional setup after loading the view.
            gameStore.fetchGames
                {
                dispatch_async(dispatch_get_main_queue())
                    {
                    if self.gameStore.numberOfGames(1) > 0
                        {
                            self.tableView.reloadData()
                        }
                    else {
                        let melding = UIAlertView(title: "Geen wedstrijden", message: txtGeenWedstrijd, delegate: nil, cancelButtonTitle: "OK")
                        melding.show()
                        }
                    }
                }
        }
        else {
            let alert = UIAlertView(title: "Geen internet verbinding!", message: txtGeenInternet, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if self.tableView.indexPathForSelectedRow != nil {
            self.tableView.deselectRowAtIndexPath(self.tableView.indexPathForSelectedRow!, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     // MARK:    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return gameStore.numberOfGames(section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Configure the cell...
        let cell = tableView.dequeueReusableCellWithIdentifier("MainCell") as! GameCell
        configureCell(cell, forRowAtIndexPath:indexPath)
        return cell
    }
    
    func configureCell(cell: GameCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let  game =  gameStore.GameInfoForItemAtIndexPath(indexPath)
        
        let formatter: NSDateFormatter = NSDateFormatter()
        
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        formatter.dateFormat = "dd-MM-yyyy"
        
        let wdatum: String = formatter.stringFromDate(game.wedstrijdDatum!)
        
        cell.lblDatum.text = wdatum

        cell.lblTijd.text = game.wedstrijdTijd
        let thuisTeam  = game.thuisTeam?.teamNaam
        let uitTeam = game.uitTeam?.teamNaam
        cell.lblWedstrijd.text = thuisTeam! + " - " + uitTeam!
        cell.lblWedstrijd.font = UIFont(name: AppFontName, size: 18)
        cell.lblCat.text = game.categorie
        cell.lblCat.font = UIFont(name: AppFontName, size: 18)
        cell.lblDatum.font = UIFont(name: AppFontName, size: 18)
        cell.lblTijd.font = UIFont(name: AppFontName, size: 18)

    }

      // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
        let indexPath = self.tableView.indexPathForSelectedRow
        let selGame = gameStore.GameInfoForItemAtIndexPath(indexPath!)
        let detailViewController = segue.destinationViewController as! GameDetailViewController
        detailViewController.title = "wedstrijd"
        detailViewController.gameInfo = selGame
    }
    
    
}
