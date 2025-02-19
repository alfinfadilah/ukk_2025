import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PdfGenerator extends StatefulWidget {
  final Map cetak;
  final String penjualanId;
  const PdfGenerator({Key? key, required this.cetak, required this.penjualanId})
      : super(key: key);

  @override
  _PdfGeneratorState createState() => _PdfGeneratorState();
}

class _PdfGeneratorState extends State<PdfGenerator> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Cetak Struck"),
      content: Text("Apakah Anda ingin mencetak struck untuk penjualan ini?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Batal"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            generateAndPrintPDF(widget.penjualanId);
          },
          child: Text("Cetak"),
        ),
      ],
    );
  }

  Future<void> generateAndPrintPDF(String penjualanId) async {
    final pdf = pw.Document();

    var responseSales = await Supabase.instance.client
        .from('penjualan')
        .select('*, pelanggan(*), user(*)')
        .eq('PenjualanID', penjualanId)
        .single();

    var responsetotal = await Supabase.instance.client
        .from('penjualan')
        .select()
        .eq('PenjualanID', penjualanId)
        .single();

    var responseSalesDetail = await Supabase.instance.client
        .from('detailpenjualan')
        .select('*, produk(*)')
        .eq('PenjualanID', int.parse(penjualanId));

    String pelangganNama = responseSales['pelanggan'] != null
        ? responseSales['pelanggan']['NamaPelanggan']
        : "Pelanggan Umum Atau Non Member";

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Struck Penjualan Waroeng Pocjok",
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Row(
                children: [
                  pw.Text('Alamat : ', style: pw.TextStyle(fontSize: 18)),
                  pw.Text('JL. Mawar,Desa Sukowilangun,Kec Kalipare', style: pw.TextStyle(fontSize: 18)),
                ]
              ),
              pw.SizedBox(height: 10),
              pw.Text("Pelanggan: $pelangganNama",
                  style: pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 10),
              pw.Text("Petugas Kasir: ${responseSales['user']['Username']}",
                  style: pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 10),
              pw.Text("Tanggal: ${responseSales['TanggalPenjualan']}",
                  style: pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headers: ["Produk", "Jumlah", "Subtotal"],
                data: responseSalesDetail
                    .map((detail) => [
                          detail['produk']['NamaProduk'],
                          detail['JumlahProduk'].toString(),
                          detail['Subtotal'].toString()
                        ])
                    .toList(),
              ),
              pw.Table.fromTextArray(
                data: [
                  ['Total Diskon', responsetotal['Diskon'] ?? 0 .toString()],
                  ['Total Harga', responsetotal['TotalHarga'].toString()],
                ],
                border: pw.TableBorder.all(),
                cellAlignment: pw.Alignment.center,
              ),
              pw.SizedBox(height: 10),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
