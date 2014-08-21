//
//  ArtistsViewController.swift
//  CoreDataExample
//
//  Created by Leonardo Lee on 8/19/14.
//  Copyright (c) 2014 Leonardo Lee. All rights reserved.
//

import UIKit
import CoreData

class ArtistsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	var selectedLabel : Label?
	var artists = [Artist]()
	
	@IBOutlet weak var artistsTableView: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.title = "Artists"
		
		self.artistsTableView.dataSource = self
		self.artistsTableView.delegate = self
		
		self.artists = self.selectedLabel!.artists.allObjects as [Artist]
		
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		self.reloadArtists()
		self.artistsTableView.reloadData()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
//MARK: IBAction
	@IBAction func addArtist(sender: AnyObject) {
		self.performSegueWithIdentifier("AddArtist", sender: self)
	}
	override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
		if segue.identifier == "AddArtist" {
			let addArtistVC = segue.destinationViewController as AddArtistViewController
			addArtistVC.selectedLabel = selectedLabel
			
		} else if segue.identifier == "ShowSongs" {
			let showDestination = segue.destinationViewController as SongsViewController
			showDestination.selectedArtist = artists[self.artistsTableView.indexPathForSelectedRow().row]
			
		}
	}
	
//MARK: Reload
	func reloadArtists() {
		var request = NSFetchRequest(entityName: "Artist")
		var error : NSError?
		
		self.selectedLabel?.managedObjectContext.executeFetchRequest(request, error: &error)
		
		if error != nil {
			println(error!.localizedDescription)
		} else {
			self.artists = self.selectedLabel!.artists.allObjects as [Artist]
			self.artistsTableView.reloadData()
		}
		
	}
	
	
//MARK: - Delegate
//MARK: TableViewDelegate
	func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
		let cell = tableView.dequeueReusableCellWithIdentifier("ArtistCell", forIndexPath: indexPath) as UITableViewCell
		
		var artist = self.artists[indexPath.row]
		cell.textLabel.text = artist.firstName
		
		return cell
	}
	
	func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
		return self.artists.count
		
	}

}
