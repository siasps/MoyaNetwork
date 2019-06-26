//
//  HomeTableViewController.swift
//  FJCommon_detection
//
//  Created by peng on 2019/6/24.
//  Copyright © 2019 peng. All rights reserved.
//

import UIKit
import Alamofire
import Moya

class HomeTableViewController: UITableViewController {
    
    var excutingAPITask:MGHttpAPITask? = nil
 
    var dataList = Array<Dictionary<String,Any>>();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.rowHeight = 60;
        
        
        getData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.dataList.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : HomeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! HomeTableViewCell
        
        let info :Dictionary<String,Any> = self.dataList[indexPath.section]
        cell.reloadInformation(info: info)
        cell.selectionStyle = .gray
        return cell
    }
    
    override  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 10
    }
    
   
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 0.01

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
    }



    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

  
    @IBAction func refresh(_ sender: Any) {
        getData()
    }
    
//    func getData() {
//
//        self.dataList.removeAll()
//        let urlString = "http://localhost:8081/suite/get/experiment_list"
//        let parameter : [AnyHashable:Any] = Dictionary()
//        excutingAPITask = XYHttpManager.request(url: urlString, meta:parameter, method: .GET) { [weak self] responds in
//            print(responds.result as Any)
//            self?.excutingAPITask = nil
//            let data : Array<Dictionary<String,Any>> = responds.result!["data"] as! Array<Dictionary<String, Any>>
//            self?.dataList+=data
//            self?.tableView.reloadData()
//        }
//    }
    
    func getData() {

//        ScanProvider.shared.getExperimentList { [weak self] (res) in
//            guard let `self` = self else { return }
//            switch res {
//            case .success(_):
//                print("success")
//            case .failure(_):
//                print("failure")
//            }
//        }
        
        
        ScanProvider.shared.provider.request(.getExperimentList) { (result) in
            switch result{
            case .success(let responseData):
                if let response = self.dataToDictionary(data: responseData.data) {
                    let resultList : Array<Dictionary<String,Any>> = response["data"] as! Array<Dictionary<String, Any>>
                    self.dataList+=resultList
                    self.tableView.reloadData()
                }
            case .failure(_):
                print("网络失败")
              
            }
        }

//        ScanProvider.shared.qrLogin(
//            appname: result.qrStringAppName,
//            nonce: result.qrStringNonce,
//            address: result.address
//        ) {[weak self] (res) in
//
//        }
    }
    
    
//    func getData() {
//        self.dataList.removeAll()
//        Alamofire.request("http://localhost:8081/suite/get/experiment_list",parameters:nil).responseJSON { (responseJson) in
//            switch responseJson.result {
//            case .success(let data):
//                print(data)
//                //Alamofire默认返回的是一个解析过的数据结构，这里代表一个字典
//                if data is Dictionary<String, Any>{
//                    let data2 = data as! Dictionary<String, Any>
//                    let resultList : Array<Dictionary<String,Any>> = data2["data"] as! Array<Dictionary<String, Any>>
//                    self.dataList+=resultList
//                    self.tableView.reloadData()
//                    //print(data2["Msg"]?)
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
    
    
//    func getData() {
//
//        let provide = MoyaProvider<HttpRequest>()
//
//        provide.request(.getExperimentList) { (Result) in
//            switch Result {
//            case let .success(response):
//                //数据解析
//                //let json = JSON(response.data)
//                let json = String(data: response.data, encoding: String.Encoding.utf8)
//                print(json as Any)
//
//                let dict = self.dataToDictionary(data: response.data)
//                let resultList : Array<Dictionary<String,Any>> = dict?["data"] as! Array<Dictionary<String, Any>>
//                self.dataList+=resultList
//                self.tableView.reloadData()
//
//
//            case let .failure(error):
//                print(error)
//            }
//        }
//
//    }
    
    func dataToDictionary(data:Data) -> Dictionary<String, Any>? {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            let dic = json as! Dictionary<String, Any>
            return dic
        } catch _ {
            return nil
        }
    }

}
