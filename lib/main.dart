import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(CarMaintenanceApp());
}

class CarMaintenanceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Maintenance',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CarMaintenanceScreen(),
    );
  }
}

class CarMaintenanceScreen extends StatefulWidget {
  @override
  _CarMaintenanceScreenState createState() => _CarMaintenanceScreenState();
}

class _CarMaintenanceScreenState extends State<CarMaintenanceScreen> {
  final List<MaintenanceItem> _items = [];

  void _addItem(String name, DateTime lastChangedDate, String memo) {
    setState(() {
      _items.add(MaintenanceItem(
        name: name,
        lastChangedDate: lastChangedDate,
        memo: memo,
      ));
    });
  }

  void _editItem(int index, String name, DateTime lastChangedDate, String memo) {
    setState(() {
      _items[index] = MaintenanceItem(
        name: name,
        lastChangedDate: lastChangedDate,
        memo: memo,
      );
    });
  }

  void _deleteItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  void _showAddItemDialog() {
    String name = '';
    DateTime lastChangedDate = DateTime.now();
    String memo = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('소모품 추가'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: '소모품 이름'),
                onChanged: (value) => name = value,
              ),
              ListTile(
                title: Text('마지막 교체 날짜: ${DateFormat('yyyy-MM-dd').format(lastChangedDate)}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: lastChangedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      lastChangedDate = selectedDate;
                    });
                  }
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: '메모'),
                onChanged: (value) => memo = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                if (name.isNotEmpty) {
                  _addItem(name, lastChangedDate, memo);
                  Navigator.pop(context);
                }
              },
              child: Text('추가'),
            ),
          ],
        );
      },
    );
  }

  void _showEditItemDialog(int index) {
    String name = _items[index].name;
    DateTime lastChangedDate = _items[index].lastChangedDate;
    String memo = _items[index].memo;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('소모품 수정'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: '소모품 이름'),
                controller: TextEditingController(text: name),
                onChanged: (value) => name = value,
              ),
              ListTile(
                title: Text('마지막 교체 날짜: ${DateFormat('yyyy-MM-dd').format(lastChangedDate)}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: lastChangedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      lastChangedDate = selectedDate;
                    });
                  }
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: '메모'),
                controller: TextEditingController(text: memo),
                onChanged: (value) => memo = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                if (name.isNotEmpty) {
                  _editItem(index, name, lastChangedDate, memo);
                  Navigator.pop(context);
                }
              },
              child: Text('저장'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('자동차 소모품 관리'),
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return ListTile(
            title: Text(item.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('마지막 교체 날짜: ${DateFormat('yyyy-MM-dd').format(item.lastChangedDate)}'),
                if (item.memo.isNotEmpty) Text('메모: ${item.memo}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _showEditItemDialog(index),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteItem(index),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}

class MaintenanceItem {
  final String name;
  final DateTime lastChangedDate;
  final String memo;

  MaintenanceItem({
    required this.name,
    required this.lastChangedDate,
    this.memo = '',
  });
}