//
// Created by Qiao Zhang on 2/15/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import UIKit

class Assembler {
  
  static let appDelegate =
    UIApplication.shared.delegate as! AppDelegate
  static let photoManager = appDelegate.photoManager!
  static let imageDataManager = appDelegate.imageDataManager!
  
  static func wireUp(_ photoCategoryList: PhotoCategoryList) {
    let presenter = PhotoCategoryListPresenter(
      categoryList: photoCategoryList,
      photoManager: photoManager)
    photoCategoryList.handler = presenter
  }
  
  static func wireUp(_ photoList: PhotoList,
                     with categoryName: String) {
    let presenter = PhotoListPresenterImp(
      photoList: photoList,
      photoManager: photoManager,
      categoryName: categoryName)
    photoList.presenter = presenter
  }
  
  static func assemble(_ photoImageView: PhotoImageView,
                       with imageURL: URL) {
    let presenter = PhotoImageViewPresenterImp(
      view: photoImageView,
      imageDataManager: imageDataManager,
      imageURL: imageURL)
    photoImageView.presenter = presenter
  }
  
  static func assemble(_ photoGrid: PhotoGrid,
                       with categoryName: String) {
    let presenter = PhotoGridPresenterImp(
      view: photoGrid,
      photoManager: photoManager,
      categoryName: categoryName)
    photoGrid.presenter = presenter
  }
}

class Router {
  
  static let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
  
  static func showPhotoListFrom(_ vc: UIViewController,
                                with categoryName: String) {
    let pl = mainStoryBoard.instantiateViewController(
      withIdentifier: "PhotoList")
    Assembler.wireUp(pl as! PhotoList, with: categoryName)
    vc.show(pl, sender: nil)
  }
  
  static func showPhotoImageViewFrom(_ vc: UIViewController,
                                     with imageURL: URL) {
    let piv = mainStoryBoard.instantiateViewController(
      withIdentifier: "PhotoImageView")
    Assembler.assemble(piv as! PhotoImageView, with: imageURL)
    vc.show(piv, sender: nil)
  }
  
  static func showPhotoGridFrom(_ vc: UIViewController,
                                with categoryName: String) {
    let pg = mainStoryBoard.instantiateViewController(
      withIdentifier: "PhotoGrid")
    Assembler.assemble(pg as! PhotoGrid, with: categoryName)
    vc.show(pg, sender: nil)
  }
}
