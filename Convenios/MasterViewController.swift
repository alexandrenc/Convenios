//
//  MasterViewController.swift
//  Convenios
//
//  Created by Alexandre on 01/09/14.
//  Copyright (c) 2014 Alexandre. All rights reserved.
//

import UIKit

extension Array {
    func removeDuplicateItens(caseSensitive:Bool = true) -> Array<T> {
        var sub = self
        var filter = [String:Int]()
        var len = sub.count
        for var index = 0; index < len  ;++index {
            var value = "\(sub[index])"
            var key = value
            if caseSensitive{
                key = value.lowercaseString
            }
            if (filter[key] != nil) {
                sub.removeAtIndex(index--)
                len--
            }else{
                filter[key] = 1
            }
        }
        return sub
    }
}

class MasterViewController: UITableViewController {
    
    var detailViewController: DetailViewController? = nil
    var objects:[[[String:String]]] = []
    
    var indexArray:[String] = []
    
    var filteredArray = []
    var filteredIndexArray = []
    
    
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
        var parsed:[[String:String]] = []
        if data != nil{
            let json = (NSJSONSerialization.JSONObjectWithData(data, options:nil, error: &errorJson)) as NSArray
            let sortDescriptor = NSSortDescriptor(key: "STRCONVENIO", ascending: true, selector: "localizedCaseInsensitiveCompare:")
            let sortDescriptors:NSArray = NSArray(object: sortDescriptor)
            parsed = json.sortedArrayUsingDescriptors(sortDescriptors) as [[String:String]]
        }
        
        var mySet:[String] = []
        var newArray:[[String:String]] = []
        
        for subDic in parsed{
            
            var foundLetter = false
            var minhaStringAsciiData: NSData?
            for (key, value) in subDic{
                if key == "STRCONVENIO"{
                    minhaStringAsciiData = value.uppercaseString.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
                    break;
                }
            }
            let stringSemAcentos = (NSString(data: minhaStringAsciiData!, encoding: NSUTF8StringEncoding)) ?? ""
            
            if stringSemAcentos.length > 0{
                
                mySet.append(stringSemAcentos.substringToIndex(1))
            }
            
            if newArray.count == 0 {
                newArray.append(subDic)
            } else {
                var minhaSubStringAsciiData: NSData?
                for (key, value) in newArray[0]{
                    if key == "STRCONVENIO"{
                        minhaSubStringAsciiData = value.uppercaseString.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
                        break;
                    }
                }
                let stringSubSemAcentos = (NSString(data: minhaSubStringAsciiData!, encoding: NSUTF8StringEncoding)) ?? ""

                 if stringSemAcentos.substringToIndex(1) == stringSubSemAcentos.substringToIndex(1){
                    newArray.append(subDic)
                 } else {
                   objects.append(newArray)
                    newArray = []
                    newArray.append(subDic)
                }
            }
        }
        mySet.removeDuplicateItens(caseSensitive: true)
        
        indexArray = sorted(mySet) {$0 < $1}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let indexPath:NSIndexPath! = self.tableView.indexPathForSelectedRow()
            let object = objects[indexPath.section][indexPath.row]
            let controller = (segue.destinationViewController as UINavigationController).topViewController as DetailViewController
            controller.detailItem = object
            controller.navigationItem.leftBarButtonItem = self.splitViewController!.displayModeButtonItem()
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
        
        let object = objects[indexPath.section][indexPath.row]
        cell.textLabel!.text = object["STRCONVENIO"]
        return cell
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return indexArray[section]
    }

    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return UILocalizedIndexedCollation.currentCollation().sectionForSectionIndexTitleAtIndex(index)
    }

    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        return indexArray
    }
}

