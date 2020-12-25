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
    
    public override init() {
        let DOCS_URL = documentsURL()
        let URL_OF_BEERS_IN_DOCUMENTS = DOCS_URL.appendingPathComponent(NAME_OF_FOLDER_IN_BUNDLE).appendingPathComponent(NAME_OF_FOLDER_IN_DOCUMENTS)
        cervezas = [Beer]()
        super.init()
        var didReadBinaryBeers = false //TODO: Leer y guardar	 de binario
        var didReadCsvBeers = false
        
        if (!didReadBinaryBeers) {
            cervezas = readBeersFromCsv()
            if cervezas.count != 0 {
                didReadCsvBeers = true
            }
        }
        
        assert (didReadBinaryBeers || didReadCsvBeers)
    }
    
    public func readBeersFromCsv() -> [Beer] {
        var tmpList = [Beer]()
        var tmpBeer:Beer?
        for s in bundleReadAllLinesFromFile(NAME_OF_BEER_FILE_IN_BUNDLE, inFolder: NAME_OF_FOLDER_IN_BUNDLE, withExtension: "csv" )! { //TODO: Cambiar esto. Usar ! es peligroso
            tmpBeer = Beer(record: s)
            if let a = tmpBeer {
                tmpList.append(a)
            }
        }
        return tmpList
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(cervezas, forKey: "cervezas")
    }
    
    public required init?(coder: NSCoder) {
        self.cervezas = coder.decodeObject(forKey: "cervezas") as! [Beer]
    }
    
}
