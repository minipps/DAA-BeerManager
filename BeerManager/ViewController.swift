//
//  ViewController.swift
//  BeerManager
//
//  Created by  AlbaCruz on 24/12/2020.
//  Copyright © 2020  AlbaCruz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //MARK: TODO: SORT
    //MARK: TODO: Cleanup
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var m = Model()
    var editingStyle:UITableViewCell.EditingStyle?
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue) {
//        let tmp = sender as! TableDetailViewController
//        tmp.cerveza?.name = tmp.nombre ?? "Sin nombre"
//        tmp.cerveza?.fabricante = tmp.fab ?? "Sin fabricante"
        self.tableView.reloadData()
        return
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // TODO: Hacer guardado en disco cada vez que se vaya a background.
        self.editingStyle = UITableViewCell.EditingStyle.none;
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.allowsSelectionDuringEditing = true
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterBackground(notification:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        self.tableView.reloadData()
    }
    
    @objc func applicationWillEnterBackground(notification : NSNotification) {
        if !m.serializeToDocuments() {
            notifyUser(self, alertTitle: "I/O Error", alertMessage: "No se pudo escribir el archivo serializado.", runOnOK: {_ in})
        }
    }

    @IBAction func addButtonAction(_ sender : Any) {
        if (self.editingStyle == UITableViewCell.EditingStyle.none) {
            self.editingStyle = UITableViewCell.EditingStyle.insert
            self.removeButton.isEnabled = false
            self.addButton.setTitle("DONE", for: .normal)
            self.tableView.setEditing(true, animated: true)
        } else {
            self.editingStyle = UITableViewCell.EditingStyle.none
            self.removeButton.isEnabled = true
            self.addButton.setTitle("Add beer", for: .normal);
            self.tableView.setEditing(false, animated: true);
        }
    }

    @IBAction func removeButtonAction(_ sender : Any) {
        if (self.editingStyle == UITableViewCell.EditingStyle.none) {
            self.editingStyle = UITableViewCell.EditingStyle.delete
            self.addButton.isEnabled = false
            self.removeButton.setTitle("DONE", for: .normal)
            self.tableView.setEditing(true, animated: true)
        } else {
            self.editingStyle = UITableViewCell.EditingStyle.none
            self.addButton.isEnabled = true
            self.removeButton.setTitle("Remove beer", for: .normal);
            self.tableView.setEditing(false, animated: true);
        }
    }
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return m.cervezas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let n = indexPath.row
        let beer = m.cervezas[n]
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


}
//MARK: TODO: TableViewControllerDelegate
extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.editingStyle == UITableViewCell.EditingStyle.delete {
               //MARK: TODO: Hay que hacer una confirmacion antes de borrar
                  self.m.cervezas.remove(at: indexPath.row)
                  self.tableView.beginUpdates()
                  self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                  self.tableView.endUpdates()
       } else if self.editingStyle == UITableViewCell.EditingStyle.insert {
                    let b = Beer()
                    m.cervezas.insert(b, at: indexPath.row)
                    self.tableView.insertRows(at: [indexPath], with: .fade)
                    self.performSegue(withIdentifier: "detailSegue", sender: m.cervezas[indexPath.row])
                   tableView.reloadData()
        } else {
            self.performSegue(withIdentifier: "detailSegue", sender: m.cervezas[indexPath.row])
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondViewController = segue.destination as! TableDetailViewController
        secondViewController.cerveza = (sender as! Beer)
    }
}
