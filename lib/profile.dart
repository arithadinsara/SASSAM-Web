import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'description.dart';

class Profile extends StatefulWidget {
  final String studentId;

  const Profile({Key? key, required this.studentId}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('Users');
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _regNumberController = TextEditingController();
  final TextEditingController _batchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchStudentData();
  }

  void _fetchStudentData() async {
    try {
      DatabaseEvent event =
          await _databaseReference.child(widget.studentId).once();
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        Map<dynamic, dynamic> studentData =
            snapshot.value as Map<dynamic, dynamic>;

        setState(() {
          _nameController.text = studentData['FullName'] ?? '';
          _usernameController.text = studentData['username'] ?? '';
          _emailController.text = studentData['email'] ?? '';
          _regNumberController.text = studentData['IndexNo'] ?? '';
          _batchController.text = studentData['batch'] ?? '';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('No data found for student ID: ${widget.studentId}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load student data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 106, 85, 140),
                Color(0xff281537),
              ]),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 60.0, left: 22),
              child: Text(
                'My Profile\nDetails',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18),
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        TextField(
                          controller: _nameController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.check, color: Colors.grey),
                            label: Text(
                              'Name',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 106, 85, 140),
                              ),
                            ),
                          ),
                        ),
                        TextField(
                          controller: _usernameController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.check, color: Colors.grey),
                            label: Text(
                              'User Name',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 106, 85, 140),
                              ),
                            ),
                          ),
                        ),
                        TextField(
                          controller: _emailController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.mail, color: Colors.grey),
                            label: Text(
                              'Email',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 106, 85, 140),
                              ),
                            ),
                          ),
                        ),
                        TextField(
                          controller: _regNumberController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.type_specimen_rounded,
                                color: Colors.grey),
                            label: Text(
                              'Reg Number',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 106, 85, 140),
                              ),
                            ),
                          ),
                        ),
                        TextField(
                          controller: _batchController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.type_specimen_rounded,
                                color: Colors.grey),
                            label: Text(
                              'Batch',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 106, 85, 140),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Description(studentId: widget.studentId)),
                            );
                          },
                          child: Container(
                            height: 55,
                            width: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(colors: [
                                Color.fromARGB(255, 106, 85, 140),
                                Color.fromARGB(255, 184, 168, 210),
                              ]),
                            ),
                            child: const Center(
                              child: Text(
                                'Continue',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        const Align(
                          alignment: Alignment.bottomRight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Attendance Management System",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                              Text(
                                "LNBTI",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
