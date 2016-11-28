//
//  DataPickerData.swift
//  
//
//  Created by Marjan Drost on 17-06-15.
//
//

import Foundation
import UIKit


class DataPickerData: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let source = ["a", "b", "c", "d", "e"]


    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return source.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return source[row]
    }
}