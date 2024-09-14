
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the date

class MayaiPage extends StatefulWidget {
  const MayaiPage({super.key});

  @override
  State<MayaiPage> createState() => _MayaiPageState();
}

class _MayaiPageState extends State<MayaiPage> {
  final TextEditingController _idadiController = TextEditingController();
  final TextEditingController _yaliyoHaribikaController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  int _calculateMazima(int idadi, int yaliyoHaribika) {
    return idadi - yaliyoHaribika;
  }

  void _saveData() async {

    final int idadi = int.tryParse(_idadiController.text) ?? 0;
    final int yaliyoHaribika = int.tryParse(_yaliyoHaribikaController.text) ?? 0;
    final int mazima = _calculateMazima(idadi, yaliyoHaribika);

   
  }

  void _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
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
          'Rekodi mayai',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                // child: StreamBuilder<QuerySnapshot>(
                //   stream: FirebaseFirestore.instance
                //       .collection('users')
                //       .doc(userId)
                //       .collection('mayai')
                //       .snapshots(),
                //   builder: (context, snapshot) {
                //     if (snapshot.hasError) {
                //       return Text('Error: ${snapshot.error}');
                //     }

                //     if (snapshot.connectionState == ConnectionState.waiting) {
                //       return CircularProgressIndicator();
                //     }

                //     final docs = snapshot.data?.docs ?? [];
                //     return Table(
                //       border: TableBorder.all(color: Colors.black12, width: 1),
                //       columnWidths: {
                //         0: FlexColumnWidth(3),
                //         1: FlexColumnWidth(2),
                //         2: FlexColumnWidth(2),
                //       },
                //       children: [
                //         TableRow(
                //           decoration: BoxDecoration(color: Colors.black12),
                //           children: [
                //             Padding(
                //               padding: const EdgeInsets.all(8.0),
                //               child: Text('Tarehe', style: TextStyle(fontWeight: FontWeight.bold)),
                //             ),
                //             Padding(
                //               padding: const EdgeInsets.all(8.0),
                //               child: Text('Idadi', style: TextStyle(fontWeight: FontWeight.bold)),
                //             ),
                //             Padding(
                //               padding: const EdgeInsets.all(8.0),
                //               child: Text('Mazima', style: TextStyle(fontWeight: FontWeight.bold)),
                //             ),
                //           ],
                //         ),
                //         for (var doc in docs)
                //           TableRow(
                //             children: [
                //               Padding(
                //                 padding: const EdgeInsets.all(8.0),
                //                 child: Text(
                //               'date',
                //                 ),
                //               ),
                //               Padding(
                //                 padding: const EdgeInsets.all(8.0),
                //                 child: Text('${doc['idadi'] ?? 'N/A'}'),
                //               ),
                //               Padding(
                //                 padding: const EdgeInsets.all(8.0),
                //                 child: Text('${doc['mazima'] ?? 'N/A'}'),
                //               ),
                //             ],
                //           ),
                //       ],
                //     );
                //   },
                // ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Jumla ya tray za mayai mwezi huu', style: TextStyle(fontSize: 16)),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  // child: StreamBuilder<int>(
                  //   // stream: _getTotalTraysStream(),
                  //   builder: (context, snapshot) {
                  //     if (snapshot.hasError) {
                  //       return Text('Error: ${snapshot.error}');
                  //     }

                  //     if (snapshot.connectionState == ConnectionState.waiting) {
                  //       return CircularProgressIndicator();
                  //     }

                  //     int totalTrays = snapshot.data ?? 0;
                  //     return Text(
                  //       '$totalTrays',
                  //       style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  //     );
                  //   },
                  // ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton.extended(
                onPressed: () {
                  _showAddMayaiBottomSheet(context);
                },
                icon: Icon(Icons.add),
                label: Text('Ongeza'),
              ),
            ),
          ],
        ),
      ),
    );
  }



  void _showAddMayaiBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 20), // spacer to center the title
                  Text(
                    'Rekodi mayai',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _idadiController,
                decoration: InputDecoration(
                  labelText: 'Idadi*',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _yaliyoHaribikaController,
                decoration: InputDecoration(
                  labelText: 'Yaliyo haribika*',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Tarehe',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                controller: TextEditingController(
                  text: "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                ),
                onTap: () {
                  _pickDate(context);
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Save', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }
}
