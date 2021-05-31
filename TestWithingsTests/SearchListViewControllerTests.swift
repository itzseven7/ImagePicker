//
//  SearchListViewControllerTests.swift
//  TestWithingsTests
//
//  Created by Romain on 31/05/2021.
//

import XCTest
@testable import TestWithings

class SearchListViewControllerTests: XCTestCase {
  
  var sut: SearchListViewController!
  var viewModelMock: SearchListViewModelMock!
  var coordinatorMock: ImageFlowCoordinatorMock!
  
  override func setUpWithError() throws {
    viewModelMock = SearchListViewModelMock()
    coordinatorMock = ImageFlowCoordinatorMock()
    sut = SearchListViewController(viewModel: viewModelMock, coordinator: coordinatorMock)
    
    _ = sut.view
    sut.viewDidLoad()
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testButtonIsHiddenWhenSearchingImages() {
    // When
    viewModelMock.isLoading.send(true)
    
    // Then
    let expected = true
    XCTAssertEqual(sut.goToDetailButton.isHidden, expected, "Button should be hidden when loading")
  }
  
  // MARK:- Navigation
  
  func testCoordinatorIsCalledWhenPressingButton() {
    // When
    sut.goToDetailButton.sendActions(for: .touchUpInside)
    
    // Then
    let expected = true
    XCTAssertEqual(coordinatorMock.showDetailViewIsCalled, expected, "Coordinator should be called when clicking on go to detail button")
  }
  
  func testViewModelIsCalledWhenSelectingImage() {
    // When
    sut.collectionView.delegate?.collectionView?(sut.collectionView, didSelectItemAt: IndexPath(row: 0, section: 0))
    
    // Then
    let expected = true
    XCTAssertEqual(viewModelMock.selectImageIsCalled, expected, "View controller should call view model on image selection")
  }
}
