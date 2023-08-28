import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class BarcodeScannerPage extends StatefulWidget {
  @override
  _BarcodeScannerPageState createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  TextEditingController _searchController = TextEditingController();

  Future<void> _scanBarcode() async {
    try {
      final String result = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // Color of the toolbar
        'Cancel', // Text for the cancel button
        true, // Show flash icon
        ScanMode.BARCODE, // Scan mode (BARCODE or QR)
      );

      if (!mounted) return;

      setState(() {
        _searchController.text = result;
      });
    } catch (error) {
      setState(() {
        _searchController.text = 'Error: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Barcode Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Scan Result:',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20.0),
            Text(
              _searchController.text,
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Enter barcode',
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        label: Text('Scan Barcode'),
        onPressed: _scanBarcode,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
