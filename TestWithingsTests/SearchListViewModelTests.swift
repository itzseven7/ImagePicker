//
//  SearchListViewModelTests.swift
//  TestWithingsTests
//
//  Created by Romain on 31/05/2021.
//

import XCTest
@testable import TestWithings

class SearchListViewModelTests: XCTestCase {
  
  var sut: SearchListViewModel!
  var workerMock: ImageWorkerMock!
  
  override func setUpWithError() throws {
    workerMock = ImageWorkerMock()
    sut = SearchListViewModel(worker: workerMock)
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testViewModelPrepareKeywordsForQuery() {
    // When
    let result = sut.prepareKeywordsForQuery("yellow,bird")
    
    // Then
    let expected = "yellow+bird"
    XCTAssertEqual(result, expected, "View model should replace separators with + symbol")
  }
  
  func testViewModelSelectsImage() throws {
    // Given
    let imageViewModel = try SearchListImageItemViewModel(image: ImageModelMock())
    sut.previews = [imageViewModel!]
    
    // When
    sut.selectImage(at: IndexPath(row: 0, section: 0))
    
    // Then
    let expected = true
    XCTAssertEqual(imageViewModel!.selected, expected, "View model should select image")
  }
  
  func testViewModelUnselectsImage() throws {
    // Given
    let imageViewModel = try SearchListImageItemViewModel(image: ImageModelMock())
    imageViewModel?.selected = true
    sut.previews = [imageViewModel!]
    
    // When
    sut.selectImage(at: IndexPath(row: 0, section: 0))
    
    // Then
    let expected = false
    XCTAssertEqual(imageViewModel!.selected, expected, "View model should unselect image")
  }
  
  func testViewModelOnlyReturnsSelectedImages() throws {
    // Given
    let firstImageViewModel = try SearchListImageItemViewModel(image: ImageModelMock())
    firstImageViewModel?.selected = true
    let secondImageViewModel = try SearchListImageItemViewModel(image: ImageModelMock())
    secondImageViewModel?.selected = true
    let thirdImageViewModel = try SearchListImageItemViewModel(image: ImageModelMock())
    thirdImageViewModel?.selected = false
    sut.previews = [firstImageViewModel!, secondImageViewModel!, thirdImageViewModel!]
    
    // When
    let results = sut.getSelectedImages()
    
    // Then
    let expected = 2
    XCTAssertEqual(results.count, expected, "View model shoudl return \(expected) selected images")
  }
}
