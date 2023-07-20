//
//  TableViewController.swift
//  SwiftDemo
//
//  Created by Kael Ding on 2023/3/27.
//

import UIKit
import ZegoExpressEngine

struct Room {
    let roomID: String
    let hostUserID: String
    let streamID: String
}

class TableViewController: UITableViewController {
    
    let roomList: [Room] = [
        Room(roomID: "111", hostUserID: "111", streamID: "stream_111"),
        Room(roomID: "222", hostUserID: "222", streamID: "stream_222"),
        Room(roomID: "333", hostUserID: "333", streamID: "stream_333"),
        Room(roomID: "444", hostUserID: "444", streamID: "stream_444"),
        Room(roomID: "444", hostUserID: "444", streamID: "stream_555"),
        Room(roomID: "444", hostUserID: "444", streamID: "stream_666")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        let profile = ZegoEngineProfile()
        profile.appID = Your App ID
        profile.appSign = "Your App Sign"
        ZegoExpressEngine.createEngine(with: profile, eventHandler: nil)
        
        let config = ZegoEngineConfig()
        config.advancedConfig = ["update_view_last_frame_mode": "preserve"]
        ZegoExpressEngine.setEngineConfig(config)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return roomList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        var config = cell.defaultContentConfiguration()
        config.text = "Room ID: " + roomList[indexPath.row].roomID
        cell.contentConfiguration = config
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! LiveViewController
        vc.roomList = roomList
        if let indexPath = tableView.indexPathForSelectedRow {
            vc.currentIndexPath = indexPath
        }
    }
    

}
