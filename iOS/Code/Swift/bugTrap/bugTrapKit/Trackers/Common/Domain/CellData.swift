//
//  CellData.swift
//  bugTrap
//
//  Created by Colby L Williams on 11/14/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

class CellData {
    
    var CellType : BugCellTypes = BugCellTypes.Display
    
    var Selected : Bool = false
    
    var Data = [DataKeys : String]()
    
    func Set(key: DataKeys, value: String) {
        Data[key] = value
    }
    
    func Get(key: DataKeys) -> String? {
        return Data[key]
    }
}