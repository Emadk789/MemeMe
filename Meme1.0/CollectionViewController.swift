//
//  CollectionViewController.swift
//  Meme1.0
//
//  Created by Emad Albarnawi on 13/05/2020.
//  Copyright © 2020 Emad Albarnawi. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
//    @IBOutlet private weak var collectionView2: UICollectionView!;
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]! {
        //        let object = UIApplication.shared.delegate
        //        let appDelegate = object as! AppDelegate
        //        return appDelegate.memes
        get{
            AppDelegate.shared().memes;
        }
        set {
            //            self.memes = x;
        }
        
    };
    
//    MemeMeController.onDoneBlock = { result in
//    collectionView.reloadData();
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("I am in CollectionView didLoad");
                let space:CGFloat = 3.0
                print(view.frame.size.width);

                let dimension = (view.frame.size.width - (2 * space)) / 3.0
                print(dimension);
                flowLayout.minimumInteritemSpacing = space
                flowLayout.minimumLineSpacing = space
                flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout;
        layout.itemSize = CGSize(width: dimension, height: dimension);
        
    }
    override func viewWillAppear(_ animated: Bool) {
        print("I am in CollectionView willAppear");
        collectionView.reloadData();
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("memes in numberOfItemsInSection \(memes.count)");
        if memes.count == 1{
            return  memes.count + 5;
        } else {
            return  memes.count;
        }
    }
    
    //    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    //
    //    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if memes.count == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell;
                   
                   let cellContent = memes[0] ;
                   
                   cell.imageView.image = cellContent.memedImage;
                   
                   return cell;
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell;
                   
                   let cellContent = memes[indexPath.row] ;
                   
                   cell.imageView.image = cellContent.memedImage;
                   
                   return cell;
        }
       
    }
    @IBAction func AddButtonClicked(_ sender: Any) {
        let memeMeController = storyboard?.instantiateViewController(withIdentifier: "MemeMeController") as! MemeMeController;
        memeMeController.onDoneBlock = { result in
            self.collectionView.reloadData();
        }
        present(memeMeController, animated: true) {
            self.collectionView.reloadData();
            
        }
    }
//dismi
    //    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
//        print("In dismiss @@@@@@@@@@@@@@@@@@@@@")
//        collectionView.reloadData();
//    }
    
    
    
    
    
}
