//
//  AboutUsViewController.swift
//  CTC
//
//  Created by Nirav Bavishi on 2019-04-23.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
 
    let images = ["Home", "profile"]
    let names = ["Teressa Eslar", "Kim White"]
    let links = ["http://www.connecttothecore.com","http://www.connecttothecore.com"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "About Us"

        // Do any additional setup after loading the view.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return links.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "aboutUs") as! AboutUsTableViewCell
        
        cell.profileImage.image = UIImage(named: images[indexPath.row])
        cell.nameLabel.text = names[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.shared.open(NSURL(string: links[indexPath.row])! as URL)
        tableView.deselectRow(at: indexPath, animated: true)
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
