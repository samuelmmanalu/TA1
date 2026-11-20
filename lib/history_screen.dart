import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/flower_model.dart';
import 'result_screen.dart';
import 'services/history_service.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  String _formatDate(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final y = dt.year.toString();
    return '$d-$m-$y';
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$h:$min';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20.0),
          decoration: BoxDecoration(
            color: const Color(0xFF88C070).withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black87, width: 1),
          ),
          child: ValueListenableBuilder<List<HistoryRecord>>(
            valueListenable: HistoryService.historyNotifier,
            builder: (context, records, _) {
              if (records.isEmpty) {
                return Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.history_toggle_off_rounded,
                          size: 52,
                          color: Color(0xFF2E7D32),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Belum Ada Riwayat Scan',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1B4332),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Hasil bunga yang Anda foto atau unggah akan otomatis tersimpan di sini.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.separated(
                itemCount: records.length,
                separatorBuilder: (context, index) => const SizedBox(height: 22),
                itemBuilder: (context, index) {
                  final record = records[index];
                  final flower = record.matches.first.flower;
                  final imgFile = File(record.imagePath);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 84,
                            height: 84,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black87,
                                width: 1.2,
                              ),
                            ),
                            child: imgFile.existsSync()
                                ? Image.file(imgFile, fit: BoxFit.cover)
                                : const Icon(
                                    Icons.local_florist,
                                    size: 40,
                                    color: Color(0xFF2E7D32),
                                  ),
                          ),
                          IconButton(
                            tooltip: 'Hapus riwayat',
                            onPressed: () =>
                                HistoryService.deleteRecord(record.id),
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.black87,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black87, width: 1.2),
                        ),
                        child: Text(
                          '${flower.name} / ${_formatDate(record.timestamp)} / ${_formatTime(record.timestamp)}',
                          style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Center(
                        child: InkWell(
                          onTap: () {
                            final resultData =
                                HistoryService.toScanResultData(record);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ResultScreen(resultData: resultData),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black87,
                                width: 1.1,
                              ),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Klik',
                              style: GoogleFonts.poppins(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}