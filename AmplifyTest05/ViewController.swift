//
//  ViewController.swift
//  AmplifyTest05
//
//  Created by Keishin CHOU on 2019/12/24.
//  Copyright © 2019 Keishin CHOU. All rights reserved.
//

import UIKit

import Amplify
import AmplifyPlugins

class ViewController: UIViewController {
    
    lazy private var contentTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Contents"
//        label.backgroundColor = .blue
        return label
    }()
    
    lazy private var taskField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter a task"
        textField.allowsEditingTextAttributes = true
//        textField.backgroundColor = .brown
        return textField
    }()
    
    lazy private var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("add", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.addTarget(self, action: #selector(addTask), for: .touchUpInside)
//        button.backgroundColor = .purple
        return button
    }()
    
    lazy private var seeResultButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("See results", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.addTarget(self, action: #selector(seeResults), for: .touchUpInside)
//        button.backgroundColor = .purple
        return button
    }()
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(contentTitle)
        contentTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        contentTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        contentTitle.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        contentTitle.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(taskField)
        taskField.topAnchor.constraint(equalTo: contentTitle.bottomAnchor, constant: 20).isActive = true
        taskField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        taskField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        taskField.widthAnchor.constraint(equalToConstant: view.frame.width * 0.7).isActive = true
        
        view.addSubview(addButton)
        addButton.topAnchor.constraint(equalTo: contentTitle.bottomAnchor, constant: 20).isActive = true
        addButton.leadingAnchor.constraint(equalTo: taskField.trailingAnchor).isActive = true
        addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        addButton.widthAnchor.constraint(equalToConstant: 350).isActive = true
        
        view.addSubview(seeResultButton)
        seeResultButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        seeResultButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        seeResultButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        seeResultButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    @objc func addTask() {
        
        guard let content = taskField.text else { return }
        let note = Note(content: content)
        _ = Amplify.API.mutate(of: note, type: .create) { (event) in
                switch event {
                case .completed(let result):
                    switch result {
                    case .success(let note):
                        print("API Mutate successful, created note: \(note)")
                        print("Result is \(result)")
                    case .failure(let error):
                        print("Completed with error: \(error.errorDescription)")
                    }
                case .failed(let error):
                    print("Failed with error \(error.errorDescription)")
                default:
                    print("Unexpected event")
                }
            }
        
        print("Add button clicked.")
        taskField.text = ""
    }
    
    @objc func seeResults() {
        print("See results clicked.")
        
        let newControllerView = ResultsViewController()
        self.navigationController?.pushViewController(newControllerView, animated: true)
    }


}

