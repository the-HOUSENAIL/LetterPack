//
//  ReviewMainViewController.swift
//  MAPTest6
//
//  Created by 今井 秀一 on 2020/09/11.
//  Copyright © 2020 maimai. All rights reserved.
//

import UIKit

class ReviewMainViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    private lazy var reviewHomeViewController: ReviewHomeViewController = {
        let storyborad = UIStoryboard(name: "Main", bundle: Bundle.main)
        var reviewMainViewController = storyborad.instantiateViewController(withIdentifier: "ReviewHomeViewController") as! ReviewHomeViewController
        add(asChildViewController: reviewMainViewController)
        return reviewMainViewController
    }()

    private lazy var reviewViewController: ReviewViewController = {
        let storyborad = UIStoryboard(name: "Main", bundle: Bundle.main)
        var reviewMainViewController = storyborad.instantiateViewController(withIdentifier: "ReviewViewController") as! ReviewViewController
        add(asChildViewController: reviewMainViewController)
        return reviewMainViewController
    }()
    
    private lazy var reviewedViewController: ReviewedViewController = {
        let storyborad = UIStoryboard(name: "Main", bundle: Bundle.main)
        var reviewMainViewController = storyborad.instantiateViewController(withIdentifier: "ReviewedViewController") as! ReviewedViewController
        add(asChildViewController: reviewMainViewController)
        return reviewMainViewController
    }()

        // MARK: - View Life Cycle

        override func viewDidLoad() {
            super.viewDidLoad()
            setupView()
        }

        // MARK: - View Methods

        private func setupView() {
            updateView()
        }

        private func updateView() {
            if segmentedControl.selectedSegmentIndex == 0 {
                remove(asChildViewController: reviewViewController)
                remove(asChildViewController: reviewedViewController)
                add(asChildViewController: reviewHomeViewController)
            } else if (segmentedControl.selectedSegmentIndex == 1) {
                remove(asChildViewController: reviewHomeViewController)
                remove(asChildViewController: reviewedViewController)
                add(asChildViewController: reviewViewController)
            } else {
                remove(asChildViewController: reviewHomeViewController)
                remove(asChildViewController: reviewViewController)
                add(asChildViewController: reviewedViewController)
            }
        }

        // MARK: - Action

        @IBAction func tapSegmentedControl(_ sender: UISegmentedControl) {
            updateView()
        }

        // MARK: - Child View Controller Operation Methods

        private func add(asChildViewController viewController: UIViewController) {
            // 子ViewControllerを追加
            addChild(viewController)
            // Subviewとして子ViewControllerのViewを追加
            view.addSubview(viewController.view)
            // 子Viewの設定
            viewController.view.frame = view.bounds
            viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            // 子View Controllerへの通知
            viewController.didMove(toParent: self)
        }

        private func remove(asChildViewController viewController: UIViewController) {
            // 子View Controllerへの通知
            viewController.willMove(toParent: nil)
            // 子ViewをSuperviewから削除
            viewController.view.removeFromSuperview()
            // 子View Controllerへの通知
            viewController.removeFromParent()
        }

    }

