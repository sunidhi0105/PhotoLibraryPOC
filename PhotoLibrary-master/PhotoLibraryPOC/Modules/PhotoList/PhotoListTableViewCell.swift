//
//  PhotoListTableViewCell.swift
//  PhotoLibraryPOC
//
//  Created by Sunidhi Gupta on 03/08/18.
//

import UIKit
import AlamofireImage

class PhotoListTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addConstrainsInView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: Public Methods
    
    /*
     This method is used to configure photo list table view cell.
     */
    func configurePhotoListCell(photoDetailDic: [String: Any]) {
        titleLabel.text = ""
        descriptionLabel.text = ""

        if let title = photoDetailDic["title"] as? String {
            titleLabel.text = title
        }
        
        if let description = photoDetailDic["description"] as? String {
            descriptionLabel.text = description
        }
        
        if let imageStr = photoDetailDic["imageHref"] as? String, let url = URL(string: imageStr) {
            photoImageView.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "Unknown"), filter: nil, progress: nil, completion: nil)
        } else {
            photoImageView.image = #imageLiteral(resourceName: "Unknown")
        }
    }
    
    /*
        Method is used to add constraint in views
    */
    func addConstrainsInView() {
        let margins = contentView.layoutMarginsGuide
        
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 10).isActive = true
        photoImageView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 10).isActive = true
        photoImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        photoImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 10).isActive = true
        titleLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: 10).isActive = true
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 10).isActive = true

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 10).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 10).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        
        descriptionLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0).isActive = true
        
        let heightConstraint: NSLayoutConstraint = descriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30)
        heightConstraint.isActive = true
    }
}
