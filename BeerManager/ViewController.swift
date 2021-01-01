//
//  ViewController.swift
//  BeerManager
//
//  Created by  AlbaCruz on 24/12/2020.
//  Copyright © 2020  AlbaCruz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var m = Model()
    var editingStyle:UITableViewCell.EditingStyle?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // TODO: Hacer guardado en disco cada vez que se vaya a background.
        self.editingStyle = UITableViewCell.EditingStyle.none;
        self.tableView.dataSource = self
        self.tableView.reloadData()
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
    

}

