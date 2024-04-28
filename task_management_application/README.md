#  Task Management Application

## Introduction

Swift is a powerful and intuitive programming language developed by Apple for iOS, macOS, watchOS, and tvOS development. It offers a clean and expressive syntax, strong typing, and a range of modern features that make it an attractive choice for developers. In this project, we will explore Swift's capabilities by building a task management application using SwiftUI, a modern framework for creating user interfaces.

## Features
The task management application will include the following features
- Add new tasks with a title and description
- Mark tasks as completed
- View a list of tasks with their completion status
- Use SwiftUI for a declarative and interactive user interface

## Code Implementation

### Task Model

```swift
import Foundation

struct Task: Identifiable {
    let id: UUID
    let title: String
    let description: String
    let isCompleted: Bool
}
```

### Task Manager

```swift
import Foundation

final class TaskManager: ObservableObject {
    @Published private(set) var tasks: [Task] = []
    
    func addTask(title: String, description: String) {
        let task = Task(id: UUID(), title: title, description: description, isCompleted: false)
        task.append(task)
    }
    
    func completedTask(id: UUID) {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else { return }
        task[index].isCompleted.toggle()
    }
}
```

### User Interface

```swift
import SwiftUI

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
            Image(systemName: task.isComplete ? "checkmark.circle.fill" : "circle")
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
    @ObservableObject var taskManager: TaskManager
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
                        presentation.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    taskManager.addTask(title: title, description: description)
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(title.isEmpty)
            }
        }
    }
}
```

### Main App

```swift
import SwiftUI

@main
struct TaskManagementApp: App {
    var body: some Scene {
        WindowGroup {
            TaskListView()
        }
    }
}
```

### Analysis and Insights

#### Strengths of Swift (The programming language) and SwiftUI (user interface framework)
- Swift's strong typing and optional handling promote code safety and help prevent common programming errors
- SwiftUI's declarative syntax makes it easy to create and maintain user interfaces.
- The `@StateObject`, `@ObservedObject`, and `@State` property wrappers in SwiftUI enable seamless data synchronization between model and views.
- SwiftUI's built-in views and modifiers provide a rich set of tools for building interactive and visually appealing user interfaces.

#### Potential Enhancements
- Implement data persistence using Core Data or a database to store tasks across app launches
- Add the ability to edit and delete tasks.
- Implement task filtering and sorting based on various criteria.
- Integrate with a backend server to sync tasks across multiple devices.

### Conclusion

Through this project, we explored Swift's capabilities and the power of SwiftUI in building a task management application. We demonstrated how to create a data model, manage tasks using an observable object, and build an interactive user interface using SwiftUI's declarative syntax.

Swift's strong typing, optional handling, and modern features, combined with SwiftUI's declarative approach, make it an excellent choice for developing robust and user-friendly applications for Apple's platforms.

The task management application serves as a foundation that can be further enhanced and expanded to include additional features and improvements based on specific requirements and user feedback.

GitHub Repository
The complete source code for the task management application can be found in the GitHub repository:
https://github.com/mattpark01/swift-task-manager
