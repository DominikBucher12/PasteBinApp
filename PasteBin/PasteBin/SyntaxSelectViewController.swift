//
//  SyntaxSelectViewController.swift
//  PasteBin
//
//  Created by Henrik Gustavii on 22/03/2018.
//  Copyright © 2018 JonLuca De Caro. All rights reserved.
//

import UIKit
import Highlightr
import SearchTextField

class SyntaxSelectViewController: UIViewController {

    let languages = SyntaxLibraries().languages

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var syntaxPicker: UIPickerView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var searchSyntaxTextField: SearchTextField!
    
    var syntax: String = ""
    var syntaxIndex: Int = 0

    // Function type that can be accessed from Callback VC (PasteView.swift)
    var onSave: ((_ data: String, _ index: Int) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()

        syntaxPicker.delegate = self
        syntaxPicker.dataSource = self
        titleLabel.text = syntax
        syntaxPicker.selectRow(syntaxIndex, inComponent: 0, animated: true)
        
        // SearchTextField settings
        searchSyntaxTextField.filterStrings(languages)
//        searchSyntaxTextField.theme = SearchTextFieldTheme.darkTheme()
        searchSyntaxTextField.theme.bgColor = UIColor (red: 160/255, green: 162/255, blue: 164/255, alpha: 0.95)
        searchSyntaxTextField.theme.fontColor = UIColor.white
        searchSyntaxTextField.maxNumberOfResults = 5
        searchSyntaxTextField.maxResultsListHeight = 180
//        searchSyntaxTextField.highlightAttributes = [kCTBackgroundColorAttributeName: UIColor(red: 181/255, green: 130/255, blue: 79/255, alpha: 1), kCTFontAttributeName: UIFont.boldSystemFont(ofSize: 12)] as [NSAttributedStringKey : AnyObject]
        
        // Handles what happens when user picks an item
        searchSyntaxTextField.itemSelectionHandler = { item, itemPosition in
            let item = item[itemPosition]
            self.searchSyntaxTextField.text = item.title
            self.syntax = item.title
            
            if self.languages.contains(self.syntax) {
                self.syntaxIndex = self.languages.index(of: self.syntax)!
                self.syntaxPicker.selectRow(self.syntaxIndex, inComponent: 0, animated: true)
                self.titleLabel.text = self.languages[self.syntaxIndex]
            }
        }
    }
    
    // Sends syntax choice to pasteview and dismisses popup
    @IBAction func saveSyntax_TouchUpInside(_ sender: UIButton) {
        
        onSave?(syntax, syntaxIndex)
        
        dismiss(animated: true)
    }
    
    @IBAction func backPress(_ sender: UIButton) {
        
        dismiss(animated: true)
        
    }
    
    // Makes keyboard disappear by touching outside popup keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// UIPickerView setup
extension SyntaxSelectViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        titleLabel.text = languages[row]
        syntax = languages[row]
        syntaxIndex = row
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = languages[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15), NSAttributedStringKey.foregroundColor: UIColor.white])
        return myTitle
    }
    
}
