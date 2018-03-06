//
//  ViewController.swift
//  SKCalendar Example
//
//  Created by Sandeep Koirala on 06/03/2018.
//  Copyright © 2018 Sandeep Koirala. All rights reserved.
//

import UIKit

import SKCalendar


class ViewController: UIViewController, SKCalendarViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
        
        let calendarView = SKCalendarView(delegate: self)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.leftAnchor.constraint(equalTo: view.leftAnchor),
            calendarView.rightAnchor.constraint(equalTo: view.rightAnchor),
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendarView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    func calendarView(calendarView: SKCalendarView!, didSelectDate date: DateComponents) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

