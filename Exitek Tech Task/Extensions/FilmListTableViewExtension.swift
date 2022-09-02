//
//  FilmListTableViewExtension.swift
//  Exitek Tech Task
//
//  Created by Иван Бегичев on 02.09.2022.
//

import Foundation
import UIKit

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        testArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let item = testArray[indexPath.row]
        cell.textLabel?.text = item.filmTitle! + " (\(String(item.filmReleaseData)))"
        return cell
    }
}
