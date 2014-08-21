//
//  ViewController.swift
//  CoreDataExample
//
//  Created by Leonardo Lee on 8/19/14.
//  Copyright (c) 2014 Leonardo Lee. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
	//AddLabelDelegate {

	var myContext : NSManagedObjectContext!
	var labels = [Label]()
	
	var fetchedResultsController : NSFetchedResultsController!
	
	
	@IBOutlet weak var labelTableView: UITableView!
	
//MARK: View Methods
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "Labels"
		
		//MoC from app delegate
		var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
		self.myContext = appDelegate.managedObjectContext
		
		//FetchedResultsController
		var request = NSFetchRequest(entityName: "Label")
		let sort = NSSortDescriptor(key: "name", ascending: false) //Knows how to sort Comparable objects
		request.sortDescriptors = [sort] //Request has a sort.
		request.fetchBatchSize = 20 //Returns 20 objects with the request.
		
		self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.myContext, sectionNameKeyPath: nil, cacheName: nil) //In testing its best not to cache results
		self.fetchedResultsController.delegate = self
		
		//reloadLabels()
		
	}
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
//		self.reloadLabels()
		
		var error : NSError?
		fetchedResultsController.performFetch(&error)
		if error != nil {
			println(error?.localizedDescription)
		}
		
		self.labelTableView.reloadData()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

//MARK:
	@IBAction func addLabelPressed(sender: AnyObject) {
		self.performSegueWithIdentifier("addLabel", sender: self)
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
		if segue.identifier == "addlabel" {
			//let addLabelVC = segue.destinationViewController as AddLabelViewController
			//addLabelVC.delegate = self
			
		} else if segue.identifier == "ShowArtists" {
			let artistsVC = segue.destinationViewController as ArtistsViewController
			var label = self.fetchedResultsController.fetchedObjects[self.labelTableView.indexPathForSelectedRow().row] as Label
			artistsVC.selectedLabel = label
			
//			artistsVC.selectedLabel = self.labels[self.labelTableView.indexPathForSelectedRow().row]
			
		}
	}

//MARK: - TableView
	func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
//		return self.labels.count
		return self.fetchedResultsController.sections[section].numberOfObjects
	}
	func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
		var cell = tableView.dequeueReusableCellWithIdentifier("LabelCell", forIndexPath: indexPath) as UITableViewCell

		self.configureCell(cell, forIndexPath: indexPath) //Moved cell methods out to optimize.
		
		return cell
	}
	
	//A requirement by NSFetchResultsController.
	func configureCell(cell: UITableViewCell, forIndexPath indexPath: NSIndexPath) {
//		var label = self.labels[indexPath.row]
//		cell.textLabel.text = label.name
		
		var label = self.fetchedResultsController.fetchedObjects[indexPath.row] as Label
		cell.textLabel.text = label.name
	}
	
	func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
		self.labelTableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
	
//MARK: Delete
	func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
		//Don't need anything.
		//Can use respondsToSelectore: test
	}
	
	func tableView(tableView: UITableView!, editActionsForRowAtIndexPath indexPath: NSIndexPath!) -> [AnyObject]! {
		//Delete
		let delete = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete") {
			(action, indexPath) -> Void in
			//implement the delete changes
			if let labelForRow = self.fetchedResultsController.fetchedObjects[indexPath.row] as? Label {
				self.myContext.deleteObject(labelForRow) //This takes time, because the changes are placed into a queue.
				//self.myContext.save(nil) //Will save the context immediately. Not blocked.
			}
		}
		delete.backgroundColor = UIColor.redColor()
		
		
		let more = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "More") {
			(action, indexPath) -> Void in
			println("Woa")
		}
		more.backgroundColor = UIColor.lightGrayColor()
		
		
		//Return an array of the actions
		return [delete, more]
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
	
//MARK: - NSFetchedresultsControllerDelegate methods
	func controllerWillChangeContent(controller: NSFetchedResultsController!) {
		self.labelTableView.beginUpdates()
		
	}
	
	func controllerDidChangeContent(controller: NSFetchedResultsController!) {
		self.labelTableView.endUpdates()
	}
	
	func controller(controller: NSFetchedResultsController!, didChangeObject anObject: AnyObject!, atIndexPath indexPath: NSIndexPath!, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath!) {
		switch type {
		case .Insert:
			self.labelTableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
		case .Delete:
			self.labelTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
		case .Move:
			self.labelTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
			self.labelTableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
			//self.labelTableView.moveRowAtIndexPath(indexPath, toIndexPath: newIndexPath) //Test this! Probably won't work.
		case .Update:
			self.configureCell(self.labelTableView.cellForRowAtIndexPath(indexPath), forIndexPath: indexPath)
		}
	}
	
	
//MARK: - AddLabelDelegate
//	Not needed due to the new fetchRequestController
//	func labelAdded() {
//		self.reloadLabels()
//	}
}