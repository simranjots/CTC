//
//  faqViewController.swift
//  CTC
//
//  Created by Jaldeep Patel on 2021-06-08.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//

import UIKit

class faqViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    fileprivate struct FAQData {
        
        let questions: [String]
        let answers: [String]
    }
   
    fileprivate let faqQuestionsAndAnswers = [
        
        FAQData(questions: [
            "What if I didn't do anything all week?",
            "How do I Calculate my numbers and progess every week?",
            "What happens if I'm good at one of these activities and not so good at the other?",
            "What if I want to quit one of my commitments?"
        ],
        answers: ["This is not an all or nothing program. There will be times when adhering to your practices is more challenging than others. You can make those days up throughout the year. Also, plan to bank before times you know will be harder or at the beginning of the year so you don’t feel the pressure at the end of the year. And keep tracking every week so you know where you’re at. If you are able to be around 60% you should have lots of leeway. If you haven’t done your practice all week, your numbers would stay the same but the percentage would go down.",
            "A) Write down the cumulative number of days you have done or not done this activity so far this year \n\nB) Here is todays day of the year \n\nC) Divide todays day of the year by your accumulated number of days so far to get your percentage for today \n\nC = A / B",
            "That’s normal, and why this program works so well. You will gain insights into where you are not as strong and need a bit more support. Tracking your achievements will help you stay on course. Having an accountability partner is a bonus!",
            "Create a post inside the Facebook Group: The 201 Day Achievement Principle. Share how you’re feeling so that others in the group including our team, can support you in staying committed to why you chose that practice in the first place."
        ]
        )]
    
    @IBOutlet weak var faqTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "FAQs"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqQuestionsAndAnswers[faqTableView.tag].questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.faqVCTableViewCell) as! faqTableViewCell
        
        cell.titleLabel.text = faqQuestionsAndAnswers[faqTableView.tag].questions[indexPath.row]
        cell.bodyLabel?.text = faqQuestionsAndAnswers[faqTableView.tag].answers[indexPath.row]
        
        return cell
    }
}
