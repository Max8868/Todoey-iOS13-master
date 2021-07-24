//
//  IntroAppVC.swift
//  LivoAPP
//
//  Created by Livo App on 25/05/21.
//

import UIKit

class IntroAppVC: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        log.info("abriu")
        
        guard let teste = UserDefaults.standard.object(forKey: "teste") as? String else {
            log.error("vazio")
            return
        }
        if teste == "teste" {
            goToStatusFunc(teste: teste)
            UserDefaults.standard.removeObject(forKey: "teste")
        }
        
    }
    
    func goToStatusFunc(teste: String) {
        log.info(teste)
        self.performSegue(withIdentifier: "goToHome", sender: self)
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        guard let LoginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC")
                as? LoginVC else {
            assertionFailure("No view controller ID ReactionViewController in storyboard")
            return
        }
        LoginVC.modalPresentationStyle = .fullScreen
        // Delay the capture of snapshot by 0.1 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 , execute: {
            // take a snapshot of current view and set it as backingImage
            LoginVC.backingImage = self.tabBarController?.view.asImage()
            
            // present the view controller modally without animation
            self.present(LoginVC, animated: false, completion: nil)
        })
        
    }
    @IBAction func priAcessoButtonTapped(_ sender: UIButton) {
        
        guard let CadastroVC = storyboard?.instantiateViewController(withIdentifier: "CadastroVC")
                as? CadastroVC else {
            assertionFailure("No view controller ID ReactionViewController in storyboard")
            return
        }
        CadastroVC.modalPresentationStyle = .fullScreen
        // Delay the capture of snapshot by 0.1 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 , execute: {
            // take a snapshot of current view and set it as backingImage
            CadastroVC.backingImage = self.tabBarController?.view.asImage()
            
            // present the view controller modally without animation
            self.present(CadastroVC, animated: false, completion: nil)
        })
    }
}
