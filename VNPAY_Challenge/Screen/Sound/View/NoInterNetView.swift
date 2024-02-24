//
//  NoDataView.swift
//  VNPAY_Challenge
//
//  Created by lê thạch on 24/02/2024.
//

import UIKit

protocol NoInternetViewDelegate: AnyObject {
    func noInternetViewDidTapTryAgainTapable(_ view: NoInternetView)
}

class NoInternetView: UIView {
    var thumbnailImage = UIImage(named: "ic_no_internet") {
        didSet {
            self.thumbnailImageView.image = thumbnailImage
        }
    }

    var titleString = "No internet" {
        didSet {
            self.titleLabel.text = titleString
        }
    }

    var descriptionString = "Please check your internet connection \nand try again" {
        didSet {
            self.descriptionLabel.text = descriptionString
        }
    }

    private var thumbnailImageView: UIImageView!
    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var tryAgainTapableView: TapableView!
    private var contentView: UIView!

    weak var delegate: NoInternetViewDelegate?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.config()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.config()
    }

    // MARK: - Config
    private func config() {
        self.configContentView()
        self.configThumbnailImageView()
        self.configTitleLabel()
        self.configDescriptionLabel()
        self.configTryAgainTapableView()
    }

    private func configContentView() {
        self.contentView = UIView()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.backgroundColor = .clear
        self.addSubview(self.contentView)

        NSLayoutConstraint.activate([
            self.contentView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.contentView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

    private func configThumbnailImageView() {
        self.thumbnailImageView = UIImageView(image: self.thumbnailImage)
        self.thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.thumbnailImageView)

        NSLayoutConstraint.activate([
            self.thumbnailImageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.thumbnailImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.thumbnailImageView.widthAnchor.constraint(equalToConstant: 96),
            self.thumbnailImageView.heightAnchor.constraint(equalToConstant: 96)
        ])
    }

    private func configTitleLabel() {
        self.titleLabel = UILabel()
        self.titleLabel.text = self.titleString
        self.titleLabel.font = Montserrat.extraBoldFont(size: 23)
        self.titleLabel.textColor = UIColor(rgb: 0x444444)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.titleLabel)

        NSLayoutConstraint.activate([
            self.titleLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.titleLabel.topAnchor.constraint(equalTo: self.thumbnailImageView.bottomAnchor, constant: 8)
        ])
    }

    private func configDescriptionLabel() {
        self.descriptionLabel = UILabel()
        self.descriptionLabel.text = self.descriptionString
        self.descriptionLabel.font = Montserrat.regularFont(size: 14)
        self.descriptionLabel.numberOfLines = 2
        self.descriptionLabel.textAlignment = .center
        self.descriptionLabel.textColor = UIColor(rgb: 0x8E8E93)
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.descriptionLabel)

        NSLayoutConstraint.activate([
            self.descriptionLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.descriptionLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.descriptionLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 8)
        ])
    }

    private func configTryAgainTapableView() {
        self.tryAgainTapableView = TapableView()
        self.tryAgainTapableView.backgroundColor = UIColor(rgb: 0xA5E037)
        self.tryAgainTapableView.translatesAutoresizingMaskIntoConstraints = false
        self.tryAgainTapableView.cornerRadius = 4

        let tryAgainLabel = UILabel()
        tryAgainLabel.text = "Try Again"
        tryAgainLabel.font = Montserrat.boldFont(size: 14)
        tryAgainLabel.textColor = UIColor(rgb: 0x333333)
        tryAgainLabel.textAlignment = .center
        tryAgainLabel.translatesAutoresizingMaskIntoConstraints = false
        self.tryAgainTapableView.addSubview(tryAgainLabel)

        NSLayoutConstraint.activate([
            tryAgainLabel.centerXAnchor.constraint(equalTo: self.tryAgainTapableView.centerXAnchor),
            tryAgainLabel.centerYAnchor.constraint(equalTo: self.tryAgainTapableView.centerYAnchor),
            tryAgainLabel.topAnchor.constraint(equalTo: self.tryAgainTapableView.topAnchor, constant: 8),
            tryAgainLabel.leadingAnchor.constraint(equalTo: self.tryAgainTapableView.leadingAnchor, constant: 8)
        ])

        self.contentView.addSubview(self.tryAgainTapableView)

        NSLayoutConstraint.activate([
            self.tryAgainTapableView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.tryAgainTapableView.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: 8),
            self.tryAgainTapableView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.tryAgainTapableView.widthAnchor.constraint(equalToConstant: 140),
            self.tryAgainTapableView.heightAnchor.constraint(equalToConstant: 36)
        ])

        self.tryAgainTapableView.addTarget(self, action: #selector(didTapTryAgainTapableView), for: .touchUpInside)
    }

    @objc private func didTapTryAgainTapableView() {
        self.delegate?.noInternetViewDidTapTryAgainTapable(self)
    }
}
