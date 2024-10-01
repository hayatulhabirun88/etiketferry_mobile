import 'package:flutter/material.dart';

class TicketDetailsPage extends StatelessWidget {
  final Map<String, dynamic> ticketData;

  const TicketDetailsPage({Key? key, required this.ticketData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Kembali ke halaman HomePage
        Navigator.of(context).popUntil((route) => route.isFirst);
        return false; // Mencegah pop default
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detail Tiket'),
          backgroundColor: Colors.blueAccent, // Warna app bar
        ),
        body: Container(
          color: Colors.grey[100], // Warna latar belakang
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              Card(
                elevation: 6, // Efek bayangan
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0), // Sudut melengkung
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.confirmation_number,
                              color:
                                  Colors.blueAccent), // Ikon untuk kode tiket
                          const SizedBox(
                              width: 10), // Jarak antara ikon dan teks
                          Expanded(
                            child: Text(
                              'Kode Tiket: ${ticketData['data']['kode_tiket']}',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                      const Divider(), // Garis pemisah
                      Row(
                        children: [
                          Icon(Icons.price_check,
                              color:
                                  Colors.blueAccent), // Ikon untuk harga tiket
                          const SizedBox(
                              width: 10), // Jarak antara ikon dan teks
                          Expanded(
                            child: Text(
                              'Harga Tiket: ${ticketData['data']['harga_tiket']}',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                      const Divider(), // Garis pemisah
                      Row(
                        children: [
                          Icon(Icons.local_offer,
                              color: Colors.blueAccent), // Ikon untuk fasilitas
                          const SizedBox(
                              width: 10), // Jarak antara ikon dan teks
                          Expanded(
                            child: Text(
                              'Fasilitas: ${ticketData['data']['fasilitas']}',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                      const Divider(), // Garis pemisah
                      Row(
                        children: [
                          Icon(Icons.directions_car,
                              color: Colors.blueAccent), // Ikon untuk kendaraan
                          const SizedBox(
                              width: 10), // Jarak antara ikon dan teks
                          Expanded(
                            child: Text(
                              'Kendaraan: ${ticketData['data']['kendaraan']}',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                      const Divider(), // Garis pemisah
                      Row(
                        children: [
                          Icon(Icons.dashboard,
                              color: Colors.blueAccent), // Ikon untuk plat
                          const SizedBox(
                              width: 10), // Jarak antara ikon dan teks
                          Expanded(
                            child: Text(
                              'Plat: ${ticketData['data']['plat']}',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                      const Divider(), // Garis pemisah
                      Row(
                        children: [
                          Icon(Icons.person,
                              color: Colors.blueAccent), // Ikon untuk penumpang
                          const SizedBox(
                              width: 10), // Jarak antara ikon dan teks
                          Expanded(
                            child: Text(
                              'Penumpang: ${ticketData['data']['penumpang']['nama_penumpang']}',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                      // Tambahkan informasi lain yang diperlukan sesuai data respons
                    ],
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
