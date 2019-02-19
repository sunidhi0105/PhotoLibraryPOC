//
//  PhotoLibraryPOCTests.swift
//  PhotoLibraryPOCTests
//
//  Created by Sunidhi Gupta on 03/08/18.
//

import XCTest
import Alamofire

@testable import PhotoLibraryPOC

class PhotoLibraryPOCTests: XCTestCase {
    
    var photoListController: PhotoListViewController?

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle:nil)
        if let photoListVC = storyboard.instantiateViewController(withIdentifier: "PhotoListViewController") as? PhotoListViewController {
            photoListController = photoListVC
            _ = photoListVC.view
            photoListVC.viewDidLoad()
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testConformsDataSourceAndDelegate() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        if let photoListVC = photoListController {
            XCTAssertNotNil(photoListVC, "Storyboard is not connected with a PhotoListViewController")
            
            XCTAssert(photoListVC.conforms(to: UITableViewDataSource.self), "does not conform to this protocol")
            XCTAssert(photoListVC.responds(to: #selector(UITableViewDataSource.tableView(_:numberOfRowsInSection:))), "does not respond to this selector")
            XCTAssert(photoListVC.responds(to: #selector(UITableViewDataSource.tableView(_:cellForRowAt:))), "does not respond to this selector")
            XCTAssert(photoListVC.conforms(to: UITableViewDelegate.self), "does not conform to this protocol")
        }
    }
    
    func testIbOutlets() {
        if let photoListVC = photoListController {
            XCTAssertNotNil(photoListVC.photoListTableView, "table outlet is not connected")
        }
    }
    
    func testAPI() {
        let expectation = self.expectation(description: "\(#function)")
        Alamofire.request(kPhotoListURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseData { (responseData) in
            expectation.fulfill()
            switch responseData.result {
            case .success:
                //converting to latin as containing the special characters which if failing in json conversion
                
                guard let data = responseData.data, let response: String = String(data: data, encoding: String.Encoding.isoLatin1) else {
                    assertionFailure("Flight notes test setup failed.")
                    return
                }
                guard let utf8Data = response.data(using: String.Encoding.utf8) else {
                    assertionFailure("UTF8 conversion failed.")
                    return
                }
                
                do {
                    guard let getResponse = try JSONSerialization.jsonObject(with: utf8Data, options: .allowFragments) as? [String: Any] else {
                        assertionFailure("Json conversion failed.")
                        return
                    }
                    guard let arrPhotoList = getResponse["rows"] as? [[String: Any]] else {
                        assertionFailure("failed to setup data.")
                        return
                    }
                    XCTAssertTrue(arrPhotoList.count > 0, "Empty data")
                } catch {
                    print("error serializing JSON: \(error)")
                }
            case .failure( _):
                print("Failed")
            }
        }
        
        self.waitForExpectations(timeout: 20) { (error) -> Void in
            XCTAssertNil(error, "\(error.debugDescription)")
        }
    }
}
