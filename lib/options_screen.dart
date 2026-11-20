import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_background.dart';

class OptionsScreen extends StatelessWidget {
  const OptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Menu Opsi
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF2E7D32).withValues(alpha: 0.25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      'assets/logo.jpeg',
                      width: 54,
                      height: 54,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Opsi & Informasi',
                          style: GoogleFonts.poppins(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1B4332),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Panduan, privasi, dan profil aplikasi PlantKnow',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Daftar 3 Menu Halaman
            _OptionMenuTile(
              icon: Icons.info_outline_rounded,
              title: 'Tentang PlantKnow',
              subtitle: 'Tujuan aplikasi, cara kerja AI, dan komitmen edukasi',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AboutPlantKnowPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 14),
            _OptionMenuTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Kebijakan Privasi',
              subtitle: 'Pengelolaan foto, akses kamera, dan data perangkat',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PrivacyPolicyPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 14),
            _OptionMenuTile(
              icon: Icons.description_outlined,
              title: 'Ketentuan Penggunaan',
              subtitle: 'Panduan keselamatan dan etika saat memindai tanaman',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TermsOfUsePage(),
                  ),
                );
              },
            ),

            const Spacer(),

            // Info Versi Aplikasi
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.82),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'PlantKnow v1.0.0 • AI Botanical Scanner',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _OptionMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _OptionMenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.92),
      borderRadius: BorderRadius.circular(18),
      elevation: 1.5,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFF2E7D32).withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: const Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1B4332),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.black54,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// HALAMAN 1: TENTANG PLANTKNOW
