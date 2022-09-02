//
//  FilmNameTexFieldDelegateExtension.swift
//  Exitek Tech Task
//
//  Created by Иван Бегичев on 02.09.2022.
//

import Foundation
import UIKit

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.text = ""
        return true
    }
}
