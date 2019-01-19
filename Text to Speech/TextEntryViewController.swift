//
//  TextEntryViewController.swift
//  Text to Speech
//
//  Created by Jonah Zukosky on 1/19/19.
//  Copyright © 2019 Zukosky, Jonah. All rights reserved.
//

import UIKit

class TextEntryViewController: UIViewController {

    @IBOutlet weak var textEntryView: UITextView!
    @IBOutlet weak var convertButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textEntryView.delegate = self
        
        textEntryView.layer.cornerRadius = 5
        textEntryView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        textEntryView.layer.borderWidth = 0.5
        textEntryView.clipsToBounds = true
        
        convertButton.layer.cornerRadius = 0.5 * convertButton.bounds.size.width
        convertButton.clipsToBounds = true
        convertButton.backgroundColor = UIColor(red: 55/255, green: 227/255, blue: 69/255, alpha: 0.7)
        convertButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "convertSegue" {
            if let destination = segue.destination as? PlaybackViewController {
                destination.text = textEntryView.text
            }
        }
    }
}

extension TextEntryViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}
