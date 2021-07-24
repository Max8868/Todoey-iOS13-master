//
//  HomeVC.swift
//  LivoAPP
//
//  Created by Livo App on 31/05/21.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var viewBlock: UIView!
    @IBOutlet weak var viewTopBlock: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBlock.animShow()
        viewBlock.layer.cornerRadius = 15
        viewBlock.layer.masksToBounds = true

    }
    

}



/*
 
 if self.view.subviews.contains(self.viewBlock) {
    // descendant view added to the parent view.
   }else{
 
 }
 
 */
