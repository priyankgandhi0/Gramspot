//
//  PhotoFilterVC.swift
//  GemSpot
//
//  Created by Jaydeep on 24/04/20.
//  Copyright © 2020 Jaydeep. All rights reserved.
//

import UIKit
import CoreImage
import CropViewController
import CoreLocation
import FMPhotoPicker

class PhotoFilterVC: UIViewController {
    
    //MARK:- Variable Declaration
    
//    var brighnessValue = Float()
//    var contrastValue : Float = 1.0
//    var selectedImg = UIImage()
    var aCIImage = CIImage()
    var contrastFilter: CIFilter!
    var brightnessFilter: CIFilter!
    var context = CIContext()
    var outputImage = CIImage()
    var newUIImage = UIImage()
    private var image: UIImage?
    private var croppingStyle = CropViewCroppingStyle.default
    
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    var pictureDate = Date()
    var pictureLocation = CLLocationCoordinate2D()
    var arrSelectedImage = [ClsPostListPostImage]()
    var selectedIndex = Int()
//    var arrBrightnessValue = [Float]()
//    var arrContrastValue = [Float]()
    var statusAddMoreImage = checkAddMore.initial
    
    //MARK:- Outlet Zone
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionOfImage: UICollectionView!
//    @IBOutlet weak var imgSelectedPhoto: UIImageView!
    @IBOutlet weak var sliderBrightnessContrast: UISlider!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var btnBrightnessOutlet: UIButton!
    @IBOutlet weak var btnContrastOutlet: UIButton!
    @IBOutlet weak var viewFilter: UIView!
    
    //MARK:- ViewLife Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        /*self.imgSelectedPhoto.image = selectedImg
        
        let aUIImage = imgSelectedPhoto.image
        let aCGImage = aUIImage?.cgImage
        aCIImage = CIImage(cgImage: aCGImage!)
        context = CIContext(options: nil)
        contrastFilter = CIFilter(name: "CIColorControls")
        contrastFilter.setValue(aCIImage, forKey: "inputImage")
        brightnessFilter = CIFilter(name: "CIColorControls")
        brightnessFilter.setValue(aCIImage, forKey: "inputImage")*/
        pageControl.numberOfPages = arrSelectedImage.count
        
        for i in 0..<arrSelectedImage.count {
            let dict = arrSelectedImage[i]
            dict.brightnessValue = 0.0
            dict.contrastValue = 1.0
            arrSelectedImage[i] = dict
        }
        
        self.collectionOfImage.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setupImageInitial(image:UIImage) {
        let aUIImage = image
        let aCGImage = aUIImage.cgImage
        aCIImage = CIImage(cgImage: aCGImage!)
        context = CIContext(options: nil)
        contrastFilter = CIFilter(name: "CIColorControls")
        contrastFilter.setValue(aCIImage, forKey: "inputImage")
        brightnessFilter = CIFilter(name: "CIColorControls")
        brightnessFilter.setValue(aCIImage, forKey: "inputImage")
    }
}

//MARK:- Action Zobe

extension PhotoFilterVC {
    
    @IBAction func btnCropAction(_ sender:UIButton) {
        configureCropViewController(image: arrSelectedImage[selectedIndex].originalImage)
    }
    
    @IBAction func btnRotateAction(_ sender:UIButton) {
        if let cell = collectionOfImage.cellForItem(at: IndexPath(item: selectedIndex, section: 0)) as? ImageFilterCell {
            let image = cell.imgFilter.image
            cell.imgFilter.image = image?.rotate(radians: .pi/2)
            arrSelectedImage[selectedIndex].image = cell.imgFilter.image
            arrSelectedImage[selectedIndex].originalImage = cell.imgFilter.image
        }
    }
    
    @IBAction func btnBrighnessAction(_ sender:UIButton) {
        setupImageInitial(image: arrSelectedImage[selectedIndex].image)
        sender.isSelected = !sender.isSelected
        btnContrastOutlet.isSelected = false
        self.sliderBrightnessContrast.value =  arrSelectedImage[selectedIndex].brightnessValue
        self.lblTitle.text = "Brightness"
        self.lblValue.text = "\(Int(arrSelectedImage[selectedIndex].brightnessValue*100))%"
        if sender.isSelected {
            viewFilter.isHidden = false
        } else {
            viewFilter.isHidden = true
        }
    }
    
    @IBAction func btnContrastAction(_ sender:UIButton) {
        setupImageInitial(image: arrSelectedImage[selectedIndex].image)
        sender.isSelected = !sender.isSelected
        btnBrightnessOutlet.isSelected = false
        self.sliderBrightnessContrast.value = arrSelectedImage[selectedIndex].contrastValue
        self.lblTitle.text = "Contrast"
        self.lblValue.text = "\(Int(arrSelectedImage[selectedIndex].contrastValue*100))%"
        if sender.isSelected {
            viewFilter.isHidden = false
        } else {
            viewFilter.isHidden = true
        }
    }
    
