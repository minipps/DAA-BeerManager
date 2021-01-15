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
    //MARK: Constantes
    let NAME_OF_FOLDER_IN_BUNDLE = "BeerManager-data"
    let NAME_OF_BEER_FILE_IN_BUNDLE = "defaultbeer"
    let NAME_OF_PHOTOGRAPH_FOLDER_IN_BUNDLE = "BeerManager-photos"
    let NAME_OF_FOLDER_IN_DOCUMENTS = "DataOfBeerManager"
    let NAME_OF_BEER_FILE_IN_DOCUMENTS = "FileOfBeers"
    //MARK: Atributos
    let dfm = FileManager.default
    public var cervezas:[Beer]
    public var fabricantes:[Maker]
    public var stringAFabricante:[String:Maker]
    public var listaNombresFabricantes:[String]
    var didReadBinaryBeers = false
    var didReadCsvBeers = false
    var didGetDataFromInternet = false
    //MARK: init()
    public override init() {
        let DOCS_URL = documentsURL()
        let URL_OF_BEERS_IN_DOCUMENTS = DOCS_URL.appendingPathComponent(NAME_OF_FOLDER_IN_BUNDLE).appendingPathComponent("cervezas").appendingPathExtension("bin")
        cervezas = [Beer]()
        fabricantes = [Maker]()
        stringAFabricante = [String:Maker]()
        listaNombresFabricantes = [String]()
        super.init()
        didReadBinaryBeers = deserializeFromDocuments()
        if (!didReadBinaryBeers) {
            didReadCsvBeers = readBeersFromCsv()
            if (!didReadCsvBeers) {
                didGetDataFromInternet = downloadDataFromInternet()
            }
        }
        
        assert (didReadBinaryBeers || didReadCsvBeers || didGetDataFromInternet)
    }
    //MARK: readBeersFromCsv
    public func readBeersFromCsv() -> Bool {
        var tmpList = [Beer]()
        var tmpBeer:Beer?

        for s in bundleReadAllLinesFromFile(NAME_OF_BEER_FILE_IN_BUNDLE, inFolder: NAME_OF_FOLDER_IN_BUNDLE, withExtension: "csv" )! {
        tmpBeer = Beer(record: s)
        if let a = tmpBeer {
            if !(stringAFabricante.keys.contains(a.fabricante))	 {
                fabricantes.append(Maker(_name: a.fabricante))
                stringAFabricante[a.fabricante] = fabricantes.last
                stringAFabricante[a.fabricante]?.beers.append(a)
                listaNombresFabricantes.append(a.fabricante)
            } else {
                stringAFabricante[a.fabricante]?.beers.append(a)
            }
            tmpList.append(a)
            }
        }
        self.cervezas = tmpList
        if (self.cervezas.count != 0) {
            return true
        } else {
            return false
        }
    }
    //MARK: serializeToDocuments
    public func serializeToDocuments() -> Bool {
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
        let fileURL = documentURL.appendingPathComponent("fabricantes").appendingPathExtension("bin")
        do {
            data = try NSKeyedArchiver.archivedData(withRootObject: fabricantes, requiringSecureCoding: true)
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
    //MARK: deserializeFromDocuments
    public func deserializeFromDocuments() -> Bool {
        var data : Data!
        var tmp : Any?
        let documentURL = documentsURL()
        if documentURL == nil {return false}
        var cervezasURL = documentURL.appendingPathComponent("fabricantes").appendingPathExtension("bin")
        do {
            data = try Data(contentsOf: cervezasURL)
        } catch {
            print("deserializeFromDocuments: Error de lectura del fichero serializado")
            return false
        }
        do {
            tmp = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
            self.fabricantes = tmp as! [Maker]
            for f in fabricantes {
                if !(self.stringAFabricante.keys.contains(f.name)) {
                    print("Nuevo fabricante: \(f.name)")
                    self.stringAFabricante[f.name] = f
                }
                if !(self.listaNombresFabricantes.contains(f.name)) {
                    self.listaNombresFabricantes.append(f.name)
                }
                for b in f.beers {
                    self.cervezas.append(b)
                }
            }
            if self.fabricantes.count == 0 {return false}
        } catch {
            print("deserializeFromDocuments: Error de deserialización")
            return false
        }
        print("deserializeFromDocuments(): Serialización correcta")
        return true
    }
    //MARK: downloadDataFromInternet
    public func downloadDataFromInternet() -> Bool {
        let remoteURL = URL(string: "http://maxus.fis.usal.es/HOTHOUSE/daa/2020beer/")
        let baseLocalDataURL = URL(string: NAME_OF_FOLDER_IN_BUNDLE)
        let baseLocalPhotoURL = URL(string: NAME_OF_PHOTOGRAPH_FOLDER_IN_BUNDLE)
        let localCsvPath = baseLocalDataURL!.appendingPathComponent("defaultbeer").appendingPathExtension("csv")
        if !dfm.fileExists(atPath: localCsvPath.absoluteString) {
            do {
            let tmp = try Data(contentsOf: (remoteURL?.appendingPathComponent("defaultbeer.csv"))!)
            }
            catch {
                print("Fallo descargando el csv de internet.")
                return false
            }
        }
        print("Se descargó correctamente el csv")
        return readBeersFromCsv()
    }
    
    //MARK: NSCoder protocol stubs
    public func encode(with coder: NSCoder) {
        coder.encode(fabricantes, forKey: "fabricantes")
    }
    
    public required init?(coder: NSCoder) {
        self.fabricantes = coder.decodeObject(forKey: "fabricantes") as! [Maker]
        self.cervezas = [Beer]()
        self.listaNombresFabricantes = [String]()
        self.stringAFabricante = [String:Maker]()
    }

}
