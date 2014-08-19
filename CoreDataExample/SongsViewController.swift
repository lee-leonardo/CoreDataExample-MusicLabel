//
//  SongsViewController.swift
//  CoreDataExample
//
//  Created by Leonardo Lee on 8/19/14.
//  Copyright (c) 2014 Leonardo Lee. All rights reserved.
//

import UIKit
import CoreData

class SongsViewController: UIViewController, UITableViewDataSource {
	
	var selectedArtist : Artist?
	var songs = [Song]()
	
	@IBOutlet weak var songTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
		self.title = "Songs"
		
		self.songs = self.selectedArtist!.songs.allObjects as [Song]
    }

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		reloadSongs()
		
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
	}
	
	func reloadSongs() {
		var request = NSFetchRequest(entityName: "Song")
		var error : NSError?
		
		self.selectedArtist?.managedObjectContext.executeFetchRequest(request, error: &error)
		
		if error != nil {
			println(error?.localizedDescription)
		} else {
			self.songs = self.selectedArtist!.songs.allObjects as [Song]
			self.songTableView.reloadData()
		}
		
	}
	
//MARK: - IBAction
	@IBAction func addSong(sender: AnyObject) {
		self.performSegueWithIdentifier("AddSong", sender: self)
	}
	
//MARK: - Segue
	override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
		if segue.identifier == "AddSong" {
			let destination = segue.destinationViewController as AddSongViewController
			destination.selectedArtist = self.selectedArtist
		}
	}
	
//MARK: - UITableView
	func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
		let cell = tableView.dequeueReusableCellWithIdentifier("SongCell", forIndexPath: indexPath) as UITableViewCell
		var song = songs[indexPath.row] as Song
		
		cell.textLabel.text = song.name
		
		return cell
	}
	func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
		return self.songs.count
	}
	

}
