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
    //MARK: Constants
    let FORMATO_FECHA = "MMMM dd"
    let NAME_OF_PHOTO_FOLDER_IN_BUNDLE = "BeerManager-photos"
    public static var supportsSecureCoding = true
    //MARK: Attributes
    var name:String
    var tipoEnvase:String
    var fabricante:String
    var capacidad:Float
    var fechaConsumo:Date
    var nota:String
    var id:String
    var gradIBU:Float
    var gradAlc:Float
    var foto:UIImage?
    //MARK: init() with token string
    public init?(record: String) {
        let tokens = record.components(separatedBy: "\t")
        let fm = FileManager.default
        let df = DateFormatter()
        df.dateFormat = FORMATO_FECHA
        df.locale = Locale(identifier: "es_ES")
        guard tokens.count == 10 else { return nil }
        let tempName = tokens[0]
        let tempTipo = tokens[1]
        let tempFab = tokens[2]
        let tempCapacidad = (tokens[3] as NSString).floatValue
        guard let tempFecha = df.date(from: tokens[4]) else { return nil }
        let tempNota = tokens[5]
        let tempId = tokens[6]
        let tempGradIBU = (tokens[7] as NSString).floatValue
        let tempGradAlc = (tokens[8] as NSString).floatValue
        guard let imagePath = splitIntoNameAndExtension(total: tokens[9]),
            let fullPath = Bundle.main.url(forResource: imagePath[0], withExtension: imagePath[1], subdirectory: NAME_OF_PHOTO_FOLDER_IN_BUNDLE),
            fm.fileExists(atPath: fullPath.path),
            let tempFoto = UIImage(contentsOfFile: fullPath.path)
        else { return nil }
        
        
        guard tempCapacidad != 0.0,
            tempGradIBU != 0.0
            else { return nil } //Si tempCapacidad es 0.0 o gradIbu es 0.0, es porque no se ha parseado correctamente
                            //No podemos hacer guard de lo mismo para gradAlc porque esto no nos dejaría añadir cervezas sin alcohol
        self.name = tempName
        self.tipoEnvase = tempTipo
        self.fabricante = tempFab.trimmingCharacters(in: .whitespacesAndNewlines)
        self.capacidad = tempCapacidad
        self.fechaConsumo = tempFecha
        self.nota = tempNota
        self.id = tempId
        self.gradIBU = tempGradIBU
        self.gradAlc = tempGradAlc
        self.foto = tempFoto;
    }
    //MARK: Empty init
    override public init() {
        self.name = "Nueva cerveza"
        self.tipoEnvase = ""
        self.fabricante = ""
        self.capacidad = 0.0
        self.fechaConsumo = Date()
        self.nota = ""
        self.id = ""
        self.gradIBU = 0.0
        self.gradAlc = 0.0
        self.foto = nil;
    }
    //MARK: NSCoder stubs
    public func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(tipoEnvase, forKey: "tipoEnvase")
        coder.encode(fabricante, forKey: "fabricante")
        coder.encode(capacidad, forKey: "capacidad")
        coder.encode(fechaConsumo, forKey: "fechaConsumo")
        coder.encode(nota, forKey: "nota")
        coder.encode(id, forKey: "id")
        coder.encode(gradIBU, forKey: "gradIBU")
        coder.encode(gradAlc, forKey: "gradAlc")
        coder.encode(foto, forKey: "foto")
    }
    
    public required init?(coder: NSCoder) {
        self.name = coder.decodeObject(forKey: "name") as! String
        self.tipoEnvase = coder.decodeObject(forKey: "tipoEnvase") as! String
        self.fabricante = coder.decodeObject(forKey: "fabricante") as! String
        self.capacidad = coder.decodeFloat(forKey: "capacidad")
        self.fechaConsumo = coder.decodeObject(forKey: "fechaConsumo") as! Date
        self.nota = coder.decodeObject(forKey: "nota") as! String
        self.id = coder.decodeObject(forKey: "id") as! String
        self.gradIBU = coder.decodeFloat(forKey: "gradIBU")
        self.gradAlc = coder.decodeFloat(forKey: "gradAlc")
        self.foto = coder.decodeObject(forKey: "foto") as? UIImage
        
    }
    
    func description() -> String{
        return "\(name), \(tipoEnvase), \(fabricante), \(capacidad), \(fechaConsumo), \(nota), \(id), \(gradIBU), \(gradAlc)"
    }
    
    
    
}
