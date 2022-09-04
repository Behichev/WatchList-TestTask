//
//  Movies+CoreDataClass.swift
//  Exitek Tech Task
//
//  Created by Иван Бегичев on 03.09.2022.
//
//

import Foundation
import CoreData

@objc(Movies)
public class Movies: NSManagedObject {
    convenience init() {
        self.init(entity: CoreDataManger.instance.entityForName(entityName: "Movies"), insertInto: CoreDataManger.instance.context)
    }
}
