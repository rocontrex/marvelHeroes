//
//  DetailsViewController.swift
//  marvelHeroes
//
//  Created by Rodrigo Conte on 01/02/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import NVActivityIndicatorView

protocol DetailsDisplayLogic: AnyObject {
    func displayCharacter(viewModel: Details.Character.ViewModel)
    func displayImage(viewModel: Details.GetImage.ViewModel)
    func displayDatabaseSuccess()
    func displayError(_ error: Details.Error)
}

class DetailsViewController: UIViewController {
    
    var interactor: DetailsBusinessLogic?
    var router: (NSObjectProtocol & DetailsRoutingLogic & DetailsDataPassing)?
    
    // MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: Variables
    var error: Details.Error?
    var viewModel: Details.Character.ViewModel?
    
    // MARK: Computed Propierties
    
    var starButtonIsFavorited: Bool = false {
        didSet {
            if starButtonIsFavorited {
                let image = UIImage(named: "full-star")
                starButton.setImage(image, for: .normal)
            } else {
                let image = UIImage(named: "empty-star")
                starButton.setImage(image, for: .normal)
            }
        }
    }
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let bundle = Bundle(for: type(of: self))
        super.init(nibName: nibNameOrNil, bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.requestCharacter()
    }
    
    // MARK: Private Functions
    
    private func requestImage() {
        LoadingView.show(view: view)
        interactor?.requestImage()
    }
    
    private func saveOrRemoveCharacterFromFavorite() {
        if starButtonIsFavorited {
            interactor?.removeCharacterFromFavorite()
        } else {
            interactor?.saveCharacterInFavorite()
        }
    }
    
    func showAlertView(forError error: Details.Error) {
        let alertView = AlertView(frame: view.frame)
        alertView.message = error.message
        alertView.buttonTitle = "Tentar novamente"
        alertView.delegate = self
        view.addSubview(alertView)
    }
    
    // MARK: IB Actions
    
    @IBAction func didTouchStarButton(_ sender: Any) {
        saveOrRemoveCharacterFromFavorite()
    }
}

// MARK: Display Logic

extension DetailsViewController: DetailsDisplayLogic {
    
    func displayCharacter(viewModel: Details.Character.ViewModel) {
        title = viewModel.name
        nameLabel.text = viewModel.name
        descriptionLabel.text = viewModel.description
        starButtonIsFavorited = viewModel.isFavorited
    }
    
    func displayImage(viewModel: Details.GetImage.ViewModel) {
        LoadingView.dismiss()
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.image = viewModel.image
    }
    
    func displayDatabaseSuccess() {
        starButtonIsFavorited.toggle()
    }
    
    func displayError(_ error: Details.Error) {
        LoadingView.dismiss()
        self.error = error
        showAlertView(forError: error)
    }
}

// MARK: AlertView Delegate

extension DetailsViewController: AlertViewDelegate {
    func alertView(_ alertView: AlertView, didTouchButton button: UIButton) {
        guard let error = error else { return }
        switch error {
        case .unexpectedError:
            navigationController?.popViewController(animated: true)
        case .database:
            saveOrRemoveCharacterFromFavorite()
        case .notConnectedToInternet:
            requestImage()
        }
        self.error = nil
        alertView.removeFromSuperview()
    }
}
