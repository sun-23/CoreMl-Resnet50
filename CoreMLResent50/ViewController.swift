//
//  ViewController.swift
//  CoreMLResent50
//
//  Created by sun on 5/5/2562 BE.
//  Copyright © 2562 sun. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {
    
    
    @IBOutlet weak var Answer: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
    }
    
    
    @IBAction func banana(_ sender: UIButton) {
        
        coreMLResNet50(ImgName: "banana")
    }
    
    
    @IBAction func orange(_ sender: UIButton) {
        
        coreMLResNet50(ImgName: "orange")
    }
    

    @IBAction func apple(_ sender: UIButton) {
        
        coreMLResNet50(ImgName: "dog")
    }
    
    
    @IBAction func car(_ sender: UIButton) {
        
        coreMLResNet50(ImgName: "cat")
    }
    
    
    @IBAction func boat(_ sender: UIButton) {
        
        coreMLResNet50(ImgName: "hamster")
    }
    
    
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    func coreMLResNet50(ImgName:String)  {
        
        for v in view.subviews{
            if v is UIImageView {
                v.removeFromSuperview()   // ล้างภาพ
            }
        }
        
        self.Answer.text = ""
        
       let image = UIImage(named: ImgName)
        
        imageView.image =  image
        
        let sceledHeight = view.frame.width / image!.size.width * image!.size.height
        let imageScaledHeight = view.frame.size.width / image!.size.width * image!.size.height
        
        // ให้ภาพอยู่จุดกึ่งกลางของ แกน y
        imageView.frame = CGRect(x: 0, y: view.frame.height - ( view.frame.height / 2 + sceledHeight / 2 ), width: view.frame.width, height: sceledHeight)
        
        imageView.backgroundColor = .black
        
        view.backgroundColor = .black
        
        
        view.addSubview(imageView)
        
        let resnetModel = Resnet50()
        
        // เอา model ใส่ใน VNCoreMLModel /-------------------/
        if let model = try? VNCoreMLModel(for: resnetModel.model) {
            
            let request = VNCoreMLRequest(model: model) { (request, error) in
                
                if let result = request.results as? [VNClassificationObservation] {
                    
                    for classification in result where classification.confidence > 0.5 {
                        
                        print("ID : \(classification.identifier), confidence: \(classification.confidence)")
                        self.Answer.text! = "ID : \(classification.identifier) , Confidence: \(Int((classification.confidence) * 100)) %"
                        
                    }
                    
                }
            }
            
            // Handler request above
            
            if let image = UIImage(named: ImgName){
                
                if let imageData = image.pngData() {
                    let handler = VNImageRequestHandler(data: imageData, options: [:])
                    try? handler.perform([request])
                    
                }
                
            }
            
            
            
        }
        // /-----------------------------------------------------/
        
    }
    
    
}

