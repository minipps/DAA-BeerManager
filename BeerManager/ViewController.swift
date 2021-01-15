//
//  ViewController.swift
//  BeerManager
//
//  Created by  AlbaCruz on 24/12/2020.
//  Copyright © 2020  AlbaCruz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    //El "boton" de sort es un TextField porque nos permite sacar un PickerView por encima de nuestra vista muy fácilmente. En dispositivos normales no hay problema (no se muestra el teclado), sin embargo si alguien usa un teclado con su iPhone puede darse cuenta de esto... Igualmente, el texto se resetea para evitar problemas.
    @IBOutlet weak var sortButton: UITextField!
    //MARK: Atributos
    var m = Model()
    var editingStyle:UITableViewCell.EditingStyle?
    var lastIndexPath: IndexPath?
    var listOfSortingMethods : [String] = ["Name", "Date", "Maker", "Alcohol %"]
    var picker = UIPickerView()
    //MARK: myUnwindAction (unwind desde el maker detail view)
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue) {
        self.tableView.reloadData()
        return
    }
    //MARK: beerDetailViewUnwindAction
    @IBAction func beerDetailViewUnwindAction(unwindSegue:
        UIStoryboardSegue) {
        let fabricante = m.fabricantes[lastIndexPath!.section]
        print("LastCerveza: \(fabricante.beers[lastIndexPath!.row].name)")
        if fabricante.beers[lastIndexPath!.row].name == "Nueva cerveza" {
            fabricante.beers.remove(at: lastIndexPath!.row)
            notifyUser(self, alertTitle: "Insertion error", alertMessage: "Blank beers are not allowed. If you want to insert a beer, change its name before clicking accept.", runOnOK: {_ in})
        }
        self.tableView.reloadData()
        return
    }
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Notificaciones de volver y salir de la aplicación, para serializar y deserializar.
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillComeBackFromBackground(notification:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterBackground(notification:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        let nib = UINib(nibName: "TableHeaderView", bundle: nil)
        self.tableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableHeaderView")
        self.tableView.sectionHeaderHeight = 50
        //Declaraciones del picker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "DONE", style: .plain, target: self, action: #selector(dismissPickerView))
        toolbar.setItems([doneButton], animated: false)
        picker.dataSource = self
        picker.delegate = self
        self.sortButton.inputView = picker
        self.sortButton.borderStyle = .none
        self.sortButton.backgroundColor = .clear
        self.sortButton.tintColor = .clear
        self.sortButton.inputAccessoryView = toolbar
        //Declaraciones de la tabla y headers
        self.editingStyle = UITableViewCell.EditingStyle.none;
        self.lastIndexPath = IndexPath()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.allowsSelectionDuringEditing = true
        //Evita un crash si el hilo principal empieza a crear la tabla antes de que se hayan cargado los datos totalmente. Seguramente haya una solución más limpia.
        while !(self.m.didReadBinaryBeers || self.m.didReadCsvBeers || self.m.didGetDataFromInternet) {
            continue
        }
        self.tableView.reloadData()
    }
    //MARK: applicationWillEnterBackground
    @objc func applicationWillEnterBackground(notification : NSNotification) {
        if !m.serializeToDocuments() {
            notifyUser(self, alertTitle: "I/O Error", alertMessage: "No se pudo escribir el archivo serializado.", runOnOK: {_ in})
        }
    }
    //MARK: applicationWillComeBackFromBackground
    @objc func applicationWillComeBackFromBackground(notification: NSNotification) {
        if !m.deserializeFromDocuments() {
            notifyUser(self, alertTitle: "I/O Error", alertMessage: "No se pudo leer el archivo serializado.", runOnOK: {_ in})
        }
    }
    //MARK: addButtonAction
    @IBAction func addButtonAction(_ sender : Any) {
        if (self.editingStyle == UITableViewCell.EditingStyle.none) {
            self.editingStyle = UITableViewCell.EditingStyle.insert
            self.removeButton.isEnabled = false
            self.sortButton.isEnabled = false
            self.sortButton.isHidden = true
            self.addButton.setTitle("DONE", for: .normal)
            self.tableView.setEditing(true, animated: true)
        } else {
            self.editingStyle = UITableViewCell.EditingStyle.none
            self.removeButton.isEnabled = true
            self.sortButton.isEnabled = true
            self.sortButton.isHidden = false
            self.addButton.setTitle("Add", for: .normal);
            self.tableView.setEditing(false, animated: true);
        }
    }
    //MARK: removeButtonAction
    @IBAction func removeButtonAction(_ sender : Any) {
        if (self.editingStyle == UITableViewCell.EditingStyle.none) {
            self.editingStyle = UITableViewCell.EditingStyle.delete
            self.addButton.isEnabled = false
            self.sortButton.isEnabled = false
            self.sortButton.isHidden = true
            self.removeButton.setTitle("DONE", for: .normal)
            self.tableView.setEditing(true, animated: true)
        } else {
            self.editingStyle = UITableViewCell.EditingStyle.none
            self.addButton.isEnabled = true
            self.sortButton.isEnabled = true
            self.sortButton.isHidden = false
            self.removeButton.setTitle("Remove", for: .normal);
            self.tableView.setEditing(false, animated: true);
        }
    }
    //MARK: headerTap
    @IBAction func headerTap(gesture: UITapGestureRecognizer) {
        let section = gesture.view?.tag
        performSegue(withIdentifier: "makerDetailSegue", sender: self.m.fabricantes[section!])
    }
    //MARK: sortTap
    @IBAction func sortTap(_ sender : Any) {
        self.addButton.isEnabled = false
        self.removeButton.isEnabled = false
        self.tableView.isUserInteractionEnabled = false
    }
    //MARK: dismissPickerView (usado para el boton "done" del pickerView
    @objc func dismissPickerView() {
        self.tableView.isUserInteractionEnabled = true
        self.addButton.isEnabled = true
        self.removeButton.isEnabled = true
        self.sortButton.text = "Sort"
        view.endEditing(true)
    }
}
//MARK: UITableViewDataSource
extension ViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.m.fabricantes[section].beers.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.m.fabricantes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let n = indexPath.row
        let beer = self.m.fabricantes[indexPath.section].beers[n]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RowCell")
        as! RowCell
        if let foto = beer.foto {
            cell.beerPhoto?.image = foto;
        }
        cell.beerName?.text = beer.name;
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return self.editingStyle ?? .none
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView {
        let fabricante = m.fabricantes[section]
        var backgroundView = UIView()
        backgroundView.backgroundColor = .lightGray
        let blankHeaderUI = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableHeaderView")
        blankHeaderUI?.tag = section
        let customHeaderUI = blankHeaderUI as! TableHeaderView
        customHeaderUI.name.text = fabricante.name
        customHeaderUI.backgroundView = backgroundView
        let headerTapGesture = UITapGestureRecognizer(target: self, action: #selector(headerTap(gesture:)))
        headerTapGesture.numberOfTapsRequired = 1
        customHeaderUI.addGestureRecognizer(headerTapGesture)
        	
        return customHeaderUI
    }


}

