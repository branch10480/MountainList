//
//  MountainCell.swift
//  MountainList
//
//  Created by branch10480 on 2021/03/15.
//

import UIKit
import SDWebImage

struct MountainCellViewData {
    let id: String
    let thumbnailUrl: String
    let name: String
    let isLike: Bool
    let likeCount: Int
}

extension Array where Element == MountainCellViewData {
    init(mountainsStatuses: [MountainStatus]) {
        self = mountainsStatuses.map {
            MountainCellViewData(
                id: $0.mountain.id.rawValue,
                thumbnailUrl: $0.mountain.thumbnailUrl,
                name: $0.mountain.name,
                isLike: $0.isLiked,
                likeCount: $0.likeCount
            )
        }
    }
}

class MountainCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var likeIconImageView: UIImageView!
    @IBOutlet weak var likeTextLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    private let likeNormalColor = UIColor.likeNormalColor
    private let likeActiveColor = UIColor.likeActiveColor

    override func awakeFromNib() {
        super.awakeFromNib()
        likeTextLabel.text = "MountainCell.likeTextLabel.text".localized
    }
    
    func configure(_ data: MountainCellViewData) {
        thumbnailView.sd_setImage(
            with: URL(string: data.thumbnailUrl),
            completed: nil
        )
        nameLabel.text = data.name
        if data.isLike {
            likeIconImageView.image =
                UIImage(named: R.image.likeActive)?.withRenderingMode(.alwaysTemplate)
            likeIconImageView.tintColor = likeActiveColor
            likeTextLabel.textColor = likeActiveColor
            likeCountLabel.textColor = likeActiveColor
        } else {
            likeIconImageView.image =
                UIImage(named: R.image.likeNormal)?.withRenderingMode(.alwaysTemplate)
            likeIconImageView.tintColor = likeNormalColor
            likeTextLabel.textColor = likeNormalColor
            likeCountLabel.textColor = likeNormalColor
        }
        likeCountLabel.text = data.likeCount.description
    }
    
}
