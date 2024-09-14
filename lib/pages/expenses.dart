// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class MatumiziPage extends StatefulWidget {
  const MatumiziPage({super.key});

  @override
  _MatumiziPageState createState() => _MatumiziPageState();
}

class _MatumiziPageState extends State<MatumiziPage> {
  String _selectedFilter = 'Zote';
  DateTime? _startDate;
  DateTime? _endDate;

  void _onFilterSelected(String filter) async {
    if (filter == "Jichagulie") {
      final picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime.now(),
        initialDateRange: DateTimeRange(
          start: DateTime.now().subtract(Duration(days: 7)),
          end: DateTime.now(),
        ),
      );

      if (picked != null) {
        setState(() {
          _startDate = picked.start;
          _endDate = picked.end;
          _selectedFilter = filter;
        });
      }
    } else {
      setState(() {
        _selectedFilter = filter;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Matumizi",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFilterButton(context, "Zote", Colors.blue.shade100),
                _buildFilterButton(context, "Wiki", Colors.blue.shade100),
                _buildFilterButton(context, "Mwezi", Colors.blue.shade100),
                _buildFilterButton(context, "Jichagulie", Colors.green.shade100),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: RecentMatumizi(
                filter: _selectedFilter,
                startDate: _startDate,
                endDate: _endDate,
              ),
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton.extended(
                backgroundColor: Colors.teal,
                onPressed: () {
                  _showBottomSheet(context);
                },
                icon: Icon(Icons.add, color: Colors.white),
                label: Text(
                  "Ongeza",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context, String title, Color color) {
    return GestureDetector(
      onTap: () {
        _onFilterSelected(title);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return MatumiziForm(onSaved: () {
          setState(() {}); // Refresh the list when saved
        });
      },
    );
  }
}

class RecentMatumizi extends StatelessWidget {
  final String filter;
  final DateTime? startDate;
  final DateTime? endDate;

  RecentMatumizi({
    required this.filter,
    this.startDate,
    this.endDate,
    super.key,
  });

  Future<List<Map<String, dynamic>>> _fetchExpenses() async {
    final response = await http.get(Uri.parse('https://directus-fuga.smarcrib.site/items/expenses'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['data']);
    } else {
      throw Exception('Failed to load expenses');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchExpenses(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data ?? [];
        // Apply filters to the data
        List<Map<String, dynamic>> filteredData = data.where((item) {
          DateTime itemDate = DateTime.parse(item['date_created']);
          if (filter == "Wiki" && itemDate.isBefore(DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)))) {
            return false;
          } else if (filter == "Mwezi" && itemDate.isBefore(DateTime(DateTime.now().year, DateTime.now().month, 1))) {
            return false;
          } else if (filter == "Jichagulie" && (startDate != null && endDate != null) && (itemDate.isBefore(startDate!) || itemDate.isAfter(endDate!))) {
            return false;
          }
          return true;
        }).toList();

        return ListView.builder(
          itemCount: filteredData.length,
          itemBuilder: (context, index) {
            var record = filteredData[index];
            return MatumiziItem(data: record);
          },
        );
      },
    );
  }
}

class MatumiziItem extends StatelessWidget {
  final Map<String, dynamic> data;

  const MatumiziItem({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.parse(data['date_created']);
    String formattedDate = DateFormat('d MMM yyyy').format(date);
    String category = data['type'] ?? 'Unknown';
    double amount = double.tryParse(data['amount'] ?? '0') ?? 0.0;

    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formattedDate,
                style: TextStyle(color: Colors.grey.shade700),
              ),
              SizedBox(height: 4),
              Text(
                category,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Text(
            '${amount.toStringAsFixed(2)} Tsh',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class MatumiziForm extends StatefulWidget {
  final VoidCallback onSaved;

  const MatumiziForm({required this.onSaved, super.key});

  @override
  _MatumiziFormState createState() => _MatumiziFormState();
}

class _MatumiziFormState extends State<MatumiziForm> {
  final _formKey = GlobalKey<FormState>();
  String? _category;
  double? _amount;
  DateTime _selectedDate = DateTime.now();

  Future<void> _saveMatumizi() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final response = await http.post(
        Uri.parse('https://directus-fuga.smarcrib.site/items/expenses'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'type': _category,
          'amount': _amount?.toString(),
          'date_created': _selectedDate.toUtc().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        widget.onSaved(); 
        Navigator.pop(context);
      } else {
        
        print('Failed to save expense: ${response.body}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                _categoryButton(context, 'Vifaranga'),
                _categoryButton(context, 'Chakula'),
                _categoryButton(context, 'Dawa'),
                _categoryButton(context, 'Chanjo'),
                _categoryButton(context, 'Usafiri'),
                _categoryButton(context, 'Umeme'),
                _categoryButton(context, 'Umeme'),

              ],
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Gharama iliyotumika*',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tafadhali ingiza gharama';
                }
                return null;
              },
              onSaved: (value) {
                _amount = double.tryParse(value!);
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Tarehe',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null && pickedDate != _selectedDate) {
                  setState(() {
                    _selectedDate = pickedDate;
                  });
                }
              },
              controller: TextEditingController(
                text: DateFormat('yyyy-MM-dd').format(_selectedDate),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
              onPressed: _saveMatumizi,
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryButton(BuildContext context, String category) {
    return ChoiceChip(
      label: Text(category),
      selected: _category == category,
      onSelected: (selected) {
        setState(() {
          _category = selected ? category : null;
        });
      },
    );
  }
}