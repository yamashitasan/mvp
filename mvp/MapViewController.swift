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
    var allStores : [Store] = []
    var activatedStores : [Store] = [] {
        didSet {
            let mainVC = self.parent as! MainViewController
            mainVC.orderRefreshCells(activatedStores: activatedStores)
        }
    }
    lazy var linesOnMap : [GMSPolyline] = []
    
    
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

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        let tappedStore = marker.userData as! Store
        if let index = activatedStores.index(where: { $0.name == tappedStore.name}) {
            activatedStores.remove(at: index)
        } else {
            activatedStores.append(tappedStore)
        }
        
        //clear lines in map
        for line in linesOnMap {
            line.map = nil
        }
        
        drawPath(between: activatedStores)
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        let infoVC = self.storyboard?.instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
        let tappedStore = marker.userData as! Store
        infoVC.setRestaurantInfo(selectedRestaurant: tappedStore)

        infoVC.modalPresentationStyle = .overCurrentContext
        infoVC.modalTransitionStyle = .crossDissolve //tap store.info action
        self.present(infoVC, animated: true, completion: nil)
    }
    
    func drawMap(data: [Store]) {
        allStores = data
        for restaurant in allStores {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(restaurant.langitude!, restaurant.longitude!)
            marker.title = restaurant.name
            marker.snippet = restaurant.genre
            marker.userData = restaurant
            marker.map = mapView
        }
    }
    func drawPath(between restaurants:[Store]) {
        var index = restaurants.count
        while index > 1 {
            index -= 1
            let origin = "\(restaurants[index-2].langitude ?? 0),\(restaurants[index-2].longitude ?? 0)"
            let destination = "\(restaurants[index-1].langitude ?? 0),\(restaurants[index-1].longitude ?? 0)"
            let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=walking&key=AIzaSyB4jL4U0lVE7gKM2eUmBXAdy1Y7ngkQ0xI"
            Alamofire.request(url).responseJSON { response in
                do {
                    let json = try JSON(data: response.data!)
                    let routes = json["routes"].arrayValue
                    
                    for route in routes {
                        let routeOverviewPolyline = route["overview_polyline"].dictionary
                        let points = routeOverviewPolyline?["points"]?.stringValue
                        let path = GMSPath.init(fromEncodedPath: points!)
                        self.drawLinesForPath(path: path!, color: UIColor.red, width: 3.0)
                    }
                } catch {
                    fatalError()
                }
            }
        }
    }
    func drawLinesForPath(path: GMSPath, color: UIColor, width: CGFloat) {
        let polyline = GMSPolyline.init(path: path)
        polyline.strokeColor = color
        polyline.strokeWidth = width
        self.linesOnMap.append(polyline)
        polyline.map = self.mapView
    }
}

