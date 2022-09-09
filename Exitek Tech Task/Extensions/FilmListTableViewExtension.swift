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
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchResultController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchResultController.sections {
            return sections[section].numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellName, for: indexPath) as UITableViewCell
        let movie = fetchResultController.object(at: indexPath) as! Movies
        cell.textLabel?.text = movie.filmTitle
        cell.detailTextLabel?.text = String(movie.filmReleaseData)
        return cell
    }
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        filmsListTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        filmsListTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                filmsListTableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                filmsListTableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                let movie = fetchResultController.object(at: indexPath) as! Movies
                let cell = filmsListTableView.cellForRow(at: indexPath)
                cell?.textLabel?.text = movie.filmTitle
                cell?.detailTextLabel?.text = String(movie.filmReleaseData)
            }
        case .move:
            if let indexPath = indexPath {
                filmsListTableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let indexPath = newIndexPath {
                filmsListTableView.insertRows(at: [indexPath], with: .automatic)
            }
        default:
            fatalError("feature not yet implemented")
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
       return true
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let movie = fetchResultController.object(at: indexPath) as! Movies
            deleteItems(item: movie)
        }
    }
    
    
    
}
