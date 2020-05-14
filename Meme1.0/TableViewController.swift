//
//  TableViewController.swift
//  Meme1.0
//
//  Created by Emad Albarnawi on 13/05/2020.
//  Copyright © 2020 Emad Albarnawi. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController{
   
    
    
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
        
    }
    
    var testArray: [Int]   {
        get {
            AppDelegate.shared().testArray;
        } set {
            
        }
    };

    override func viewDidLoad() {
        super.viewDidLoad()
        print("hay there");

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        reloadInputViews();
        print("View Will Appear%%%%%%%%%%%%%%%%%%%");
        memes = AppDelegate.shared().memes;
        testArray = AppDelegate.shared().testArray;
        print(memes ?? "Its empty");
        tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("How many Times you enter Here???????????????????????????");
//        return memes.count;
        return memes.count;
       }
       
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("and Here###########");
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell")!;
//        let cellContet = testArray[indexPath.row];
        let cellContent = memes[indexPath.row];
//        cell.textLabel?.text = String(cellContet);
        cell.imageView?.image = cellContent.memedImage;
        return cell;
       }
    @IBAction func addButtonClicked(_ sender: Any) {
            let memeMeController = storyboard?.instantiateViewController(withIdentifier: "MemeMeController") as! MemeMeController;
            memeMeController.onDoneBlock = { result in
                self.tableView.reloadData();
            }
            present(memeMeController, animated: true) {
                self.tableView.reloadData();
                
            }

    }
    

}
