//
//  DetailViewController.swift
//  StocksApp
//
//  Created by Daniyar Mamadov on 22.03.2021.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var companyName: UILabel!
    
    let model = StockModel.instance
    var favourites = StockModel.instance.favouriteTickers
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        companyName.text = model.selectedTicker
    }

    @IBAction func GoBack(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func AddToFavourites(_ sender: UIButton) {
        let currentTicker = model.companyItems.first { $0.ticker == model.selectedTicker }
        if (currentTicker != nil) { model.favouriteTickers.append(currentTicker!) }
        dump(model.favouriteTickers)
        }
    }
