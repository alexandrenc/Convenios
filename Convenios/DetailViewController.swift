//
//  DetailViewController.swift
//  Convenios
//
//  Created by Alexandre on 01/09/14.
//  Copyright (c) 2014 Alexandre. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
                            
    @IBOutlet weak var detailDescriptionLabel: UIWebView!


    var detailItem: NSDictionary? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        var html:String = "<html><body>"

        if let detail:[String:String] = self.detailItem as? [String:String] {
            
        
            if "" != detail["STRCONVENIO"] {
                html += "<p><b>"
                html += detail["STRCONVENIO"]!
                html += "</b></p>"
            }
            
            if "" != detail["STRENDERECO"] {
                html += "<p>Endereço: "
                html += detail["STRENDERECO"]!
                html += "</p>"
            }
            
            if "" != detail["STRTELEFONE"]{
                html += "<p>Telefone: "
                html += detail["STRTELEFONE"]!
                html += "</p>"
            }
            
//            if "" != detail.objectForKey("STRCONTATO") as String {
//                html += "<p>Contato: "
//                html += detail.objectForKey("STRCONTATO") as String
//                html += "</p>"
//            }
            
            if "" != detail["STRDESCRICAOESTAB"] {
                html += "<p>"
                html += detail["STRDESCRICAOESTAB"]!
                html += "</p>"
            }
            
            if "" != detail["STRDESCRICAO"] {
                html += "<p>Benefício"
                html += detail["STRDESCRICAO"]!
                html += "</p>"
            }
            
         } else {
            html += "<p>Nenhum convênio selecionado</p>"

        }
        html += "</body></html>"
        
        if let label = self.detailDescriptionLabel {
            label.loadHTMLString(html, baseURL: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

