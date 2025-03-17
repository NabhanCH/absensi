import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderForm extends StatefulWidget {
  @override
  _OrderFormState createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _submitOrder() {
    String name = _nameController.text;
    String product = _productController.text;
    String quantity = _quantityController.text;
    String address = _addressController.text;

    if (name.isNotEmpty && product.isNotEmpty && quantity.isNotEmpty && address.isNotEmpty) {
      _firestore.collection('orders').add({
        'name': name,
        'product': product,
        'quantity': quantity,
        'address': address,
        'timestamp': FieldValue.serverTimestamp(),
      }).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pesanan berhasil dikirim!', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.green,
          ),
        );
        _nameController.clear();
        _productController.clear();
        _quantityController.clear();
        _addressController.clear();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim pesanan: $error')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harap isi semua bidang!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Form Pemesanan Barang',
          style: TextStyle(color: Colors.white), // Warna teks putih
        ),
        backgroundColor: Color.fromARGB(255, 26, 0, 143), // Warna biru tua
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFE3F2FD)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header dalam Card (Full Background Biru Tua)
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent, // Warna biru tua
                      borderRadius: BorderRadius.vertical(top: Radius.circular(12)), // Supaya bagian atas melengkung
                    ),
                    child: Center(
                      child: Text(
                        'Isi Detail Pemesanan',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 10),
                        // Input Fields
                        _buildTextField(_nameController, 'Nama Pemesan', Icons.person),
                        _buildTextField(_productController, 'Nama Barang', Icons.shopping_cart),
                        _buildTextField(_quantityController, 'Jumlah', Icons.format_list_numbered, isNumber: true),
                        _buildTextField(_addressController, 'Alamat Pengiriman', Icons.location_on),

                        SizedBox(height: 20),

                        // Submit Button
                        ElevatedButton.icon(
                          onPressed: _submitOrder,
                          icon: Icon(Icons.send, color: Colors.white),
                          label: Text('Kirim Pesanan', style: TextStyle(fontSize: 16)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
