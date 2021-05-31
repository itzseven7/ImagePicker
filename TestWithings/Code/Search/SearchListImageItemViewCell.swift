//
//  SearchListImageItemViewCell.swift
//  TestWithings
//
//  Created by Romain on 31/05/2021.
//

import UIKit
import Stevia

class SearchListImageItemViewCell: UICollectionViewCell {
  
  static var cellReuseIdentifier = "SearchListImageItemViewCell"
  
  let imageView = UIImageView()
  let checkedImageView = UIImageView()
  let checkedImageContainerView = UIView()
  
  var width: CGFloat = 90 {
    didSet {
      //imageView.widthConstraint?.constant = width
    }
  }
  
  var height: CGFloat = 90 {
    didSet {
      //imageView.heightConstraint?.constant = height
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    checkedImageView.image = UIImage(named: "checked")
    
    contentView.backgroundColor = .white
    checkedImageContainerView.backgroundColor = .white
    
    prepareSubviews()
    setConstraints()
    
    checkedImageContainerView.isHidden = true
  }
  
  func prepareSubviews() {
    checkedImageContainerView.sv(checkedImageView)
    contentView.sv(imageView, checkedImageContainerView)
  }
  
  func setConstraints() {
    imageView.width(width).height(height)
    imageView.Leading == contentView.Leading
    imageView.Trailing == contentView.Trailing
    imageView.Top == contentView.Top
    imageView.Bottom == contentView.Bottom
    
    checkedImageContainerView.width(24).height(24)
    checkedImageContainerView.centerInContainer()
    checkedImageView.width(24).height(24)
    checkedImageView.centerInContainer()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
