//
//  CadastroVC.swift
//  LivoAPP
//
//  Created by Livo App on 26/05/21.
//

import UIKit

class CadastroVC: UIViewController {
    
    enum CardViewState {
        case expanded
        case normal
    }
    
    @IBOutlet weak var backingImageView: UIImageView!
    @IBOutlet weak var dimmerView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var handleView: UIView!
    @IBOutlet weak var lblTxt: UILabel!
    @IBOutlet weak var lblTxt2: UILabel!
    
    @IBOutlet weak var cardViewTopConstraint: NSLayoutConstraint!

    //backing image
    var backingImage: UIImage?
    var cardViewState : CardViewState = .normal
    
    var cardPanStartingTopConstraint : CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabelText()
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
    
    func setLabelText() {
        let normalText = "Por favor, digite seu "
        let normalText2 = " para"
        let boldText  = "CPF"
        
        let attributedString = NSMutableAttributedString(string:normalText)
        let attributedString2 = NSMutableAttributedString(string:normalText2)
        
        
        if let font = UIFont(name: "SegoeUI-Bold", size: 18) {
            let attrs = [NSAttributedString.Key.font: font]
            // do something with attributes
            let boldString = NSMutableAttributedString(string: boldText, attributes:attrs)
            
            attributedString.append(boldString)
            attributedString.append(attributedString2)
            lblTxt.attributedText = attributedString
            lblTxt2.text = "ter acesso a nossa plataforma."
            lblTxt.textColor = corRoxoLivo
            lblTxt2.textColor = corRoxoLivo
        } else {
            let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)]
            let boldString = NSMutableAttributedString(string: boldText, attributes:attrs)
            
            attributedString.append(boldString)
            attributedString.append(attributedString2)
            lblTxt.attributedText = attributedString
            lblTxt2.text = "ter acesso a nossa plataforma."
            lblTxt.textColor = corVerdeLivo
            lblTxt2.textColor = corVerdeLivo
        }
        
        
        
        
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
