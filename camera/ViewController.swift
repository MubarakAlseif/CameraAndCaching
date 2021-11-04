//
//  ViewController.swift
//  camera
//
//  Created by Mobark Alseif on 27/03/1443 AH.
//

import UIKit
import PhotosUI

class ViewController: UIViewController {
    
    let imagePicker = UIImagePickerController()
    private let caching = CachingManager()
    @IBOutlet weak var imageProfile: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    // MARK: - Load Image From Caching
    override func viewWillAppear(_ animated: Bool) {
        let image = caching.image(forKey: "url")
        guard let image = image else { return }
        self.imageProfile.image = image
    }
    
    // MARK: - Storyboard Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let detailViewController = segue.destination as! SecondViewController
        detailViewController.caching = caching
        
    }
    // MARK: - Buttons Actions
    
    @IBAction func showSecond(_ sender: UIButton) {
        performSegue(withIdentifier: "Second", sender: nil)
    }
    @IBAction func deleteImageFromCach(_ sender: UIButton) {
        caching.deleteImageFromCach(forKey: "url")
    }
    @IBAction func deleteFromFileSystem(_ sender: UIButton) {
        caching.deleteImageFromFileSystem(forKey: "url")
    }
    @IBAction func choseImage(_ sender: UIButton) {
        //        imagePicker.sourceType = .photoLibrary
        //        present(imagePicker, animated: true, completion: nil)
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 4
        configuration.filter = .images
        let photoPicker = PHPickerViewController(configuration: configuration)
        photoPicker.delegate = self
        present(photoPicker, animated: true, completion: nil)
    }
}

// MARK: - UIImage Picker Controller Delegate

extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate,PHPickerViewControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        dismiss(animated: true, completion: nil)
        let image = info[.originalImage] as! UIImage
        self.caching.setImage(image, forKey: "url")
        self.imageProfile.image = image
        
    }
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true, completion: nil)
        guard !results.isEmpty else { return }
        for result in results {
            
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                    DispatchQueue.main.async {
                        if let image = image as? UIImage {
                            self.caching.setImage(image, forKey: "url")
                            //cache.setObject(image, forKey: NSString(string: "url"))
                            self.imageProfile.image = image
                        }
                    }
                    
                }
            }
        }
        
        
    }
}






//PHPickerViewControllerDelegate



