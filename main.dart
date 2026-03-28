import 'package:flutter/material.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MayTinhLaiSuatApp());
}

class MayTinhLaiSuatApp extends StatelessWidget {
  const MayTinhLaiSuatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Máy tính lãi suất',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const ManHinhChinh(),
    );
  }
}

class ManHinhChinh extends StatefulWidget {
  const ManHinhChinh({super.key});

  @override
  State<ManHinhChinh> createState() => _ManHinhChinhState();
}

class _ManHinhChinhState extends State<ManHinhChinh> {
  final TextEditingController _soTienController = TextEditingController();
  final TextEditingController _laiSuatController = TextEditingController();
  String _ketQua = "-- (Tính toán)";

  void _tinhToan() {
    final double? P = double.tryParse(_soTienController.text);
    final double? r_percent = double.tryParse(_laiSuatController.text);

    if (P == null || r_percent == null || r_percent <= 0) {
      setState(() {
        _ketQua = "Nhập số dương hợp lệ!";
      });
      return;
    }

    double r = r_percent / 100;
    double n_thang = log(2) / log(1 + r);
    double n_nam = n_thang / 12;

    setState(() {
      _ketQua = "${n_nam.toStringAsFixed(2)} năm";
    });

    print("Kết quả: $n_nam năm");
  }

  Future<void> _moWebsite() async {
    final Uri url = Uri.parse('https://google.com');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint("Không thể mở web");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Máy tính lãi suất"),
        centerTitle: true,
        backgroundColor: Colors.teal.shade100,
      ),
      // --- ĐÃ SỬA LỖI ONPRESSED TẠI ĐÂY ---
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Text("MENU", style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text("Giới thiệu apps"),
              onTap: () { // Đã đổi từ onPressed sang onTap
                Navigator.pop(context);
                showAboutDialog(context: context, applicationName: "Máy tính lãi suất");
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text("Thông tin liên hệ"),
              onTap: () { // Đã đổi từ onPressed sang onTap
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Liên hệ: 0123.456.789")),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text("Liên kết đến website"),
              onTap: () { // Đã đổi từ onPressed sang onTap
                Navigator.pop(context);
                _moWebsite();
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _soTienController,
              decoration: const InputDecoration(labelText: "Số tiền gốc", border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _laiSuatController,
              decoration: const InputDecoration(labelText: "Lãi hàng tháng (%)", border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            Text("Số năm để tiền tăng gấp đôi:", style: TextStyle(color: Colors.grey.shade700)),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
              child: Text(_ketQua, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _tinhToan, // Nút bấm thì vẫn dùng onPressed
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white, minimumSize: const Size(200, 50)),
              child: const Text("TÍNH TOÁN"),
            ),
          ],
        ),
      ),
    );
  }
}