import Foundation

struct Constants {
    
    //MARK: -  Storyboard IDs
    struct Storyboard {
        static let loginViewController = "loginVC"
        static let signUpViewController = "signUpVC"
        static let homeViewController = "homeVC"
        static let staticsViewController = "stataticsVC"
        static let historyViewController = "historyVC"
        static let moreViewController = "moreVC"
        static let tabBarViewController = "tabBarVC"
        static let activityDetailsViewController = "ActivityDetailsVC"
        static let profileViewController = "updateProfileVC"
    }
    
    //MARK: -  TableView and CollectionView cell identifiers
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
        static let orderBooksCollectionViewCell = "shopBooksCollectionViewReusableCell"
        static let howToUseCollectionViewCell = "howToUseAppCollectionViewReusableCell"
        static let practiceHistoryCollectionViewCell = "practiceHistoryCollectionViewReusableCell"
    }
    
    //MARK: - Segue identifiers
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
        static let moreToContactUsSegue = "navigateToContactUs"
        static let homeToActivityDetailsSegue = "navigateToActivityDetailsVC"
        static let moreToProfileSegue = "navigateToProfile"
        static let moreToUpdateProfileSegue = "navigateToUpdateProfile"
        static let loginToResetPasswordSegue = "loginToResetPassword"
        static let onBoardingSegue = "loginToOnBoardingSegue"
        
    }
}
