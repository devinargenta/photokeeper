//
//  PhotoPreviewViewController.swift
//  PhotoKeeper
//
//  Created by Devin Argenta on 5/17/18.
//  Copyright © 2018 Devin Argenta. All rights reserved.
//

import UIKit

class PhotoPreviewViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    // MARK: UI Stuff
    let store = PhotoStore.shared
    var image = UIImage()
    let metaForm = UIView()
    let titleField = UITextField()
    let descField = UITextView()
    let submitButton = UIButton()

    let blueblack = UIColor(hue: 0.6333, saturation: 0.15, brightness: 0.64, alpha: 1.0)
    lazy var blueblackCG = blueblack.cgColor

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupView()
        handleKeyboardEvents()
    }

    func setupView() {
        let bgView = UIImageView()
        bgView.contentMode = .scaleAspectFill
        bgView.image = image
        bgView.frame = UIScreen.main.bounds
        view.addSubview(bgView)
        buildMetaForm()
    }

    func buildMetaForm() {
       // metaForm.backgroundColor = .white
        metaForm.frame =
            CGRect(x: 0, y: view.frame.height / 2, width: view.frame.width - 40, height: view.frame.height / 2 - 40 )
        metaForm.center.x = view.center.x
        let tf = buildTitleField()
        let df = buildDescriptionField()

        // MARK: submit button
        submitButton.frame = CGRect(x: 20, y: metaForm.frame.height - 50, width: view.frame.width - 40, height: 50)
        submitButton.setTitle("Save", for: .normal)
        submitButton.backgroundColor = .red
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.addTarget(self, action: #selector(savePhoto), for: .touchUpInside)

        metaForm.addSubview(tf)
        metaForm.addSubview(df)
        metaForm.addSubview(submitButton)
        view.addSubview(metaForm)
    }

    func buildTitleField() -> UITextField {
        // MARK: titlefield
        let titleLabel = UILabel(frame: CGRect(x: 0, y: -25, width: 200, height: 20))
        titleLabel.textColor = blueblack
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.text = "Title"

        titleField.frame = CGRect(x: 0, y: 20, width: view.frame.width - 40, height: 40)
        titleField.font = UIFont.systemFont(ofSize: 15)
        titleField.attributedPlaceholder =
        NSAttributedString(string: "Title", attributes: [NSAttributedStringKey.foregroundColor: blueblack])
        titleField.textColor = blueblack
        titleField.borderStyle = UITextBorderStyle.roundedRect // keep this for builtin padding / inset
        titleField.placeholder = ""
        titleField.layer.borderColor = blueblackCG
        titleField.layer.borderWidth = 1
        titleField.layer.cornerRadius = 5
        titleField.autocorrectionType = .no
        titleField.keyboardType = .default
        titleField.returnKeyType = .next
        titleField.clearButtonMode = .whileEditing
        titleField.delegate = self
        titleField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        titleField.addSubview(titleLabel)
        return titleField
    }


    func buildDescriptionField() -> UITextView {
        // MARK: descriptionfield
        let descLabel = UILabel(frame: CGRect(x: 0, y: -25, width: 200, height: 20))
        descLabel.textColor = blueblack
        descLabel.font = UIFont.systemFont(ofSize: 15)
        descLabel.text = "Description"

        descField.frame = CGRect(x: 0, y: 90, width: view.frame.width - 40, height: 100)
        descField.isEditable = true
        descField.font = UIFont.systemFont(ofSize: 15)
        descField.textColor = blueblack
        descField.layer.borderWidth = 1
        descField.layer.cornerRadius = 5
        descField.clipsToBounds = false
        descField.layer.borderColor =  blueblackCG
        descField.autocorrectionType = .no
        descField.delegate = self
        descField.keyboardType = .default
        descField.returnKeyType = .default
        descField.addSubview(descLabel)
        return descField

    }

    func handleKeyboardEvents() {
        let defaultNFC = NotificationCenter.default
        defaultNFC.addObserver(self, selector: #selector(keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        defaultNFC.addObserver(self, selector: #selector(keyboardWillHide),
            name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        descField.becomeFirstResponder()
        return false
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @objc func savePhoto() {
        // https://stackoverflow.com/questions/32836862/how-to-use-writetofile-to-save-image-in-document-directory
        // https://www.hackingwithswift.com/example-code/system/how-to-save-user-settings-using-userdefaults
        // get the documents directory url
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = "image-\(Date().timeIntervalSince1970)"
        // create the destination file url to save your image
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        // get your UIImage jpeg data representation and check if the destination file url already exists
        if let data = UIImageJPEGRepresentation(image, 1.0),
            !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                // writes the image data to disk
                try data.write(to: fileURL)
                // store the path && info in our data
                let tfText = titleField.text
                let dfText = descField.text
                let photo = PhotoObject(value: ["fileName": fileName, "title": tfText, "desc":  dfText])
                store.addPhotoToStore(photo: photo)
                closeView()
            } catch {
                print("error saving file:", error)
            }
        } else {
            print("what is goign on here")
        }
    }

    @objc func closeView() {
        dismiss(animated: true, completion: nil)
       // navigationController?.popViewController(animated: true)
    }

    @objc func back() {
        //dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.titleField.becomeFirstResponder()
    }

}
