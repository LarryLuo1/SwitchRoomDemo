//
//  LiveViewController.swift
//  SwiftDemo
//
//  Created by Kael Ding on 2023/3/27.
//

import UIKit
import ZegoExpressEngine

class LiveViewController: UITableViewController, ZegoEventHandler {
    
    var roomList: [Room] = []
    var currentIndexPath: IndexPath = .init(row: 0, section: 0)
    
    var currentStreamView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.contentInsetAdjustmentBehavior = .never
        tableView.scrollsToTop = false
        
        ZegoExpressEngine.shared().setEventHandler(self)
        
        tableView.reloadData()
        
        DispatchQueue.main.async {
            self.tableView.scrollToRow(at: self.currentIndexPath, at: .none, animated: false)
            self.loginRoom()
        }
        
    }
    
    func loginRoom() {
        let roomID = roomList[currentIndexPath.row].roomID
        let user = ZegoUser()
        user.userID = "123456"
        user.userName = "Test UserName"
        ZegoExpressEngine.shared().loginRoom(roomID, user: user)
    }
    
    func playStream(_ stream: ZegoStream, roomID: String) {
        for i in 0..<roomList.count {
            let room = roomList[i]
            if roomID == room.roomID {
                guard let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) else {return}
                print("onRoomStreamUpdate row:" + String(i))
                print("onRoomStreamUpdate view is: \(Unmanaged.passUnretained(cell).toOpaque())")
                let canvas = ZegoCanvas(view: cell.contentView)
                ZegoExpressEngine.shared().startPlayingStream(stream.streamID, canvas: canvas)
            }
        }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = floor(scrollView.contentOffset.y / view.frame.size.height + 0.5)
        let indexPath = IndexPath(row: Int(index), section: 0)
//        guard let index = tableView.indexPathsForVisibleRows?.last else { return }
//        print("scrollViewDidEndDecelerating", tableView.indexPathsForVisibleRows)
        let oldRoom = roomList[currentIndexPath.row]
        let newRoom = roomList[indexPath.row]
        if (oldRoom.roomID != newRoom.roomID) {
            ZegoExpressEngine.shared().switchRoom(oldRoom.roomID, toRoomID: newRoom.roomID)
        }
        currentIndexPath = indexPath
    }
    
    // MARK: - ZegoEventHandler
    func onRoomStreamUpdate(_ updateType: ZegoUpdateType, streamList: [ZegoStream], extendedData: [AnyHashable : Any]?, roomID: String) {
        if updateType == .delete {
            for stream in streamList {
                ZegoExpressEngine.shared().stopPlayingStream(stream.streamID)
            }
        } else {
            streamList.forEach { stream in
                playStream(stream, roomID: roomID)
            }
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "liveCell", for: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        view.bounds.height
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }
}
