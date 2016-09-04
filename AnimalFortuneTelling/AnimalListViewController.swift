//
//  AnimalListViewController.swift
//  AnimalFortuneTelling
//
//  Created by ハラダ アズサ on 2016/08/24.
//  Copyright © 2016年 ハラダ アズサ. All rights reserved.
//

import UIKit
import CoreData

class AnimalListViewController: UIViewController,NSFetchedResultsControllerDelegate {
    
    private let coreDataStore = CoreDataStack()
    private var fetchedResultsController: NSFetchedResultsController?
    private var taskSections: [[NSManagedObject]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest = NSFetchRequest(entityName: "AnimalType")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "animalName", ascending: true)]
               
                fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStore.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
                fetchedResultsController!.delegate = self
                try! fetchedResultsController!.performFetch()
        
                for task in fetchedResultsController!.fetchedObjects! as! [NSManagedObject] {
                       print(task)
                    }
    }
    
//    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
//        		let task = anObject as! NSManagedObject
//                switch type {
//                        
//                    case .Delete:
//                            let sectionIndex = sectionIndexForTask(task)
//                            let deletedTaskIndex = taskSections[sectionIndex].indexOf(task)!
//                            taskSections[sectionIndex].removeAtIndex(deletedTaskIndex)
//                    tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: deletedTaskIndex, inSection: sectionIndex)], withRowAnimation: .Automatic)
//                    case .Insert,.Move, .Update:
//                           fatalError("Unsupported")
//        }
    

}
