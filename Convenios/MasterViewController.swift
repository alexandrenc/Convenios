//
//  MasterViewController.swift
//  Convenios
//
//  Created by Alexandre on 01/09/14.
//  Copyright (c) 2014 Alexandre. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    var detailViewController: DetailViewController? = nil
    var objects = NSArray()
    
    var indexArray = NSArray()
    
    var filteredArray = NSMutableArray()
    var filteredIndexArray = NSMutableArray()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
        }
        
        let filePath = NSBundle.mainBundle().pathForResource("convenios", ofType: "json")
        let data = NSData.dataWithContentsOfFile(filePath!, options: nil, error: nil)
        var errorJson: NSError?
        if data != nil{
            let json = (NSJSONSerialization.JSONObjectWithData(data, options:nil, error: &errorJson)) as NSArray
            let sortDescriptor = NSSortDescriptor(key: "STRCONVENIO", ascending: true, selector: "localizedCaseInsensitiveCompare:")
            let sortDescriptors:NSArray = NSArray(object: sortDescriptor)
            objects = json.sortedArrayUsingDescriptors(sortDescriptors)
        }
        
        var mySet = NSMutableSet()
        var newArray = NSMutableArray()
        
        for d in objects{
            var foundLetter = false
            let minhaStringAsciiData = ((d["STRCONVENIO"] as String).uppercaseString).dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
            let stringSemAcentos = NSString(data: minhaStringAsciiData!, encoding: NSUTF8StringEncoding)
            
            if stringSemAcentos.length > 0{
                
                mySet.addObject(stringSemAcentos.substringToIndex(1))
            }
            for subArray in newArray{
                let minhaSubStringAsciiData = ((subArray[0]["STRCONVENIO"] as String).uppercaseString).dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
                let subStringSemAcentos = NSString(data: minhaSubStringAsciiData!, encoding: NSUTF8StringEncoding)
                
                if stringSemAcentos.substringToIndex(1) == subStringSemAcentos.substringToIndex(1){
                    foundLetter = true
                    subArray.addObject(d)
                    break
                }
            }
            
            if !foundLetter {
                let newDict = NSMutableArray(object: d)
                newArray.addObject(newDict)
            }
        }
        
        indexArray = (mySet.allObjects as NSArray).sortedArrayUsingSelector("localizedCaseInsensitiveCompare:")
        objects = newArray
        filteredArray = NSMutableArray(capacity: objects.count)
        filteredIndexArray = NSMutableArray(capacity: indexArray.count)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let indexPath = self.tableView.indexPathForSelectedRow()
            let object = objects[indexPath.section][indexPath.row] as NSDictionary
            let controller = (segue.destinationViewController as UINavigationController).topViewController as DetailViewController
            controller.detailItem = object
            controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return objects.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects[section].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        let object = objects[indexPath.section][indexPath.row] as NSDictionary
        cell.textLabel.text = object["STRCONVENIO"] as String
        return cell
    }
    
    override func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
        return indexArray[section] as String
    }
    
    override func tableView(tableView: UITableView!, sectionForSectionIndexTitle title: String!, atIndex index: Int) -> Int {
        return UILocalizedIndexedCollation.currentCollation().sectionForSectionIndexTitleAtIndex(index)
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView!) -> [AnyObject]! {
        return indexArray
    }
}

