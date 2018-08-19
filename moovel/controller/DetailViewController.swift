//
//  DetailViewController.swift
//  moovel
//
//  Created by shick on 17.08.18.
//  Copyright © 2018 vahid. All rights reserved.
//

import UIKit
import Foundation
import MessageUI

class DetailViewController: UIViewController,MFMailComposeViewControllerDelegate {
    
    var emailAddress: URL!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        
        let mailComposeViewController = configureMailController()
        
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            showMailError()
        }
        
    }
    
    func configureMailController() -> MFMailComposeViewController {
        
        let mailComposerVC = MFMailComposeViewController()
        
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["andrew@seemuapps.com"])
        
        return mailComposerVC
    }
    
    func showMailError() {
        
        let sendMailErrorAlert = UIAlertController(title: "Could not send email", message: "Your device could not send email", preferredStyle: .alert)
        
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
       
        sendMailErrorAlert.addAction(dismiss)
       
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
    }

}
