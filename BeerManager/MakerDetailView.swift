//
//  MakerDetailView.swift
//  BeerManager
//
//  Created by  AlbaCruz on 14/01/2021.
//  Copyright © 2021  AlbaCruz. All rights reserved.
//

import Foundation
import UIKit

class MakerDetailView : UIViewController {
    //MARK: Outlets
    @IBOutlet weak var nameOfMaker: UILabel!
    @IBOutlet weak var numberOfBeers: UILabel!
    //MARK: Atributos
    var fabricante : Maker?
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameOfMaker.text = self.fabricante?.name
        self.numberOfBeers.text = "\(self.fabricante!.beers.count) beers"
    }
    //MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        
    }
}
