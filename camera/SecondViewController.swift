//
//  SecondViewController.swift
//  camera
//
//  Created by Mobark Alseif on 28/03/1443 AH.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var imageViewSecond: UIImageView!
    var caching = CachingManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let image = caching.image(forKey: "url")
        guard let image = image else { return }
        self.imageViewSecond.image = image
    }
    
}