    @IBAction func btnCloseAction(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDoneAction(_ sender:UIButton) {
        if statusAddMoreImage == .initial {
            arrMainSelectedImage.removeAll()
        }
        for i in 0..<arrSelectedImage.count {
            let dict = arrSelectedImage[i]
            let img = dict.image
            let data = img?.jpegData(compressionQuality: 0.7)
            dict.allData = data
            arrMainSelectedImage.append(dict)
        }
        if statusAddMoreImage == .initial {
            let obj = customeCameraStoryboard.instantiateViewController(withIdentifier: "PictureLocationVC") as! PictureLocationVC
            obj.selectType = .photo
            obj.pictureLocation = pictureLocation
            obj.pictureDate = pictureDate
            self.navigationController?.pushViewController(obj, animated: true)
        } else {
            self.navigationController?.backToViewController(vc: PhotoDetailVC.self)
        }
        
    }
    
    @IBAction func btnApplyFilterAction(_ sender:UIButton) {
        let vc = FMImageEditorViewController(config: config(), sourceImage: arrSelectedImage[selectedIndex].image)
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    @IBAction func sliderValueChanged(_ sender:UISlider) {
        print("value \(Int(sender.value*100))")
        self.lblValue.text = "\(Int(sender.value*100))%"
        if self.btnBrightnessOutlet.isSelected {
            arrSelectedImage[selectedIndex].brightnessValue = sender.value
            if let cell = collectionOfImage.cellForItem(at: IndexPath(item: selectedIndex, section: 0)) as? ImageFilterCell {
                cell.imgFilter.image = imageForBrightness(sender,cell.imgFilter.image!)
                arrSelectedImage[selectedIndex].image = cell.imgFilter.image
                arrSelectedImage[selectedIndex].originalImage = cell.imgFilter.image
            }
        } else {
            arrSelectedImage[selectedIndex].contrastValue = sender.value
            if let cell = collectionOfImage.cellForItem(at: IndexPath(item: selectedIndex, section: 0)) as? ImageFilterCell {
                cell.imgFilter.image = imageForContrast(sender,cell.imgFilter.image!)
                arrSelectedImage[selectedIndex].image = cell.imgFilter.image
                arrSelectedImage[selectedIndex].originalImage = cell.imgFilter.image
            }
        }
    }
    
    func imageForContrast(_ sender:UISlider,_ image:UIImage) -> UIImage {
        contrastFilter.setValue(NSNumber(value: sender.value), forKey: "inputContrast")
        outputImage = contrastFilter.outputImage!
        let cgimg = context.createCGImage(outputImage, from: outputImage.extent)
        newUIImage = UIImage(cgImage: cgimg!, scale: image.scale, orientation: image.imageOrientation)
        return newUIImage
    }
    
    func imageForBrightness(_ sender:UISlider,_ image:UIImage) -> UIImage {
        brightnessFilter.setValue(NSNumber(value: sender.value), forKey: "inputBrightness")
        outputImage = brightnessFilter.outputImage!;
        let imageRef = context.createCGImage(outputImage, from: outputImage.extent)
        newUIImage = UIImage(cgImage: imageRef!, scale: image.scale, orientation: image.imageOrientation)
        return newUIImage
    }
    
    func config() -> FMPhotoPickerConfig {
        let selectMode: FMSelectMode = .single
  
        var config = FMPhotoPickerConfig()
        
        config.selectMode = selectMode
        config.mediaTypes = [.image]
        config.maxImage = 0
        config.maxVideo = 0
        config.forceCropEnabled = false
        config.eclipsePreviewEnabled = false
        
        // in force crop mode, only the first crop option is available
        /*config.availableCrops = [
            FMCrop.ratioSquare,
            FMCrop.ratioCustom,
            FMCrop.ratio4x3,
            FMCrop.ratio16x9,
            FMCrop.ratio9x16,
            FMCrop.ratioOrigin,
        ]*/
        config.availableCrops = nil
        
        // all available filters will be used
        config.availableFilters = []
        
        return config
    }
}

//MARK:- Filter Delegate Method

extension PhotoFilterVC:FMPhotoPickerViewControllerDelegate, FMImageEditorViewControllerDelegate {
    func fmImageEditorViewController(_ editor: FMImageEditorViewController, didFinishEdittingPhotoWith photo: UIImage) {
        self.dismiss(animated: true, completion: nil)
        arrSelectedImage[selectedIndex].image = photo
        arrSelectedImage[selectedIndex].originalImage = photo
        collectionOfImage.reloadItems(at: [IndexPath(row: selectedIndex, section: 0)])
    }
    
    func fmPhotoPickerController(_ picker: FMPhotoPickerViewController, didFinishPickingPhotoWith photos: [UIImage]) {
        self.dismiss(animated: true, completion: nil)
    }
}


//MARK:- UICollectionView Delegate Method

extension PhotoFilterVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSelectedImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageFilterCell", for: indexPath) as! ImageFilterCell
        /*let dict = arrSelectedImage.object(at: indexPath.row) as! NSMutableDictionary
        if let img = dict.value(forKey: "image") as? UIImage {
            cell.imgFilter.image = img
        }*/
        cell.imgFilter.image = arrSelectedImage[indexPath.row].image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        selectedIndex = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        pageControl.currentPage = selectedIndex
        /*let dict = arrSelectedImage.object(at: selectedIndex) as! NSMutableDictionary
        guard let image = dict.value(forKey: "image") as? UIImage else {
            return
        }*/
        setupImageInitial(image: arrSelectedImage[selectedIndex].image)
        viewFilter.isHidden = true
        btnBrightnessOutlet.isSelected = false
        btnContrastOutlet.isSelected = false
    }
    
}

