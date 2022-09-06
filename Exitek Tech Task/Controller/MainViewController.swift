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
    
    var models = [Movies]()
    
    struct Constants {
        static let entity = "Movies"
        static let cellName = "Cell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
        configureFilmListTableView()
        hideKeyboardWhenTappedAround()
        getAllItems()
    }
    
    func getAllItems() {
        do {
            models = try CoreDataManger.instance.context.fetch(Movies.fetchRequest())
            DispatchQueue.main.async {
                self.filmsListTableView.reloadData()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func createItem(title: String, year: String) {
        let newItem = Movies(context: CoreDataManger.instance.context)
        newItem.filmTitle = title
        newItem.filmReleaseData = Int16(year) ?? 0
        
        do {
            try CoreDataManger.instance.context.save()
        } catch {
            //error
            print(error.localizedDescription)
        }
        getAllItems()
    }
    
    func deleteItems(item: Movies) {
        CoreDataManger.instance.context.delete(item)
        getAllItems()
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
    
    private func configureTextFields() {
        filmNameTextField.delegate = self
        filmReleaseYearTextField.delegate = self
    }
    
    private func configureFilmListTableView() {
        filmsListTableView.delegate = self
        filmsListTableView.dataSource = self
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
        
        for model in models {
            if model.filmTitle == filmNameTextField.text?.capitalized && Int16(filmReleaseYearTextField.text?.capitalized ?? "0") == model.filmReleaseData {
                showAlereadySavedAlert()
                textReset()
                return false
            }
        }
        
        createItem(title: filmNameTextField.text?.capitalized ?? "", year: filmReleaseYearTextField.text?.capitalized ?? "0")
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
    
    @IBAction func buttonTapped() {
       saveMovie()
    }
    
}
