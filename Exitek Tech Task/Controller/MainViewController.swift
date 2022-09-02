//
//  ViewController.swift
//  Exitek Tech Task
//
//  Created by Иван Бегичев on 02.09.2022.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    var testArray: [Movies] = []
    var filmTitle: String?
    var releaseDate: Int?
    //MARK: - Outlets
    @IBOutlet weak var filmNameTextField: UITextField!
    @IBOutlet weak var filmReleaseYearTextField: UITextField!
    @IBOutlet weak var filmAddButton: UIButton!
    @IBOutlet weak var filmsListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
        configureFilmListTableView()
        hideKeyboardWhenTappedAround()
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
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Error", message: "Not all data is complete", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Okay", style: .default)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
    
    @IBAction func buttonTapped() {
        if let textFromNameTextField = filmNameTextField.text {
            if filmNameTextField.text != "" {
                self.filmTitle = textFromNameTextField.capitalized
                managedObject.setValue(textFromNameTextField, forKey: "filmTitle")
            } else if filmNameTextField.text == "" || filmReleaseYearTextField.text == "" {
                showAlert()
            }
            
            if let textFormReleaseYearTextField = filmReleaseYearTextField.text {
                if filmReleaseYearTextField.text != "" {
                    self.releaseDate = Int(textFormReleaseYearTextField)
                    managedObject.setValue(textFormReleaseYearTextField, forKey: "filmReleaseData")
                } else if filmNameTextField.text == "" || filmReleaseYearTextField.text == "" {
                    showAlert()
                }
            }
            
            if releaseDate != nil && filmTitle != nil {
                let test = managedObject.value(forKey: "filmTitle")
                let testOne = managedObject.value(forKey: "filmReleaseData")
                if testArray.contains(test) {
                    let alert = UIAlertController(title: "Error", message: "You have already added this movie", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default))
                    present(alert, animated: true)
                } else {
                    print("\(test),\(testOne)")
                }
                filmsListTableView.reloadData()
                filmNameTextField.text = ""
                filmReleaseYearTextField.text = ""
                releaseDate = nil
                filmTitle = nil
            }
        }
    }
    
}

