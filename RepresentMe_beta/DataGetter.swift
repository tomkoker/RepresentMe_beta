//
//  DataGetter.swift
//  RepresentMe_beta
//
//  Created by Teddy Koker on 5/5/15.
//  Copyright (c) 2015 Teddy Koker. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class DataGetter: NSObject,CLLocationManagerDelegate {
    
    var leadersList: LeadersList
    let locationManager = CLLocationManager()
    let key = "b93cc4cf0e9a4530b0e0ddb9f963e227"
    var sender: LegislatorsTableViewController?
    
    override init(){
        leadersList = LeadersList.list
        super.init()
        if self.locationManager.respondsToSelector(Selector("requestAlwaysAuthorization")) {
            self.locationManager.requestWhenInUseAuthorization()
        }
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations[locations.count-1] as! CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let lat: Double = location.coordinate.latitude
        let long: Double = location.coordinate.longitude
        loadLegislators(lat, long: long)
        self.locationManager.stopUpdatingLocation()
    }
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error: " + error.localizedDescription)
    }
    func update(sender:LegislatorsTableViewController){
        self.locationManager.startUpdatingLocation()
        self.sender = sender
    }
    func done(){
        if sender != nil{
            sender!.refreshComplete()
        }
    }
    
    func loadLegislators(lat:Double, long:Double){
        
        var leaders: [Leader] = []
        var urlString = "http://congress.api.sunlightfoundation.com/legislators/locate?latitude=\(lat)&longitude=\(long)&apikey=\(key)"
        let session = NSURLSession.sharedSession()
        let legislatorURL = NSURL(string: urlString)
        
        var jsonData = NSData(contentsOfURL: legislatorURL!, options: nil, error: nil)//Turns URL into Data
        var jsonResult = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary //Turns Data int Dictionary
        
        if let results = jsonResult["results"] as? NSArray{
            for i in 0 ..< results.count {
                if let lastName = results[i]["last_name"] as? String{ //Keep putting if let statements with different traits you want
                    //remember to add them as vars to the leader struct
                    if let title = results[i]["title"] as? String{
                        if let bioguideId = results[i]["bioguide_id"] as? String{
                            if let firstName = results[i]["first_name"] as? String{
                                if let title = results[i]["title"] as? String{
                                    if let state = results[i]["title"] as? String{
                                        if let party = results[i]["party"] as? String{
                                            if let birthday = results[i]["birthday"] as? String{
                                                if let termStart = results[i]["term_start"] as? String{
                                                    if let termEnd = results[i]["term_end"] as? String{
                                                        if let phone = results[i]["phone"] as? String{
                                                            if let website = results[i]["website"] as? String{
                                                                leaders.append(Leader(firstName: firstName,lastName: lastName, title: title, bioguideId:bioguideId,party: party, state: state, birthday: birthday, term_start: termStart, term_end: termEnd, phone: phone, website: website))
                                                                
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        leadersList.setLeaders(leaders)
        done()
    }
    func loadBills(){
        
    }
    func loadBills(bioguideId: String){
        
    }
}