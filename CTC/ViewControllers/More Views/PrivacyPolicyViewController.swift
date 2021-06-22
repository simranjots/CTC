//
//  PrivacyPolicyViewController.swift
//  CTC
//
//  Created by Jaldeep Patel on 2021-06-09.
//  Copyright © 2021 Nirav Bavishi. All rights reserved.
//

import UIKit


class PrivacyPolicyViewController: UIViewController {
    
    @IBOutlet var privacyPolicyTableView: UITableView!
    
    let privacyPolicyHeader = ["Our Privacy Policy", "About Affiliated Sites", "Collection Of Personal Information", "Disclouser of Your Information","Promotional and Informational Offers", "Protection of Children Online", "Our Commitment to Security", "Storage of Information", "Policy Change", "Acceptance of Our Privacy Policy", "Complaints", "Contact"]
    let privacyPolicyBody = [
        "Connect to The Core Inc. is serious about protecting your privacy. This privacy policy covers the gathering and use of information on this app. The Company is committed to providing safe app use for users of all ages and has implemented this Privacy Policy to demonstrate our firm commitment to your privacy. The Company complies with Canadian Federal and Provincial privacy laws and regulations including the Personal Information and Electronic Documents Act.",
        "There may be links from our app to other web sites; note that this Privacy Policy applies only to our app and not to the web sites of other companies or organizations to which our app may be linked. You must check on any linked sites for the privacy policy that applies to that site and/or make any necessary inquiries in respect of that privacy policy with the operator of the linked site. These links to third party websites are provided as a convenience and are for informational purposes only. The Company does not endorse, and is not responsible for, these linked websites.",
        "Personal Information is information about you that identifies you as an individual, for example, your name, e-mail address, or profile photo. We collect information that you voluntarily provide to us to register in the app.",
        "The Company will not disclose personal information that you provide on the app to any third parties other than to a Company agent except: i) in accordance with the terms of this Privacy Policy, or ii) to comply with legal requirements such as a law, regulation, warrant, subpoena or court order, and/or iii) if you are reporting an adverse event/side effect, in which case the Company may be required to disclose such information to bodies such as, but not limited to, Canadian and/or international regulatory authorities. Please note that any of these disclosures may involve the storage or processing of personal information outside of Canada and may therefore be subject to different privacy laws than those applicable in Canada.",
        "With the permission of user information submitted at the time of registration or submission may be used for marketing and promotional purposes by the Company provided notice of this fact is made available online. If a visitor objects to such use for any reason, he/she may prevent that use, either by e-mail request or by modifying the registration information provided. The Company uses reasonable efforts to maintain users' information in a secure environment. If you have submitted personal information and want to change it or opt-out, please contact us as described below.",
        "The Company considers the protection of children's privacy, especially online, to be of the utmost importance. We do not knowingly collect or solicit personal information from children, or to request information through, our app or help-seeking information lines.",
        "We have put in place physical, electronic, and managerial procedures to safeguard and help prevent unauthorized access, maintain data security, and correctly use the information we collect online. The Company applies security safeguards appropriate to the sensitivity of the information, such as retaining information in secure facilities and making personal information accessible only to authorized employees on a need-to-know basis.",
        "Personal information you share with us is stored on our database servers at Company data centers (in whatever country they may be located), or hosted by third parties who have entered into agreements with us that require them to observe our Privacy Policy.",
        "If we alter our Privacy Policy, any changes will be posted on this page of our app so that you are always informed of the information we collect about you, how we use it and the circumstances under which we may disclose it.",
        "By using this app or any other The Company Site or interactive banner ads, you signify your acceptance of our Privacy Policy, and you adhere to the terms and conditions posted on the app. By submitting your information, you agree that it will be governed by our Privacy Policy.",
        "If you have a complaint, contact Connect To The Core; by phone 1-(416) 696-2020; or by an email at info@connectotthecore.com.",
        "You can contact us with any questions or concerns at: Connect to The Core, 374 Aspen Forest Drive, Oakville, ON L6J 6H4."
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        privacyPolicyTableView.dataSource = self
        privacyPolicyTableView.delegate = self
    }
}

extension PrivacyPolicyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return privacyPolicyHeader.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.privacyPolicyTableViewCell, for: indexPath) as! PrivacyPolicyTableViewCell
        
        cell.privacyPolicyHeading.text = privacyPolicyHeader[indexPath.row]
        cell.privacyPolicyBody.text = privacyPolicyBody[indexPath.row]
        
        return cell
    }
    
}
