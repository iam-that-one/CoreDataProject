//
//  NoteModel.swift
//  CoreDataProject
//
//  Created by Abdullah Alnutayfi on 24/11/2021.
//

import Foundation
import UIKit
import CoreData


class ViewModel{
   var notes : [Note] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    func getContext() -> NSManagedObjectContext{
    return appDelegate.persistentContainer.viewContext
    }
    func fetchData(){
        let fetchRequest = NSFetchRequest<Note>()
        let entity =
          NSEntityDescription.entity(forEntityName: "Note",
                                     in: getContext())!
        fetchRequest.entity = entity
        print(notes)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
                request.returnsObjectsAsFaults = false
                do {
                    let result = try getContext().fetch(request)
                    self.notes = result as! [Note]
                } catch {
                    print(error)
                }
        
    }
    
}
struct NoteModel {
    var id = UUID().uuidString
    var name = ""
    var info = ""
    
}
