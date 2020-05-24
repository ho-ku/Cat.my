//
//  FavoritesVC.swift
//  Cat.my
//
//  Created by Денис Андриевский on 24.05.2020.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//

import UIKit

class FavoritesVC: UIViewController {

    private var cats = [Cat]()
    private var cachedImages = [UIImage?]()
    private let coreDataManager = CoreDataManager()
    private let coreDataStack = CoreDataStack(modelName: "Cat")
    
    @IBOutlet weak var tableView: UITableView!
    var selectedCat: Cat?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Fetching favorite cats
        cats = coreDataManager.fetchFavorites(stack: coreDataStack)
        cachedImages = Array(repeating: nil, count: cats.count)
        self.tableView.reloadData()
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
        
        tableView.delegate = self
        tableView.dataSource = self
    }

}

// MARK: - UITableViewDelegate
extension FavoritesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            let catToDelete = self.cats[indexPath.row]
            catToDelete.favorite = false
            self.coreDataStack.saveContext()
            self.cats.remove(at: indexPath.row)
            self.cachedImages.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        let swipeActionConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActionConfiguration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCat = cats[indexPath.row]
        performSegue(withIdentifier: "detailCatSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailCatSegue" {
            guard let dest = segue.destination as? DetailVC else { return }
            dest.cat = selectedCat
        }
    }
}

// MARK: - UITableViewDataSource
extension FavoritesVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FavoriteCell.self), for: indexPath) as! FavoriteCell
        let cat = cats[indexPath.row]
        if let img = cachedImages[indexPath.row] {
            cell.catImage.image = img
        } else {
            RequestManager().requestImage(self, urlString: (cat.images as! [String])[0]) { (data, response, error) in
                if let error = error { AlertManager.presentAlert(self, title: "Oops...", message: "Error: \(error.localizedDescription)") }
                if let data = data {
                    DispatchQueue.main.async {
                        self.cachedImages[indexPath.row] = UIImage(data: data)
                        cell.catImage.image = UIImage(data: data)
                    }
                }
            }
        }
        cell.catName.text = cat.name
        return cell
    }
}
