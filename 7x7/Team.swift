//
//  Team.swift
//  7x7
//
//  Created by Marjan Drost on 13-05-15.
//  Copyright (c) 2015 MD. All rights reserved.
//

import UIKit

class Team: NSObject {
    var teamId: Int?
    var teamNaam: String?
    var club: Club?
    var categorie: Bool?
    var players:[Player] = []
    
    override init() {
        super.init()
    }
 
    func fetchTeamPlayers(_ teamId: Int, succes: @escaping () -> () )
    {
        self.players = []
        let teamQuery = qrySpelersPerTeam + String(teamId)
        let url =  URL(string: teamQuery)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: url!, completionHandler: {
                ( data, response, error) in
                
                if(error != nil) {
                    print(error!.localizedDescription)
                }
                else
                {
            //        let jsonError: NSError?
                    let jsondata: NSArray
                    if JSONSerialization.isValidJSONObject(data!) {
                    do {
                        jsondata  = try (JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSArray)!
                        // success ...
                        for i in 0...(jsondata.count - 1)
                        {
                            if let maindata = (jsondata[i] as? NSDictionary) {
                                let newPlayer = Player()
                                if let vplayerID = (maindata["ID"] as? Int) {
                                    newPlayer.playerID = vplayerID
                                }
                                
                                if let vplayerNaam = (maindata["naam"] as? String) {
                                    newPlayer.playerNaam = vplayerNaam
                                }
                                self.players.append(newPlayer)
                            } // let maindata
                        } // for i ..
                      succes()
                    } catch {
                        // failure
                        print("Fetch failed: \(error as NSError).localizedDescription)") // fout wordt verder afgevangen in showplayers() dus hier geen foutmelding nodig
                        succes()
                    }
                    }
                    succes() // if validJsonObject. Ook als geen valid Json (als er geen spelers zijn) dan toch success doen, melding niet gevonden wordt afgevangen in showplayers()
                } // else
        })            
 // task
        task.resume()
    } //func

   /*
    func fetchTeamPlayers(teamId: Int, succes: () -> () )
    {
        self.players = []
        let teamQuery = qrySpelersPerTeam + String(teamId)
        let url =  NSURL(string: teamQuery)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithURL(url!)
            {
                (data, response, error) in
            
                if(error != nil) {
                    print(error!.localizedDescription)
                }
                else
                {
                    let jsonError: NSError?
                    if let data = NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSArray {
            
                        if let unwrappedError = jsonError {
                            // er is een fout
                            print("Json error: \(jsonError)")
                        } else
                        {
                            for i in 0...(data.count - 1)
                                {
                                    if let maindata = (data[i] as? NSDictionary) {
                                        let newPlayer = Player()
                                        if let vplayerID = (maindata["ID"] as? Int) {
                                            newPlayer.playerID = vplayerID
                                        }
                                            
                                        if let vplayerNaam = (maindata["naam"] as? String) {
                                            newPlayer.playerNaam = vplayerNaam
                                        }
                                        self.players.append(newPlayer)
                                    } // let maindata
                             } // for i ..
                        } // if let unwrappedError
                } //if let data
                succes()
            } // else
         } // task
        task.resume()
    } //func
*/
    func getPlayers() -> [Player] {
        return players
    }
}
