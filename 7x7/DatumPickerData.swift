 //
//  DatumPickerData.swift
//  7x7
//
//  Created by Marjan Drost on 17-06-15.
//  Copyright (c) 2015 MD. All rights reserved.
//

import Foundation
import UIKit


class DatumPickerData: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var speelData:[SpeelDatum] = []
    var selectedDate:NSDate?
    
    var formatter:NSDateFormatter = NSDateFormatter()
    let vandaag = NSDate()
    
    var strVandaag:String = ""
    var strSpeeldatum:String = ""

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return speelData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
   
        return formatter.stringFromDate(speelData[row].speelDatum!)
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if let vselectedDate = speelData[row].speelDatum {
          //  selectedDate = speelData[row].speelDatum
           selectedDate = vselectedDate
        }
        
    }
    // je kunt view, en dus ook label gebruiken als definitie voor de row, en daardoor heb je meer mogelijkheden voor opmaak
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        var pickerLabel = view as! UILabel!
        if view == nil {  //if no label there yet
            pickerLabel = UILabel()
            pickerLabel.textAlignment = .Center
            pickerLabel.backgroundColor = UIColor.whiteColor()
        }
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        formatter.dateFormat = "dd-MM-yyyy"
        if let vspeelDatum = speelData[row].speelDatum {
            let titleData = formatter.stringFromDate(vspeelDatum)
        
            let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: AppFontName, size: 20.0)!,
                                                                             NSForegroundColorAttributeName:appColor,
                                                                             NSBackgroundColorAttributeName:UIColor.whiteColor()])
            
            pickerLabel!.attributedText = myTitle
        }
        selectedDate = speelData[0].speelDatum // om de eerste datum geselecteerd te zetten
        return pickerLabel
    }

    
    func fetchDatums(succes: () -> () ) {
        let url = NSURL(string: qryDates)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithURL(url!) {
            (data, response, error) in
            
            if(error != nil) {
                print(error!.localizedDescription)
            }
            else
            {
            //let jsonError: NSError?
            let jsondata: NSArray
            do {
               jsondata = try (NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSArray)!
            
                           // store in gameStore for further use
                for i in 0...(jsondata.count - 1) {
                    
                    if let maindata = (jsondata[i] as? NSDictionary) {
                        if let meta = (maindata["meta"] as? NSDictionary) {
                            let newDatum = SpeelDatum()
                            if let vspeelDatum = (meta["wedstrijddatum_wedstrijddatum"] as? String) {
                                self.formatter.dateStyle = NSDateFormatterStyle.ShortStyle
                                self.formatter.dateFormat = "yyyyMMdd"
                                self.formatter.timeZone = NSTimeZone(name: "GMT")
                                newDatum.speelDatum = self.formatter.dateFromString(vspeelDatum)
                            }
                            // alleen toevoegen als vandaag <= nieuwe datum
                            self.strVandaag = self.formatter.stringFromDate(self.vandaag)
                            self.strSpeeldatum = self.formatter.stringFromDate(newDatum.speelDatum!)
                            
                            if  self.strSpeeldatum > self.strVandaag
                            {
                                self.speelData.append(newDatum)
                            }
                            else {
                              if self.strVandaag == self.strSpeeldatum {
                                self.speelData.append(newDatum)
                                }
                            } //else
                        } // if let meta
                    } // if let maindata
                } //for i ..
                self.speelData = Array(self.speelData.reverse()) // om in chronologische volgorde te krijgen!
                succes()
            } catch {
                //failure
                print("Fetch failed: \(error as NSError).localizedDescription)")
                }
            } //else
        } //task
        task.resume()
    } // func
    
  /*  func fetchDatums(succes: () -> () ) {
        let url = NSURL(string: qryDates)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithURL(url!) {
            (data, response, error) in
            
            let jsonError: NSError?
            let data = (try! NSJSONSerialization.JSONObjectWithData(data!, options: [])) as! NSArray
            
            if let unwrappedError = jsonError {
                // er is een fout
                print("json error: \(unwrappedError)")
            } else {
                // store in gameStore for further use
                for i in 0...(data.count - 1) {
                    
                    if let maindata = (data[i] as? NSDictionary) {
                        if let meta = (maindata["meta"] as? NSDictionary) {
                            let newDatum = SpeelDatum()
                            if let vspeelDatum = (meta["wedstrijddatum_wedstrijddatum"] as? String) {
                                self.formatter.dateStyle = NSDateFormatterStyle.ShortStyle
                                self.formatter.dateFormat = "yyyyMMdd"
                                self.formatter.timeZone = NSTimeZone(name: "GMT")
                                newDatum.speelDatum = self.formatter.dateFromString(vspeelDatum)
                            }
                            // alleen toevoegen als vandaag <= nieuwe datum
                            self.strVandaag = self.formatter.stringFromDate(self.vandaag)
                            self.strSpeeldatum = self.formatter.stringFromDate(newDatum.speelDatum!)
                            
                            if  self.strSpeeldatum > self.strVandaag
                            {
                                self.speelData.append(newDatum)
                            }
                            else {
                                if self.strVandaag == self.strSpeeldatum {
                                    self.speelData.append(newDatum)
                                }
                            }
                        }
                    }
                }
                self.speelData = Array(self.speelData.reverse()) // om in chronologische volgorde te krijgen!
                succes()
            }
        }
        task.resume()
    }
*/
    func addDays(date: NSDate, additionalDays: Int) -> NSDate {
        // adding $additionalDays
        let components = NSDateComponents()
        components.day = additionalDays
        
        // important: NSCalendarOptions(0)
        let futureDate = NSCalendar.currentCalendar()
            .dateByAddingComponents(components, toDate: date, options: NSCalendarOptions(rawValue: 0))
        return futureDate!
    }
}
