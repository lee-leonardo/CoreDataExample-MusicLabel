//
//  AddArtistViewController.swift
//  CoreDataExample
//
//  Created by Leonardo Lee on 8/19/14.
//  Copyright (c) 2014 Leonardo Lee. All rights reserved.
//

import UIKit
import CoreData

class AddArtistViewController: UIViewController {

	var selectedLabel : Label?
	
	@IBOutlet weak var firstNameField: UITextField!
	
	@IBOutlet weak var lastNameField: UITextField!
	
	
    override func viewDidLoad() {
        super.viewDidLoad()

	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func saveArtist(sender: AnyObject) {
		
		var labelContext = self.selectedLabel?.managedObjectContext
		var newArtist = NSEntityDescription.insertNewObjectForEntityForName("Artist", inManagedObjectContext: labelContext) as Artist
		
		newArtist.firstName = self.firstNameField.text
		newArtist.lastName = self.lastNameField.text
		newArtist.label = self.selectedLabel!
		
		var error: NSError?
		labelContext?.save(&error)
		if error != nil {
			println(error?.localizedDescription)
		} else {
			
		}
		
	}

}
