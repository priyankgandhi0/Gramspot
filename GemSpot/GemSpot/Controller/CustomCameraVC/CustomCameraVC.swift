//
//  CustomCameraVC.swift
//  GemSpot
//
//  Created by Jaydeep on 01/04/20.
//  Copyright © 2020 Jaydeep. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import Photos
import BSImagePicker

class CustomCameraVC: UIViewController {
    
    //MARK:- Variable Declaration
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    var input: AVCaptureDeviceInput?
    var picker = UIImagePickerController()
    var pictureDate : Date?
    var pictureLocation : CLLocationCoordinate2D?
    var statusAddMoreImage = checkAddMore.initial
    var arrSelectedImage = [ClsPostListPostImage]()
    
    //MARK:- Outlet Zone
    
    @IBOutlet weak var previewView: UIView!
    
    //MARK:- ViewLifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCamera()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if statusAddMoreImage == .initial {
            arrSelectedImage.removeAll()
            arrMainSelectedImage.removeAll()
        }
        
        self.navigationController?.isNavigationBarHidden = true
        appDelegate.objTabbar.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if statusAddMoreImage == .initial {
            appDelegate.objTabbar.tabBar.isHidden = false
        }
    }
    
    func setupCamera() {
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            return
//            fatalError("No video device found")
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous deivce object
            input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object
            captureSession = AVCaptureSession()
            
            // Set the input devcie on the capture session
            captureSession?.addInput(input!)
            
            // Get an instance of ACCapturePhotoOutput class
            capturePhotoOutput = AVCapturePhotoOutput()
            capturePhotoOutput?.isHighResolutionCaptureEnabled = true
            
            // Set the output on the capture session
            captureSession?.addOutput(capturePhotoOutput!)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the input device
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)

            // Set delegate and use the default dispatch queue to execute the call back
//            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
//            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            //Initialise the video preview layer and add it as a sublayer to the viewPreview view's layer
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = previewView.layer.frame
            previewView.layer.addSublayer(videoPreviewLayer!)
            
            //start video capture
            captureSession?.startRunning()

        } catch {
            //If any error occurs, simply print it out
            print(error)
            DispatchQueue.main.async {
                self.redirectToPhotos()
            }
            return
        }
    }
    
    override func viewDidLayoutSubviews() {
        videoPreviewLayer?.frame = previewView.frame
        if let previewLayer = videoPreviewLayer ,(previewLayer.connection?.isVideoOrientationSupported)! {
            previewLayer.connection?.videoOrientation = UIApplication.shared.statusBarOrientation.videoOrientation ?? .portrait
        }
    }
    
    override func btnBackAction(_ sender: UIButton) {
        if statusAddMoreImage == .initial {
            appDelegate.objTabbar.selectedIndex = 0
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }

}

extension CustomCameraVC : AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            let capturedImage = UIImage.init(data: imageData , scale: 1.0)
            if let image = capturedImage {
                // Save our captured image to photos album
                print("image \(image)")
                let obj = customeCameraStoryboard.instantiateViewController(withIdentifier: "PhotoFilterVC") as! PhotoFilterVC
                let dict = ClsPostListPostImage()
                dict.isUploaded = 0
                dict.image = image
                dict.isVideo = 0
                dict.originalImage = image
                dict.allData = image.pngData()
                dict.location = kCurrentUserLocation.coordinate
                arrSelectedImage.append(dict)
                obj.arrSelectedImage = arrSelectedImage
                obj.statusAddMoreImage = self.statusAddMoreImage
                obj.hidesBottomBarWhenPushed = true
                obj.pictureDate = Date()
                obj.pictureLocation = kCurrentUserLocation.coordinate
                self.navigationController?.pushViewController(obj, animated: true)
            }
        }
    }
}

//MARK:- Action Zone

