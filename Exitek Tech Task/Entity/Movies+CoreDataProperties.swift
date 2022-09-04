//
//  Movies+CoreDataProperties.swift
//  Exitek Tech Task
//
//  Created by Иван Бегичев on 03.09.2022.
//
//

import Foundation
import CoreData


extension Movies {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movies> {
        return NSFetchRequest<Movies>(entityName: "Movies")
    }

    @NSManaged public var filmReleaseData: Int16
    @NSManaged public var filmTitle: String?

}

extension Movies : Identifiable {

}
