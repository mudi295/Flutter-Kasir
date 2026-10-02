import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../providers/auth_provider.dart';
import '../../providers/transaction_provider.dart';
import '../widgets/widgets.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final trx = context.watch<TransactionProvider>();
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (_) => const SettingsScreen()),
            ),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          GradientHeader(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Text(
                    auth.user.name.isNotEmpty
                        ? auth.user.name[0].toUpperCase()
                        : 'A',
                    style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.burgundy),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(auth.user.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 17)),
                      Text(auth.user.email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white.withValues(
                                  alpha: 0.8),
                              fontSize: 13)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                            color: Colors.white.withValues(
                                alpha: 0.18),
                            borderRadius:
                                BorderRadius.circular(999),
                            border: Border.all(
                              color: Colors.white.withValues(
                                  alpha: 0.25),
                            )),
                        child: Text(auth.user.role,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _miniStat(context, 'Transaksi',
                    '${trx.transactions.length}',
                    Icons.receipt_long_rounded),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _miniStat(context, 'Omzet',
                    _short(trx.totalRevenue),
                    Icons.payments_rounded),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _miniStat(context, 'Toko',
                    auth.user.storeName.split(' ').first,
                    Icons.store_rounded),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _menuTile(context,
              icon: Icons.store_outlined,
              title: auth.user.storeName,
              subtitle: 'Nama toko aktif',
              onTap: () => _editStore(context)),
          const SizedBox(height: 10),
          _menuTile(context,
              icon: Icons.settings_outlined,
              title: 'Pengaturan',
              subtitle: 'Tema, dark mode, preferensi',
              onTap: () =>
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) =>
                          const SettingsScreen()))),
          const SizedBox(height: 10),
          _menuTile(context,
              icon: Icons.help_outline_rounded,
              title: 'Bantuan',
              subtitle: 'admin@kasir.id • v1.0.0',
              onTap: () =>
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Hubungi admin@kasir.id')))),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton.tonalIcon(
              onPressed: () async {
                await context
                    .read<AuthProvider>()
                    .logout();
                if (context.mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login', (r) => false);
                }
              },
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Keluar Akun'),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              Formatters.dateTime(DateTime.now()),
              style:
                  TextStyle(color: scheme.outline, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  String _short(double v) {
    if (v >= 1000000) {
      return '${(v / 1000000).toStringAsFixed(1)}jt';
    }
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}rb';
    return '$v';
  }

  Widget _miniStat(
      BuildContext context, String label, String value, IconData icon) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 8, vertical: 14),
        child: Column(
          children: [
            Icon(icon, color: AppColors.burgundy, size: 22),
            const SizedBox(height: 6),
            Text(value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontWeight: FontWeight.w800, fontSize: 14)),
            Text(label,
                style: TextStyle(
                    color: scheme.outline, fontSize: 11.5)),
          ],
        ),
      ),
    );
  }

  Widget _menuTile(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle,
      required VoidCallback onTap}) {
    return Card(
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: AppColors.pinkGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: Colors.white),
        ),
        title: Text(title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontWeight: FontWeight.w700, fontSize: 14)),
        subtitle: Text(subtitle,
            style: const TextStyle(fontSize: 12)),
        trailing:
            const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  void _editStore(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final nameC = TextEditingController(text: auth.user.name);
    final storeC =
        TextEditingController(text: auth.user.storeName);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 12,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.pinkSoft,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 14),
            const Text('Edit Profil Toko',
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16)),
            const SizedBox(height: 12),
            TextField(
                controller: nameC,
                decoration: const InputDecoration(
                    labelText: 'Nama kasir')),
            const SizedBox(height: 10),
            TextField(
                controller: storeC,
                decoration: const InputDecoration(
                    labelText: 'Nama toko')),
            const SizedBox(height: 14),
            FilledButton(
              onPressed: () async {
                await auth.updateProfile(
                    nameC.text.trim().isEmpty
                        ? auth.user.name
                        : nameC.text.trim(),
                    storeC.text.trim().isEmpty
                        ? auth.user.storeName
                        : storeC.text.trim());
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
