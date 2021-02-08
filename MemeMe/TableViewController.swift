//
//  TableViewController.swift
//  MemeMe
//
//  Created by Asma  on 1/5/21.
//

import UIKit

class TableViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    //MARK: tableView Outlet
    @IBOutlet var table: UITableView!
    
    
    var memes: [Meme]! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return( appDelegate.memes)
    }
    
    //MARK: LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        //force data reload
        self.table.reloadData()
    }
    
    
    //MARK: Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell") as! tableViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        var displayedText=meme.topText ?? ""
        displayedText+=" "
        displayedText+=meme.bottomText ?? ""
        
        // Set the text and image
        cell.label.text=displayedText
        cell.cellImage.image=meme.memedImage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //navigating to MemeDetailViewController
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "memeDetailVC") as! MemeDetailViewController
        detailController.meme = self.memes[(indexPath as NSIndexPath).row].memedImage
        self.navigationController!.pushViewController(detailController, animated: true)
    }

    
    
    
    


}
