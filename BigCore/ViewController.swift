//
//  ViewController.swift
//  BigCore
//
//  Created by Sukumar Anup Sukumaran on 03/06/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
   // var apiData = [APIData]()
    
   
    lazy var fetchedResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "APIData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "author", ascending: true)]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        
        return frc
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       updateTableContent()
    }
    
    
    func updateTableContent() {
        
        do {
             try self.fetchedResultController.performFetch()
            
            print("COUNT FETCHED FIRST: \(String(describing: self.fetchedResultController.sections?[0].numberOfObjects))")
        }
        catch let error {
            print("ERROR: \(error)")
        }
        
        APIService.getDataWith { (response) in
           
            switch response {
            case .Success(let data):
                self.clearData()
                self.saveInCoreDataWith(array: data)
            case .Error(let error):
                 print("Error = \(error)")
            }
        }
        
    }
    
    private func clearData() {
        
        
            let context = CoreDataStack.context
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "APIData")
            
        do {
            let objects = try context.fetch(fetchRequest) as? [NSManagedObject]
            print("ONBjectCount = \(objects!.count)")
            _ = objects.map{$0.map{context.delete($0)}}
            CoreDataStack.saveContext()
        } catch let error {
            print("ERROR DELETING : \(error)")
        }
        
    }
    
    
    private func createAPIEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
        
        let context = CoreDataStack.context
        
        let APIEntity = APIData(context: context)
        APIEntity.author = dictionary["author"] as? String
        APIEntity.tags = dictionary["tags"] as? String
        
        let mediaDic = dictionary["media"] as? [String: AnyObject]
        APIEntity.media = mediaDic!["m"] as? String
        
        return APIEntity
        
    }
    
    
    private func saveInCoreDataWith(array: [[String: AnyObject]]) {
        
        let futileVar = array.map{ self.createAPIEntityFrom(dictionary: $0)}
        
        print("futileVar = \(futileVar)")
        
        CoreDataStack.saveContext()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }


}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let count = fetchedResultController.sections?.first?.numberOfObjects else { return 0 }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CoreTableViewCell
        
        if let apiData = fetchedResultController.object(at: indexPath) as? APIData {
            cell.configure(apiData: apiData)
        }
        
        return cell
        
    }
    
}

extension ViewController:NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
}
