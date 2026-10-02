import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/transaction_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _payment = 'Tunai';
  final _cash = TextEditingController();
  final _customer = TextEditingController();
  final _discount = TextEditingController(text: '0');

  @override
  void dispose() {
    _cash.dispose();
    _customer.dispose();
    _discount.dispose();
    super.dispose();
  }

  double _num(String v) =>
      double.tryParse(v.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final scheme = Theme.of(context).colorScheme;
    final discount = _num(_discount.text);
    final subtotal = cart.subtotal;
    final tax = (subtotal - discount) * 0.1;
    final double total =
        (subtotal - discount + tax).clamp(0, double.infinity).toDouble();
    final cash = _num(_cash.text);
    final change = cash - total;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: cart.isEmpty
          ? const Center(child: Text('Keranjang kosong'))
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 180),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _cardTitle('Ringkasan Pesanan'),
                        const SizedBox(height: 10),
                        ...cart.items.map((e) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4),
                              child: Row(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: AppColors.pinkSoft
                                          .withValues(alpha: 0.7),
                                      borderRadius:
                                          BorderRadius.circular(9),
                                    ),
                                    child: Text(
                                      '${e.qty}x',
                                      style: const TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.burgundy,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                      child: Text(
                                          e.product.name,
                                          maxLines: 1,
                                          overflow: TextOverflow
                                              .ellipsis,
                                          style: const TextStyle(
                                              fontSize: 13.5))),
                                  const SizedBox(width: 8),
                                  Text(Formatters.rupiah(e.subtotal),
                                      style: const TextStyle(
                                          fontWeight:
                                              FontWeight.w700,
                                          fontSize: 13.5)),
                                ],
                              ),
                            )),
                        const Divider(height: 24),
                        _row('Subtotal',
                            Formatters.rupiah(subtotal)),
                        _row('Diskon',
                            '- ${Formatters.rupiah(discount)}'),
                        _row('Pajak (10%)',
                            Formatters.rupiah(tax)),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              const Text('Total',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15)),
                              const Spacer(),
                              Text(Formatters.rupiah(total),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18,
                                      letterSpacing: -0.3)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _cardTitle('Pembayaran'),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            'Tunai',
                            'QRIS',
                            'Transfer',
                            'E-Wallet'
                          ]
                              .map((m) => ChoiceChip(
                                    label: Text(m),
                                    selected: _payment == m,
                                    onSelected: (_) => setState(
                                        () => _payment = m),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _customer,
                          decoration: const InputDecoration(
                            labelText:
                                'Nama pelanggan (opsional)',
                            prefixIcon: Icon(
                                Icons.person_outline_rounded),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _discount,
                                keyboardType:
                                    TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Diskon (Rp)',
                                  prefixIcon: Icon(
                                      Icons.discount_outlined),
                                ),
                                onChanged: (_) =>
                                    setState(() {}),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _cash,
                                keyboardType:
                                    TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Uang diterima',
                                  prefixIcon: Icon(
                                      Icons.payments_outlined),
                                ),
                                onChanged: (_) =>
                                    setState(() {}),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          children: [
                            50000,
                            100000,
                            total.toInt()
                          ].map((v) {
                            return ActionChip(
                              label: Text(Formatters.rupiah(
                                  v.toDouble())),
                              onPressed: () => setState(
                                  () => _cash.text = '$v'),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: change >= 0
                                ? const Color(0xFFE6F4EA)
                                : scheme.errorContainer
                                    .withValues(alpha: 0.5),
                            borderRadius:
                                BorderRadius.circular(12),
                            border: Border.all(
                              color: change >= 0
                                  ? const Color(0xFF15803D)
                                      .withValues(alpha: 0.2)
                                  : scheme.error.withValues(
                                      alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                change >= 0
                                    ? Icons
                                        .check_circle_outline_rounded
                                    : Icons
                                        .error_outline_rounded,
                                size: 18,
                                color: change >= 0
                                    ? const Color(0xFF15803D)
                                    : scheme.error,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                change >= 0
                                    ? 'Kembalian: ${Formatters.rupiah(change)}'
                                    : 'Kurang: ${Formatters.rupiah(-change)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.5,
                                  color: change >= 0
                                      ? const Color(0xFF15803D)
                                      : scheme.error,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      bottomSheet: cart.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24)),
                border: Border(
                    top: BorderSide(
                        color: scheme.outlineVariant)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.burgundy
                        .withValues(alpha: 0.08),
                    blurRadius: 24,
                    offset: const Offset(0, -8),
                  ),
                ],
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: (cash < total &&
                            _payment == 'Tunai')
                        ? null
                        : () {
                            final cashier = context
                                .read<AuthProvider>()
                                .user
                                .name;
                            final paid = _payment == 'Tunai'
                                ? cash
                                : total;
                            final trx = context
                                .read<TransactionProvider>()
                                .checkout(
                                  cartItems: cart.items,
                                  paymentMethod: _payment,
                                  cashReceived: paid,
                                  cashier: cashier,
                                  customerName:
                                      _customer.text,
                                  discount: discount,
                                );
                            context
                                .read<CartProvider>()
                                .clear();
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (_) => SuccessScreen(
                                      trxId: trx.id)),
                            );
                          },
                    child: Text(
                        'Bayar ${Formatters.rupiah(total)}'),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _cardTitle(String t) => Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              gradient: AppColors.pinkGradient,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(width: 8),
          Text(t,
              style: const TextStyle(
                  fontWeight: FontWeight.w800, fontSize: 15)),
        ],
      );

  Widget _row(String l, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Text(l, style: const TextStyle(fontSize: 13.5)),
            const Spacer(),
            Text(v,
                style: const TextStyle(
                    fontSize: 13.5, fontWeight: FontWeight.w600)),
          ],
        ),
      );
}

class SuccessScreen extends StatelessWidget {
  final String trxId;
  const SuccessScreen({super.key, required this.trxId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(26),
                decoration: BoxDecoration(
                  gradient: AppColors.heroGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.burgundy
                          .withValues(alpha: 0.35),
                      blurRadius: 30,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: const Icon(Icons.check_rounded,
                    color: Colors.white, size: 48),
              ),
              const SizedBox(height: 18),
              const Text('Pembayaran Berhasil!',
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                      letterSpacing: -0.4,
                      color: AppColors.burgundyDeep)),
              const SizedBox(height: 6),
              Text('Transaksi $trxId tersimpan.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey)),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context)
                      .pushNamedAndRemoveUntil(
                          '/main', (r) => false),
                  child: const Text('Kembali ke Kasir'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () =>
                      Navigator.of(context).pushReplacementNamed(
                          '/detail',
                          arguments: trxId),
                  child: const Text('Lihat Struk'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
