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
       
    }

    @IBAction func GoBack(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func AddToFavourites(_ sender: UIButton) {
//        AddToFavourites(currentTicker)
    }
    
    func addTickerToFavourites(addTicker: String) {
//        favourites.append(currentTicker)
    }
}