extension CustomCameraVC {
    @IBAction func onTapTakePhoto(_ sender: UIButton) {
        // Make sure capturePhotoOutput is valid
        guard let capturePhotoOutput = self.capturePhotoOutput else { return }
        
        // Get an instance of AVCapturePhotoSettings class
        let photoSettings = AVCapturePhotoSettings()
        
        // Set photo settings for our need
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .off
        let currentCameraInput: AVCaptureInput = captureSession!.inputs[0]
        if (currentCameraInput as! AVCaptureDeviceInput).device.hasFlash {
            let position = (currentCameraInput as! AVCaptureDeviceInput).device.position
            photoSettings.flashMode = position == .front || position == .unspecified ? .off : .off
        }
        
        // Call capturePhoto method by passing our photo settings and a delegate implementing AVCapturePhotoCaptureDelegate
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    @IBAction func btnOpenGallary(_ sender: UIButton) {
        PHPhotoLibrary.requestAuthorization({status in
            switch status {
            case .authorized:
                DispatchQueue.main.async {
//                    self.alertActionForGallary()
                    self.openPickerForGallary()
                }
            case .denied:
                print("denied")
                DispatchQueue.main.async {
                    self.redirectToPhotos()
                }
            // probably alert the user that they need to grant photo access
            case .notDetermined:
                print("not determined")
                DispatchQueue.main.async {
                    self.redirectToPhotos()
                }
            case .restricted:
                print("restricted")
                DispatchQueue.main.async {
                    self.redirectToPhotos()
                }
                // probably alert the user that photo access is restricted
            @unknown default:
                print("")
            }
        })
    }
    
    @IBAction func btnOpenGallaryForVideo(_ sender: UIButton) {
        PHPhotoLibrary.requestAuthorization({status in
            switch status {
            case .authorized:
                DispatchQueue.main.async {
                    self.alertActionForVideo()
                }                
            case .denied:
                print("denied")
                DispatchQueue.main.async {
                    self.redirectToPhotos()
                }
            // probably alert the user that they need to grant photo access
            case .notDetermined:
                print("not determined")
                DispatchQueue.main.async {
                    self.redirectToPhotos()
                }
            case .restricted:
                print("restricted")
                DispatchQueue.main.async {
                    self.redirectToPhotos()
                }
                // probably alert the user that photo access is restricted
            @unknown default:
                print("")
            }
        })
        
    }
    
    @IBAction func btnCameraRotate(_ sender: UIButton) {
        
        let currentCameraInput: AVCaptureInput = captureSession!.inputs[0]
        captureSession!.removeInput(currentCameraInput)
        var newCamera: AVCaptureDevice
        newCamera = AVCaptureDevice.default(for: AVMediaType.video)!
        
        if (currentCameraInput as! AVCaptureDeviceInput).device.position == .back {
            UIView.transition(with: self.previewView, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                newCamera = self.cameraWithPosition(.front)!
            }, completion: nil)
        } else {
            UIView.transition(with: self.previewView, duration: 0.5, options: .transitionFlipFromRight, animations: {
                newCamera = self.cameraWithPosition(.back)!
            }, completion: nil)
        }
        do {
            try self.captureSession?.addInput(AVCaptureDeviceInput(device: newCamera))
        }
        catch {
            print("error: \(error.localizedDescription)")
        }  
    }
    
    func cameraWithPosition(_ position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let deviceDescoverySession = AVCaptureDevice.DiscoverySession.init(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)

        for device in deviceDescoverySession.devices {
            if device.position == position {
                return device
            }
        }
        return nil
    }
    
    func redirectToPhotos() {
        displayAlertWithTitle(APP_NAME, andMessage: "Please turn on photos permission from setting", buttons: ["Setting","Cancel"], completion: {(tag) in
            if tag == 0{
                let url = URL(string:UIApplication.openSettingsURLString)
                if UIApplication.shared.canOpenURL(url!){
                    // can open succeeded.. opening the url
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                }
            }
            
        })
    }
    
}

extension UIInterfaceOrientation {
    var videoOrientation: AVCaptureVideoOrientation? {
        switch self {
        case .portraitUpsideDown: return .portraitUpsideDown
        case .landscapeRight: return .landscapeRight
        case .landscapeLeft: return .landscapeLeft
        case .portrait: return .portrait
        default: return nil
        }
    }
}

//MARK: - UIImagePickerController

extension CustomCameraVC:UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    func openPickerForGallary()  {
        
        // Create the alert controller
        let alertController = UIAlertController(title: APP_NAME, message: "Please choose any one", preferredStyle: .actionSheet)
        
