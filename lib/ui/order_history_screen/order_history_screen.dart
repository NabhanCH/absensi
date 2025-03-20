import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final CollectionReference ordersCollection =
      FirebaseFirestore.instance.collection('orders');

  void _deleteOrder(String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Pesanan"),
        content: const Text("Apakah Anda yakin ingin menghapus pesanan ini?"),
        actions: [
          TextButton(
            onPressed: () async {
              await ordersCollection.doc(docId).delete();
              Navigator.pop(context);
            },
            child: const Text("Ya", style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tidak", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Riwayat Pesanan",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 26, 0, 143),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: ordersCollection.orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Terjadi kesalahan!"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Tidak ada pesanan."));
          }

          var orders = snapshot.data!.docs;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var order = orders[index];
              var data = order.data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  title: Text("${data['product']} (${data['quantity']})"),
                  subtitle: Text("Nama: ${data['name']}\nAlamat: ${data['address']}"),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteOrder(order.id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}