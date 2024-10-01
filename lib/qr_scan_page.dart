import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ticket_details_page.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QRScanPage extends StatefulWidget {
  const QRScanPage({Key? key}) : super(key: key);

  @override
  _QRScanPageState createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? bearerToken; // Ganti menjadi nullable
  bool isScanning = true; // Tambahkan variabel status pemindaian

  @override
  void initState() {
    super.initState();
    _loadToken(); // Panggil metode untuk memuat token
  }

  Future<void> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      bearerToken =
          prefs.getString('token'); // Ambil token dari SharedPreferences
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    // Memulai pemindaian QR
    _startScanning(controller);
  }

  void _startScanning(QRViewController controller) {
    controller.scannedDataStream.listen((scanData) async {
      // Hanya panggil API jika kode tidak kosong dan belum dipindai sebelumnya
      if (isScanning && scanData.code != null) {
        String kodeTiket =
            scanData.code!; // Pakai ! untuk mengekstrak nilai non-null
        isScanning = false; // Set status pemindaian menjadi false
        await _fetchTicketData(kodeTiket);
      }
    });
  }

  Future<void> _fetchTicketData(String kodeTiket) async {
    try {
      final response = await http.post(
        Uri.parse('https://asdpbaubau.my.id/api/qrcode'),
        headers: {
          'Authorization': 'Bearer $bearerToken', // Tambahkan Bearer Token
          'Content-Type': 'application/json',
        },
        body: json
            .encode({'kode_tiket': kodeTiket}), // Kirim data dalam format JSON
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Navigasi ke halaman baru dengan data tiket
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TicketDetailsPage(ticketData: data),
          ),
        );
      } else {
        // Jika status code bukan 200, tampilkan pesan kesalahan
        _showErrorDialog('Tiket tidak ditemukan.');
      }
    } catch (e) {
      // Tampilkan pesan kesalahan jika terjadi kesalahan dalam permintaan
      _showErrorDialog('Terjadi kesalahan: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Mengizinkan pemindaian ulang ketika halaman ini muncul kembali
    isScanning = true; // Set status pemindaian menjadi true
    controller?.resumeCamera(); // Resume pemindaian
  }
}
