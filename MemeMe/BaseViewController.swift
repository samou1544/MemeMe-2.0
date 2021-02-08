//
//  BaseViewController.swift
//  MemeMe
//
//  Created by Asma  on 1/7/21.
//
// This is a base viewController containing common code for both tableViewController and collectionViewController
import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //Adding plus button to navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus") ,style: .plain, target: self, action: #selector(addMeme))
    }
    
    //this function lunches Meme Editor
    @objc func addMeme(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "memeEditor") as! MemeEditorViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
         
    }

}
