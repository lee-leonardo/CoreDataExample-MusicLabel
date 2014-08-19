//
//  ArtistsViewController.swift
//  CoreDataExample
//
//  Created by Leonardo Lee on 8/19/14.
//  Copyright (c) 2014 Leonardo Lee. All rights reserved.
//

import UIKit

class ArtistsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	var selectedLabel : Label?
	var artists = [Artist]()

	@IBOutlet weak var artistsTableView: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.artistsTableView.dataSource = self
		self.artistsTableView.delegate = self
		
		self.artists = self.selectedLabel!.artists.allObjects as [Artist]

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
//MARK: IBAction
	@IBAction func addArtist(sender: AnyObject) {
		self.performSegueWithIdentifier("AddArtist", sender: self)
	}
	override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
		if segue.identifier == "AddArtist" {
			let addArtistVC = segue.destinationViewController as AddArtistViewController
			addArtistVC.selectedLabel = selectedLabel
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
