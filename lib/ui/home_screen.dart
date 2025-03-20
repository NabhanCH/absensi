import 'package:absensi/ui/order_history_screen/order_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:absensi/ui/attend/attend_screen.dart';
import 'package:absensi/ui/absent/absent_screen.dart';
import 'package:absensi/ui/attendance_history/attendance_history_screen.dart';
import 'package:absensi/ui/form/form_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          SizedBox(
            height: 50,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blueAccent,
                centerTitle: true,
                title: const Text(
                  "Attendance - Flutter App Admin",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          // Content
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: _buildMenuItem(context, 'assets/images/ic_absen.png', "Attendance Record", const AttendScreen()),
                ),
                Expanded(
                  child: _buildMenuItem(context, 'assets/images/ic_form.png', "Formulir",  OrderForm()),
                ),
                Expanded(
                  child: _buildMenuItem(context, 'assets/images/ic_leave.png', "Permission", const AbsentScreen()),
                ),
                Expanded(
                  child: _buildMenuItem(context, 'assets/images/ic_history.png', "Attendance History", const AttendanceHistoryScreen()),
                ),
                Expanded(
                  child: _buildMenuItem(context, 'assets/images/ic_history.png', "Order History",  OrderHistoryScreen()),
                ),
              ],
            ),
          ),

          // Footer
          SizedBox(
            height: 50,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blueAccent,
                centerTitle: true,
                title: const Text(
                  "IDN Boarding School Solo",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
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

  Widget _buildMenuItem(BuildContext context, String imagePath, String title, Widget screen) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage(imagePath),
            height: 100,
            width: 100,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}