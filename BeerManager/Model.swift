//
//  Model.swift
//  BeerManager
//
//  Created by  AlbaCruz on 24/12/2020.
//  Copyright © 2020  AlbaCruz. All rights reserved.
//

import Foundation
import UIKit

public class Model : NSObject, NSCoding {
    let NAME_OF_FOLDER_IN_BUNDLE = "BeerManager-data"
    let NAME_OF_BEER_FILE_IN_BUNDLE = "defaultbeer"
    let NAME_OF_PHOTOGRAPH_FOLDER_IN_BUNDLE = "BeerManager-photos"
    let NAME_OF_FOLDER_IN_DOCUMENTS = "DataOfBeerManager"
    let NAME_OF_BEER_FILE_IN_DOCUMENTS = "FileOfBeers"
    
    public var cervezas:[Beer]
    
    
    
    public func encode(with coder: NSCoder) {
        <#code#>
    }
    
    public required init?(coder: NSCoder) {
        <#code#>
    }
    
}
