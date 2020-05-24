//
//  RequestManager.swift
//  Cat.my
//
//  Created by Денис Андриевский on 23.05.2020.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//

import UIKit

// MARK: - Class that is responsible for making network requests
class RequestManager {
    
    private let apiKey = "0ee96a11-0502-49a0-8dda-90ffc3e84e9f"
    
    func requestBreeds(_ viewController: UIViewController, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let urlString = "https://api.thecatapi.com/v1/breeds?api_key=\(apiKey)"
        guard let url = URL(string: urlString) else { AlertManager.presentAlert(viewController, title: "Oops..", message: "Unsupported URL"); return }
        let task = URLSession(configuration: .default).dataTask(with: url, completionHandler: completion)
        task.resume()
    }
    
    func requestImage(_ viewController: UIViewController, id: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let urlString = "https://api.thecatapi.com/v1/images/search?api_key=\(apiKey)&breed_id=\(id)"
        guard let url = URL(string: urlString) else { AlertManager.presentAlert(viewController, title: "Oops..", message: "Unsupported URL"); return }
        let task = URLSession(configuration: .default).dataTask(with: url, completionHandler: completion)
        task.resume()
    }
    
    func requestImage(_ viewController: UIViewController, urlString: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let url = URL(string: urlString) else { AlertManager.presentAlert(viewController, title: "Oops..", message: "Unsupported URL"); return }
        let task = URLSession(configuration: .default).dataTask(with: url, completionHandler: completion)
        task.resume()
    }
    
}
