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
    let dfm = FileManager.default
    public var cervezas:[Beer]
    
    public override init() {
        let DOCS_URL = documentsURL()
        let URL_OF_BEERS_IN_DOCUMENTS = DOCS_URL.appendingPathComponent(NAME_OF_FOLDER_IN_BUNDLE).appendingPathComponent("cervezas").appendingPathExtension("bin")
        cervezas = [Beer]()
        super.init()
        var didReadBinaryBeers = false
        var didReadCsvBeers = false
        //TODO: Error de deserialización (hay un nil)
        //didReadBinaryBeers = deserializeFromDocuments()
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
    
    public func serializeToDocuments() -> Bool {
        
        //TODO: Actualmente lo serializamos todo a un archivo. Quizas usar varios es mejor? 
        var data: Data!
        // En el simulador de iOS (versión >11.0) la carpeta de documentos no existe en aplicaciones instaladas nuevas. Esto es un arreglo rápido.
        let directory = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first!
        if !dfm.fileExists(atPath: directory) {
            do  {try dfm.createDirectory(atPath: directory, withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                return false
            }
        }
        let documentURL = documentsURL()
        let fileURL = documentURL.appendingPathComponent("cervezas").appendingPathExtension("bin")
        do {
            data = try NSKeyedArchiver.archivedData(withRootObject: cervezas, requiringSecureCoding: true)
        } catch {
            print("serializeToDocuments: Error de serialización.")
            return false
        }
        do {
            try data.write(to: fileURL)
        } catch {
            print("serializeToDocuments: Error de escritura")
            return false
        }
        print("serializeToDocuments: Serialización correcta")
        return true
    }
    
    public func deserializeFromDocuments() -> Bool {
        var data : Data!
        var tmp : Any?
        let documentURL = documentsURL()
        if documentURL == nil {return false}
        var cervezasURL = documentURL.appendingPathComponent("cervezas").appendingPathExtension("bin")
        do {
            data = try Data(contentsOf: cervezasURL)
        } catch {
            print("deserializeFromDocuments: Error de lectura del fichero serializado")
            return false
        }
        do {
            tmp = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
            self.cervezas = tmp as! [Beer]
            if self.cervezas.count == 0 {return false}
        } catch {
            print("deserializeFromDocuments: Error de deserialización")
            return false
        }
        
        return true
    }
    
    
    
    public func encode(with coder: NSCoder) {
        coder.encode(cervezas, forKey: "cervezas")
    }
    
    public required init?(coder: NSCoder) {
        self.cervezas = coder.decodeObject(forKey: "cervezas") as! [Beer]
    }
    
}
