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
    @IBOutlet var nameTextInput : UITextField!
    @IBOutlet var fabTextInput : UITextField!
    @IBOutlet var imagenView : UIImageView!
    var nombre : String?
    var fab : String?
    var cerveza : Beer?
    var img : UIImage?
    let picker = UIImagePickerController();
    var m : Model?
    //MARK: TODO: AÑADIR TODOS LOS ATRIBUTOS
    //MARK: TODO: AÑADIR CONSTRAINTS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(photoTap(gesture:)))
        self.imagenView.isUserInteractionEnabled = true
        self.imagenView.addGestureRecognizer(tapGestureRecognizer)
        self.nombre = cerveza?.name
        self.fab = cerveza?.fabricante
        self.img = cerveza?.foto
        self.imagenView.image = self.img
        self.picker.allowsEditing = false;
        self.picker.modalPresentationStyle = .fullScreen
        self.picker.mediaTypes = ["public.image"]
    }
    override func viewWillAppear(_ animated: Bool) {
        self.nameTextInput.text = self.nombre
        self.fabTextInput.text = self.fab
    }
    
    @IBAction func backButton(sender: Any?) {
        performSegue(withIdentifier: "unwindSegue", sender: self)
    }
    
    @IBAction func acceptButton(sender: Any?) {
        cerveza?.name = self.nameTextInput.text!
        cerveza?.fabricante = self.fabTextInput.text!
        cerveza?.foto = self.imagenView.image!
        performSegue(withIdentifier: "unwindSegue", sender: self)
    }
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
}

extension TableDetailViewController : UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return m?.cervezas.count ?? 1
    }
    
    func pickerView(_: UIPickerView, didSelectRow: Int, inComponent: Int) {
        return
    }

}

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
