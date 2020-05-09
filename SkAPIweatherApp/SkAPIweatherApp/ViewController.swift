//
//  ViewController.swift
//  SkAPIweatherApp
//
//  Created by 김광준 on 2020/05/02.
//  Copyright © 2020 VincentGeranium. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var listTableView: UITableView!
    
    /// 기온의 소숫점이 .00 으로 나오기 때문에 한 자리 숫자로 바꿔줌
    let tempFormatter: NumberFormatter = {
        let f = NumberFormatter()
        // 소숫점이 0 인 경우 출력하지 않는다
        f.minimumFractionDigits = 0
        // 나머지 경우에는 최대 한 자리만 출력한다.
        f.maximumFractionDigits = 1
        return f
    }()
    
    let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "Ko_kr")
        return f
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        listTableView.backgroundColor = UIColor.clear
        listTableView.separatorStyle = .none
        listTableView.showsVerticalScrollIndicator = false
        
        WeatherDataSource.shared.fetchSummary(lat: 37.498206, lon: 127.02761) { [weak self]
            in self?.listTableView.reloadData()
        }
        
        WeatherDataSource.shared.fetchForecast(lat: 37.498206, lon: 127.02761) { [weak self]
            in self?.listTableView.reloadData()
        }
    }
    
    var topInset: CGFloat = 0.0
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if topInset == 0.0 {
            let first = IndexPath(row: 0, section: 0)
            if let cell = listTableView.cellForRow(at: first) {
                topInset = listTableView.frame.height - cell.frame.height
                
                var inset = listTableView.contentInset
                inset.top = topInset
                listTableView.contentInset = inset
            }
        }
    }


}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return WeatherDataSource.shared.forecastList.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SummaryTableViewCell.identifier, for: indexPath) as? SummaryTableViewCell else {
                return UITableViewCell()
            }
            if let data = WeatherDataSource.shared.summary?.weather.minutely.first {
                cell.weatherImageView.image = UIImage(named: data.sky.code)
                cell.statusLabel.text = data.sky.name
                
                /// 문자열에 저장된 값을 타입 캐스팅을 활용하여 Double 값으로 바꾼 다음, 바꿀 수 없다면 0.0 을 저장한다.
                /// max와 min 값에는 Double 값이 저장되어 있다.
                let max = Double(data.temperature.tmax) ?? 0.0
                let min = Double(data.temperature.tmin) ?? 0.0
                
                /// max와 min을 tempFormatter를 이용하여 문자열로 바꾼다, 바꿀 수 없다면 - 으로 바꾼다.
                let maxStr = tempFormatter.string(for: max) ?? "-"
                let minStr = tempFormatter.string(for: min) ?? "-"
                
                cell.minMaxLabel.text = "최대 \(maxStr)º, 최소 \(minStr)º"
                
                let current = Double(data.temperature.tc) ?? 0.0
                let currentStr = tempFormatter.string(for: current) ?? "-"
                cell.currentTemperatureLabel.text = "\(currentStr)º"
            }
            
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.identifier, for: indexPath) as? ForecastTableViewCell else {
            return UITableViewCell()
        }
        
        let target = WeatherDataSource.shared.forecastList[indexPath.row]
        
        dateFormatter.dateFormat = "M.d (E)"
        cell.dateLabel.text = dateFormatter.string(from: target.date)
        
        dateFormatter.dateFormat = "HH:00"
        cell.timeLabel.text = dateFormatter.string(from: target.date)
        
        cell.weatherImageView.image = UIImage(named: target.skyCode)
        
        cell.statusLabel.text = target.skyName
        
        let tempStr = tempFormatter.string(for: target.temperature) ?? "-"
        cell.temperatureLabel.text = "\(tempStr)º"
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}
