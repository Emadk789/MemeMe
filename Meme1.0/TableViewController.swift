//
//  TableViewController.swift
//  Meme1.0
//
//  Created by Emad Albarnawi on 13/05/2020.
//  Copyright © 2020 Emad Albarnawi. All rights reserved.
//

import UIKit
//MARK: TableViewController: UITableViewController
class TableViewController: UITableViewController{
    
    // MARK: Shared Variable
    var memes: [Meme]! {
        get{
            AppDelegate.shared().memes;
        }
        set {   }
        
    }
    // MARK: - View will appear
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    // MARK: - numberOfRowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count;
    }
    // MARK: cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell")!;
        let cellContent = memes[indexPath.row];
        cell.imageView?.image = cellContent.memedImage;
        cell.textLabel?.text = cellContent.topText + " ... " + cellContent.bottomText;
        
        return cell;
    }
    // MARK: - Actions
    
    // MARK: addButtonClicked
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
