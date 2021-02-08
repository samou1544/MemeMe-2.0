//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Asma  on 1/6/21.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var meme:UIImage!

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        imageView.image=meme
    }
    

    

}
