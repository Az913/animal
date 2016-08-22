//
//  AnimalType+CoreDataProperties.swift
//  
//
//  Created by ハラダ アズサ on 2016/08/21.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension AnimalType {

    @NSManaged var animalName: String?
    @NSManaged var type: NSNumber?
    @NSManaged var future: NSNumber?
    @NSManaged var right: NSNumber?
    @NSManaged var goal: NSNumber?

}