//MARK:- Crop

extension PhotoFilterVC:CropViewControllerDelegate {
    
    func configureCropViewController(image:UIImage) {
        let cropController = CropViewController(croppingStyle: croppingStyle, image: image)
        cropController.modalPresentationStyle = .fullScreen
        cropController.delegate = self
        
        // Uncomment this if you wish to provide extra instructions via a title label
        //cropController.title = "Crop Image"
        
        // -- Uncomment these if you want to test out restoring to a previous crop setting --
        //cropController.angle = 90 // The initial angle in which the image will be rotated
        //cropController.imageCropFrame = CGRect(x: 0, y: 0, width: 2848, height: 4288) //The initial frame that the crop controller will have visible.
        
        // -- Uncomment the following lines of code to test out the aspect ratio features --
        cropController.aspectRatioPreset = .presetSquare; //Set the initial aspect ratio as a square
        cropController.aspectRatioLockEnabled = true // The crop box is locked to the aspect ratio and can't be resized away from it
        //cropController.resetAspectRatioEnabled = false // When tapping 'reset', the aspect ratio will NOT be reset back to default
        cropController.aspectRatioPickerButtonHidden = true
        
        // -- Uncomment this line of code to place the toolbar at the top of the view controller --
        cropController.toolbarPosition = .top
        
        cropController.rotateButtonsHidden = true
        cropController.rotateClockwiseButtonHidden = true
        
        cropController.toolbar.doneTextButton.titleLabel?.font = themeFont(size: 14, fontname: .regular)
        cropController.toolbar.doneTextButton.setTitleColor(.white, for: .normal)
        
        cropController.toolbar.cancelTextButton.titleLabel?.font = themeFont(size: 14, fontname: .regular)
        cropController.toolbar.cancelTextButton.setTitleColor(.white, for: .normal)
        
        //cropController.toolbar.doneButtonHidden = true
        //cropController.toolbar.cancelButtonHidden = true
        //cropController.toolbar.clampButtonHidden = true
       
        
        //If profile picture, push onto the same navigation stack
        
            
        self.present(cropController, animated: true, completion: nil)
                //self.navigationController!.pushViewController(cropController, animated: true)
            
        
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    
    public func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
        
//        arrSelectedImage[selectedIndex] = image
        /*if let dict = arrSelectedImage.object(at: selectedIndex) as? NSMutableDictionary {
            dict.setValue(image, forKey: "image")
            arrSelectedImage.replaceObject(at: selectedIndex, with: dict)
        }*/
        arrSelectedImage[selectedIndex].image = image
        collectionOfImage.reloadItems(at: [IndexPath(row: selectedIndex, section: 0)])
        
        cropViewController.dismiss(animated: true, completion: nil)
        /*imgSelectedPhoto.image = image
        layoutImageView()
        
        self.navigationItem.leftBarButtonItem?.isEnabled = true
        
        if cropViewController.croppingStyle != .circular {
            imgSelectedPhoto.isHidden = true
            
            cropViewController.dismissAnimatedFrom(self, withCroppedImage: image,
                                                   toView: imgSelectedPhoto,
                                                   toFrame: CGRect.zero,
                                                   setup: { self.layoutImageView() },
                                                   completion: {
                                                    self.imgSelectedPhoto.isHidden = false })
        }
        else {
            self.imgSelectedPhoto.isHidden = false
            cropViewController.dismiss(animated: true, completion: nil)
        }*/
    }
    
    /*public func layoutImageView() {
        guard imgSelectedPhoto.image != nil else { return }
        
        let padding: CGFloat = 20.0
        
        var viewFrame = self.view.bounds
        viewFrame.size.width -= (padding * 2.0)
        viewFrame.size.height -= ((padding * 2.0))
        
        var imageFrame = CGRect.zero
        imageFrame.size = imgSelectedPhoto.image!.size;
        
        if imgSelectedPhoto.image!.size.width > viewFrame.size.width || imgSelectedPhoto.image!.size.height > viewFrame.size.height {
            let scale = min(viewFrame.size.width / imageFrame.size.width, viewFrame.size.height / imageFrame.size.height)
            imageFrame.size.width *= scale
            imageFrame.size.height *= scale
            imageFrame.origin.x = (self.view.bounds.size.width - imageFrame.size.width) * 0.5
            imageFrame.origin.y = (self.view.bounds.size.height - imageFrame.size.height) * 0.5
            imgSelectedPhoto.frame = imageFrame
        }
        else {
            self.imgSelectedPhoto.frame = imageFrame;
            self.imgSelectedPhoto.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        }
    }*/
}


