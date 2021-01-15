//
//  TableDetailViewController.swift
//  BeerManager
//
//  Created by  AlbaCruz on 01/01/2021.
//  Copyright © 2021  AlbaCruz. All rights reserved.
//

import Foundation
import UIKit
class TableDetailViewController : UIViewController {
    //MARK: Constantes
    let FORMATO_FECHA = "MMMM dd"
    //MARK: Outlets
    @IBOutlet var makerPickerInput : UIPickerView!
    @IBOutlet var nameTextInput : UITextField!
    @IBOutlet var imagenView : UIImageView!
    @IBOutlet weak var envaseTextField: UITextField!
    @IBOutlet weak var capacidadTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var notaTextField: UITextField!
    @IBOutlet weak var ibuTextField: UITextField!
    @IBOutlet weak var alcoholTextField: UITextField!
    //MARK: Atributos
    var nombre : String?
    var tipoEnvase:String?
    var capacidad:Float?
    var fab : String?
    var fechaConsumo:Date?
    var nota:String?
    var id:String?
    var gradIBU:Float?
    var gradAlc:Float?
    var foto:UIImage?
    var cerveza : Beer?
    var img : UIImage?
    let picker = UIImagePickerController()
    var datePicker = UIDatePicker()
    var m : Model?
    let df = DateFormatter()
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set-up del launcher de la camera / galeria
        let photoTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(photoTap(gesture:)))
        self.imagenView.isUserInteractionEnabled = true
        self.imagenView.addGestureRecognizer(photoTapGestureRecognizer)
        // Set-up de los label de los textfield y algunas caracteristicas
        setLeftViewLabel(textField: self.nameTextInput, string: "Name: ")
        setLeftViewLabel(textField: self.envaseTextField, string: "Packaging: ")
        setLeftViewLabel(textField: self.capacidadTextField, string: "Quantity (mL): ")
        self.capacidadTextField.keyboardType = .decimalPad
        setLeftViewLabel(textField: self.dateTextField, string: "Date: ")
        //MARK: Si se buildea para iOS 13.4+ se puede usar esta opción, que hará el input de datos mucho mejor... Previa a esta versión solo está disponible un estilo.
        //self.dateTextField.preferredDatePickerStyle = .compact
        self.dateTextField.inputView = datePicker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "DONE", style: .plain, target: self, action: #selector(dismissDatePickerView))
        toolbar.setItems([doneButton], animated: false)
        self.dateTextField.inputAccessoryView = toolbar
        setLeftViewLabel(textField: self.notaTextField, string: "Notes: ")
        setLeftViewLabel(textField: self.ibuTextField, string:"IBU: ")
        self.ibuTextField.keyboardType = .decimalPad
        setLeftViewLabel(textField: self.alcoholTextField, string: "Alcohol %:")
        self.alcoholTextField.keyboardType = .decimalPad
    
        //Iniciamos los atributos locales
        self.nombre = cerveza?.name
        self.fab = cerveza?.fabricante
        self.tipoEnvase = cerveza?.tipoEnvase
        self.capacidad = cerveza?.capacidad
        self.fechaConsumo = cerveza?.fechaConsumo
        self.nota = cerveza?.nota
        self.id = cerveza?.id
        self.gradIBU = cerveza?.gradIBU
        self.gradAlc = cerveza?.gradAlc
        self.img = cerveza?.foto
        if (self.img != nil) {//Si es nil dejamos el placeholder
            self.imagenView.image = self.img
        }
        //Ultimos retoques
        df.dateFormat = FORMATO_FECHA
        df.locale = Locale(identifier: "es_ES")
        self.picker.allowsEditing = false;
        self.makerPickerInput.dataSource = self
        self.makerPickerInput.delegate = self
        self.picker.modalPresentationStyle = .fullScreen
        self.picker.mediaTypes = ["public.image"]
        self.datePicker.setDate(self.fechaConsumo!, animated: false)
    }
    //MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        let df = DateFormatter()
        df.dateFormat = FORMATO_FECHA
        df.locale = Locale(identifier: "es_ES")
        self.nameTextInput.text = self.nombre
        self.envaseTextField.text = self.tipoEnvase
        self.capacidadTextField.text = "\(self.capacidad!)"
        self.dateTextField.text = df.string(from: self.fechaConsumo!)
        self.notaTextField.text = self.nota
        self.ibuTextField.text = "\(self.gradIBU!)"
        self.alcoholTextField.text = "\(self.gradAlc!)"
    }
    //MARK: backButton
    @IBAction func backButton(sender: Any?) {
        performSegue(withIdentifier: "unwindSegue", sender: self)
    }
    //MARK: acceptButton
    @IBAction func acceptButton(sender: Any?) {
        
        cerveza?.name = self.nameTextInput.text ?? self.nombre!
        cerveza?.tipoEnvase = self.envaseTextField.text ?? self.tipoEnvase!
        cerveza?.capacidad = (self.capacidadTextField?.text as? NSString)?.floatValue ?? self.capacidad!
        cerveza?.fechaConsumo = df.date(from: self.dateTextField.text!) ?? self.fechaConsumo!
        cerveza?.nota = self.notaTextField.text ?? self.nota!
        cerveza?.gradIBU = (self.ibuTextField?.text as? NSString)?.floatValue ?? self.gradIBU!
        cerveza?.gradAlc = (self.alcoholTextField?.text as? NSString)?.floatValue ?? self.gradAlc!
        if self.imagenView.image != nil {
            cerveza?.foto = self.imagenView.image
        }
        if (cerveza?.fabricante != self.fab) {
            let index = self.m?.stringAFabricante[cerveza!.fabricante]!.beers.firstIndex(of: cerveza!)
            self.m?.stringAFabricante[cerveza!.fabricante]!.beers.remove(at: index!)
            cerveza?.fabricante = self.fab!
            
            self.m?.stringAFabricante[self.fab!]!.beers.append(cerveza!)
            
        }
        performSegue(withIdentifier: "unwindSegue", sender: self)
    }
    //MARK: photoTap
    @IBAction func photoTap(gesture: UITapGestureRecognizer) {
        self.picker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        if !(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            print("No se pudo iniciar la cámara (estás en simulador?). Cogemos la librería de fotos por defecto.")
            self.picker.sourceType = .photoLibrary
        } else {
            self.picker.sourceType = .camera
            self.picker.cameraCaptureMode = .photo
        }
        present(self.picker, animated: true, completion: nil)
    }
    //MARK: setLeftViewLabel
    func setLeftViewLabel(textField: UITextField, string: String) {
        var label = UILabel()
        label.text = string
        textField.leftView = label
        textField.leftViewMode = .always
    }
    @objc func dismissDatePickerView() {
        self.dateTextField.text = df.string(from: datePicker.date)
        view.endEditing(true)
    }
}
//MARK: UIPickerViewDataSource
extension TableDetailViewController : UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.m?.fabricantes.count ?? 1
    }
    
    func pickerView(_: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.m?.fabricantes[row].name ?? "Unknown maker"
    }

}
//MARK: UIPickerViewDelegate
extension TableDetailViewController : UIPickerViewDelegate {
    func pickerView(_: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.fab = self.m?.fabricantes[row].name ?? "Unknown maker"
    }
}
//MARK: UIImagePickerControllerDelegate
extension TableDetailViewController : UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let fotoTmp = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.img = fotoTmp
        self.imagenView.image = fotoTmp
        self.imagenView.setNeedsDisplay()
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated:true, completion: nil)
    }
}

extension TableDetailViewController : UINavigationControllerDelegate {
    	
}


