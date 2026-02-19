import 'package:flutter/material.dart';
import '../../services/supabase_tables_contents.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ReceiptPage extends StatelessWidget {
  final List<Receipt> receipts;

  const ReceiptPage({Key? key, required this.receipts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipts'),
        centerTitle: true,
      ),
      body: receipts.isEmpty
          ? const Center(child: Text('No receipts found.'))
          : ListView.builder(
              itemCount: receipts.length,
              itemBuilder: (context, index) {
                final receipt = receipts[index];
                return ListTile(
                  title: Text(receipt.receiptNumber ?? 'Receipt'),
                  subtitle: Text('${receipt.amount} ${receipt.currency}'),
                  trailing: Icon(Icons.picture_as_pdf, color: Colors.red),
                  onTap: () {
                    if (receipt.receiptPdf != null && receipt.receiptPdf!.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReceiptPdfViewer(pdfUrl: receipt.receiptPdf!),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No PDF available for this receipt.')),
                      );
                    }
                  },
                );
              },
            ),
    );
  }
}

class ReceiptPdfViewer extends StatelessWidget {
  final String pdfUrl;

  const ReceiptPdfViewer({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Receipt PDF')),
      body: SfPdfViewer.network(pdfUrl),
    );
  }
}