//MARK: UITableViewDelegate
extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.lastIndexPath = indexPath
        let fabricante = self.m.fabricantes[indexPath.section]
        if self.editingStyle == UITableViewCell.EditingStyle.delete {
            userConfirmsAction(self, alertTitle: "Deletion confirmation", alertMessage: "Do you really want to delete this beer?" , runOnConfirm: {_ in fabricante.beers.remove(at: indexPath.row);
                self.tableView.beginUpdates();
                self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic);
                self.tableView.endUpdates()}, runOnCancel: {_ in})
            
       } else if self.editingStyle == UITableViewCell.EditingStyle.insert {
                    let b = Beer()
            fabricante.beers.insert(b, at: indexPath.row)
                    self.tableView.insertRows(at: [indexPath], with: .fade)
            self.performSegue(withIdentifier: "detailSegue", sender: fabricante.beers[indexPath.row])
                   tableView.reloadData()
        } else {
            self.performSegue(withIdentifier: "detailSegue", sender: self.m.fabricantes[indexPath.section].beers[indexPath.row])
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailSegue") {
            let secondViewController = segue.destination as! TableDetailViewController
            secondViewController.m = self.m
            secondViewController.cerveza = (sender as! Beer)
        } else if (segue.identifier == "makerDetailSegue") {
            let secondViewController = segue.destination as! MakerDetailView
            secondViewController.fabricante = (sender as! Maker)
        }
    }
}
//MARK: UIPickerViewDataSource
extension ViewController : UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return self.listOfSortingMethods.count
        }
        
        func pickerView(_: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return self.listOfSortingMethods[row]
        }

    }
    extension ViewController : UIPickerViewDelegate {
        func pickerView(_: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            let sortingMethod = self.listOfSortingMethods[row]
            switch(sortingMethod) {
            case "Name":
                for f in self.m.fabricantes {
                    f.beers.sort(by: { $0.name < $1.name })
                }
            case "Date":
                for f in self.m.fabricantes {
                    f.beers.sort(by: { $0.fechaConsumo < $1.fechaConsumo })
                }
            case "Maker":
                self.m.fabricantes.sort(by : { $0.name < $1.name})
            case "Alcohol %":
                for f in self.m.fabricantes {
                    f.beers.sort(by: {$0.gradAlc < $1.gradAlc})
                }
            default:
                break;
            }
            self.tableView.reloadData()
            self.sortButton.text = "Sort"
            resignFirstResponder()
        }
}

