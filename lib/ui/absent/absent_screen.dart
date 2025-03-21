import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:absensi/ui/home_screen.dart';

class AbsentScreen extends StatefulWidget {
  const AbsentScreen({super.key});

  @override
  State<AbsentScreen> createState() => _AbsentScreenState();
}

class _AbsentScreenState extends State<AbsentScreen> {
  var categoriesList = <String>[
    "Please Choose:",
    "Others",
    "Permission",
    "Sick",
  ];

  final controllerName = TextEditingController();
  double dLat = 0.0, dLong = 0.0;
  final CollectionReference dataCollection = FirebaseFirestore.instance
      .collection('attendance');

  int dateHours = 0, dateMinutes = 0;
  String dropValueCategories = "Please Choose:";
  final fromController = TextEditingController();
  String strAlamat = '', strDate = '', strTime = '', strDateTime = '';
  final toController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  //show progress dialog
  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: const Text("Please Wait..."),
          ),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  //submit data absent to firebase
  Future<void> submitAbsen(
    String nama,
    String keterangan,
    String from,
    String until,
  ) async {
    // Validasi input sebelum mengirim ke Firebase
    if (nama.isEmpty ||
        keterangan == "Please Choose:" ||
        from.isEmpty ||
        until.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 10),
              Text(
                "Pastikan semua data telah diisi!",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Menampilkan loader
    showLoaderDialog(context);

    try {
      await dataCollection.add({
        'address': '-',
        'name': nama,
        'description': keterangan,
        'datetime': '$from - $until',
        'created_at': FieldValue.serverTimestamp(), // Tambahkan timestamp
      });

      // Tutup loader sebelum menampilkan pesan sukses
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.white),
              SizedBox(width: 10),
              Text(
                "Yeay! Attendance Report Succeeded!",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Kembali ke halaman utama
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      // Jika terjadi error, tutup loader
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Ups, terjadi kesalahan: $e",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 26, 0, 143),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          "Permission Request Menu",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Card(
          color: Colors.white,
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  color: Colors.blueAccent,
                ),
                child: const Row(
                  children: [
                    SizedBox(width: 12),
                    Icon(Icons.maps_home_work_outlined, color: Colors.white),
                    SizedBox(width: 12),
                    Text(
                      "Please Fill out the Form!",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: TextField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  controller: controllerName,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    labelText: "Your Name",
                    hintText: "Please enter your name",
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.blueAccent),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.blueAccent),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Text(
                  "Description",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.blueAccent,
                      style: BorderStyle.solid,
                      width: 1,
                    ),
                  ),
                  child: DropdownButton(
                    dropdownColor: Colors.white,
                    value: dropValueCategories,
                    onChanged: (value) {
                      setState(() {
                        dropValueCategories = value.toString();
                      });
                    },
                    items:
                        categoriesList.map((value) {
                          return DropdownMenuItem(
                            value: value.toString(),
                            child: Text(
                              value.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          );
                        }).toList(),
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    underline: Container(height: 2, color: Colors.transparent),
                    isExpanded: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Text(
                            "From: ",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  builder: (
                                    BuildContext context,
                                    Widget? child,
                                  ) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: const ColorScheme.light(
                                          onPrimary: Colors.white,
                                          onSurface: Colors.white,
                                          primary: Colors.blueAccent,
                                        ),
                                        datePickerTheme:
                                            const DatePickerThemeData(
                                              headerBackgroundColor:
                                                  Colors.blueAccent,
                                              backgroundColor: Color.fromARGB(
                                                255,
                                                0,
                                                0,
                                                0,
                                              ),
                                              headerForegroundColor:
                                                  Colors.white,
                                              surfaceTintColor: Colors.white,
                                            ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(9999),
                                );
                                if (pickedDate != null) {
                                  fromController.text = DateFormat(
                                    'dd/M/yyyy',
                                  ).format(pickedDate);
                                }
                              },
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                              controller: fromController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                hintText: "Starting From",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Row(
                        children: [
                          const Text(
                            "Until: ",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  builder: (
                                    BuildContext context,
                                    Widget? widget,
                                  ) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: const ColorScheme.light(
                                          onPrimary: Colors.white,
                                          onSurface: Colors.white,
                                          primary: Colors.blueAccent,
                                        ),
                                        datePickerTheme:
                                            const DatePickerThemeData(
                                              headerBackgroundColor:
                                                  Colors.blueAccent,
                                              backgroundColor: Color.fromARGB(
                                                255,
                                                0,
                                                0,
                                                0,
                                              ),
                                              headerForegroundColor:
                                                  Colors.white,
                                              surfaceTintColor: Colors.white,
                                            ),
                                      ),
                                      child: widget!,
                                    );
                                  },
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(9999),
                                );
                                if (pickedDate != null) {
                                  toController.text = DateFormat(
                                    'dd/M/yyyy',
                                  ).format(pickedDate);
                                }
                              },
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                              controller: toController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                hintText: "Until",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(30),
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: size.width,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Material(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blueAccent,
                      child: InkWell(
                        splashColor: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          if (controllerName.text.isEmpty ||
                              dropValueCategories == "Please Choose:" ||
                              fromController.text.isEmpty ||
                              toController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "Ups, please fill the form!",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                backgroundColor: Colors.blueAccent,
                                shape: StadiumBorder(),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          } else {
                            submitAbsen(
                              controllerName.text.toString(),
                              dropValueCategories.toString(),
                              fromController.text,
                              toController.text,
                            );
                          }
                        },
                        child: const Center(
                          child: Text(
                            "Make a Request",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
