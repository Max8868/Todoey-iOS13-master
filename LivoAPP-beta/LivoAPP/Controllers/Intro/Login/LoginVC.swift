//
//  LoginVC.swift
//  LivoAPP
//
//  Created by Livo App on 25/05/21.
//

import UIKit
import TextFieldEffects

class LoginVC: UIViewController, UITextFieldDelegate {
    
    enum CardViewState {
        case expanded
        case normal
    }
    
    @IBOutlet weak var txtFldEmail: HoshiTextField!
    @IBOutlet weak var txtFldPassword: HoshiTextField!
    @IBOutlet weak var lblPasswordError: UILabel!
    @IBOutlet weak var btnProsseguir: BtnRoxoLivo!
    
    @IBOutlet weak var backingImageView: UIImageView!
    @IBOutlet weak var dimmerView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var handleView: UIView!
    
    @IBOutlet weak var cardViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblPasswordErrorTopConstraint: NSLayoutConstraint!
    
    //backing image
    var backingImage: UIImage?
    var cardViewState : CardViewState = .normal
    
    var cardPanStartingTopConstraint : CGFloat = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtFldEmail.delegate = self
        txtFldPassword.delegate = self
        lblPasswordErrorTopConstraint.constant = 0.0
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginVC.tapFechaTeclado(sender:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
        // MARK: SETUP MODAL VIEW
        backingImageView.image = backingImage
        // Do any additional setup after loading the view.
        let dimmerTap = UITapGestureRecognizer(target: self, action: #selector(dimmerViewTapped(_:)))
        dimmerView.addGestureRecognizer(dimmerTap)
        dimmerView.isUserInteractionEnabled = true
        
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        viewPan.delaysTouchesBegan = false
        viewPan.delaysTouchesEnded = false
        
        self.view.addGestureRecognizer(viewPan)
        
        cardView.clipsToBounds = true
        cardView.layer.cornerRadius = 10.0
        cardView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        if let safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
            let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
            cardViewTopConstraint.constant = safeAreaHeight + bottomPadding
        }
        
        handleView.clipsToBounds = true
        handleView.layer.cornerRadius = 3.0
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showCard(atState: .expanded)
        
    }
    
    @IBAction func txtFldEmailEdit(_ sender: UITextField) {
        if ExtraFuncs().isValidEmail(txtFldEmail.text!) {
            txtFldEmail.borderActiveColor = corVerdeLivo
            txtFldEmail.placeholderColor = corRoxoLivo
        }
        else {
            txtFldEmail.borderActiveColor = .red
            txtFldEmail.placeholderColor = .red
            btnProsseguir.desativaBtn()
        }
        
    }
    
