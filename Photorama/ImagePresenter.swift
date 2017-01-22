//
// Created by Qiao Zhang on 1/15/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import Foundation
import UIKit.UIImage

protocol ImagePresenterOutput: class {
  func showImage(_ image: UIImage)
}

class ImagePresenter: ImageDataInteractorOutput {
  
  unowned let output: ImagePresenterOutput

  init(output: ImagePresenterOutput) {
    self.output = output
  }

  func imageDataFetched(_ imageData: Data?) {
    let image: UIImage
    if let data = imageData, let temp = UIImage(data: data) {
      image = temp
    } else {
      image = #imageLiteral(resourceName: "dowloadImageFailed")
    }
    
    OperationQueue.main.addOperation{ [weak self] in
      self?.output.showImage(image)
    }
  }

}
