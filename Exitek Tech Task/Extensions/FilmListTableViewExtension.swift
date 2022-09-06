//
//  FilmListTableViewExtension.swift
//  Exitek Tech Task
//
//  Created by Иван Бегичев on 02.09.2022.
//

import Foundation
import UIKit
import CoreData

extension MainViewController: UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellName, for: indexPath) as UITableViewCell
        let movie = models[indexPath.row]
        cell.textLabel?.text = movie.filmTitle
        cell.detailTextLabel?.text = String(movie.filmReleaseData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteItems(item: models[indexPath.row])
        }
    }   
}
