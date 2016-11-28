//
//  ClubPickerData.swift
//  7x7
//
//  Created by Marjan Drost on 17-06-15.
//  Copyright (c) 2015 MD. All rights reserved.
//

import Foundation
import UIKit

import Foundation

class ClubPickerData: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var clubs:[Club] = []
    var selectedClub:Club = Club()
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return clubs.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return clubs[row].clubNaam
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedClub = clubs[row]
    }
    // je kunt view, en dus ook label gebruiken als definitie voor de row, en daardoor heb je meer mogelijkheden voor opmaak
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        var pickerLabel = view as! UILabel!
        if view == nil {  //if no label there yet
            pickerLabel = UILabel()
            pickerLabel.textAlignment = .Center
            pickerLabel.backgroundColor = UIColor.whiteColor()
        }
        let titleData = clubs[row].clubNaam
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: AppFontName, size: 20.0)!,
                                                                         NSForegroundColorAttributeName:appColor,
                                                                         NSBackgroundColorAttributeName:UIColor.whiteColor()])
        selectedClub  = clubs[0] // om eerste club geselecteerd te zetten

        pickerLabel!.attributedText = myTitle
        return pickerLabel
    }
   
    func fetchClubs(succes: () -> () ) {
        let url = NSURL(string: qryClubs)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithURL(url!) {
            (data, response, error) in
            
            if(error != nil) {
                print(error!.localizedDescription)
            }
            else
            {

           // let jsonError: NSError?
            let jsondata: NSArray
            do {
                jsondata = try ( NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSArray)!
                // success
                   // store in gameStore for further use
                for i in 0...(jsondata.count - 1) {
                    
                    if let maindata = (jsondata[i] as? NSDictionary) {
                        if let meta = (maindata["meta"] as? NSDictionary) {
                            let newClub = Club()
                            if let vclubNaam = (meta["club_clubnaam"] as? String) {
                                newClub.clubNaam = vclubNaam
                            }
                            if let vcontactPersoon = (meta["club_contactpersoon"] as? String) {
                                newClub.contactPersoon = vcontactPersoon
                            }
                            if let vemail = (meta["club_email"] as? String) {
                                newClub.email = vemail
                            }
                            if let vtelefoon = (meta["club_telefoon"] as? String) {
                                newClub.telefoon = vtelefoon
                            }
                            self.clubs.append(newClub)
                        }
                    }
                }
                #if DEBUG
                    // even zelf nog extra club toevoegen ivm niet aanroepen didSelectRow
                    let newClub = Club()
                    newClub.clubNaam = "Marjan's club"
                    self.clubs.append(newClub)
                #endif
                succes()
            } catch {
                // failure
                print("Fetch failed: \(error as NSError).localizedDescription)")
                }
   
            } // else
        } // task
        task.resume()
    } // func
  
    
  /*  func fetchClubs(succes: () -> () ) {
        let url = NSURL(string: qryClubs)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithURL(url!) {
            (data, response, error) in
            
            let jsonError: NSError?
            let data = (try! NSJSONSerialization.JSONObjectWithData(data!, options: [])) as! NSArray
            
            if let unwrappedError = jsonError {
                // er is een fout
                print("json error: \(jsonError)")
            } else {
                // store in gameStore for further use
                for i in 0...(data.count - 1) {
                   
                    if let maindata = (data[i] as? NSDictionary) {
                        if let meta = (maindata["meta"] as? NSDictionary) {
                            let newClub = Club()
                            if let vclubNaam = (meta["club_clubnaam"] as? String) {
                                newClub.clubNaam = vclubNaam
                            }
                            if let vcontactPersoon = (meta["club_contactpersoon"] as? String) {
                                newClub.contactPersoon = vcontactPersoon
                            }
                            if let vemail = (meta["club_email"] as? String) {
                                newClub.email = vemail
                            }
                            if let vtelefoon = (meta["club_telefoon"] as? String) {
                                newClub.telefoon = vtelefoon
                            }
                            self.clubs.append(newClub)
                        }
                    }
                }
                #if DEBUG
                    // even zelf nog extra club toevoegen ivm niet aanroepen didSelectRow
                    let newClub = Club()
                    newClub.clubNaam = "Marjan's club"
                    self.clubs.append(newClub)
                #endif
                succes()
            }
        }
        task.resume()
    }
*/
}
