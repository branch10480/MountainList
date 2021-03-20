//
//  RoundLikeButton.swift
//  MountainList
//
//  Created by branch10480 on 2021/03/20.
//

import Foundation
import UIKit

class RoundLikeButton: UIButton {
    
    private let borderWidth: CGFloat = 3
    private let borderColor: UIColor = .likeActiveColor
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
        layer.masksToBounds = true
    }
    
    private func setup() {
        setTitle(nil, for: .normal)
        tintColor = .none
        backgroundColor = .orange
        setImage(
            UIImage(named: R.image.likeActiveL)?.withRenderingMode(.alwaysTemplate),
            for: .normal)
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
    
    func updateStatus(getLiked: Bool) {
        if getLiked {
            tintColor = .white
            backgroundColor = .likeActiveColor
        } else {
            tintColor = .likeActiveColor
            backgroundColor = .white
        }
    }
}
