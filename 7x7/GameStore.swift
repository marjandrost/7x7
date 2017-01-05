//
//  GameStore.swift
//  7x7
//
//  Created by Marjan Drost on 13-05-15.
//  Copyright (c) 2015 MD. All rights reserved.
//

import UIKit

class GameStore: NSObject {
    var games:[Game] = []
    var games35:[Game] = []
    var games45:[Game] = []
    
    var data: NSArray = []
    
    
    func fetchGames(_ succes: @escaping () -> () )
    {
        let url =  URL(string: qryGames)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: url!, completionHandler: {
                (data, response, error) in
               
                if(error != nil) {
                    print(error!.localizedDescription)
                }
                else
                {
                  self.games = []
                  // let jsonError: NSError?
                  let jsondata: NSArray
                  do
                  {
                       jsondata = try (JSONSerialization.jsonObject(with: data!, options: []) as! NSArray)
                        // success...
                           // store in gameStore for further use
                        if jsondata.count > 0 { // alleen als er data is gevonden!
                            for i in 0...(jsondata.count - 1)
                            {
                                let newGame = Game()
                                let thuisTeam = Team()
                                let uitTeam = Team()
                                let locatie = Club()
                    
                                let maindata = (jsondata[i] as! NSDictionary)
                                let meta = (maindata["meta"] as! NSDictionary)
                    
                                var teamData = (meta["westrijden_team_1"]) as! NSDictionary
                                thuisTeam.teamId = (teamData["ID"] as! Int)
                                thuisTeam.teamNaam = (teamData["post_title"] as! String)
                                newGame.thuisTeam = thuisTeam
                    
                                teamData = (meta["westrijden_team_2"]) as! NSDictionary
                                uitTeam.teamId = (teamData["ID"] as! Int)
                                uitTeam.teamNaam = (teamData["post_title"]as! String)
                                newGame.uitTeam = uitTeam
                    
                                let locatieData = (meta["westrijden_locatie"] as! NSDictionary)
                                locatie.clubId = (locatieData["ID"] as! Int)
                                locatie.clubNaam = (locatieData["post_title"] as! String)
                                newGame.locatie = locatie
                    
                                newGame.wedstrijdTijd  = (meta["wedstrijden_tijd"] as! String)
                                let datum = (meta["westrijden_datum"] as! String)
                                let formatter: DateFormatter = DateFormatter()
                    
                                formatter.dateStyle = DateFormatter.Style.short
                                formatter.dateFormat = "yyyyMMdd"
                    
                                newGame.wedstrijdDatum = formatter.date(from: datum)
                    
                                newGame.categorie = (meta["wedstrijden_leeftijd_categorie"] as! String)
                                // alleen in gamestore zetten als de categorie gelijk is aan de gewenste
                                if newGame.categorie == gvCategorie35 {
                                    self.games35.append(newGame)
                                } else {
                                    self.games45.append(newGame)
                                }
                            } // for i in
                            self.games35 = Array(self.games35.reversed())
                            self.games45 = Array(self.games45.reversed())
                            self.setGamesForCategorie()
                            succes()
                        } // if
                  } catch {
                        //failure
                        print("fetch failed: \(error as NSError).localizedDescription)")
                 } // do
                } // else
        })            
 // task
        task.resume()

    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfGames(_ section: Int) -> Int {
       return games.count
    }
    
    func GameInfoForItemAtIndexPath(_ indexPath: IndexPath) -> Game{
        return games[(indexPath as NSIndexPath).row]
    }

    func setGamesForCategorie() {
        if gvCategorie == gvCategorie35 {
            self.games = self.games35
        }
        else {
            self.games = self.games45
        }

    }
}
