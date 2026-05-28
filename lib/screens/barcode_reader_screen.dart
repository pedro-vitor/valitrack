import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeReaderScreen extends StatefulWidget {
  const BarcodeReaderScreen({super.key});

  @override
  State<BarcodeReaderScreen> createState() => _BarcodeReaderScreenState();
}

class _BarcodeReaderScreenState extends State<BarcodeReaderScreen> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leitor de Código de Barras')),
      body: MobileScanner(
        onDetect: (capture) {
          if (_isProcessing) return; // Evita múltiplas detecções

          _isProcessing = true; // Marca que está processando

          final Barcode barCode = capture.barcodes.first;
          final String code = barCode.rawValue ?? '';
          Navigator.pop(context, code); // Retorna o código para a tela anterior
        },
      ),
    );
  }
}
