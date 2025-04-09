import CoreGraphics

enum UserProfileViewConstraints: CGFloat {
    case userProfileImage_LayerCornerRadiusConstant = 35
    case trailingAnchorConstant = -16 // + superview.safeAreaLayoutGuide.trailingAnchor
    case leadingAnchorConstant = 16 // + superview.safeAreaLayoutGuide.leadingAnchor
    case userProfileImage_WidthHeightConstant = 70
    case userProfileImage_TopAnchorConstant = 32
    case usernameLabel_TopAnchorConstant = 8 // + userProfileImageView.topAnchor
    case favoriteLabel_TopAnchorConstant = 24 // + aboutUserLabel/nicknameLabel/usernameLabel.topAnchor
    case logoutButton_WidthHeightConstant = 44
    case emptyFavotiesImageView_WidthHeightConstant = 115
}
