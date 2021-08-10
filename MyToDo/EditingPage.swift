//
//  EditingPage.swift
//  MyTodo
//
//  Created by hualala on 2021/8/6.
//

import SwiftUI

struct EditingPage: View {
    
    @EnvironmentObject var userDta: ToDo
    
    @State var title: String = ""
    @State var duedate: Date = Date()
    
    var id: Int? = nil
    
    @Environment(\.presentationMode) var persentation
    
    var body: some View {
        NavigationView {
            //表单
            Form {
                Section(header:Text("事项")
                            .font(.system(size: 15))
                            .padding(EdgeInsets(top: 20, leading: 0, bottom: 10, trailing: 10))) {
                    TextField("事项内容",text:$title)
                    DatePicker(selection: $duedate, label: { Text("截止时间") })
                }
                
                Section {
                    Button(action:{
                        if self.title.count <= 0 {
                            return
                        }
                        
                        if self.id == nil {
                            self.userDta.add(data: singleToDo(title: self.title,duedate: self.duedate))
                        }else{
                            self.userDta.edit(id: self.id ?? 0, data: singleToDo(title: self.title,duedate: self.duedate))
                        }
                        self.persentation.wrappedValue.dismiss()
                    }){
                        Text("确认")
                    }
                    
                    Button(action:{
                        self.persentation.wrappedValue.dismiss()
                    }){
                        Text("取消")
                    }
                }
            }
            .navigationTitle("添加")
        }
    }
}

struct EditingPage_Previews: PreviewProvider {
    static var previews: some View {
        EditingPage()
    }
}
