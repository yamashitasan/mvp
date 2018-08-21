//
//  ViewController.swift
//  mvp
//
//  Created by 山下翔平 on 2018/08/17.
//  Copyright © 2018年 山下翔平. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, GMSMapViewDelegate {

    lazy var mapView = GMSMapView()
    var points : [CLLocationCoordinate2D] = []
    lazy var lines : [GMSPolyline] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: 35.6841105, longitude: 139.6999833, zoom: 15.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        mapView.delegate = self
        view = mapView
        
        let data = readFile(name: "data", type: "csv")
        //draw markers for restaurants in dataset
        for restaurant in data {
            let store = Store(restaurant: restaurant)
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(store.langitude!, store.longitude!)
            marker.title = store.name
            marker.snippet = store.genre
            marker.map = mapView
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isSameCoordinates(first: CLLocationCoordinate2D, second: CLLocationCoordinate2D) -> Bool {
        //compare latitude and longitude of 2 coordinates and return true or false
        if first.latitude == second.latitude &&
            first.longitude == second.longitude {
            return true
        }
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let index = points.index(where: { isSameCoordinates(first: $0, second: marker.position) }) {
            //if tapped before, remove point from array
            points.remove(at: index)
            
        } else {
            //if never tapped before, append to array
            points.append(marker.position)
        }
        
        let path = GMSMutablePath()
        
        //clear lines in map
        for line in lines {
            line.map = nil
        }
        
        
        for point in points {
            path.add(point)
            let line = GMSPolyline(path: path)
            line.strokeWidth = 3.0
            line.strokeColor = UIColor.red
            line.map = mapView
            lines.append(line)
        }
        return false
    }
    
    //read csv file and make double array from it
    func readFile(name: String, type: String) -> [[String]] {
        if let filepath = Bundle.main.path(forResource: name, ofType: type) {
            do {
                let text = try String(contentsOfFile: filepath)
                var result: [[String]] = []
                let rows = text.components(separatedBy: "\n")
                for row in rows {
                    let columns = row.components(separatedBy: ",")
                    result.append(columns)
                }
                return result
            } catch {
                fatalError()
            }
        } else {
            fatalError()
        }
    }

}

