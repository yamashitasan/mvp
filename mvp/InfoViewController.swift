//
//  InfoViewController.swift
//  mvp
//
//  Created by 山下翔平 on 2018/08/25.
//  Copyright © 2018年 山下翔平. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    lazy var presentingStore = Store(restaurant: [])
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var genreLabel: UILabel!
    
    @IBOutlet weak var lunchTimeLabel: UILabel!
    
    @IBOutlet weak var lunchBudgetLabel: UILabel!
    
    @IBOutlet weak var dinnerBudgetLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.nameLabel.text = self.presentingStore.name
        self.genreLabel.text = self.presentingStore.genre
        self.lunchTimeLabel.text = self.presentingStore.lunchTime
        self.lunchBudgetLabel.text = self.presentingStore.lunchBudget
        self.dinnerBudgetLabel.text = self.presentingStore.dinnerBudget
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setRestaurantInfo(selectedRestaurant: Store) {
        self.presentingStore = selectedRestaurant
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
