import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HorizontalWidget extends StatefulWidget {
  final String studentId;

  const HorizontalWidget({Key? key, required this.studentId}) : super(key: key);

  @override
  _HorizontalWidgetState createState() => _HorizontalWidgetState();
}

class _HorizontalWidgetState extends State<HorizontalWidget>
    with SingleTickerProviderStateMixin {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('subjects');
  List<Map<String, dynamic>> modulesData = [];

  final List<Color> moduleColors = [
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.purpleAccent,
    Colors.orangeAccent,
    Colors.redAccent,
  ];

  late AnimationController _animationController;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _animations = [];

    _fetchModulesData();
  }

  void _fetchModulesData() async {
    try {
      DatabaseEvent event =
          await _databaseReference.child(widget.studentId).once();
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        setState(() {
          modulesData = data.entries.map((entry) {
            var value = entry.value;
            return {
              'subject': entry.key,
              'percentage': (value['percentage'] ?? 0.0) / 100.0,
              'presentDates': value['presentDates'] ?? 0,
              'absentDates': value['absentDates'] ?? 0,
            };
          }).toList();

          _animations = modulesData.map((module) {
            return Tween<double>(begin: 0, end: module['percentage']).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeOut,
              ),
            );
          }).toList();

          _animationController.forward();
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
        SnackBar(content: Text('Failed to load data: $e')),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.25, // Responsive height
      child: modulesData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: modulesData.length,
              itemBuilder: (context, index) {
                var module = modulesData[index];
                var color = moduleColors[index % moduleColors.length];
                return Container(
                  width: screenWidth * 0.85, // Adjusted to fit screen width
                  margin: const EdgeInsets.symmetric(
                      horizontal: 5), // Add small margin to avoid overflow
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: color.withOpacity(0.2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(
                        15.0), // Reduce padding to fit better
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          module['subject'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize:
                                screenWidth * 0.045, // Responsive font size
                            color: color,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AnimatedBuilder(
                              animation: _animationController,
                              builder: (context, child) {
                                return CircularPercentIndicator(
                                  radius:
                                      screenWidth * 0.25, // Responsive radius
                                  lineWidth: screenWidth *
                                      0.05, // Responsive line width
                                  percent: _animations[index].value,
                                  center: Text(
                                    "${(_animations[index].value * 100).toStringAsFixed(0)}%",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenWidth *
                                          0.04, // Responsive font size
                                    ),
                                  ),
                                  progressColor: color,
                                );
                              },
                            ),
                            Flexible(
                              // Use Flexible to prevent overflow
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Present Count: ${module['presentDates']}',
                                    style: TextStyle(
                                      fontSize: screenWidth *
                                          0.04, // Responsive font size
                                      fontWeight: FontWeight.bold,
                                      color:
                                          const Color.fromARGB(255, 8, 3, 80),
                                    ),
                                  ),
                                  Text(
                                    'Absent Count: ${module['absentDates']}',
                                    style: TextStyle(
                                      fontSize: screenWidth *
                                          0.04, // Responsive font size
                                      fontWeight: FontWeight.bold,
                                      color:
                                          const Color.fromARGB(255, 168, 5, 5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
