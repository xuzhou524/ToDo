//
//  ContentView.swift
//  MyToDo
//
//  Created by hualala on 2021/8/9.
//

import SwiftUI

var formatter = DateFormatter()

func initUserData() -> [singleToDo] {
    formatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
    var outPut: [singleToDo] = []
    if let dataStored = UserDefaults.standard.object(forKey: "come.xuzhou.toDoList") as? Data {
        let data = try! decoder.decode([singleToDo].self, from: dataStored)
        for item in data {
            if !item.deleted {
                outPut.append(singleToDo(title: item.title, duedate: item.duedate, isChecked: item.isChecked, id: outPut.count))
            }
        }
    }
    return outPut
}

struct ContentView: View {
    
    @ObservedObject var userData: ToDo = ToDo(data: initUserData().count > 0 ? initUserData() : [singleToDo(title: "示例", duedate: Date(), isChecked: false, id: 0)])
    
    @State var showEditingPage = false
    @State var editingMode = false
    
    @State var selection: [Int] = []
    
    var body: some View {
        
        ZStack {
            
            NavigationView {
                ScrollView(.vertical, showsIndicators:true){
                    VStack {
                        //ForEach 满足结构体必须时
                        ForEach(userData.toDoList) { item in
                            if !item.deleted {
                                SingleCardView(index: item.id,
                                               editingModel: $editingMode,
                                               selection: $selection)
                                    .environmentObject(userData)
                                    //横向加默认的边距
                                    .padding(EdgeInsets(top: 15, leading: 20, bottom: 5, trailing: 20))
                                    .animation(.spring())
                                    .transition(.slide)
                            }
                        }
                    }
                }
                .navigationTitle("提醒事项")
                .navigationBarItems(trailing:
                                        HStack(spacing: 20){
                                            if editingMode {
                                                DaleteButton(selection: $selection, editingMode: $editingMode)
                                                    .environmentObject(userData)
                                            }
                                            EditingButton(editingModel: $editingMode,
                                                          selection: $selection, editingMode: $editingMode)
                                        }
                )
            }
        
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Button(action:{
                        self.showEditingPage = true
                    }){
                        Image("add")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 65, height: 65)
                            .foregroundColor(.blue)
                            .padding(.trailing)
                    }
                    .sheet(isPresented: $showEditingPage, content: {
                        EditingPage()
                            .environmentObject(userData)
                    })
                }
            }
        }
    }
}

struct EditingButton: View {
    
    @Binding var editingModel: Bool
    @Binding var selection: [Int]
    
    @Binding var editingMode: Bool
    
    var body: some View {
        Button(action:{
            self.editingModel.toggle()
            self.selection.removeAll()
        }){
            Image("setting")
                .imageScale(.large)
        }
    }
}

struct DaleteButton: View {
    
    @Binding var selection: [Int]
    @EnvironmentObject var userData: ToDo
    
    @Binding var editingMode: Bool
    
    var body: some View {
        Button(action:{
            for i in selection {
                self.userData.delete(id: i)
            }
            self.editingMode = false
        }){
            Image("delete")
                .imageScale(.large)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

