//
//  SwipeNavigationController.swift
//  DripDrop
//
//  Created by Jaksa Tomovic on 24/02/2018.
//  Copyright © 2018 Jaksa Tomovic. All rights reserved.
//

import UIKit
import SwipeTransition

class SwipeNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeBack = SwipeBackController(navigationController: self)
    }
}
