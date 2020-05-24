//
//  ViewController.swift
//  Cat.my
//
//  Created by Денис Андриевский on 21.05.2020.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//

import UIKit
import CoreData

class WelcomeVC: UIViewController {

    @IBOutlet weak var requestingLabel: UILabel!
    private var imagePoints: [CGPoint] = []
    private let coreDataStack = CoreDataStack(modelName: "Cat")
    private var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performTextAnimation()
        // If user launches app for the first time, fetching and saving breeds
        if UserDefaults.standard.value(forKey: "notFirstTime") == nil {
            Fetcher.fetch(self) { cats, urls in
                Saver.save(cats: cats, urls: urls)
                UserDefaults.standard.set(true, forKey: "notFirstTime")
                DispatchQueue.main.async {
                    self.timer?.invalidate()
                    self.timer = nil
                    self.performSegue(withIdentifier: "showMain", sender: self)
                }
            }
        } else {
            self.timer?.invalidate()
            self.timer = nil
            performSegue(withIdentifier: "showMain", sender: self)
        }

        for i in 1...4 {
            let img = addImage(num: i)
            UIView.animate(withDuration: 2, delay: TimeInterval(2*(i-1)), animations: { [weak self] in
                guard let self = self else { return }
                img.layer.cornerRadius = 80*self.view.frame.height/896
                img.frame.size.height = 160*self.view.frame.height/896
                img.frame.size.width = 160*self.view.frame.height/896
                img.center = self.imagePoints[i-1]
                img.alpha = 1
            })
        }
    }
    
    // MARK: - Animations
    private func addImage(num: Int) -> WelcomeCatImageView {
        let constantValue = 32 + 80*view.frame.height/896
        let catImageView = WelcomeCatImageView(image: UIImage(named: "cat\(num)"))
        let x = num % 2 == 0 ? constantValue : view.frame.width - constantValue
        let y = num <= 2 ? requestingLabel.frame.origin.y - constantValue : requestingLabel.frame.origin.y + requestingLabel.frame.height + constantValue
        imagePoints.append(CGPoint(x: x, y: y))
        catImageView.frame.size.height = 0
        catImageView.layer.frame.size.width = 0
        catImageView.alpha = 0.2
        catImageView.center = CGPoint(x: x, y: y)
        self.view.addSubview(catImageView)
        return catImageView
    }
    
    private func performTextAnimation() {
        var points = 4
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (timer) in
            if points == 4 {
                points = 1
            } else {
                points += 1
            }
            var labelTitle = "Requesting cats"
            for _ in 0..<points {
                labelTitle += "."
            }
            DispatchQueue.main.async {
                self.requestingLabel.text = labelTitle
            }
        }
    }


}

