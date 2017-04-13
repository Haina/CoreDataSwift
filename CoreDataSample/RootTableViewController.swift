//
//  RootTableViewController.swift
//  CoreDataSample
//
//  Created by Hannh on 2017/4/13.
//  Copyright © 2017年 Hannh. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class RootViewController: UITableViewController {

//    var myContext: NSManagedObjectContext!
    var allData: NSMutableArray = NSMutableArray()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        return persistentContainer.viewContext
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.title = "ListPage"
        self.navigationItem.rightBarButtonItem = self.rightBarButton()
        self.getDataFromCoreData()
        self.tableView.register(UINib.init(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: "contactIdentifier")
    }
    
    func rightBarButton() -> UIBarButtonItem {
        let right: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(self.rightClick))
        return right
        
    }
    
    func rightClick() -> Void {
        self.inserData()
    }
    
    func getDataFromCoreData() -> Void {
        // Initialize FetchRequest
        let fetchRequest:NSFetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entity:NSEntityDescription = NSEntityDescription.entity(forEntityName: "ZTUser", in: managedObjectContext)!
        fetchRequest.entity = entity
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "accoutID", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Execute FetchRequest Result
//        let error:NSError? = nil
        
        //open func execute(_ request: NSPersistentStoreRequest) throws -> NSPersistentStoreResult
        
            
            do{
                let results = try managedObjectContext.fetch(fetchRequest)
                print("resultsNum:",results.count)
                if results.count > 0 {
                    self.allData.addObjects(from: results)
                }
            }catch{
                print("no results")
            }
        
//            self.allData.addObjects(from: persistentStoreResult.obj)
        
            self.tableView.reloadData()
        
    }
    
    func inserData() -> Void {

        let entityDescription:NSEntityDescription = NSEntityDescription.entity(forEntityName: "ZTUser", in: managedObjectContext)!
        if let user = NSManagedObject(entity: entityDescription, insertInto: managedObjectContext) as? ZTUser{
            user.accoutID = 7
            user.email = "wwzfj13ww@163.com"
            user.gender = true
            self.allData.add(user)
            
            
            do{
                try managedObjectContext.save()
                print("增加保存成功 ")
                let kIndexPath:NSIndexPath = NSIndexPath(row: self.allData.count-1, section: 0)
                self.tableView.insertRows(at: [kIndexPath as IndexPath], with: UITableViewRowAnimation.left)
            }catch{
                let nserror = error as NSError
                print("增加保存失败%@",nserror.description)
            }
        }else{
            print("==warning==Contact needs a name");
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactIdentifier", for: indexPath) as! ContactTableViewCell
        if let user:ZTUser = self.allData.object(at: indexPath.row) as? ZTUser{
            cell.contact.text = "\(user.accoutID)"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let user:ZTUser = self.allData.object(at:  indexPath.row) as! ZTUser
//FIXME: "self.allData.remove(at: indexPath.row)"当此断替换替换 下面一句时 会crash  为什么？
            self.allData.remove(user)
            
            managedObjectContext.delete(user)
            do{
               try managedObjectContext.save()
                print("删除成功row:",indexPath.row)
                
                self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
            }catch{
                let handelError = error as NSError
                
                print("editingRow%@",handelError.description)
            }
            
            
        }
    }
    
}
