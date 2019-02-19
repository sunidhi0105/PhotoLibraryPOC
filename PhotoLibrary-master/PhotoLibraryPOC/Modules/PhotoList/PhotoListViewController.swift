//
//  PhotoListViewController.swift
//  PhotoLibraryPOC
//
//  Created by Sunidhi Gupta on 03/08/18.
//

import UIKit
import Alamofire

class PhotoListViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var photoListTableView: UITableView!
    
    // MARK: Variables
    var photoListArray = [[String: Any]]()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(PhotoListViewController.getPhotoList),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    // MARK: View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getPhotoList()
        self.setUpView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     This method is used to set up view.
     */
    private func setUpView() {
        self.photoListTableView.rowHeight = UITableViewAutomaticDimension
        self.photoListTableView.estimatedRowHeight = 100.0
        self.photoListTableView.tableFooterView = UIView()
        
        self.photoListTableView.addSubview(self.refreshControl)
    }
}

// MARK: UITableView Delegate/DataSource
extension PhotoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let photoListCell = self.photoListTableView.dequeueReusableCell(withIdentifier: "PhotoListCell") as? PhotoListTableViewCell else {
            return UITableViewCell()
        }
        photoListCell.configurePhotoListCell(photoDetailDic: photoListArray[indexPath.row])
        return photoListCell
    }
}

// MARK: Web Service Call
extension PhotoListViewController {
    /*
     This method is used to get photo list from the server
    */
    @objc func getPhotoList() {
        if Utilities.isConnectedToNetwork() {
            Alamofire.request(kPhotoListURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseData { [weak self] (responseData) in
                switch responseData.result {
                case .success:
                    self?.refreshControl.endRefreshing()
                    //converting to latin as containing the special characters which if failing in json conversion
                    guard let data = responseData.data, let response: String = String(data: data, encoding: String.Encoding.isoLatin1) else {
                        return
                    }
                    guard let utf8Data = response.data(using: String.Encoding.utf8) else {
                        return
                    }
                    
                    do {
                        guard let getResponse = try JSONSerialization.jsonObject(with: utf8Data, options: .allowFragments) as? [String: Any] else {
                            return
                        }
                        guard let arrPhotoList = getResponse["rows"] as? [[String: Any]] else {
                            return
                        }
                        self?.navigationItem.title = getResponse["title"] as? String ?? "Photo Library"
                        self?.photoListArray = arrPhotoList
                        DispatchQueue.main.async {
                            self?.photoListTableView.reloadData()
                        }
                    } catch {
                        print("error serializing JSON: \(error)")
                    }
                case .failure( _):
                    self?.refreshControl.endRefreshing()
                    Utilities.showAlertWithTitle(AppName, message: FailedToGetData, controller: self!)
                }
            }
        } else {
            Utilities.showAlertWithTitle(AppName, message: NoNetwork, controller: self)
        }
    }
}
