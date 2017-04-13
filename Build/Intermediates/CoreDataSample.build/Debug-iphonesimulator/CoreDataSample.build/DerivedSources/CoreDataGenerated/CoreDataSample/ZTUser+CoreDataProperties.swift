//
//  ZTUser+CoreDataProperties.swift
//  
//
//  Created by Hannh on 2017/4/13.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension ZTUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ZTUser> {
        return NSFetchRequest<ZTUser>(entityName: "ZTUser")
    }

    @NSManaged public var accoutID: Int32
    @NSManaged public var email: String?
    @NSManaged public var gender: Bool

}
