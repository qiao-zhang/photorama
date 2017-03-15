//
// Created by Qiao Zhang on 3/14/17.
// Copyright (c) 2017 Qiao Zhang. All rights reserved.
//

import UIKit

class PhotoGridDataSource: NSObject, UICollectionViewDataSource {
  
  var photoGridItems: [PhotoGridItem]?
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return photoGridItems?.count ?? 0
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: "PhotoGridCell",
      for: indexPath) as! PhotoGridCell
    return cell
  }

}
