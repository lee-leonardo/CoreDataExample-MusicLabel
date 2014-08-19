//
//  Song.swift
//  CoreDataExample
//
//  Created by Leonardo Lee on 8/19/14.
//  Copyright (c) 2014 Leonardo Lee. All rights reserved.
//

import Foundation
import CoreData

class Song: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var year: NSNumber
    @NSManaged var artist: NSManagedObject

}
