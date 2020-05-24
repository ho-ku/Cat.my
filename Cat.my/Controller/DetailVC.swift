//
//  DetailVC.swift
//  Cat.my
//
//  Created by Денис Андриевский on 24.05.2020.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    var cat: Cat!
    private var rateCells: [RateCell?] = [nil, nil]
    private var cachedImages: [UIImage?] = [nil, nil, nil]
    private var previewImage: UIImageView?
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configuring navbar and tabbar
        if #available(iOS 13.0, *) {
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "TitleColor") ?? UIColor.black, NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 20)!]
        } else {
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0.122, green: 0.365, blue: 0.184, alpha: 1), NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 20)!]
        }
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        tabBarController?.tabBar.backgroundImage = UIImage()
        tabBarController?.tabBar.shadowImage = UIImage()
        
        // Configuring tableView
        tableView.layer.cornerRadius = 10
        tableView.layer.borderWidth = 1.0
        tableView.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 0.5).cgColor
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        // Configuring previewImage
        previewImage = UIImageView(frame: self.view.frame)
        previewImage?.contentMode = .scaleAspectFit
        previewImage?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.96)
        previewImage?.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.closePreview))
        previewImage?.addGestureRecognizer(tap)
    }
    
    @objc func closePreview() {
        previewImage?.removeFromSuperview()
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareBtnPressed(_ sender: Any) {
        share()
    }
    
    private func share() {
        guard let name = cat.name, let origin = cat.origin, let summary = cat.summary else { return }
        let defaultText = """
        Check \(name) from \(origin)
        \(summary)
        """
                
        let activityController: UIActivityViewController
        if let img = cachedImages[0] {
            activityController = UIActivityViewController(activityItems: [defaultText, img], applicationActivities: nil)
        } else  {
            activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
        }
                
        self.present(activityController, animated: true, completion: nil)
    }
    
}

// MARK: - UITableViewDelegate
extension DetailVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return tableView.frame.height
        case 1...2:
            return 70
        case 3:
            return (cat.images as! [String]).count >= 2 ? 400 : 0
        case 4:
            return 200
        case 5:
            return (cat.images as! [String]).count >= 3 ? 400 : 0
        case 6:
            if cat.hair || cat.hypoalerg || cat.rare {
                return 170
            }
            return 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            previewImage?.image = cachedImages[0]
        case 3:
            previewImage?.image = cachedImages[1]
        case 5:
            previewImage?.image = cachedImages[2]
        default:
            print("Unsupported")
        }
        UIApplication.shared.keyWindow?.addSubview(previewImage!)
    }
    
}

// MARK: - UITableViewDataSource
extension DetailVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MainCatCell.self), for: indexPath) as! MainCatCell
            cell.catName.text = cat.name
            cell.origin.text = cat.origin
            if let img = cachedImages[0] {
                cell.catImage.image = img
            } else {
                cell.catImage.image = UIImage()
                RequestManager().requestImage(self, urlString: (cat.images as! [String])[0]) { (data, response, error) in
                    if let error = error { AlertManager.presentAlert(self, title: "Oops...", message: "Error: \(error.localizedDescription)") }
                    if let data = data {
                        DispatchQueue.main.async {
                            self.cachedImages[0] = UIImage(data: data)
                            cell.catImage.image = UIImage(data: data)
                            cell.catImage.contentMode = ContentModeSetter.getContentMode(for: UIImage(data: data) ?? UIImage())
                        }
                    }
                }
            }
            cell.selectionStyle = .none
            return cell
        case 1...2:
            if let rateCell = rateCells[indexPath.row-1] { return rateCell }
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RateCell.self), for: indexPath) as! RateCell
            cell.titleLabel.text = ["Dog-friendly", "Child-friendly"][indexPath.row-1]
            for i in 0...Int([cat.dogFriendly, cat.childFriendly][indexPath.row-1])-1 {
                [cell.star1, cell.star2, cell.star3, cell.star4, cell.star5][i]?.image = #imageLiteral(resourceName: "star")
            }
            rateCells[indexPath.row-1] = cell
            cell.selectionStyle = .none
            return cell
        case 3, 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ImageCell.self), for: indexPath) as! ImageCell
            if (cat.images as! [String]).count >= 2 && indexPath.row == 3 {
                if let img = cachedImages[1] {
                    cell.img.image = img
                } else {
                    cell.img.image = UIImage()
                    RequestManager().requestImage(self, urlString: (cat.images as! [String])[1]) { (data, response, error) in
                        if let error = error { AlertManager.presentAlert(self, title: "Oops...", message: "Error: \(error.localizedDescription)") }
                        if let data = data {
                            DispatchQueue.main.async {
                                self.cachedImages[1] = UIImage(data: data)
                                cell.img.image = UIImage(data: data)
                                cell.img.contentMode = ContentModeSetter.getContentMode(for: UIImage(data: data) ?? UIImage())
                            }
                        }
                    }
                }
            } else if (cat.images as! [String]).count >= 3 && indexPath.row == 5 {
                if let img = cachedImages[2] {
                    cell.img.image = img
                } else {
                    cell.img.image = UIImage()
                    RequestManager().requestImage(self, urlString: (cat.images as! [String])[2]) { (data, response, error) in
                        if let error = error { AlertManager.presentAlert(self, title: "Oops...", message: "Error: \(error.localizedDescription)") }
                        if let data = data {
                            DispatchQueue.main.async {
                                self.cachedImages[2] = UIImage(data: data)
                                cell.img.image = UIImage(data: data)
                                cell.img.contentMode = ContentModeSetter.getContentMode(for: UIImage(data: data) ?? UIImage())
                            }
                        }
                    }
                }
            }
            cell.selectionStyle = .none
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DescriptionCell.self), for: indexPath) as! DescriptionCell
            cell.descriptionView.text = cat.summary
            cell.selectionStyle = .none
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CharacteristicsCell.self), for: indexPath) as! CharacteristicsCell
            cell.hairlessLabel.isHidden = !cat.hair
            cell.hypoLabel.isHidden = !cat.hypoalerg
            cell.rareLabel.isHidden = !cat.rare
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
    }
    
}
