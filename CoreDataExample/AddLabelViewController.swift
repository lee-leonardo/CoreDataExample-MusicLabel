
//
//  AddLabelViewController.swift
//  CoreDataExample
//
//  Created by Leonardo Lee on 8/19/14.
//  Copyright (c) 2014 Leonardo Lee. All rights reserved.
//

import UIKit
import CoreData

protocol AddLabelDelegate {
	func labelAdded()
}

class AddLabelViewController: UIViewController {

	var myContext : NSManagedObjectContext!
	var delegate : AddLabelDelegate?
	
	@IBOutlet weak var labelNameField: UITextField!
	
//MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
		self.title = "Add Label"

		var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
		self.myContext = appDelegate.managedObjectContext
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	@IBAction func saveLabelPressed(sender: AnyObject) {
		
		var newLabel = NSEntityDescription.insertNewObjectForEntityForName("Label", inManagedObjectContext: self.myContext) as Label
		
		//newLabel.setValue("Leo", forKey: "name") 		//NSManagedObject
		newLabel.name = self.labelNameField.text
		
		var error : NSError?
		self.myContext.save(&error) //Uses the address return operator.
		
		if error != nil {
			println(error?.localizedDescription)
		} else {
			self.delegate?.labelAdded()
			self.navigationController.popToRootViewControllerAnimated(true)
			
		}
		
	}

}
