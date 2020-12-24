//
//  Beer.swift
//  BeerManager
//
//  Created by  AlbaCruz on 24/12/2020.
//  Copyright © 2020  AlbaCruz. All rights reserved.
//

import Foundation
import UIKit
public class Beer : NSObject, NSCoding, NSSecureCoding {
    public static var supportsSecureCoding = true
    var name:String
    var tipoEnvase:String //TODO: Enum TipoEnvase
    var fabricante:String
    var pais:String
    var capacidad:Float
    var fechaConsumo:Date
    var nota:String
    var id:Int
    var gradIBU:Float
    var gradAlc:Float
    var foto:UIImage?
    
    public func encode(with coder: NSCoder) {
        <#code#>
    }
    
    public required init?(coder: NSCoder) {
        <#code#>
    }
    
    
    
    
    
}
