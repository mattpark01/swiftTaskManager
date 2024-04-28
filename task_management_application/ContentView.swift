//
//  ContentView.swift
//  task_management_application
//
//  Created by Matthew Park on 4/28/24.
//

import SwiftUI

struct Task: Identifiable {
   let id: UUID
   let title: String
   let description: String
   var isCompleted: Bool
}

final class TaskManager: ObservableObject {
   @Published private(set) var tasks: [Task] = []
   
   func addTask(title: String, description: String) {
       let task = Task(id: UUID(), title: title, description: description, isCompleted: false)
       tasks.append(task)
   }
   
   func completeTask(id: UUID) {
       guard let index = tasks.firstIndex(where: { $0.id == id }) else { return }
       tasks[index].isCompleted.toggle()
   }
}

struct TaskListView: View {
   @StateObject private var taskManager = TaskManager()
   @State private var showAddTaskView = false
   
   var body: some View {
       NavigationView {
           List {
               ForEach(taskManager.tasks) { task in
                   TaskRowView(task: task)
                       .onTapGesture {
                           taskManager.completeTask(id: task.id)
                       }
               }
           }
           .navigationTitle("Tasks")
           .toolbar {
               ToolbarItem(placement: .navigationBarTrailing) {
                   Button(action: {
                       showAddTaskView = true
                   }) {
                       Image(systemName: "plus")
                   }
               }
           }
           .sheet(isPresented: $showAddTaskView) {
               AddTaskView(taskManager: taskManager)
           }
       }
   }
}

struct TaskRowView: View {
   let task: Task
   
   var body: some View {
       HStack {
           Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
               .foregroundColor(task.isCompleted ? .green : .gray)
           
           VStack(alignment: .leading) {
               Text(task.title)
                   .font(.headline)
               Text(task.description)
                   .font(.subheadline)
                   .foregroundColor(.gray)
           }
       }
   }
}

struct AddTaskView: View {
   @ObservedObject var taskManager: TaskManager
   @State private var title = ""
   @State private var description = ""
   @Environment(\.presentationMode) var presentationMode
   
   var body: some View {
       NavigationView {
           Form {
               Section(header: Text("Task Details")) {
                   TextField("Title", text: $title)
                   TextField("Description", text: $description)
               }
           }
           .navigationTitle("Add Task")
           .toolbar {
               ToolbarItem(placement: .navigationBarLeading) {
                   Button("Cancel") {
                       presentationMode.wrappedValue.dismiss()
                   }
               }
               ToolbarItem(placement: .navigationBarTrailing) {
                   Button("Save") {
                       taskManager.addTask(title: title, description: description)
                       presentationMode.wrappedValue.dismiss()
                   }
                   .disabled(title.isEmpty)
               }
           }
       }
   }
}

struct ContentView: View {
   var body: some View {
       TaskListView()
   }
}


//struct ContentView_Previews: PreviewProvider {
//   static var previews: some View {
//       ContentView()
//   }
//}

#Preview {
    ContentView()
}
