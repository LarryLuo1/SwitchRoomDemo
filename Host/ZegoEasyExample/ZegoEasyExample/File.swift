import UIKit

private let reuseableIdentifier = "cell"

class TableViewController: UITableViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
      tableView.register(UITableViewCell.self,forCellReuseIdentifier: reuseableIdentifier)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // return number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return number of rows in sections
        return 10
    }
    
    // add method
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: reuseableIdentifier, for: indexPath )
        return cell
    }
}
