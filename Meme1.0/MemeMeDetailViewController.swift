//
//  MemeMeDetailViewController.swift
//  Meme1.0
//
//  Created by Emad Albarnawi on 14/05/2020.
//  Copyright © 2020 Emad Albarnawi. All rights reserved.
//

import UIKit

class MemeMeDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var meme: Meme!;
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        imageView.image = meme.memedImage;
//        print(meme);
    }


}
