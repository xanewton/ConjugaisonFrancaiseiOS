//
//  VerbListViewController.swift
//  ConjugaisonFrancaiseiOS
//
//  Created by xengar on 2018-01-05.
//  Copyright © 2018 xengar. All rights reserved.
//

import UIKit

class VerbListViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    
    var verbs: [Verb] = [Verb]() // List of verbs
    var conjugations: [Conjugation] = [Conjugation]() // List of conjugations
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize the verbs
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Load data
    private func loadData() {
        let verbPlistPaths = Bundle.main.paths(forResourcesOfType: "plist", inDirectory: nil)
        
        for plistPath in verbPlistPaths {
            if (plistPath as NSString).lastPathComponent == "verbs.plist" {
                // Get the verbs
                if let verbsDictionary = NSDictionary(contentsOfFile: plistPath) as? [String : AnyObject] {
                    let verbNodesDictionary = verbsDictionary["verbs"] as! [AnyObject]
                    // Add the verb
                    for (dictionary): (AnyObject) in verbNodesDictionary {
                        verbs.append(Verb(dictionary: dictionary as! [String : AnyObject]))
                    }
                }
            } else if (plistPath as NSString).lastPathComponent == "conjugations.plist" {
                // Get the conjugations
                if let conjugationsDictionary = NSDictionary(contentsOfFile: plistPath) as? [String : AnyObject] {
                    let conjugationNodesDictionary = conjugationsDictionary["conjugations"] as! [AnyObject]
                    // Add the conjugation
                    for (dictionary): (AnyObject) in conjugationNodesDictionary {
                        conjugations.append(Conjugation(dictionary: dictionary as! [String : AnyObject]))
                    }
                }
            }
        }
    }
    
    // MARK: Find the conjugation with the id
    private func findConjugationWithId(_ id : Int) -> Conjugation {
        var result : Conjugation = conjugations[0]
        for conjugation in conjugations {
            if conjugation.id == id {
                result = conjugation
                break
            }
        }
        return result
    }
    
    
    // MARK: Show Options dialog
    @IBAction func showOptions(_ sender: AnyObject) {
        
        let storyboard = self.storyboard
        let controller = storyboard?.instantiateViewController(withIdentifier: "OptionsViewController")as! OptionsViewController
        
        //controller.history = self.history
        
        //self.present(controller, animated: true, completion: nil)
        self.navigationController?.pushViewController(controller, animated: true)
    }

}


// MARK: - VerbListViewController (Table Data Source)
extension VerbListViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return verbs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell")! as! VerbTableViewCell
        let verb = verbs[(indexPath as NSIndexPath).row]
        cell.infinitive!.text = verb.infinitive
        cell.definition!.text = verb.definition
        cell.translation!.text = verb.translationEN
        //let imageName = adventure.credits.imageName
        //cell.imageView!.image = UIImage(named: imageName!)
        
        // Use UserDefaults for hide/show definition
        let boolValue = UserDefaults.standard.bool(forKey: "showVerbDefinition")
        cell.definition.isHidden = !boolValue
        // TODO: Use UserDefaults for hide/show translation
        //cell.translation.isHidden = true
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Get the selected verb
        let verb = verbs[(indexPath as NSIndexPath).row]
        
        // Get a controller from the Storyboard
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "VerbDetailsViewController")as! VerbDetailsViewController
        
        // Set the verb data
        controller.verb = verb
        // Set the conjugation model for the verb
        controller.conjugation = findConjugationWithId(verb.conjugation)
        
        // Push the new controller onto the stack
        self.navigationController!.pushViewController(controller, animated: true)
    }
}
