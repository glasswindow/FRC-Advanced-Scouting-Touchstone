//
//  AboutViewController.swift
//  FRC Advanced Scouting Touchstone
//
//  Created by Aaron Kampmeier on 12/29/16.
//  Copyright © 2016 Kampfire Technologies. All rights reserved.
//

import UIKit
import Crashlytics

class AboutViewController: UIViewController {
    @IBOutlet weak var aboutTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        aboutTextView.text = ""
        if let rtf = Bundle.main.url(forResource: "About", withExtension: "rtf") {
            do {
            let attributedString = try NSAttributedString(url: rtf, options: [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.rtf], documentAttributes: nil)
            aboutTextView.attributedText = attributedString
            } catch {
                CLSNSLogv("Unable to read About.rtf file", getVaList([]))
            }
        }
        
        Answers.logContentView(withName: "FAST About Page", contentType: nil, contentId: nil, customAttributes: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 11.0, *) {
            aboutTextView.contentInset = self.additionalSafeAreaInsets
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
