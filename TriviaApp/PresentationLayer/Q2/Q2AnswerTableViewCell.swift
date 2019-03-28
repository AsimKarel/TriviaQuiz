//
//  Q2AnswerTableViewCell.swift
//  TriviaApp
//
//  Created by Asim Karel on 28/03/19.
//  Copyright © 2019 Asim. All rights reserved.
//

import UIKit

class Q2AnswerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .blue;
        let imgView:UIImageView = UIImageView(frame: CGRect(x: self.frame.maxX-40, y: self.frame.midY-10, width: 20, height: 20))
        imgView.image = UIImage(named:"check-mark")
        self.selectedBackgroundView?.addSubview(imgView)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
