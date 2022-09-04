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
    
    var movie: Movies?
    
    struct Constants {
        static let entity = "Movies"
        static let sortName = "filmTitle"
        static let cellName = "Cell"
    }
    
    var fetchResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.entity)
        let sortDescripter = NSSortDescriptor(key: Constants.sortName, ascending: true)
        fetchRequest.sortDescriptors = [sortDescripter]
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManger.instance.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
        configureFilmListTableView()
        hideKeyboardWhenTappedAround()
        
        do {
            try fetchResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func textReset() {
        filmNameTextField.text = ""
        filmReleaseYearTextField.text = ""
    }
    
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
    
    func saveMovie() -> Bool {
        if filmNameTextField.text!.isEmpty || filmReleaseYearTextField.text!.isEmpty {
            showNotFieldAreFilledAlert()
            return false
        }
        
        do {
            let results = try CoreDataManger.instance.context.fetch(fetchResultController.fetchRequest)
            for result in results as! [Movies] {
                if result.filmTitle == filmNameTextField.text {
                    showAlereadySavedAlert()
                    textReset()
                    return false
                }
            }
        } catch {
            print(error)
        }
        
        if movie == nil {
            movie = Movies()
        }

        if let movie = movie {
            movie.filmTitle = filmNameTextField.text?.capitalized
            movie.filmReleaseData = Int16(filmReleaseYearTextField.text?.capitalized ?? "0") ?? 0
            CoreDataManger.instance.saveContext()
            textReset()
        }
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
    
    @IBAction func buttonTapped() {
        saveMovie()
        do {
            try fetchResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

