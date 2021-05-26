//
//  faqViewController.swift
//  CTC
//
//  Created by Nirav Bavishi on 2019-04-23.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//

import UIKit

class faqViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    let faqTitles = ["WHAT IF I DIDN’T DO ANYTHING ALL WEEK?", "HOW DO I CALCULATE MY NUMBERS AND PROGRESS EVERY WEEK?", "WHAT HAPPENS IF I’M GREAT AT ONE OF THESE AND NOT SO GREAT AT THE OTHER?", "WHAT IF I WANT TO QUIT ONE OF MY COMMITMENTS?"]
    let faqBodies = ["This is not an all or nothing program. There will be times when adhering to your practices is more challenging than others. You can make those days up throughout the year. Also, plan to bank before times you know will be harder or at the beginning of the year so you don’t feel the pressure at the end of the year. And keep tracking every week so you know where you’re at. If you are able to be around 60% you should have lots of leeway. If you haven’t done your practice all week, your numbers would stay the same but the percentage would go down.", "A) Write down the cumulative number of days you have done or not done this activity so far this year \n\nB) Here is todays day of the year \n\nC) Divide todays day of the year by your accumulated number of days so far to get your percentage for today \n\nC = A / B", "That’s normal, and why this program works so well. You will gain insights into where you are not as strong and need a bit more support. Tracking your achievements will help you stay on course. Having an accountability partner is a bonus!", "Create a post inside the Facebook Group: The 201 Day Achievement Principle. Share how you’re feeling so that others in the group including our team, can support you in staying committed to why you chose that practice in the first place."]
    
    
    @IBOutlet weak var faqTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        faqTableView.allowsSelection = false
        self.title = "FAQs"
        

        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqBodies.count == faqTitles.count ? faqTitles.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "faqCell") as! faqTableViewCell
        
        cell.titleLabel.text = faqTitles[indexPath.row]
        cell.bodyLabel.text = faqBodies[indexPath.row]
        
        return cell
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
