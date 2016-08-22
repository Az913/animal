//
//  Animal+CoreDataProperties.swift
//  AnimalFortuneTelling
//
//  Created by ハラダ アズサ on 2016/08/20.
//  Copyright © 2016年 ハラダ アズサ. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Animal {

    @NSManaged var animalId: NSNumber?
    @NSManaged var animalType: String?

}
