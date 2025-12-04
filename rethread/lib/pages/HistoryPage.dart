import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rethread/common/colors.dart';
import 'package:rethread/common/fonts.dart';
import 'package:rethread/database/Database.dart';
import 'package:rethread/pages/summarypage.dart';
import 'dart:io';

import 'package:rethread/templates/TemplateBackground.dart';
import 'package:rethread/widgets/navbar.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<ScanRecord> scanHistory = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() {
      isLoading = true;
    });

    final db = ScanHistoryDatabase.instance;
    final scans = await db.getAllScans();
    
    setState(() {
      scanHistory = scans.map((scan) => ScanRecord.fromMap(scan)).toList();
      isLoading = false;
    });
  }

  Future<void> _deleteScan(int id) async {
    await ScanHistoryDatabase.instance.deleteScan(id);
    _loadHistory(); // Reload the list
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Scan deleted')),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy - hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundBlue,
        title: Text('Scan History', style: PrevPageText,),
        iconTheme: IconThemeData(
          color: Colors.white
        ),
      ),
      body: Stack(
        children: [
                TemplateBackground01(),
                isLoading
                ? Center(child: CircularProgressIndicator())
                : scanHistory.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.history, size: 80, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'No scan history yet',
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadHistory,
                        child: ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: scanHistory.length,
                          itemBuilder: (context, index) {
                            final record = scanHistory[index];
                            return Container(
                              margin: EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Image
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    child: Image.file(
                                      File(record.imagePath),
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          height: 200,
                                          color: Colors.grey[300],
                                          child: Icon(Icons.broken_image, size: 50),
                                        );
                                      },
                                    ),
                                  ),
                                  
                                  // Content
                                  Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Classification and Delete Button Row
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.blue[100],
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                record.classification.toUpperCase(),
                                                style: TextStyle(
                                                  color: Colors.blue[900],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.delete, color: Colors.red),
                                              onPressed: () => _deleteScan(record.id!),
                                            ),
                                          ],
                                        ),
                                        
                                        SizedBox(height: 8),
                                        
                                        // Timestamp
                                        Text(
                                          _formatDateTime(record.timestamp),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                          ),
                                        ),
                                        
                                        SizedBox(height: 8),
                                        
                                        // View More Button
                                        TextButton(
                                          onPressed: () {
                                            // Show full description in dialog
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Summarypage(
                                                  imagePath: record.imagePath,
                                                  classification: record.classification,
                                                  aiDescription: record.aiDescription,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text('View Summary Page'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
        ],
      ),
      bottomNavigationBar: Navbar(),

    );
  }
}