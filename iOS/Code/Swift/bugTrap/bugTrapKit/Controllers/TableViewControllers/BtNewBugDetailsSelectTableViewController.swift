//
//  BtNewBugDetailsSelectTableViewController.swift
//  bugTrap
//
//  Created by Colby L Williams on 6/30/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import UIKit

class BtNewBugDetailsSelectTableViewController: BtTableViewController {

	@IBOutlet var tableBackgroundView: UIView!
	
	@IBOutlet var noDataTitle: UILabel!
	
	@IBOutlet var noDataDetail: UILabel!
	
	let cellReuseId = "BtNewBugDetailsSelectTableViewCell"
	
	var separatorColorCache = UIColor.clearColor()
	
	var imageCache = [NSIndexPath : UIImage]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if let tracker = TrackerService.Shared.currentTracker {

			title = tracker.trackerState.ActiveBugDetailTitle
			
			screenName = "\(GAIKeys.ScreenNames.bugDetails) (\(tracker.type.string)) - Select \(tracker.trackerState.ActiveBugDetailTitle)"
			
            tracker.loadDataForActiveDetail() { result in
                
                switch result {
                case let .Error(error):
					Log.error(self.screenName!, error)
                    //handle .Error(error)
                case let .Value(success):
					if let successful = success.value {
						if (successful) {
							tracker.trackerState.sortActiveBugDetailValues()
							self.tableView!.reloadData()
						}
					}
                }
            }
        }
		
		initNoDataTitleDetail()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController!.hidesBarsOnTap = false
	}

	
	
	@IBAction func refreshControlValueChanged(sender: UIRefreshControl) {
		
		// refresh data here
		
		tableView.reloadData()
		sender.endRefreshing()
	}
	
	
	
	override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
		return 1
	}
	
	
	
	override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        
		if let tracker = TrackerService.Shared.currentTracker {
			return tracker.trackerState.getCountForActiveBugDetail()
		}
        
		return 0
	}
	
	
	let defaultAvatar = UIImage(named: "i_default_avatar")!
	
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		Log.debug(screenName! + " - cellForRowAtIndexPath", indexPath)
		
		let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseId, forIndexPath: indexPath) as! BtNewBugDetailsSelectTableViewCell
		
		if let cellData = TrackerService.Shared.currentTracker?.trackerState.getActiveCellDetails(indexPath.row) {
		
			switch cellData.CellType {
			case .Person, .IconSelect:
				
				cell.setDataWithKey(indexPath, title: cellData.Get(.Title), image: cellData.CellType == .Person ? defaultAvatar : nil, detail: cellData.Get(.Detail), auxiliary: cellData.Get(.Auxiliary))

				if let image = imageCache[indexPath] {
				
					cell.setImage(image, key: indexPath)

				} else {

					if let imageUrl = cellData.Get(.ImageUrl) {
						//do we have an avatar to set?
						if !imageUrl.isEmpty {
							TrackerService.Shared.currentTracker?.trackerProxy.getDataForUrl(imageUrl) { result in
								switch result {
								case let .Error(error):
									Log.error(self.screenName!, error)
								case let .Value(wrapped):
									if let data = wrapped.value {
										if data.length > 0 {
											if let image = UIImage(data: data) {
												self.imageCache[indexPath] = image
												if cell.setImage(image, key: indexPath) {
													tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
												}
											}
										}
									}
								}
							}
						}
					}
				}
				
				cell.setSelected(cellData.Selected, animated: false)

			default:
				cell.setData(title: cellData.Get(DataKeys.Title))
				cell.setSelected(cellData.Selected, animated: false)
			}
		
			cell.accessoryType = cell.selected ? .Checkmark : .None
		}
        
		return cell
	}
	
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
		if let tracker = TrackerService.Shared.currentTracker {
			
			if tracker.updateIssueFromSelection(indexPath.row) {
				tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
			} else {
				navigationController!.popViewControllerAnimated(true)
			}
		}
	}

	
	
	func initNoDataTitleDetail() {
		
		separatorColorCache = tableView.separatorColor
		
		tableBackgroundView.frame = tableView.bounds
		tableView.backgroundView = tableBackgroundView
		
		if let titleDetail = TrackerService.Shared.currentTracker?.trackerState.getActiveTitleDetail() {
			
			let title = titleDetail[DataKeys.Title]!
			let detail = titleDetail[DataKeys.Detail]!
			
			noDataTitle.text = title
			noDataDetail.text = detail
			
			tableView.separatorColor = title.isEmpty && detail.isEmpty ? separatorColorCache : UIColor.clearColor()
		}
	}

	
	
	override func prefersStatusBarHidden() -> Bool {
		return true
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
}