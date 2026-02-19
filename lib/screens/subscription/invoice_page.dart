import 'package:flutter/material.dart';
import '../../services/supabase_tables_contents.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class InvoicePage extends StatelessWidget {
  final List<Invoice> invoices;

  const InvoicePage({Key? key, required this.invoices}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoices'),
        centerTitle: true,
      ),
      body: invoices.isEmpty
          ? const Center(child: Text('No invoices found.'))
          : ListView.builder(
              itemCount: invoices.length,
              itemBuilder: (context, index) {
                final invoice = invoices[index];
                return ListTile(
                  title: Text(invoice.invoiceNumber ?? 'Invoice'),
                  subtitle: Text('${invoice.amountDue} ${invoice.currency}'),
                  trailing: Icon(Icons.picture_as_pdf, color: Colors.red),
                  onTap: () {
                    if (invoice.invoicePdf != null && invoice.invoicePdf!.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InvoicePdfViewer(pdfUrl: invoice.invoicePdf!),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No PDF available for this invoice.')),
                      );
                    }
                  },
                );
              },
            ),
    );
  }
}

class InvoicePdfViewer extends StatelessWidget {
  final String pdfUrl;

  const InvoicePdfViewer({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Invoice PDF')),
      body: SfPdfViewer.network(pdfUrl),
    );
  }
}
