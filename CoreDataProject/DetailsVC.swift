//
//  DetailsVC.swift
//  CoreDataProject
//
//  Created by Abdullah Alnutayfi on 25/11/2021.
//

import UIKit

class DetailsVC: UIViewController {
    var info = ""
    
    
    lazy var infoLable: UILabel = {
        $0.textColor = .brown
        return $0
    }(UILabel())
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(infoLable)
        // Do any additional setup after loading the view.
        infoLable.text = info
        print("my name is \(info)")
        infoLable.translatesAutoresizingMaskIntoConstraints = false
        infoLable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        infoLable.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20).isActive = true
        infoLable.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20).isActive = true
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
