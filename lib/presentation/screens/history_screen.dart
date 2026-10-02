import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../providers/transaction_provider.dart';
import '../widgets/widgets.dart';
import '../../data/models/models.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Transaksi')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: SearchBar(
              controller: _search,
              hintText: 'Cari ID / pelanggan / metode…',
              leading: const Icon(Icons.search_rounded),
              trailing: provider.query.isNotEmpty
                  ? [
                      IconButton(
                        onPressed: () {
                          _search.clear();
                          provider.setQuery('');
                        },
                        icon:
                            const Icon(Icons.close_rounded),
                      )
                    ]
                  : null,
              onChanged: provider.setQuery,
            ),
          ),
          Expanded(
            child: provider.transactions.isEmpty
                ? const EmptyState(
                    icon: Icons.receipt_long_outlined,
                    title: 'Belum ada transaksi',
                    subtitle:
                        'Transaksi yang sudah dibayar akan muncul di sini.',
                  )
                : ListView.separated(
                    padding:
                        const EdgeInsets.fromLTRB(16, 4, 16, 110),
                    itemCount: provider.transactions.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final t = provider.transactions[i];
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) =>
                                    TransactionDetailScreen(
                                        trx: t)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.all(11),
                                  decoration: BoxDecoration(
                                    gradient:
                                        AppColors.pinkGradient,
                                    borderRadius:
                                        BorderRadius.circular(
                                            14),
                                  ),
                                  child: const Icon(
                                    Icons.receipt_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(t.id,
                                          maxLines: 1,
                                          overflow: TextOverflow
                                              .ellipsis,
                                          style: const TextStyle(
                                              fontWeight:
                                                  FontWeight.w800,
                                              fontSize: 13.5)),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${Formatters.dateTime(t.date)} • ${t.totalQty} item',
                                        style: TextStyle(
                                            color: scheme.outline,
                                            fontSize: 12),
                                      ),
                                      const SizedBox(height: 6),
                                      Container(
                                        padding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 9,
                                                vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppColors
                                              .pinkSoft
                                              .withValues(
                                                  alpha: 0.7),
                                          borderRadius:
                                              BorderRadius.circular(
                                                  999),
                                        ),
                                        child: Text(
                                          t.paymentMethod,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight:
                                                FontWeight.w700,
                                            color: AppColors
                                                .burgundy,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                        Formatters.rupiah(
                                            t.total),
                                        style: const TextStyle(
                                            fontWeight:
                                                FontWeight.w800,
                                            fontSize: 14,
                                            color: AppColors
                                                .burgundyDeep)),
                                    Icon(
                                        Icons.chevron_right_rounded,
                                        size: 20,
                                        color: scheme.outline),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class TransactionDetailScreen extends StatelessWidget {
  final AppTransaction trx;
  const TransactionDetailScreen(
      {super.key, required this.trx});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Transaksi')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          GradientHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'STRUK PEMBAYARAN',
                        style: TextStyle(
                            color: Colors.white.withValues(
                                alpha: 0.75),
                            letterSpacing: 1.2,
                            fontSize: 12,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(999)),
                      child: Text(trx.paymentMethod,
                          style: const TextStyle(
                              color: AppColors.burgundy,
                              fontWeight: FontWeight.w800,
                              fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(trx.id,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 18)),
                const SizedBox(height: 2),
                Text(Formatters.dateTime(trx.date),
                    style: TextStyle(
                        color: Colors.white.withValues(
                            alpha: 0.85),
                        fontSize: 13)),
                if (trx.customerName != null &&
                    trx.customerName!.isNotEmpty)
                  Text('Pelanggan: ${trx.customerName}',
                      style: TextStyle(
                          color: Colors.white.withValues(
                              alpha: 0.85),
                          fontSize: 13)),
                Text('Kasir: ${trx.cashier}',
                    style: TextStyle(
                        color: Colors.white.withValues(
                            alpha: 0.85),
                        fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Item',
                      style:
                          TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  ...trx.items.map((e) => Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(e.productName,
                                      style: const TextStyle(
                                          fontWeight:
                                              FontWeight.w600,
                                          fontSize: 13.5)),
                                  Text(
                                      '${e.qty} x ${Formatters.rupiah(e.price)}',
                                      style: TextStyle(
                                          color: scheme.outline,
                                          fontSize: 12)),
                                ],
                              ),
                            ),
                            Text(
                                Formatters.rupiah(e.subtotal),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13.5)),
                          ],
                        ),
                      )),
                  const Divider(height: 24),
                  _row('Subtotal',
                      Formatters.rupiah(trx.subtotal)),
                  _row('Diskon',
                      '- ${Formatters.rupiah(trx.discount)}'),
                  _row('Pajak',
                      Formatters.rupiah(trx.tax)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Total',
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16)),
                      const Spacer(),
                      Text(Formatters.rupiah(trx.total),
                          style: const TextStyle(
                              color: AppColors.burgundy,
                              fontWeight: FontWeight.w800,
                              fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  _row('Dibayar',
                      Formatters.rupiah(trx.cashReceived)),
                  _row('Kembalian',
                      Formatters.rupiah(trx.change)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String l, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Text(l, style: const TextStyle(fontSize: 13.5)),
            const Spacer(),
            Text(v,
                style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      );
}
