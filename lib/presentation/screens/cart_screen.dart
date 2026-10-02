import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../providers/cart_provider.dart';
import '../widgets/widgets.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang'),
        actions: [
          if (!cart.isEmpty)
            TextButton.icon(
              onPressed: () => cart.clear(),
              icon: const Icon(Icons.delete_outline_rounded, size: 18),
              label: const Text('Hapus'),
            ),
        ],
      ),
      body: cart.isEmpty
          ? const EmptyState(
              icon: Icons.shopping_cart_outlined,
              title: 'Keranjang kosong',
              subtitle:
                  'Tambahkan produk dari dashboard atau daftar produk.',
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 170),
              itemCount: cart.items.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final item = cart.items[i];
                return Dismissible(
                  key: ValueKey(item.product.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      gradient: AppColors.pinkGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.delete_rounded,
                        color: Colors.white),
                  ),
                  onDismissed: (_) =>
                      context.read<CartProvider>().remove(item.product.id),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              color: item.product.color
                                  .withValues(alpha: 0.14),
                              borderRadius:
                                  BorderRadius.circular(14),
                            ),
                            child: Icon(item.product.icon,
                                color: item.product.color,
                                size: 26),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(item.product.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13.5)),
                                const SizedBox(height: 2),
                                Text(
                                  Formatters.rupiah(
                                      item.product.effectivePrice),
                                  style: const TextStyle(
                                      color: AppColors.burgundy,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 13.5),
                                ),
                                Text(
                                  'Subtotal: ${Formatters.rupiah(item.subtotal)}',
                                  style: TextStyle(
                                      color: scheme.outline,
                                      fontSize: 11.5),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.pinkSoft.withValues(
                                  alpha: 0.6),
                              borderRadius:
                                  BorderRadius.circular(999),
                              border: Border.all(
                                color: AppColors.burgundy
                                    .withValues(alpha: 0.12),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  visualDensity:
                                      VisualDensity.compact,
                                  onPressed: () => context
                                      .read<CartProvider>()
                                      .setQty(item.product.id,
                                          item.qty - 1),
                                  icon: const Icon(
                                      Icons.remove_rounded,
                                      size: 18,
                                      color: AppColors.burgundy),
                                ),
                                SizedBox(
                                  width: 24,
                                  child: Text('${item.qty}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight:
                                              FontWeight.w800)),
                                ),
                                IconButton(
                                  visualDensity:
                                      VisualDensity.compact,
                                  onPressed: () => context
                                      .read<CartProvider>()
                                      .setQty(item.product.id,
                                          item.qty + 1),
                                  icon: const Icon(
                                      Icons.add_rounded,
                                      size: 18,
                                      color: AppColors.burgundy),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
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
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text('${cart.count} item',
                              style: TextStyle(
                                  color: scheme.outline,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600)),
                          Text(Formatters.rupiah(cart.subtotal),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20,
                                  letterSpacing: -0.5,
                                  color:
                                      AppColors.burgundyDeep)),
                        ],
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) =>
                                const CheckoutScreen()),
                      ),
                      icon: const Icon(
                          Icons.arrow_forward_rounded,
                          size: 18),
                      label: const Text('Checkout'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
