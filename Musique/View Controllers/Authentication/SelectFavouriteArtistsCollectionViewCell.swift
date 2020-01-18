//
//  SelectFavouriteArtistsCollectionViewCell.swift
//  Musique
//
//  Created by Luís Paulo Serra Ferreira on 17/01/2020.
//  Copyright © 2020 Luís Manuel Martins Campos. All rights reserved.
//

import UIKit

class SelectFavouriteArtistsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var favouriteArtisitsImageView: UIImageView!
    
    @IBOutlet weak var highlightIndicator: UIView!
    @IBOutlet weak var selectIndicator: UIImageView!
    
    override var isHighlighted: Bool {
        didSet {
            highlightIndicator.isHidden = !isHighlighted
        }
    }
    
    override var isSelected: Bool {
        didSet{
            highlightIndicator.isHidden = !isSelected
            selectIndicator.isHidden = !isSelected

        }
    }
}
