//
//  LoadingView.swift
//  VNPAY_Challenge
//
//  Created by lê thạch on 24/02/2024.
//

import UIKit

class LoadingView: UIView {
    private var activityIndicator: UIActivityIndicatorView!

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
        self.configCommonUI()
        self.configActivityIndicator()
    }

    private func configCommonUI() {
        self.backgroundColor = .black.withAlphaComponent(0.3)
    }

    private func configActivityIndicator() {
        self.activityIndicator = UIActivityIndicatorView()
        self.activityIndicator.style = .gray
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.activityIndicator)

        NSLayoutConstraint.activate([
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

    // MARK: - Public
    func updateAnimating(isStart: Bool) {
        if isStart {
            self.activityIndicator.startAnimating()
            return
        }

        self.activityIndicator.stopAnimating()

    }
}
