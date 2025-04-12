import UIKit

enum UserProfileViewAttributedString {
    static var userNameLabelAttributedText: NSAttributedString {
        NSAttributedString(
            string: "Placeholder_username",
            attributes: [
                .kern : 0.3,
                .font : UIFont.systemFont(ofSize: 23, weight: .bold),
                .foregroundColor : UIColor.ypWhite
            ]
        )
    }
    
    static var nicknameLabelAttributedText: NSAttributedString {
        NSAttributedString(
            string: "@placeholder_nickname",
            attributes: [
                .kern : 0,
                .font : UIFont.systemFont(ofSize: 13, weight: .regular),
                .foregroundColor : UIColor.ypGray,
                .baselineOffset : 8,
            ]
        )
    }
    
    static var aboutUserLabelAttributedText: NSAttributedString {
        NSAttributedString(
            string: "Placeholder_about",
            attributes: [
                .kern : 0,
                .font : UIFont.systemFont(ofSize: 13, weight: .regular),
                .foregroundColor : UIColor.ypWhite
            ]
        )
    }
    
    static var favoriteLabelAttributedText: NSAttributedString {
        NSAttributedString(
            string: "Избранное",
            attributes: [
                .kern : 0,
                .font : UIFont.systemFont(ofSize: 23, weight: .bold),
                .foregroundColor : UIColor.ypWhite
            ]
        )
    }
}
