//
//  SingleCardView.swift
//  MyTodo
//
//  Created by hualala on 2021/8/6.
//

import SwiftUI

struct SingleCardView: View {
    
    var index: Int

    @EnvironmentObject var userData:ToDo
    
    @Binding var editingModel: Bool
    @Binding var selection: [Int]
    
    //@State 属性包装器
    @State var showEditingPage = false
    
    var body: some View {
        //HStack 横向排列
        HStack {
            //创建一个矩形
            Rectangle()
                .frame(width: 8)
                .foregroundColor(Color("Color" + String(self.index % 6)))
            
            if editingModel {
                Button(action:{
                    self.userData.delete(id: self.index)
                    self.editingModel = false
                }){
                    Image("delete")
                        .imageScale(.large)
                        .padding(.leading)
                }
            }
            
            Button(action:{
                if !self.editingModel {
                    self.showEditingPage = true
                }
            }){
                Group {
                    //VStack 垂直排列
                    VStack(alignment: .leading,spacing: 10.0) {
                        Text(userData.toDoList[index].title)
                            .font(.system(size: 18))
                            .foregroundColor(.black)
                            .bold()
                        Text(formatter.string(from: userData.toDoList[index].duedate))
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    //边距 leading：左边
                    .padding(.leading)
                    //把上面的元素挤到最左边
                    Spacer()
                }
            }
            .sheet(isPresented: $showEditingPage, content: {
                EditingPage(title: self.userData.toDoList[index].title,
                            duedate: self.userData.toDoList[index].duedate,
                            id: self.index)
                    .environmentObject(self.userData)
            })

            if editingModel {
                Image(systemName: self.selection.firstIndex(where: { $0 == self.index }) == nil ? "circle" : "checkmark.circle.fill")
                    .imageScale(.large) //设置大小
                    .padding(.trailing)
                    //点击
                    .onTapGesture {
                        if self.selection.firstIndex(where: {
                            $0 == self.index
                        }) == nil {
                            self.selection.append(self.index)
                        }else{
                            self.selection.remove(at: self.selection.firstIndex(where: {
                                $0 == self.index
                            })!)
                        }
                    }
            }else{
                Image(systemName: userData.toDoList[index].isChecked ? "checkmark.square.fill" : "square")
                    .imageScale(.large) //设置大小
                    .padding(.trailing)
                    //点击
                    .onTapGesture {
                        self.userData.check(id: index)
                    }
            }
        }
        .frame(height:90)
        //背景 用颜色时 用 “Color.white”
        .background(Color.white)
        //要先设置视图 再设置圆角
        .cornerRadius(10)
        //设置阴影
        .shadow(radius: 5,x:0,y:5)
    }
}

//struct SingleCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        SingleCardView(index: 0,editingModel: )
//    }
//}
