//
//  MainInterfaceController.swift
//  br.com.mfelipesp.DesafioStoneWatch Extension
//
//  Created by Marcos Felipe Souza on 04/02/20.
//  Copyright © 2020 Marcos Felipe Souza. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class MainInterfaceController: WKInterfaceController {

    var facts = [FactModel]()
    var rowTypes = ["SearchRow"]
    var wcSession : WCSession = WCSession.default
    
    @IBOutlet var factTable: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        configWCSession()
        createStub()
    }
    
    override func willActivate() {
        super.willActivate()
        refreshTable()
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        print(self.rowTypes[rowIndex])
        switch rowTypes[rowIndex]{
            case "SearchRow":
                let row = factTable.rowController(at:rowIndex) as! SearchRowController
                print(row.description)
//                presentController(withName: "SearchInterface", context: self)
            case "FactRow":
                let row = factTable.rowController(at:rowIndex) as! FactRowController
                print(row.factModel?.title)
    
            default:
                break;
        }

    }
    
    private func createStub() {
        facts.append(FactModel(id: "1", title: "Chuck norris foi mordido pela cobra, mas a cobra que morreu", tag: "Descategorizando", url: "http://www.google.com"))
        facts.append(FactModel(id: "2", title: "Do que vale um homem vivo do que nenhum.", tag: "Descategorizando", url: "http://www.google.com"))
        facts.append(FactModel(id: "3", title: "Chuck sempre dar medo, podendo vir antes de Norris, Videl ou Boneco", tag: "Mata", url: "http://www.google.com"))
        facts.append(FactModel(id: "4", title: "Norris", tag: "Chuck", url: "http://www.google.com"))
        
        facts.forEach { _ in
            self.rowTypes.append("FactRow")
        }
    }
    
    private func configWCSession(){
        self.wcSession.delegate = self
        self.wcSession.activate()
    }
    
    func refreshTable(){
        
        factTable.setRowTypes(rowTypes)
        let total =  facts.count + 1
        for rowIndex in 0 ..< total {
            switch rowTypes[rowIndex]{
                case "SearchRow":
                    let row = factTable.rowController(at:rowIndex) as! SearchRowController
                    print(row.description)
                case "FactRow":
                    let index = rowIndex - 1 // searchRow
                    let row = factTable.rowController(at:rowIndex) as! FactRowController
                    row.factModel = facts[index]
        
                default:
                     print("Not a valid row type: " + rowTypes[rowIndex]   )
            }
    
         }
     }
    
}

extension MainInterfaceController: WCSessionDelegate {
    // MARK: WCSession Methods
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let facts = message["facts"] as? [FactModel] {
            print(facts)
            //Get some facts from search in iOS.
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
        //TODO: Got this session here or some error
    }
}
