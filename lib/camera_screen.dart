import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'result_screen.dart';
import 'services/flower_classifier.dart';
import 'services/history_service.dart';

class CameraScreen extends StatefulWidget {
  final VoidCallback onCloseToHome;

  const CameraScreen({super.key, required this.onCloseToHome});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  String? _errorMessage;
  XFile? _capturedPhoto;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _errorMessage = 'Kamera tidak ditemukan pada perangkat.');
        return;
      }

      // Gunakan kamera belakang
      final backCamera = cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await controller.initialize();
      if (!mounted) return;

      setState(() {
        _controller = controller;
        _isCameraInitialized = true;
        _errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Izin kamera diperlukan untuk memindai bunga.';
      });
    }
  }

  Future<void> _takePicture() async {
    final controller = _controller;
    if (controller == null ||
        !controller.value.isInitialized ||
        controller.value.isTakingPicture) {
      return;
    }

    try {
      final photo = await controller.takePicture();
      setState(() {
        _capturedPhoto = photo;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil gambar: $e')),
      );
    }
  }

  Future<void> _confirmAndAnalyze() async {
    if (_capturedPhoto == null || _isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      final result = await FlowerClassifier.classifyImage(_capturedPhoto!.path);
      await HistoryService.saveScanResult(result);

      if (!mounted) return;
      setState(() {
        _isProcessing = false;
        _capturedPhoto = null;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(resultData: result),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isProcessing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menganalisis foto: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: Column(
            children: [
              // Area Viewfinder Kamera Aktif / Preview Hasil Jepretan
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      width: double.infinity,
                      color: Colors.black,
                      child: _buildCameraContent(),
                    ),
                  ),
                ),
              ),

              // 3 Tombol Kontrol Bawah: Silang (X), Jepret (O), Centang (✓)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Tombol Silang: Ulangi foto jika sudah jepret, atau kembali ke Beranda
                    _CircleControlButton(
                      icon: Icons.close_rounded,
                      size: 52,
                      iconSize: 30,
                      backgroundColor: Colors.white.withValues(alpha: 0.9),
                      iconColor: Colors.black87,
                      onTap: () {
                        if (_capturedPhoto != null) {
                          setState(() => _capturedPhoto = null);
                        } else {
                          widget.onCloseToHome();
                        }
                      },
                    ),

                    // Tombol Bulat Tengah untuk Mengambil Gambar
                    GestureDetector(
                      onTap: _capturedPhoto == null ? _takePicture : null,
                      child: Container(
                        width: 74,
                        height: 74,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: _capturedPhoto == null
                                ? const Color(0xFF2E7D32)
                                : Colors.grey,
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _capturedPhoto == null
                                ? const Color(0xFF2E7D32)
                                : Colors.grey.shade300,
                          ),
                          child: Icon(
                            _capturedPhoto == null
                                ? Icons.camera_alt_rounded
                                : Icons.check_circle_outline,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),

                    // Tombol Centang: Aktif setelah gambar diambil
                    _CircleControlButton(
                      icon: Icons.check_rounded,
                      size: 52,
                      iconSize: 30,
                      backgroundColor: _capturedPhoto != null
                          ? const Color(0xFF2E7D32)
                          : Colors.white.withValues(alpha: 0.55),
                      iconColor: _capturedPhoto != null
                          ? Colors.white
                          : Colors.black38,
                      onTap: _capturedPhoto != null ? _confirmAndAnalyze : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Overlay Loading saat AI memproses gambar setelah klik Ceklis
        if (_isProcessing)
          Container(
            color: Colors.black.withValues(alpha: 0.55),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(color: Color(0xFF2E7D32)),
                    const SizedBox(height: 16),
                    Text(
                      'AI sedang mengenali bunga...',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCameraContent() {
    // Jika foto sudah dijepret, tampilkan hasilnya
    if (_capturedPhoto != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.file(
            File(_capturedPhoto!.path),
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Tekan ✓ untuk identifikasi atau X untuk foto ulang',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Jika kamera error / belum diizinkan
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.no_photography_rounded,
                  color: Colors.white70, size: 54),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _initCamera,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Aktifkan Kamera'),
              ),
            ],
          ),
        ),
      );
    }

    // Loading kamera
    if (!_isCameraInitialized || _controller == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    // Live Camera Preview + Frame Fokus di Tengah
    return Stack(
      fit: StackFit.expand,
      children: [
        CameraPreview(_controller!),
        Center(
          child: Container(
            width: 210,
            height: 210,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.85),
                width: 2.5,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
        Positioned(
          top: 16,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Arahkan kamera ke bunga',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CircleControlButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final double iconSize;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback? onTap;

  const _CircleControlButton({
    required this.icon,
    required this.size,
    required this.iconSize,
    required this.backgroundColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, size: iconSize, color: iconColor),
      ),
    );
  }
}