    @IBAction func txtFldPasswordEdit(_ sender: UITextField) {
        if (txtFldPassword.text!.count < 6){
            txtFldPassword.borderActiveColor = .red
            txtFldPassword.placeholderColor = .red
            lblPasswordError.text = "A senha deve conter ao menos 6 digitos"
            lblPasswordErrorTopConstraint.constant = 8.0
            btnProsseguir.desativaBtn()
            
        }else {
            lblPasswordError.text = ""
            lblPasswordErrorTopConstraint.constant = 0.0
            txtFldPassword.borderActiveColor = corVerdeLivo
            txtFldPassword.placeholderColor = corRoxoLivo
            btnProsseguir.ativaBtn()
        }
    }
    
    
    @IBAction func btnProsseguirTapped(_ sender: UIButton) {
        
        UserDefaults.standard.set("teste", forKey: "teste")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.hideCardAndGoBack()
        })

        
    }
    
    @IBAction func txtFldEmailExit(_ sender: UITextField) {
        
        if ExtraFuncs().isValidEmail(txtFldEmail.text!) {
            txtFldEmail.borderActiveColor = corVerdeLivo
            txtFldEmail.placeholderColor = corRoxoLivo
            txtFldPassword.becomeFirstResponder()
        }
        else {
            log.error("email vazio")
            DispatchQueue.main.async {
                self.txtFldEmail.placeholderColor = .red
                self.txtFldEmail.borderActiveColor = .red
                self.txtFldEmail.borderInactiveColor = .red
                self.txtFldEmail.borderStyle = .line
                self.txtFldEmail.becomeFirstResponder()
            }
            btnProsseguir.desativaBtn()
        }
    }
    
    @IBAction func txtFldPasswordExit(_ sender: UITextField) {
        if (txtFldPassword.text!.count < 6){
            lblPasswordError.text = "A senha deve conter ao menos 6 digitos"
            lblPasswordErrorTopConstraint.constant = 8.0
            DispatchQueue.main.async {
                self.txtFldPassword.placeholderColor = .red
                self.txtFldPassword.borderActiveColor = .red
                self.txtFldPassword.borderInactiveColor = .red
                self.txtFldPassword.borderStyle = .line
                self.txtFldPassword.becomeFirstResponder()
            }
            
        }else {
            lblPasswordError.text = ""
            lblPasswordErrorTopConstraint.constant = 0.0
            txtFldPassword.placeholderColor = corRoxoLivo
            txtFldPassword.borderActiveColor = corVerdeLivo
            btnProsseguir.ativaBtn()
            
        }
    }
    
    @objc func tapFechaTeclado(sender:UITapGestureRecognizer) {
        txtFldEmail.resignFirstResponder()
        txtFldPassword.resignFirstResponder()
        
    }
    
    @IBAction func dimmerViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideCardAndGoBack()
    }
    
    @IBAction func viewPanned(_ panRecognizer: UIPanGestureRecognizer) {
        let velocity = panRecognizer.velocity(in: self.view)
        let translation = panRecognizer.translation(in: self.view)
        
        switch panRecognizer.state {
        case .began:
            cardPanStartingTopConstraint = cardViewTopConstraint.constant
        case .changed:
            if self.cardPanStartingTopConstraint + translation.y > 30.0 {
                self.cardViewTopConstraint.constant = self.cardPanStartingTopConstraint + translation.y
                btnProsseguir.desativaBtn()
            }
            else {
                btnProsseguir.ativaBtn()
            }
            
            dimmerView.alpha = dimAlphaWithCardTopConstraint(value: self.cardViewTopConstraint.constant)
        case .ended:
            if velocity.y > 1500.0 {
                hideCardAndGoBack()
                
                return
            }
            
            if let safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
                let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
                
                if self.cardViewTopConstraint.constant < (safeAreaHeight + bottomPadding) * 0.25 {
                    showCard(atState: .expanded)
                }
//                    else if self.cardViewTopConstraint.constant < (safeAreaHeight) - 70 {
//                    showCard(atState: .normal)
//                }
                    else {
                        
                    hideCardAndGoBack()
                }
            }
        default:
            break
        }
    }
    
    //MARK: Animations
    private func showCard(atState: CardViewState = .normal) {
        self.view.layoutIfNeeded()
        
        if let safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
            let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
            
            if atState == .expanded {
                cardViewTopConstraint.constant = 30.0
            } else {
                cardViewTopConstraint.constant = (safeAreaHeight + bottomPadding) / 2.0
            }
            
            cardPanStartingTopConstraint = cardViewTopConstraint.constant
        }
        
        let showCard = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: {
            self.view.layoutIfNeeded()
            
        })
        
        showCard.addAnimations {
            self.dimmerView.alpha = 0.7
            self.btnProsseguir.ativaBtn()
        }
        
        showCard.startAnimation()
    }
    
    private func hideCardAndGoBack() {
        self.view.layoutIfNeeded()
        
        if let safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
            let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
            cardViewTopConstraint.constant = safeAreaHeight + bottomPadding
            
        }
        
        let hideCard = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: {
            self.view.layoutIfNeeded()
            
        })
        
        hideCard.addAnimations {
            self.dimmerView.alpha = 0.0
            self.btnProsseguir.desativaBtn()
        }
        
        hideCard.addCompletion({ position in
            if position == .end {
                
                if(self.presentingViewController != nil) {
                    self.dismiss(animated: false, completion: nil)
                }
            }
        })
        
        hideCard.startAnimation()
    }
    
    // MARK: Utility
    private func dimAlphaWithCardTopConstraint(value: CGFloat) -> CGFloat {
        let fullDimAlpha : CGFloat = 0.7
        
        // ensure safe area height and safe area bottom padding is not nil
        guard let safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
            let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom else {
            return fullDimAlpha
        }
        
        // when card view top constraint value is equal to this,
        // the dimmer view alpha is dimmest (0.7)
        let fullDimPosition = (safeAreaHeight + bottomPadding) / 2.0
        
        // when card view top constraint value is equal to this,
        // the dimmer view alpha is lightest (0.0)
        let noDimPosition = safeAreaHeight + bottomPadding
        
        // if card view top constraint is lesser than fullDimPosition
        // it is dimmest
        if value < fullDimPosition {
            return fullDimAlpha
        }
        
        // if card view top constraint is more than noDimPosition
        // it is dimmest
        if value > noDimPosition {
            return 0.0
        }
        
        // else return an alpha value in between 0.0 and 0.7 based on the top constraint value
        return fullDimAlpha * 1 - ((value - fullDimPosition) / fullDimPosition)
    }
}
