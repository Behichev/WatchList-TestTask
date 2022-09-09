//
//  ViewController.swift
//  Exitek Tech Task
//
//  Created by Иван Бегичев on 02.09.2022.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var filmNameTextField: UITextField!
    @IBOutlet weak var filmReleaseYearTextField: UITextField!
    @IBOutlet weak var filmAddButton: UIButton!
    @IBOutlet weak var filmsListTableView: UITableView!
    
    var model: Movies?
    
    struct Constants {
        static let entity = "Movies"
        static let cellName = "Cell"
        static let sortName = "filmTitle"
    }
    
    var fetchResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.entity)
        var sortDescriptor = NSSortDescriptor(key: Constants.sortName, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        var fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManger.instance.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllItems()
        configureTextFields()
        configureFilmListTableView()
        hideKeyboardWhenTappedAround()
        
    }
    
    func getAllItems() {
        do {
            try fetchResultController.performFetch()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func createItem(title: String, year: String) {
        if model == nil {
            model = Movies()
        } else if model != nil {
            model = Movies()
        }
        
        if let model = model {
            model.filmTitle = title
            model.filmReleaseData = Int16(year)!
        }
        CoreDataManger.instance.saveContext()
    }
    
    func deleteItems(item: Movies) {
        CoreDataManger.instance.context.delete(item)
        do {
            try CoreDataManger.instance.context.save()
        } catch {
            //error
            print(error.localizedDescription)
        }
    }
    
    func textReset() {
        filmNameTextField.text = ""
        filmReleaseYearTextField.text = ""
    }
    
    func isPropperSymbol(symbol: Character) -> Bool {
        if let scalar = symbol.unicodeScalars.first {
            let value = scalar.value
            return (value >= 65 && value <= 90) || (value >= 97 && value <= 122) || (value >= 48 && value <= 57)
        }
        return false
    }
    
    
    
    func saveMovie() -> Bool {
        let filmTitle = filmNameTextField.text!.capitalized.filter{isPropperSymbol(symbol: $0)}
        let releaseDate = filmReleaseYearTextField.text!.capitalized
        
        
        if filmTitle.isEmpty || releaseDate.isEmpty {
            showNotFieldAreFilledAlert()
            return false
        }
        
        for model in fetchResultController.fetchedObjects as! [Movies] {
            if model.filmTitle?.lowercased() == filmTitle.lowercased() {
                showAlereadySavedAlert()
                textReset()
                return false
            }
        }
        
        createItem(title: filmTitle, year: releaseDate)
        textReset()
        return true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showNotFieldAreFilledAlert() {
        let alert = UIAlertController(title: "Error", message: "Not all fields are filled", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Okay", style: .default)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
    
    func showAlereadySavedAlert() {
        let alert = UIAlertController(title: "Error", message: "You have already saved this movie", preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
    //MARK: - Private
    private func configureTextFields() {
        filmNameTextField.delegate = self
        filmReleaseYearTextField.delegate = self
    }
    
    private func configureFilmListTableView() {
        filmsListTableView.delegate = self
        filmsListTableView.dataSource = self
        fetchResultController.delegate = self
    }
    
    private func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(MainViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func buttonTapped() {
        saveMovie()
    }
    
}
