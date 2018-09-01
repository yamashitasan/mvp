//
//  InfoViewController.swift
//  mvp
//
//  Created by 山下翔平 on 2018/08/25.
//  Copyright © 2018年 山下翔平. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    lazy var store = Store(restaurant: [])
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var genreLabel: UILabel!
    
    @IBOutlet weak var lunchLabel: UILabel!
    
    @IBOutlet weak var urlLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.nameLabel.text = self.store.name
        self.genreLabel.text = self.store.genre
        self.lunchLabel.text = self.store.lunch
        self.urlLabel.text = self.store.url
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setRestaurantInfo(restaurant: Store) {
        self.store = restaurant
    }
    
    
    @IBAction func tabBackground(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
