//
//  AddSongsViewController.swift
//  CoreDataExample
//
//  Created by Leonardo Lee on 8/19/14.
//  Copyright (c) 2014 Leonardo Lee. All rights reserved.
//

import UIKit
import CoreData

class AddSongViewController: UIViewController {
	
	var selectedArtist : Artist?
	var startYear = 1990
	var minimumYear = 1400
	var maxumimYear = 2020

	@IBOutlet weak var songNameTextField: UITextField!
	@IBOutlet weak var yearStepper: UIStepper!
	@IBOutlet weak var dateLabel: UILabel!
	
	
//MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
		self.dateLabel.text = "\(startYear)"
				
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
//MARK: - IBAction
	@IBAction func yearStepperChanged(sender: UIStepper) {
		//println("\(yearStepper.value)")
		let year : NSNumber = yearStepper.value
		self.dateLabel.text = year.stringValue
	}
	
	@IBAction func saveSong(sender: AnyObject) {
		var artistContext = self.selectedArtist?.managedObjectContext
		var newSong = NSEntityDescription.insertNewObjectForEntityForName("Song", inManagedObjectContext: artistContext) as Song
		
		newSong.name = songNameTextField.text
		newSong.year = yearStepper.value
		newSong.artist = self.selectedArtist!
		
		var error : NSError?
		artistContext?.save(&error)
		if error != nil {
			println(error?.localizedDescription)
		} else {
			self.navigationController.popViewControllerAnimated(true)
		}
		
	}
}
