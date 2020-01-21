//
//  AppContainerViewController.swift
//  Musique
//
//  Created by Daniel Dias Rodrigues on 21/01/2020.
//  Copyright © 2020 Luís Manuel Martins Campos. All rights reserved.
//

import UIKit

class AppContainerViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AppManager.shared.appContainer = self
        AppManager.shared.showApp()
        
     
    }
    


}
