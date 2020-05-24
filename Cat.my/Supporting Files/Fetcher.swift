//
//  Fetcher.swift
//  Cat.my
//
//  Created by Денис Андриевский on 23.05.2020.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//

import UIKit

class Fetcher {
    // MARK: - Fetches cat breeds
    class func fetch(_ viewController: UIViewController, completionBlock: @escaping (Cats, [[String]]) -> Void) {
        RequestManager().requestBreeds(viewController) { (data, response, error) in
            if let error = error, let response = response as? HTTPURLResponse { AlertManager.presentAlert(viewController, title: "Oops...", message: "Error: \(error.localizedDescription), status code: \(response.statusCode)"); return }
            guard let data = data else { return }
            let cats = try? JSONDecoder().decode(Cats.self, from: data)
            guard let catArray = cats else { return }
            var imageURLs = Array(repeating: [String](), count: catArray.count)
            var wasArray = Array(repeating: false, count: catArray.count) {
                didSet {
                    if !wasArray.contains(false) {
                        completionBlock(catArray, imageURLs)
                    }
                }
            }
            for (index, cat) in catArray.enumerated() {
                for i in 0...2 {
                    RequestManager().requestImage(viewController, id: cat.id) { (imageData, response, error) in
                        if let error = error, let response = response as? HTTPURLResponse { AlertManager.presentAlert(viewController, title: "Oops...", message: "Error: \(error.localizedDescription), status code: \(response.statusCode)"); return }
                        guard let data = imageData else { return }
                        let image = try? JSONDecoder().decode([Image].self, from: data)
                        guard let img = image else { return }
                        if !imageURLs[index].contains(img[0].url) {
                            imageURLs[index].append(img[0].url)
                        }
                        if i == 2 {
                            wasArray[index] = true
                        }
                    }
                }
            }
        }
    }
    
}
