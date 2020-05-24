//
//  MainVC.swift
//  Cat.my
//
//  Created by Денис Андриевский on 23.05.2020.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController {

    private var cats = [Cat]()
    private var coreDataStack = CoreDataStack(modelName: "Cat")
    private var parameters = FetchParameters()
    private var rateCells: [RateCell?] = [nil, nil]
    private var cachedImages: [UIImage?] = [nil, nil, nil]
    private var currentCat: Cat?
    private let coreDataManager = CoreDataManager()
    
    private var previewImage: UIImageView?
    private var finalView: UIView?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Fetching Cats
        parameters = ParametersManager().fetch() ?? FetchParameters()
        fetchWithParameters(parameters: parameters)
        
    }
    
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
        
        // Configuring final view
        finalView = UIView(frame: view.frame)
        if #available(iOS 13.0, *) {
            finalView?.backgroundColor = UIColor.systemBackground
        } else {
            finalView?.backgroundColor = UIColor.white
        }
        let label = UILabel(frame: CGRect(x: 0, y: 200, width: finalView!.frame.width, height: 50))
        label.text = "That's all!"
        label.font = UIFont(name: "Avenir", size: 25)
        label.textColor = UIColor(named: "TitleColor")
        label.textAlignment = .center
        finalView?.addSubview(label)
        let btn = UIButton(frame: CGRect(x: 0, y: 250, width: finalView!.frame.width, height: 100))
        btn.setTitle("Tap to restart", for: .normal)
        btn.setTitleColor(UIColor.systemBlue, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.addTarget(self, action: #selector(self.restartCats), for: .touchUpInside)
        finalView?.addSubview(btn)
        self.view.addSubview(finalView!)
        finalView?.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rateCells = [nil, nil]
        cachedImages = [nil, nil, nil]
        currentCat = cats.first
        if currentCat == nil {
            finalView?.isHidden = false
        }
        self.tableView.reloadData()
    }

    private func fetchWithParameters(parameters: FetchParameters) {
        let fetchRequest = NSFetchRequest<Cat>(entityName: "Cat")
        fetchRequest.predicate = PredicateFormatter.formPredicate(parameters: parameters)
        let results = try? coreDataStack.managedContext.fetch(fetchRequest)
        guard let res = results else { AlertManager.presentAlert(self, title: "Oops...", message: "We've found no data"); return }
        cats = res
    }
    
    @objc func closePreview() {
        previewImage?.removeFromSuperview()
    }
    
    @objc func restartCats() {
        coreDataManager.refresh()
        finalView?.isHidden = true
        parameters = ParametersManager().fetch() ?? FetchParameters()
        fetchWithParameters(parameters: parameters)
        rateCells = [nil, nil]
        cachedImages = [nil, nil, nil]
        currentCat = cats.first
        self.tableView.reloadData()
    }
    
    private func moveForward(withState state: MoveState) {
        tableView.setContentOffset(.zero, animated: true)
        rateCells = [nil, nil]
        cachedImages = [nil, nil, nil]
        currentCat?.favorite = state == .like
        currentCat?.watched = true
        coreDataStack.saveContext()
        guard let c = currentCat, let index = cats.firstIndex(of: c) else { return }
        if index + 1 == cats.count {
            finalView?.isHidden = false
        } else {
            currentCat = cats[index+1]
            self.tableView.reloadData()
        }
    }
    
    @IBAction func likeBtnPressed(_ sender: Any) {
        moveForward(withState: .like)
    }
    @IBAction func dislikeBtnPressed(_ sender: Any) {
        moveForward(withState: .dislike)
    }
}

// MARK: - UITableViewDelegate
extension MainVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cat = currentCat else { return 0 }
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
extension MainVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cat = currentCat else { return UITableViewCell() }
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MainCatCell.self), for: indexPath) as! MainCatCell
            cell.catName.text = cat.name
            cell.origin.text = cat.origin
            if let img = cachedImages[0] {
                cell.catImage.image = img
                cell.catImage.contentMode = ContentModeSetter.getContentMode(for: img)
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
