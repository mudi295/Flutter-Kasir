import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/product_provider.dart';
import '../widgets/widgets.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    final cart = context.read<CartProvider>();
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Produk'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${provider.filtered.length} produk',
                  style: TextStyle(
                    color: scheme.onPrimaryContainer,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: SearchBar(
              controller: _search,
              hintText: 'Cari produk… (cth: kopi, nasi)',
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
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16),
              itemCount: provider.categories.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final c = provider.categories[i];
                final selected = provider.categoryId == c.id;
                return ChoiceChip(
                  label: Text(c.name),
                  avatar: Icon(c.icon, size: 18),
                  selected: selected,
                  onSelected: (_) =>
                      provider.setCategory(c.id),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('Promo'),
                  selected: provider.onlyPromo,
                  onSelected: provider.togglePromo,
                  avatar: const Icon(
                      Icons.local_offer_outlined,
                      size: 18),
                ),
                const Spacer(),
                Text(
                  provider.onlyPromo
                      ? 'Hanya promo'
                      : 'Semua produk',
                  style: TextStyle(
                      color: scheme.outline, fontSize: 12.5),
                ),
              ],
            ),
          ),
          Expanded(
            child: provider.filtered.isEmpty
                ? const EmptyState(
                    icon: Icons.search_off_rounded,
                    title: 'Produk tidak ditemukan',
                    subtitle:
                        'Coba kata kunci atau kategori lain.',
                  )
                : GridView.builder(
                    padding:
                        const EdgeInsets.fromLTRB(16, 8, 16, 110),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.66,
                    ),
                    itemCount: provider.filtered.length,
                    itemBuilder: (context, i) {
                      final p = provider.filtered[i];
                      return ProductCard(
                        product: p,
                        onAdd: () {
                          cart.add(p);
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(SnackBar(
                                content: Text(
                                    '${p.name} masuk keranjang')));
                        },
                        onFavorite: () =>
                            provider.toggleFavorite(p.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
