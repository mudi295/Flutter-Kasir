import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notif = true;
  bool _sound = true;
  double _tax = 10;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          const _GroupLabel('Tampilan'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(
                      Icons.dark_mode_outlined,
                      color: AppColors.burgundy),
                  title: const Text('Dark Mode',
                      style: TextStyle(
                          fontWeight: FontWeight.w600)),
                  subtitle: const Text(
                      'Mode gelap burgundy elegan'),
                  value: theme.mode == ThemeMode.dark,
                  onChanged: (v) => theme.toggleDark(v),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(
                      Icons.contrast_rounded,
                      color: AppColors.burgundy),
                  title: const Text('Mode Tema',
                      style: TextStyle(
                          fontWeight: FontWeight.w600)),
                  subtitle: Text(_label(theme.mode)),
                  trailing: SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(
                          value: ThemeMode.light,
                          icon: Icon(
                              Icons.light_mode_outlined)),
                      ButtonSegment(
                          value: ThemeMode.system,
                          icon: Icon(Icons
                              .settings_suggest_outlined)),
                      ButtonSegment(
                          value: ThemeMode.dark,
                          icon: Icon(
                              Icons.dark_mode_outlined)),
                    ],
                    selected: {theme.mode},
                    showSelectedIcon: false,
                    onSelectionChanged: (s) =>
                        theme.setMode(s.first),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const _GroupLabel('Transaksi'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                          child: Text('Pajak default (%)',
                              style: TextStyle(
                                  fontWeight:
                                      FontWeight.w600))),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.pinkSoft,
                          borderRadius:
                              BorderRadius.circular(999),
                        ),
                        child: Text('${_tax.toInt()}%',
                            style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                color: AppColors.burgundy)),
                      ),
                    ],
                  ),
                  Slider(
                    value: _tax,
                    min: 0,
                    max: 15,
                    divisions: 15,
                    label: '${_tax.toInt()}%',
                    onChanged: (v) =>
                        setState(() => _tax = v),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    secondary: const Icon(
                        Icons.receipt_long_outlined,
                        color: AppColors.burgundy),
                    title:
                        const Text('Cetak struk otomatis'),
                    value: _sound,
                    onChanged: (v) =>
                        setState(() => _sound = v),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const _GroupLabel('Notifikasi'),
          Card(
            child: SwitchListTile(
              secondary: const Icon(
                  Icons.notifications_outlined,
                  color: AppColors.burgundy),
              title: const Text('Notifikasi transaksi',
                  style:
                      TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text(
                  'Bunyi setiap pembayaran berhasil'),
              value: _notif,
              onChanged: (v) => setState(() => _notif = v),
            ),
          ),
          const SizedBox(height: 12),
          const _GroupLabel('Tentang'),
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.burgundy
                      .withValues(alpha: 0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const ListTile(
              leading: Icon(Icons.point_of_sale_rounded,
                  color: Colors.white),
              title: Text('Kasir Premium v1.0.0',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700)),
              subtitle: Text(
                  'Flutter • Material 3 • Provider\nPalette Ungu • Pink • Burgundy.',
                  style: TextStyle(color: Colors.white70)),
            ),
          ),
        ],
      ),
    );
  }

  String _label(ThemeMode m) => switch (m) {
        ThemeMode.light => 'Terang',
        ThemeMode.dark => 'Gelap',
        ThemeMode.system => 'Mengikuti sistem',
      };
}

class _GroupLabel extends StatelessWidget {
  final String text;
  const _GroupLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              gradient: AppColors.pinkGradient,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(width: 8),
          Text(text,
              style: const TextStyle(
                  color: AppColors.burgundy,
                  fontWeight: FontWeight.w800,
                  fontSize: 13)),
        ],
      ),
    );
  }
}
