//
//  StatusVC.swift
//  LivoAPP
//
//  Created by Livo App on 27/05/21.
//

import UIKit

class StatusVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtFldSelecioneUnidade: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtFldSelecioneUnidade.delegate = self
        let tapHorario = UITapGestureRecognizer(target: self, action: #selector(listaHorarios))
        txtFldSelecioneUnidade.isUserInteractionEnabled = true
        txtFldSelecioneUnidade.addGestureRecognizer(tapHorario)
        txtFldSelecioneUnidade.inputView = UIView()
        // Do any additional setup after loading the view.
    }
    
    @objc func listaHorarios() {
        guard let LoginVC = storyboard?.instantiateViewController(withIdentifier: "ListaEnderecosVC")
                as? ListaEnderecosVC else {
            assertionFailure("No view controller ID ReactionViewController in storyboard")
            return
        }
        LoginVC.modalPresentationStyle = .fullScreen
        // Delay the capture of snapshot by 0.1 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 , execute: {
            // take a snapshot of current view and set it as backingImage
            LoginVC.backingImage = self.view.asImage()
    
            // present the view controller modally without animation
            self.present(LoginVC, animated: false, completion: nil)
        })
    }


}
