//
//  SearchListViewController.swift
//  TestWithings
//
//  Created by Romain on 31/05/2021.
//

import UIKit
import Stevia
import Combine

class SearchListViewController: ViewController {
  
  let titleLabel = UILabel()
  let keywordsTextField = UITextField()
  let validateButton = UIButton()
  let goToDetailButton = UIButton()
  
  let activityIndicatorView: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView(style: .medium)
    indicator.color = .blue
    indicator.hidesWhenStopped = true
    return indicator
  }()
  
  let stackView: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.distribution = .fill
    stack.alignment = .center
    return stack
  }()
  
  let collectionViewLayout = UICollectionViewFlowLayout()
  let collectionView: UICollectionView!
  
  let viewModel: SearchListViewModelProtocol
  let coordinator: ImageFlowCoordinable
  
  var cancellables = Set<AnyCancellable>()
  
  init(viewModel: SearchListViewModelProtocol = SearchListViewModel(), coordinator: ImageFlowCoordinable) {
    self.viewModel = viewModel
    self.coordinator = coordinator
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Search"
    
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(SearchListImageItemViewCell.self, forCellWithReuseIdentifier: SearchListImageItemViewCell.cellReuseIdentifier)
    
    titleLabel.text = "Keywords (separator = ,)"
    
    validateButton.setTitle("Search", for: .normal)
    validateButton.setStyle(.primary)
    validateButton.addTarget(self, action: #selector(searchButtonAction), for: .touchUpInside)
    
    goToDetailButton.setTitle("Go to details", for: .normal)
    goToDetailButton.setStyle(.primary)
    goToDetailButton.addTarget(self, action: #selector(goToDetailsButtonAction), for: .touchUpInside)
    goToDetailButton.isHidden = true
    
    keywordsTextField.layer.cornerRadius = 16
    keywordsTextField.layer.masksToBounds = true
    keywordsTextField.layer.borderWidth = 0.5
    keywordsTextField.layer.borderColor = UIColor.black.cgColor
    
    viewModel.isLoading
      .receive(on: DispatchQueue.main)
      .sink(receiveValue: { [weak self] loading in
        if loading {
          self?.activityIndicatorView.startAnimating()
        } else {
          self?.activityIndicatorView.stopAnimating()
        }
      })
      .store(in: &cancellables)
    
    viewModel.isLoading
      .receive(on: DispatchQueue.main)
      .assign(to: \.isHidden, on: goToDetailButton)
      .store(in: &cancellables)
  }
  
  override func prepareSubviews() {
    let searchStackView = UIStackView()
    searchStackView.spacing = 9
    searchStackView.axis = .horizontal
    searchStackView.distribution = .fillEqually
    searchStackView.alignment = .center
    
    searchStackView.addArrangedSubview(titleLabel)
    searchStackView.addArrangedSubview(keywordsTextField)
    
    stackView.addArrangedSubview(searchStackView)
    stackView.addArrangedSubview(validateButton)
    
    view.sv(stackView, collectionView, goToDetailButton, activityIndicatorView)
  }
  
  override func setConstraints() {
    keywordsTextField.height(30)
    
    stackView.Top == view.safeAreaLayoutGuide.Top + 18
    stackView.fillHorizontally(m: 24)
    
    collectionView.Top == stackView.Bottom + 18
    collectionView.fillHorizontally(m: 6)
    collectionView.Bottom == goToDetailButton.Top - 18
    
    goToDetailButton.height(54)
    goToDetailButton.fillHorizontally(m: 24)
    goToDetailButton.Bottom == view.safeAreaLayoutGuide.Bottom - 18
    
    activityIndicatorView.width(24).height(24)
    activityIndicatorView.CenterX == goToDetailButton.CenterX
    activityIndicatorView.CenterY == goToDetailButton.CenterY
  }
  
  @objc
  func searchButtonAction() {
    guard let text = keywordsTextField.text else { return }
    
    keywordsTextField.resignFirstResponder()
    
    viewModel.searchImages(with: text)
      .sink { [weak self] completion in
        switch completion {
        case .finished:
          self?.collectionView.reloadData()
        case .failure(_):
          self?.presentPopUpForError()
        }
      } receiveValue: { _ in }
      .store(in: &cancellables)
  }
  
  @objc
  func goToDetailsButtonAction() {
    coordinator.showDetailView(for: viewModel.getSelectedImages())
  }
  
  func presentPopUpForError() {
    
  }
}

extension SearchListViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.previews.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchListImageItemViewCell.cellReuseIdentifier, for: indexPath) as? SearchListImageItemViewCell else {
      preconditionFailure("Cell must have SearchListImageItemViewCell type")
    }
    
    let imageViewModel = viewModel.previews[indexPath.row]
    cell.imageView.image = imageViewModel.displayedImage
    cell.width = CGFloat(imageViewModel.image.imageWidth)
    cell.height = CGFloat(imageViewModel.image.imageHeight)
    
    imageViewModel.selectedPublisher
      .map { !$0 }
      .assign(to: \.isHidden, on: cell.checkedImageContainerView)
      .store(in: &cancellables)
    
    return cell
  }
}

extension SearchListViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    viewModel.selectImage(at: indexPath)
  }
}

extension SearchListViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 90, height: 90)
  }
}
