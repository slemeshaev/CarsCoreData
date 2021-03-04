//
//  CarsViewController.swift
//  CarsCoreData
//
//  Created by Станислав Лемешаев on 04.03.2021.
//

import UIKit
import CoreData

class CarsViewController: UIViewController {
    
    // MARK: - Properties
    
    lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var markLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var lastTimeStartedLabel: UILabel!
    @IBOutlet weak var numberOfTripsLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var myChoiceImageView: UIImageView!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func segmentedCtrlPressed(_ sender: UISegmentedControl) {
        //
    }
    
    @IBAction func startEnginePressed(_ sender: UIButton) {
        //
    }
    
    @IBAction func rateItPressed(_ sender: UIButton) {
        // 
    }
    
    // MARK: - Helpers


}
