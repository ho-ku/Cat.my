//
//  FiltersVC.swift
//  Cat.my
//
//  Created by Денис Андриевский on 23.05.2020.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//

import UIKit
import CoreData

class FiltersVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var applyBtn: UIButton!
    private var parameters = FetchParameters()
    private var manager = ParametersManager()
    private let titles = ["Dog Friendly", "Child Friendly", "Rare", "Hairless", "Hypoallergenic"]
    
    private var sliders = [UISlider]()
    private var switches = [UISwitch]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        parameters = manager.fetch() ?? FetchParameters()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "TitleColor") ?? UIColor.black, NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 20)!]
        } else {
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0.122, green: 0.365, blue: 0.184, alpha: 1), NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 20)!]
        }
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        applyBtn.layer.cornerRadius = 20
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func sliderChangedValue(_ sender: UISlider) {
        if sender == sliders[0] {
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! SliderCell
            cell.parametersLabel.text = "\(Int(cell.slider.value))-5"
        } else {
            let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! SliderCell
            cell.parametersLabel.text = "\(Int(cell.slider.value))-5"
        }
    }

    @IBAction func closeBtnPressed(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func clearBtnPressed(_ sender: Any) {
        parameters = FetchParameters()
        self.tableView.reloadData()
    }
    @IBAction func applyBtnPressed(_ sender: Any) {
        let params = FetchParameters()
        params.childFriendly = Int(sliders[1].value)...5
        params.dogFriendly = Int(sliders[0].value)...5
        params.rare = switches[0].isOn
        params.hairless = switches[1].isOn
        params.hypoallergenic = switches[2].isOn
        manager.clear()
        manager.save(parameters: params)
        _ = navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDelegate
extension FiltersVC: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource
extension FiltersVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row <= 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SliderCell.self), for: indexPath) as! SliderCell
            cell.titleLabel.text = titles[indexPath.row]
            cell.parametersLabel.text = "\(indexPath.row == 1 ? parameters.childFriendly.lowerBound : parameters.dogFriendly.lowerBound)-5"
            cell.slider.setValue(Float(indexPath.row == 1 ? parameters.childFriendly.lowerBound : parameters.dogFriendly.lowerBound), animated: false)
            sliders.append(cell.slider)
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SelectionCell.self), for: indexPath) as! SelectionCell
            cell.titleLabel.text = titles[indexPath.row]
            cell.switcher.isOn = [parameters.rare, parameters.hairless, parameters.hypoallergenic][indexPath.row-2]
            switches.append(cell.switcher)
            cell.selectionStyle = .none
            return cell
        }
    }
    
}
