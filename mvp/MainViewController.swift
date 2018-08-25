//
//  MainViewController.swift
//  mvp
//
//  Created by 山下翔平 on 2018/08/25.
//  Copyright © 2018年 山下翔平. All rights reserved.
//

import Foundation
import Pulley

class MainViewController: PulleyViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setDrawerPosition(position: .collapsed, animated: true)
        
        let data = readFile(name: "data", type: "csv")
        let mapVC = primaryContentViewController as! MapViewController
        mapVC.drawMap(data: data)
        
    }
    
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
