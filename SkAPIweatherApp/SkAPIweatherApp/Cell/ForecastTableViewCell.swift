//
//  ForecastTableViewCell.swift
//  SkAPIweatherApp
//
//  Created by 김광준 on 2020/05/05.
//  Copyright © 2020 VincentGeranium. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    static let identifier: String = "ForecastTableViewCell"
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var weatherImageView: UIImageView!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
