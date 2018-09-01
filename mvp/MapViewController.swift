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

class MapViewController: UIViewController, GMSMapViewDelegate {

    lazy var mapView = GMSMapView()
    var points : [CLLocationCoordinate2D] = []
    lazy var lines : [GMSPolyline] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: 35.6841105, longitude: 139.6999833, zoom: 15.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        mapView.delegate = self
        view = mapView

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
        
        let mainVC = self.parent as! MainViewController
        mainVC.orderRefreshCells(points: points)
        
        let path = GMSMutablePath()
        
        //clear lines in map
        for line in lines {
            line.map = nil
        }
        
        drawPath(points: points)
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        let presentedViewController = self.storyboard?.instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
        presentedViewController.name = marker.title! //nameLabel を代入したものがこれ
        presentedViewController.genre = marker.snippet! //下段85行目くらいmarker=snipet
        //presentedViewController.lunch = marker.//????
        presentedViewController.modalPresentationStyle = .overCurrentContext
        presentedViewController.modalTransitionStyle = .crossDissolve //tap store.info action
        self.present(presentedViewController, animated: true, completion: nil)
    }
    
    func drawMap(data: [Store]) {
        for restaurant in data {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(restaurant.langitude!, restaurant.longitude!)
            marker.title = restaurant.name
            marker.snippet = restaurant.genre
            marker.setValue(restaurant.name, forKey: "name")
            marker.map = mapView
        }
    }
    
    func drawPath(points:[CLLocationCoordinate2D]) {
        if points.count > 1 {
            for index in 2...points.count {
                let origin = "\(points[index-2].latitude),\(points[index-2].longitude)"
                let destination = "\(points[index-1].latitude),\(points[index-1].longitude)"
                
                let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=walking&key=AIzaSyB4jL4U0lVE7gKM2eUmBXAdy1Y7ngkQ0xI"
                
                Alamofire.request(url).responseJSON { response in
                    do {
                        let json = try JSON(data: response.data!)

                        let routes = json["routes"].arrayValue
                    
                        for route in routes {
                            let routeOverviewPolyline = route["overview_polyline"].dictionary
                            let points = routeOverviewPolyline?["points"]?.stringValue
                            let path = GMSPath.init(fromEncodedPath: points!)
                            let polyline = GMSPolyline.init(path: path)
                            polyline.strokeColor = UIColor.red
                            polyline.strokeWidth = 3.0
                            self.lines.append(polyline)
                            polyline.map = self.mapView
                        }
                    } catch {
                        fatalError()
                    }
                    
                }

            }
        }
    }
}