        // Create the actions
        let gallaryAction = UIAlertAction(title: "Photo", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.alertActionForGallary()
        }
        let cameraAction = UIAlertAction(title: "Video", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.picker = UIImagePickerController()
            self.picker.mediaTypes = ["public.movie"]
            self.picker.allowsEditing = true
            self.picker.delegate = self
            self.picker.sourceType = .photoLibrary
            self.picker.modalPresentationStyle = .fullScreen
            self.present(self.picker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(gallaryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alertActionForGallary(){
        let imagePicker = ImagePickerController()
        imagePicker.settings.selection.max = 10
        imagePicker.settings.theme.selectionStyle = .numbered
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
        imagePicker.settings.selection.unselectOnReachingMax = true
        
        let start = Date()
        self.presentImagePicker(imagePicker, select: { (asset) in
            print("Selected: \(asset)")
        }, deselect: { (asset) in
            print("Deselected: \(asset)")
        }, cancel: { (assets) in
            print("Canceled with selections: \(assets)")
        }, finish: { (assets) in
            print("Finished with selections: \(assets)")
            SHOW_CUSTOM_LOADER()
            DispatchQueue.main.async {
                for i in 0..<assets.count{
                    self.getImageFromAsset(asset: assets[i], callback: { (image) in
                        let dict = ClsPostListPostImage()
                        dict.isUploaded = 0
                        dict.image = image
                        dict.originalImage = image
                        dict.isVideo = 0
                        dict.allData = image.pngData()
//                        dict.assets = assets[i]
                        DispatchQueue.main.async {
                            dict.location = assets[i].location?.coordinate
                        }
                        self.arrSelectedImage.append(dict)
                    })
                }
                HIDE_CUSTOM_LOADER()
                let obj = customeCameraStoryboard.instantiateViewController(withIdentifier: "PhotoFilterVC") as! PhotoFilterVC
                obj.arrSelectedImage = self.arrSelectedImage
                obj.statusAddMoreImage = self.statusAddMoreImage
                obj.pictureLocation = kCurrentUserLocation.coordinate
                obj.pictureDate = Date()
                obj.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(obj, animated: true)
            }
        }, completion: {
            let finish = Date()
            print(finish.timeIntervalSince(start))
        })
    }
    /*func alertActionForGallary()  {
        self.picker = UIImagePickerController()
        self.picker.allowsEditing = false
        self.picker.delegate = self
        self.picker.sourceType = .photoLibrary
        self.picker.mediaTypes = ["public.image","public.movie"]
        self.picker.modalPresentationStyle = .fullScreen
        self.picker.navigationBar.isTranslucent = false
        self.picker.navigationBar.barTintColor = APP_THEME_GREEN_COLOR // Background color
        self.picker.navigationBar.tintColor = .white // Cancel button ~ any UITabBarButton items
        self.picker.navigationBar.backgroundColor = APP_THEME_GREEN_COLOR
        self.picker.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        self.picker.navigationBar.shadowImage = UIImage()
        self.picker.navigationBar.setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barTintColor = APP_THEME_GREEN_COLOR
        self.present(self.picker, animated: true, completion: nil)
    }*/
    
    func alertActionForVideo()  {
        self.picker = UIImagePickerController()               
        self.picker.allowsEditing = true
        self.picker.delegate = self
        self.picker.videoMaximumDuration = 15
        self.picker.sourceType = .camera
        self.picker.mediaTypes = [kUTTypeMovie as String]
        self.picker.modalPresentationStyle = .fullScreen
        self.picker.videoQuality = .typeHigh
        self.present(self.picker, animated: true, completion: {
            self.picker.cameraFlashMode = .off
        })
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let asset = info[.phAsset] as? PHAsset {
            print("date",asset.creationDate ?? "None")
            print("location",asset.location ?? "None")
            print("\(asset.description)")
            print("\(asset.debugDescription)")
            pictureDate = asset.creationDate ?? Date()
            pictureLocation = asset.location?.coordinate ?? kCurrentUserLocation.coordinate
        }
        if let originalImage = info[.originalImage] as? UIImage {
            let obj = customeCameraStoryboard.instantiateViewController(withIdentifier: "PhotoFilterVC") as! PhotoFilterVC
//            obj.selectedImg = originalImage
            obj.pictureLocation = pictureLocation ?? kCurrentUserLocation.coordinate
            obj.pictureDate = pictureDate ?? Date()
            obj.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(obj, animated: true)
        } else if let videoURL = info[.mediaURL] as? URL {
            
            var thumbnailImage = UIImage()
            getThumbnailImageFromVideoUrl(url: videoURL) { (image) in
                guard let image = image else {
                    return
                }
//                self.imageSelected.append(thumbnailImage)
                thumbnailImage = image
            }
            let data = NSData(contentsOf: videoURL as URL)!
            print("File size before compression: \(Double(data.length / 1048576)) mb")
            let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".mp4")
            compressVideo(inputURL: videoURL , outputURL: compressedURL) { (exportSession) in
                guard let session = exportSession else {
                    return
                }
                
                switch session.status {
                case .unknown:
                    break
                case .waiting:
                    break
                case .exporting:
                    break
                case .completed:
                    guard let compressedData = NSData(contentsOf: compressedURL) else {
                        return
                    }
                    print("File size after compression: \(Double(compressedData.length / 1048576)) mb")
                    DispatchQueue.main.async {
                        if self.statusAddMoreImage == .initial {
                            let obj = customeCameraStoryboard.instantiateViewController(withIdentifier: "PictureLocationVC") as! PictureLocationVC
                            obj.hidesBottomBarWhenPushed = true
                            let dict = ClsPostListPostImage()
                            dict.isUploaded = 0
                            dict.image = thumbnailImage
                            dict.isVideo = 1
                            dict.allData = compressedData as Data
                            dict.videoURL = compressedURL
                            dict.location =  self.pictureLocation
                            arrMainSelectedImage.append(dict)
                            obj.pictureLocation = self.pictureLocation ?? kCurrentUserLocation.coordinate
                            obj.pictureDate = self.pictureDate ?? Date()
                            self.navigationController?.pushViewController(obj, animated: true)
                        } else {
                            let dict = ClsPostListPostImage()
                            dict.isUploaded = 0
                            dict.image = thumbnailImage
                            dict.isVideo = 1
                            dict.allData = compressedData as Data
                            dict.videoURL = compressedURL
                            dict.location =  self.pictureLocation
                            arrMainSelectedImage.append(dict)
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                case .failed:
                    break
                case .cancelled:
                    break
                @unknown default:
                    break
                }
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetHighestQuality) else {
            handler(nil)

            return
        }

        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
}
