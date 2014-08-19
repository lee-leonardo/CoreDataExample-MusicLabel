//
//  ViewController.swift
//  CoreDataExample
//
//  Created by Leonardo Lee on 8/19/14.
//  Copyright (c) 2014 Leonardo Lee. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddLabelDelegate {
	
	var myContext : NSManagedObjectContext!
	var labels = [Label]()
	
	@IBOutlet weak var labelTableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "Labels"
		
		var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
		self.myContext = appDelegate.managedObjectContext
		
		reloadLabels()
		
	}
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		self.reloadLabels()
		self.labelTableView.reloadData()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func addLabelPressed(sender: AnyObject) {
		self.performSegueWithIdentifier("addLabel", sender: self)
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
		if segue.identifier == "addlabel" {
			let addLabelVC = segue.destinationViewController as AddLabelViewController
			addLabelVC.delegate = self
			
		} else if segue.identifier == "ShowArtists" {
			let artistsVC = segue.destinationViewController as ArtistsViewController
			artistsVC.selectedLabel = self.labels[self.labelTableView.indexPathForSelectedRow().row]
			
		}
	}

//MARK: - TableView
	func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
		return self.labels.count
	}
	func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
		var cell = tableView.dequeueReusableCellWithIdentifier("LabelCell", forIndexPath: indexPath) as UITableViewCell
		
		var label = self.labels[indexPath.row]
		cell.textLabel.text = label.name
		
		return cell
	}
	
//MARK: Reload
	func reloadLabels() {
		
		//Need to cache this unless...
		var request = NSFetchRequest(entityName: "Label")
		var error : NSError?
		
		self.labels = self.myContext.executeFetchRequest(request, error: &error) as [Label]
		
		if error != nil {
			println(error?.localizedDescription)
		} else {
			self.labelTableView.reloadData()
		}
	}
	
//MARK: - AddLabelDelegate
	func labelAdded() {
		self.reloadLabels()
}
}