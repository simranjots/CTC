import Foundation

struct Constants {
    
    struct Storyboard {
        static let loginViewController = "loginVC"
        static let signUpViewController = "signUpVC"
        static let homeViewController = "homeVC"
        static let staticsViewController = "stataticsVC"
        static let historyViewController = "historyVC"
        static let moreViewController = "moreVC"
        static let tabBarViewController = "tabBarVC"
        static let activityDetailsViewController = "ActivityDetailsVC"
    }
    
    struct CellIdentifiers {
        static let homeVCTableViewCell = "homeVCResudableCell"
        static let moreVCTableViewCell = "moreVCReusableCell"
        static let faqVCTableViewCell = "faqVCResusableCell"
        static let aboutAuthorTableViewCell = "aboutAuthorsVCResusableCell"
        static let activityProgressTableViewCell = "activityProgressVCReusableCell"
        static let stataticsTableViewCell = "showStataticsVCResusableCell"
        static let practicesRecordListCell = "practicesListVCResusableCell"
        static let privacyPolicyTableViewCell = "privacyPolicyVCResudableCell"
        static let orderBooksTableViewCell = "orderBooksReusableCell"
    }
    
    struct Segues {
        static let signInToHomeSegue = "navigateToHome"
        static let signUpToHomeSegue = "navigateToHome"
        static let forgotPasswordSegue = "forgotPasswordSegue"
        static let signUpSegue = "signUpSegue"
        static let moreToPracticeHistorySegue = "navigateToPracticeHistory"
        static let moreToHowToUseSegue = "navigateToHowToUse"
        static let moreToAboutProgramSegue = "navigateToAboutProgram"
        static let moreToFAQsSegue = "navigateToFAQs"
        static let moreToPrivacyPolicySegue = "navigateToPrivacyPolicy"
        static let moreToOrderBooksSegue = "navigateToOrderBooks"
        static let moreToAboutAuthorsSegue = "navigateToAboutAuthors"
        static let moreToConnectToUsSegue = "navigateToConnectToUs"
        static let homeToActivityDetailsSegue = "navigateToActivityDetailsVC"
        static let moreToProfileSegue = "navigateToProfile"
        
    }
}
