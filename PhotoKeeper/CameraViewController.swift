//
//  CameraViewController.swift
//  PhotoKeeper
//
//  Created by Devin Argenta on 5/3/18.
//  Copyright © 2018 Devin Argenta. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    // MARK: av capture shit
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?

    // MARK: UI Stuff
    // store this instance here cuz im finna mount a cam view in here
    let image = UIImage()
    let camPlaceholder = UIView()
    let metaForm = UIView()
    let snappyBoi = UIButton()
    let titleField = UITextField()
    let descriptionField = UITextView()
    let submitButton = UIButton()
    let iView = UIImageView()

    // MARK: colors
    let blueblack = UIColor(hue: 0.6333, saturation: 0.15, brightness: 0.64, alpha: 1.0)
    
    
    // MARK: the app
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.barStyle = .blackTranslucent
        navigationController?.navigationBar.tintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(cancel))
        camPlaceholder.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
        camPlaceholder.backgroundColor = .black
        view.addSubview(camPlaceholder)
        buildMetaForm()
        buildCameraButton()
        initializeCaptureDevice()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func initializeCaptureDevice() {
        
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            fatalError("No video device found")
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession = AVCaptureSession()
            captureSession?.sessionPreset = AVCaptureSession.Preset.high
            captureSession?.addInput(input)
            
            // Get an instance of ACCapturePhotoOutput class
            capturePhotoOutput = AVCapturePhotoOutput()
            capturePhotoOutput?.isHighResolutionCaptureEnabled = true
    
            if captureSession!.canAddOutput(capturePhotoOutput!) {
                captureSession?.addOutput(capturePhotoOutput!)
            }
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = camPlaceholder.layer.bounds
            
            //start video capture
            camPlaceholder.layer.addSublayer(videoPreviewLayer!)
            captureSession?.startRunning()
        } catch {
            print(error)
        }
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func savePhoto() {
        UIImageWriteToSavedPhotosAlbum(iView.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func takePhoto() {
        // take a  photo
        guard let capturePhotoOutput = self.capturePhotoOutput else { return }
        // Get an instance of AVCapturePhotoSettings class
        let photoSettings = AVCapturePhotoSettings()
        // Set photo settings for our need
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        // Call capturePhoto method by passing our photo settings and a delegate implementing AVCapturePhotoCaptureDelegate
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)

        // hide the camera icon thingie
        snappyBoi.isHidden = true
        
        // show meta stuff
        UIView.animate(withDuration: 0.5, animations: {
            let mf = self.metaForm
            mf.alpha = 1
            mf.center.x = self.view.center.x
            self.submitButton.frame.origin.y = self.view.frame.height - 80
        })

    }
    func buildMetaForm() {
        
        metaForm.frame = CGRect(x: view.frame.width, y: view.frame.width + 20, width: view.frame.width - 40, height: view.frame.width / 2 - 40 )
        metaForm.alpha = 0.0

        // MARK: titlefield
        let titleLabel = UILabel(frame: CGRect(x: 0, y: -25, width: 200, height: 20))
        titleLabel.textColor = blueblack
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.text = "Title"

        titleField.frame = CGRect(x: 0, y: 20, width: view.frame.width - 40, height: 40)
        titleField.font = UIFont.systemFont(ofSize: 15)
        titleField.attributedPlaceholder = NSAttributedString(string: "Title", attributes: [NSAttributedStringKey.foregroundColor : blueblack])
        titleField.textColor = blueblack
        titleField.borderStyle = UITextBorderStyle.roundedRect // keep this for builtin padding / inset
        titleField.placeholder = ""
        titleField.layer.borderColor = blueblack.cgColor
        titleField.layer.borderWidth = 1
        titleField.layer.cornerRadius = 5
        titleField.autocorrectionType = .no
        titleField.keyboardType = .default
        titleField.returnKeyType = .next
        titleField.clearButtonMode = .whileEditing;
        titleField.delegate = self
        titleField.contentVerticalAlignment = UIControlContentVerticalAlignment.center

        // MARK: descriptionfield
        let descLabel = UILabel(frame: CGRect(x: 0, y: -25, width: 200, height: 20))
        descLabel.textColor = blueblack
        descLabel.font = UIFont.systemFont(ofSize: 15)
        descLabel.text = "Description"
        
        descriptionField.frame = CGRect(x: 0, y: 90, width: view.frame.width - 40, height: 100)
        descriptionField.isEditable = true
        descriptionField.font = UIFont.systemFont(ofSize: 15)
        descriptionField.textColor = blueblack
        descriptionField.layer.borderWidth = 1
        descriptionField.layer.cornerRadius = 5
        descriptionField.clipsToBounds = false
        descriptionField.layer.borderColor =  blueblack.cgColor
        descriptionField.autocorrectionType = .no
        descriptionField.delegate = self
        descriptionField.keyboardType = .default
        descriptionField.returnKeyType = .default
        
        // MARK: submit button
        submitButton.frame = CGRect(x: 0, y: view.frame.height + 60, width: view.frame.width / 2 - 10, height: 50)
        submitButton.center.x = view.frame.width - 120
        submitButton.setTitle("Save", for: .normal)
        submitButton.backgroundColor = .red
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.addTarget(self, action: #selector(savePhoto), for: .touchUpInside)
        
        titleField.addSubview(titleLabel)
        metaForm.addSubview(titleField)
        descriptionField.addSubview(descLabel)
        metaForm.addSubview(descriptionField)
        
        view.addSubview(submitButton)
        view.addSubview(metaForm)
    }
    
    func buildCameraButton(){
        let sb = snappyBoi
        let sbl = sb.layer
        sb.frame = CGRect(x: 0, y: 0, width: 65, height: 65)
        let sbsize = sb.bounds.size
        sb.center.x = view.frame.width - (sbsize.width)
        sb.center.y = view.frame.height - (sbsize.height)
        sbl.cornerRadius = 0.5 * sb.bounds.size.width
        sbl.borderWidth = 1
        sbl.borderColor = blueblack.cgColor
        sbl.shadowColor = blueblack.cgColor
        sbl.shadowOpacity = 0.9
        sbl.shadowOffset = CGSize(width: 2, height: 2)
        sbl.shadowRadius = 2
        sbl.shadowPath = UIBezierPath(roundedRect: sb.bounds, cornerRadius: 0.5 * sbsize.width).cgPath
        sb.backgroundColor = .white
        sb.setTitle("+", for: .normal)
        sb.setTitleColor(blueblack, for: .normal)
        sb.addTarget(self, action: #selector(takePhoto), for: UIControlEvents.touchUpInside)
        view.addSubview(sb)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


}

extension CameraViewController : AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let imageData = photo.fileDataRepresentation()
    
        let capturedImage = UIImage.init(data: imageData! , scale: 1.0)
        if let image = capturedImage {
            iView.image = image
            iView.frame = CGRect(x: 0, y: 0, width: camPlaceholder.frame.width, height: camPlaceholder.frame.height)
            iView.contentMode = .scaleAspectFill

            camPlaceholder.addSubview(iView)
            camPlaceholder.clipsToBounds = true
            
            // idk how 2 crop this
        
            
        }
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }

}

