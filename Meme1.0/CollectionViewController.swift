//
//  CollectionViewController.swift
//  Meme1.0
//
//  Created by Emad Albarnawi on 13/05/2020.
//  Copyright © 2020 Emad Albarnawi. All rights reserved.
//

import UIKit

// MARK: CollectionViewController: UICollectionViewController
class CollectionViewController: UICollectionViewController {
    
    
    // MARK: Outlet
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // MARK: Shared Variable
    var memes: [Meme]! {
        get{
            AppDelegate.shared().memes;
        }
        set {   }
    };
    // MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let space:CGFloat = 3.0;
        
        let dimension = (view.frame.size.width - (2 * space)) / 3.0;
        flowLayout.minimumInteritemSpacing = space;
        flowLayout.minimumLineSpacing = space;
        flowLayout.itemSize = CGSize(width: dimension, height: dimension);
    }
    // MARK: View will appear
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData();
    }
    // MARK: - numberOfItemsInSection
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  memes.count;
    }
    // MARK: cellForItemAt
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell;
        let cellContent = memes[indexPath.row] ;
        cell.imageView.image = cellContent.memedImage;
        
        return cell;
        
    }
    // MARK: - Actions
    
    // MARK: AddButtonClicked
    @IBAction func AddButtonClicked(_ sender: Any) {
        let memeMeController = storyboard?.instantiateViewController(withIdentifier: "MemeMeController") as! MemeMeController;
        memeMeController.onDoneBlock = { result in
            self.collectionView.reloadData();
        }
        present(memeMeController, animated: true) {
            self.collectionView.reloadData();
            
        }
    }
}
