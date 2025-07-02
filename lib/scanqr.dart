import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:firebase_database/firebase_database.dart';
import 'description.dart';
import 'dart:convert';

class scanqr extends StatefulWidget {
  final String studentId;

  const scanqr({Key? key, required this.studentId}) : super(key: key);
  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<scanqr> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? qrText;
  final DatabaseReference database = FirebaseDatabase.instance.ref();
  bool isUpdating = false; 
  bool scanStarted = false; 

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.pauseCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child:
                  qrText != null ? const Text('') : const Text('Scan a code'),
            ),
          ),
          SizedBox(height: 15),
          SizedBox(
            width: 300,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 106, 85, 140),
                    Color.fromARGB(255, 33, 33, 34),
                  ],
                ),
              ),
              child: ElevatedButton(
                onPressed: () {
                  _startScan(); // Start scanning when the button is pressed
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: const Text(
                  'Scan',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 15), // Add spacing between buttons
          SizedBox(
            width: 300,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 106, 85, 140),
                    Color.fromARGB(255, 33, 33, 34),
                  ],
                ),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Description(studentId: widget.studentId),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: const Text(
                  'Back',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanStarted && qrText == null) {
        setState(() {
          qrText = scanData.code;
        });

        if (qrText != null && !isUpdating) {
          // Check if update is in progress
          try {
            // Parse JSON data from QR code
            final Map<String, dynamic> qrData = jsonDecode(qrText!);
            final String lecId = qrData['LecId'];
            final String lecDt = qrData['LecDt'];

            // Update Firebase with scanned data
            _updateFirebase(widget.studentId, lecId, lecDt);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error parsing QR code: $e')),
            );
          }
        }
      }
    });
  }

  void _startScan() {
    setState(() {
      scanStarted = true;
      qrText = null; // Reset the QR text
    });

    if (controller != null) {
      controller!.resumeCamera(); // Resume camera to scan QR code
    }
  }

  void _updateFirebase(String studentId, String lecId, String lecDt) async {
    setState(() {
      isUpdating = true; // Set flag to true
    });

    try {
      // Fetch the student's full name from Firebase
      DatabaseReference studentRef =
          database.child('Users').child(studentId).child('FullName');
      DataSnapshot snapshot = await studentRef.get();

      if (snapshot.exists) {
        String studentName = snapshot.value as String;

        await database
            .child('Attendence-QRDetails')
            .child(studentId)
            .push()
            .set({
          'LecId': lecId,
          'LecDt': lecDt,
          'StudentId': studentId,
          'name': studentName,
          'timestamp': DateTime.now().toIso8601String(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Attendance marked successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Student not found')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating attendance: $e')),
      );
    } finally {
      setState(() {
        isUpdating = false; // Reset flag
        scanStarted = false; // Reset scan flag
        qrText = null; // Reset QR text
      });

      if (controller != null) {
        controller!.pauseCamera(); // Pause camera after updating
      }
    }
  }
}
