//
//   Maker.swift
//  BeerManager
//
//  Created by  AlbaCruz on 14/01/2021.
//  Copyright © 2021  AlbaCruz. All rights reserved.
//

import Foundation

public class Maker : NSObject, NSCoding, NSSecureCoding {
    
    public static var supportsSecureCoding: Bool = true
    var name : String
    var beers : [Beer]
    
    init(_name: String) {
        self.name = _name
        self.beers = [Beer]()
    }
    public func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(beers, forKey: "beers")
    }
    
    public required init?(coder: NSCoder) {
        self.name = coder.decodeObject(forKey: "name") as! String
        self.beers = coder.decodeObject(forKey: "beers") as! [Beer]
    }
    

    
}
