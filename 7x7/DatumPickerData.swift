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
    var selectedDate:Date?
    
    var formatter:DateFormatter = DateFormatter()
    let vandaag = Date()
    
    var strVandaag:String = ""
    var strSpeeldatum:String = ""

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return speelData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
   
        return formatter.string(from: speelData[row].speelDatum! as Date)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if let vselectedDate = speelData[row].speelDatum {
          //  selectedDate = speelData[row].speelDatum
           selectedDate = vselectedDate as Date
        }
        
    }
    // je kunt view, en dus ook label gebruiken als definitie voor de row, en daardoor heb je meer mogelijkheden voor opmaak
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as! UILabel!
        if view == nil {  //if no label there yet
            pickerLabel = UILabel()
            pickerLabel?.textAlignment = .center
            pickerLabel?.backgroundColor = UIColor.white
        }
        formatter.dateStyle = DateFormatter.Style.short
        formatter.dateFormat = "dd-MM-yyyy"
        if let vspeelDatum = speelData[row].speelDatum {
            let titleData = formatter.string(from: vspeelDatum as Date)
        
            let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: AppFontName, size: 20.0)!,
                                                                             NSForegroundColorAttributeName:appColor,
                                                                             NSBackgroundColorAttributeName:UIColor.white])
            
            pickerLabel!.attributedText = myTitle
        }
        selectedDate = speelData[0].speelDatum as Date? // om de eerste datum geselecteerd te zetten
        return pickerLabel!
    }

    
    func fetchDatums(_ succes: @escaping () -> () ) {
        let url = URL(string: qryDates)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            
            if(error != nil) {
                print(error!.localizedDescription)
            }
            else
            {
            //let jsonError: NSError?
            let jsondata: NSArray
            do {
               jsondata = try (JSONSerialization.jsonObject(with: data!, options: []) as? NSArray)!
            
                           // store in gameStore for further use
                for i in 0...(jsondata.count - 1) {
                    
                    if let maindata = (jsondata[i] as? NSDictionary) {
                        if let meta = (maindata["meta"] as? NSDictionary) {
                            let newDatum = SpeelDatum()
                            if let vspeelDatum = (meta["wedstrijddatum_wedstrijddatum"] as? String) {
                                self.formatter.dateStyle = DateFormatter.Style.short
                                self.formatter.dateFormat = "yyyyMMdd"
                                self.formatter.timeZone = TimeZone(identifier: "GMT")
                                newDatum.speelDatum = self.formatter.date(from: vspeelDatum)
                            }
                            // alleen toevoegen als vandaag <= nieuwe datum
                            self.strVandaag = self.formatter.string(from: self.vandaag)
                            self.strSpeeldatum = self.formatter.string(from: newDatum.speelDatum! as Date)
                            
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
                self.speelData = Array(self.speelData.reversed()) // om in chronologische volgorde te krijgen!
                succes()
            } catch {
                //failure
                print("Fetch failed: \(error as NSError).localizedDescription)")
                }
            } //else
        })  //task
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
    func addDays(_ date: Date, additionalDays: Int) -> Date {
        // adding $additionalDays
        var components = DateComponents()
        components.day = additionalDays
        
        // important: NSCalendarOptions(0)
        let futureDate = (Calendar.current as NSCalendar)
            .date(byAdding: components, to: date, options: NSCalendar.Options(rawValue: 0))
        return futureDate!
    }
}
