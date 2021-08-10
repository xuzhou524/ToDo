//
//  UserData.swift
//  MyTodo
//
//  Created by hualala on 2021/8/5.
//

import Foundation
import UserNotifications

let NotificationContent = UNMutableNotificationContent()

var encoder = JSONEncoder()
var decoder = JSONDecoder()

struct singleToDo: Identifiable,Codable {
    var title: String = ""
    var duedate:Date = Date()
    var isChecked: Bool = false
    
    var deleted = false
    
    var id: Int = 0
}

class ToDo: ObservableObject {
    
    @Published var toDoList: [singleToDo]
    var count = 0
    
    init() {
        self.toDoList = []
    }
    
    init(data: [singleToDo]) {
        self.toDoList = []
        for item in data {
            self.toDoList.append(singleToDo(title: item.title, duedate: item.duedate,isChecked: item.isChecked, id: self.count))
            count += 1
        }
    }
    
    func check(id: Int){
        self.toDoList[id].isChecked.toggle()
        self.dataStore()
    }
    
    func add(data: singleToDo) {
        self.toDoList.append(singleToDo(title: data.title, duedate: data.duedate, id: self.count))
        self.count += 1
        //排序
        sort()
        self.dataStore()
        
        self.sendNotification(id: self.toDoList.count - 1)
    }
    
    func edit(id:Int,data:singleToDo) {
        
        self.withdrawNotification(id: id)
        
        self.toDoList[id].title = data.title
        self.toDoList[id].duedate = data.duedate
        self.toDoList[id].isChecked = false
        //排序
        sort()
        self.dataStore()
        
        self.sendNotification(id: id)
    }
    
    func delete(id: Int){
        self.withdrawNotification(id: id)
        self.toDoList[id].deleted = true
        //排序
        self.sort()
        self.dataStore()
    }
    //排序
    func sort() {
        self.toDoList.sort(by: {(data1,data2) in
            return data1.duedate.timeIntervalSince1970 < data2.duedate.timeIntervalSince1970
        })
        
        for i in 0..<self.toDoList.count {
            self.toDoList[i].id = i
        }
    }
    
    //存数据
    func dataStore() {
        let dataStored = try! encoder.encode(self.toDoList)
        UserDefaults.standard.set(dataStored, forKey: "come.xuzhou.toDoList")
    }
    
    //发送通知
    func sendNotification(id: Int) {
        //添加的时间小于等于当前时间  不发送推送了
        if self.toDoList[id].duedate.timeIntervalSinceNow <= 0 {
            return
        }
        NotificationContent.title = self.toDoList[id].title
        NotificationContent.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: self.toDoList[id].duedate.timeIntervalSinceNow, repeats: false)
        let request = UNNotificationRequest(identifier: self.toDoList[id].title + self.toDoList[id].duedate.description, content: NotificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    //撤销通知
    func withdrawNotification(id: Int) {
        //已经发送的通知
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [self.toDoList[id].title + self.toDoList[id].duedate.description])
        //请求的通知，但还没发送
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [self.toDoList[id].title + self.toDoList[id].duedate.description])
    }
}
