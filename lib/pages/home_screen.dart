import 'package:duepopper/hive/hive_functions.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Stores Hive Data on App Runtime
  List myHiveData = [];

  // Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Retrieves data on Hive/local storage
  getHiveData() {
    setState(() {
      myHiveData = HiveFunctions.getAllTasks();
    });
  }

  // Retrieves data on start-up/initialization
  @override
  void initState() {
    super.initState();
    getHiveData();
  }

  // Show Add/Edit Modal Sheet
  void showForm(int? itemKey) async {
    bool? checkedTask;

    if (itemKey != null) {
      final existingItem = myHiveData.firstWhere(
        (element) => element['key'] == itemKey
      );
      _titleController.text = existingItem['title'];
      _descriptionController.text = existingItem['description'];
      checkedTask = existingItem['checked'];
    }
    else {
      _titleController.text = '';
      _descriptionController.text = '';
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 15,
          left: 15,
          right: 15,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                itemKey == null ? 'Add Task' : 'Modify Task',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _titleController,
              maxLines: 1,
              decoration: InputDecoration(
                labelText: 'Task',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _descriptionController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () async {
                if (itemKey == null) {
                  HiveFunctions.addTask({
                    'title': _titleController.text,
                    'description': _descriptionController.text,
                    'checked': false,
                  });
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Added task"),
                  ));
                }
                else {
                  HiveFunctions.modifyTask(itemKey, {
                    'title': _titleController.text,
                    'description': _descriptionController.text,
                    'checked': checkedTask,
                  });
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Modified task"),
                  ));
                }
                Navigator.of(context).pop();
                getHiveData();
              },
              child: Icon(
                itemKey == null ? Icons.add : Icons.check,
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  // Builds the UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.amber,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.amber,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.check,
                        size: 50,
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Due Popper',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Get Poppin'",
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(
                        Icons.copyright,
                        size: 17,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "Rovic Aliman 2024",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  const Icon(Icons.refresh),
                  SizedBox(width: 20),
                  const Text('Refresh'),
                ],
              ),
              onTap: () {
                getHiveData();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: Durations.extralong1,
                  content: Text('Loaded'),
                ));
              },
            ),
            ListTile(
              title: Row(
                children: [
                  const Icon(Icons.delete),
                  SizedBox(width: 20),
                  const Text('Delete all tasks'),
                ],
              ),
              onTap: () {
                if (myHiveData.isEmpty) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    duration: Durations.extralong4,
                    content: Text("There is no task..."),
                  ));
                }
                else {
                  HiveFunctions.deleteAllTasks();
                  getHiveData();
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    duration: Durations.extralong1,
                    content: Text('Deleted all tasks'),
                  ));
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showForm(null);
        },
        backgroundColor: Colors.amber[50],
        label: Text("Add Task"),
        icon: Icon(Icons.add),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: myHiveData.isEmpty
        ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 50,
              ),
              SizedBox(height: 10),
              Text("No tasks for you today"),
            ],
          ),
        )
        : ListView(
          children: List.generate(
            myHiveData.length,
            (index) {
              final taskData = myHiveData[index];
              return Card(
                child: ListTile(
                  leading: Checkbox(
                    value: taskData['checked'],
                    onChanged: (_) {
                      HiveFunctions.updateTaskStatus(taskData['key']);
                      getHiveData();
                    },
                    activeColor: Colors.black,
                  ),
                  title: Text(taskData['title']),
                  subtitle: taskData['description'] == '' ? null : Text(taskData['description']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          showForm(taskData['key']);
                          getHiveData();
                        },
                        icon: const Icon(
                          Icons.create,
                          size: 20,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          HiveFunctions.deleteTask(taskData['key']);
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text('Deleted task'),
                          ));
                          getHiveData();
                        },
                        icon: const Icon(
                          Icons.delete,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}