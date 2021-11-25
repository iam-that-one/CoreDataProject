//
//  ViewController.swift
//  CoreDataProject
//
//  Created by Abdullah Alnutayfi on 24/11/2021.
//

import UIKit

class ViewController: UIViewController{
var viewModel = ViewModel()
    var filterdResult : [Note] = []
    lazy var searchBar : UISearchBar = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.delegate = self
        return $0
    }(UISearchBar())
    
    lazy var addBtn : UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setBackgroundImage(UIImage(systemName: "plus.square"), for: .normal)
        $0.addTarget(self, action: #selector(addBtnClick), for: .touchDown)

        return $0
    }(UIButton(type: .system))
    
    lazy var tableView : UITableView = {
        $0.delegate = self
        $0.dataSource = self
        $0.layer.cornerRadius = 5
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .systemGray5
        return $0
    }(UITableView(frame: CGRect.zero, style: .insetGrouped))
    
    
    
    override func viewDidLoad() {
        [searchBar,addBtn,tableView].forEach{view.addSubview($0)}
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Notes"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        viewModel.fetchData()
        tableView.reloadData()
        uiSettings()
        filterdResult = viewModel.notes
    }
   
    func uiSettings(){
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: addBtn.leadingAnchor,constant: -20),
            
            addBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 15),
            addBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addBtn.leadingAnchor.constraint(equalTo: searchBar.trailingAnchor),
           
            
            tableView.topAnchor.constraint(equalTo: addBtn.bottomAnchor,constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
        
    }
    @objc func addBtnClick(){
        let alert = UIAlertController(title: "New Note", message: "Enter note name and its details", preferredStyle: .alert)
        alert.addTextField { (nameTextField) in
            nameTextField.placeholder = "Enter Note name"
        }
        alert.addTextField { (infoTextField) in
            infoTextField.placeholder = "Enter Note details"
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let nameTextField = alert?.textFields![0]
            let infoTextField = alert?.textFields![1]
            if nameTextField?.text != "" || infoTextField?.text != ""{
            let newNote = Note(context: self.viewModel.getContext())
            newNote.id = UUID().uuidString
            newNote.name = nameTextField?.text
            newNote.info = infoTextField?.text
            }
            
            do{
                try self.viewModel.getContext().save()
                self.viewModel.fetchData()
                self.tableView.reloadData()
                self.filterdResult = self.viewModel.notes
                self.tableView.reloadData()
            }catch{
                print(error)
            }
        }))
        self.present(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
        }))

      
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterdResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
     
            cell.textLabel?.text = filterdResult[indexPath.row].name
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let toBeDelete = viewModel.notes[indexPath.row]
        if editingStyle == .delete {
            viewModel.getContext().delete(toBeDelete)
             do {
                 try viewModel.getContext().save()
             } catch let error as NSError {
                 print("Error While Deleting Note: \(error.userInfo)")
             }
         }
        viewModel.fetchData()
        filterdResult = viewModel.notes
        tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterdResult = []
        
        if searchText == ""{
            filterdResult = viewModel.notes
        }
        else{
        for note in viewModel.notes{
            if note.name!.lowercased().contains(searchText.lowercased()){
                filterdResult.append(note)
            }
        }
    }
        viewModel.fetchData()
       tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsController = DetailsVC()
        detailsController.info = filterdResult[indexPath.row].info!
        self.navigationController?.pushViewController(detailsController, animated: true)
    }
}
