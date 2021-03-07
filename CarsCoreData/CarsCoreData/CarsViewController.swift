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
    
    @IBOutlet weak var markLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var lastTimeStartedLabel: UILabel!
    @IBOutlet weak var numberOfTripsLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var myChoiceImageView: UIImageView!
    
    var context: NSManagedObjectContext!
    
    lazy var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .none
        return df
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromFile()
        insertData()
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
    
    private func getDataFromFile() {
        
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "mark != nil")
        
        var records = 0
        
        do {
            records = try context.count(for: fetchRequest)
            print("Is Data there already?")
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        guard records == 0 else { return }
        
        guard let pathToFile = Bundle.main.path(forResource: "DataCars", ofType: "plist"),
              let dataArray = NSArray(contentsOfFile: pathToFile) else {
            print("Error retrieving data from file")
            return
        }
        
        for dictionary in dataArray {
            guard let entity = NSEntityDescription.entity(forEntityName: "Car", in: context) else { return }
            let car = NSManagedObject(entity: entity, insertInto: context) as! Car
            
            let carDictionary = dictionary as! [String: AnyObject]
            car.mark = carDictionary["mark"] as? String
            car.model = carDictionary["model"] as? String
            
            guard let imageName = carDictionary["imageName"] as? String else { return }
            let image = UIImage(named: imageName)
            let imageData = image?.pngData()
            car.imageData = imageData
            
            car.lastStarted = carDictionary["lastStarted"] as? Date
            car.rating = carDictionary["rating"] as! Double
            car.timesDriven = carDictionary["numberTrips"] as! Int16
            car.myChoice = carDictionary["myChoice"] as! Bool
            
            if let colorDictionary = carDictionary["tintColor"] as? [String: Float] {
                car.tintColor = getColor(colorDictionary: colorDictionary)
            }
            
        }
    }
    
    private func getColor(colorDictionary: [String: Float]) -> UIColor {
        guard let red = colorDictionary["red"],
              let green = colorDictionary["green"],
              let blue = colorDictionary["blue"] else { return UIColor() }
        return UIColor(red: CGFloat(red / 255), green: CGFloat(green / 255), blue: CGFloat(blue / 255), alpha: 1.0)
    }
    
    private func insertDataFrom(selectedCar car: Car) {
        markLabel.text = car.mark
        modelLabel.text = car.model
        if let carImage = car.imageData {
            carImageView.image = UIImage(data: carImage)
        }
        if let lastStarted = car.lastStarted {
            lastTimeStartedLabel.text = "Last time started: \(dateFormatter.string(from: lastStarted))"
        }
        numberOfTripsLabel.text = "Number of trips: \(car.timesDriven)"
        segmentedControl.tintColor = car.tintColor as? UIColor
        ratingLabel.text = "Rating: \(car.rating) / 10"
        myChoiceImageView.isHidden = !(car.myChoice)
    }
    
    private func insertData() {
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        guard let mark = segmentedControl.titleForSegment(at: 0) else { return }
        fetchRequest.predicate = NSPredicate(format: "mark == %@", mark)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let car = results.first {
                insertDataFrom(selectedCar: car)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