// ============================================================================
class AboutPlantKnowPage extends StatelessWidget {
  const AboutPlantKnowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.white.withValues(alpha: 0.88),
          elevation: 0,
          title: Text(
            'Tentang PlantKnow',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1B4332),
            ),
          ),
          iconTheme: const IconThemeData(color: Color(0xFF1B4332)),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: const Color(0xFF2E7D32).withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo & Identitas Utama
                Center(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/logo.jpeg',
                          width: 84,
                          height: 84,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'PLANTKNOW',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF2E7D32),
                          letterSpacing: 1.0,
                        ),
                      ),
                      Text(
                        'IDENTIFIKASI BUNGA BERBASIS KECERDASAN BUATAN',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1B4332),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Kenali Alam, Jaga Kelestarian.',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                _SectionBlock(
                  title: 'Mengapa PlantKnow Hadir?',
                  body:
                      'Banyak dari kita sering melewati berbagai jenis bunga dan tanaman di sekitar rumah, taman, maupun pinggir jalan tanpa mengetahui nama serta karakteristiknya. PlantKnow hadir untuk menjembatani rasa ingin tahu tersebut dengan cara yang praktis, cepat, dan edukatif langsung dari genggaman Anda.',
                ),

                const SizedBox(height: 18),

                _SectionBlock(
                  title: 'Cara Kerja Aplikasi',
                  body:
                      'Arahkan kamera ke bunga di sekitar Anda atau unggah foto dari galeri. Sistem klasifikasi citra pada PlantKnow akan menganalisis karakteristik visual bunga untuk menampilkan identitas spesies, nama ilmiah, ringkasan perawatan, serta daftar bunga serupa beserta skor kemiripannya.',
                ),

                const SizedBox(height: 20),

                Text(
                  'Tujuan Kami',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1B4332),
                  ),
                ),
                const SizedBox(height: 10),

                _GoalCard(
                  badgeText: '01',
                  badgeColor: const Color(0xFFC62828),
                  title: 'Edukasi Botani Mudah',
                  description:
                      'Membantu pelajar, mahasiswa, dan masyarakat umum mengenal keanekaragaman flora secara interaktif.',
                ),
                const SizedBox(height: 10),
                _GoalCard(
                  badgeText: '02',
                  badgeColor: const Color(0xFF2E7D32),
                  title: 'Kepedulian Lingkungan',
                  description:
                      'Menumbuhkan rasa cinta dan kepedulian terhadap kelestarian tanaman serta ekosistem hijau di sekitar kita.',
                ),

                const SizedBox(height: 18),

                // Kartu Informasi Teknologi
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFF2E7D32).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.eco_rounded,
                        color: Color(0xFF2E7D32),
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dibangun dengan Flutter',
                              style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1B4332),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Dirancang untuk memberikan pengalaman pemindaian tanaman yang ringan, cepat, dan nyaman digunakan di perangkat Android.',
                              style: GoogleFonts.poppins(
                                fontSize: 12.5,
                                height: 1.45,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// HALAMAN 2: KEBIJAKAN PRIVASI
// ============================================================================
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.white.withValues(alpha: 0.88),
          elevation: 0,
          title: Text(
            'Kebijakan Privasi',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1B4332),
            ),
          ),
          iconTheme: const IconThemeData(color: Color(0xFF1B4332)),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: const Color(0xFF2E7D32).withValues(alpha: 0.2),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionBlock(
                  title: 'Data Anda Tersimpan di Perangkat',
                  body:
                      'PlantKnow menyimpan seluruh catatan riwayat pemindaian hanya di penyimpanan lokal perangkat Anda. Aplikasi ini tidak memiliki server pelacak eksternal, serta tidak menjual maupun membagikan data Anda kepada pihak ketiga mana pun.',
                ),
                SizedBox(height: 18),
                _SectionBlock(
                  title: 'Penggunaan Kamera dan Foto',
                  body:
                      'Izin kamera dan galeri hanya digunakan ketika Anda menekan tombol pemindaian atau unggah gambar. Foto yang diambil digunakan untuk proses identifikasi bunga dan disimpan dalam folder khusus aplikasi agar dapat dilihat kembali pada menu Riwayat.',
                ),
                SizedBox(height: 18),
                _SectionBlock(
                  title: 'Penghapusan Data Riwayat',
                  body:
                      'Anda memiliki kendali penuh atas data yang tersimpan. Anda dapat menghapus setiap hasil pemindaian kapan saja melalui tombol hapus di halaman Riwayat, dan menghapus instalasi aplikasi akan menghapus seluruh data lokal secara otomatis.',
                ),
                SizedBox(height: 18),
                _SectionBlock(
                  title: 'Aman untuk Pelajar dan Umum',
                  body:
                      'PlantKnow dikembangkan sebagai media edukasi pengenalan flora yang aman digunakan oleh berbagai kalangan, bebas dari iklan yang mengganggu maupun interaksi dengan pengguna asing.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// HALAMAN 3: KETENTUAN PENGGUNAAN
// ============================================================================
class TermsOfUsePage extends StatelessWidget {
  const TermsOfUsePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.white.withValues(alpha: 0.88),
          elevation: 0,
          title: Text(
            'Ketentuan Penggunaan',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1B4332),
            ),
          ),
          iconTheme: const IconThemeData(color: Color(0xFF1B4332)),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: const Color(0xFF2E7D32).withValues(alpha: 0.2),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionBlock(
                  title: 'Jelajahi Lingkungan dengan Aman',
                  body:
                      'Selalu utamakan keselamatan diri saat memotret tanaman di luar ruangan, seperti di taman, kebun, maupun area terbuka. Perhatikan kondisi sekitar termasuk lalu lintas kendaraan, jalan licin, dan keberadaan serangga.',
                ),
                SizedBox(height: 18),
                _SectionBlock(
                  title: 'Jangan Mengonsumsi Tanaman Liar',
                  body:
                      'Hasil klasifikasi dari model kecerdasan buatan bersifat sebagai referensi edukasi dan memiliki kemungkinan kekeliruan. Jangan pernah memakan, mencicipi, atau menyentuh tanaman liar secara sembarangan hanya berdasarkan hasil deteksi aplikasi karena sebagian tanaman dapat beracun atau memicu iritasi.',
                ),
                SizedBox(height: 18),
                _SectionBlock(
                  title: 'Hormati dan Jaga Alam',
                  body:
                      'Abadikan tanaman cukup melalui foto tanpa merusaknya. Hindari memetik bunga, mematahkan tangkai, atau menginjak tanaman lain, terutama saat berada di taman umum maupun kawasan lindung.',
                ),
                SizedBox(height: 18),
                _SectionBlock(
                  title: 'Penggunaan yang Bijak',
                  body:
                      'Gunakan aplikasi PlantKnow secara bertanggung jawab untuk keperluan pembelajaran, pengenalan botani, serta menumbuhkan kepedulian terhadap lingkungan hijau.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionBlock extends StatelessWidget {
  final String title;
  final String body;

  const _SectionBlock({
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 15.5,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1B4332),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          body,
          style: GoogleFonts.poppins(
            fontSize: 13.5,
            height: 1.55,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class _GoalCard extends StatelessWidget {
  final String badgeText;
  final Color badgeColor;
  final String title;
  final String description;

  const _GoalCard({
    required this.badgeText,
    required this.badgeColor,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              badgeText,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1B4332),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 12.5,
                    height: 1.4,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}