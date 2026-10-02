import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/transaction_provider.dart';
import '../widgets/widgets.dart';
import 'cart_screen.dart';
import 'checkout_screen.dart';
import 'history_screen.dart';
import 'product_list_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = const [
      DashboardScreen(),
      ProductListScreen(),
      HistoryScreen(),
      ProfileScreen(),
    ];
    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2_rounded),
            label: 'Produk',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text(
                  '${context.watch<TransactionProvider>().transactions.length}'),
              child: const Icon(Icons.receipt_long_outlined),
            ),
            selectedIcon: const Icon(Icons.receipt_long_rounded),
            label: 'Riwayat',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
      ),
      floatingActionButton: _index == 1 || _index == 0
          ? Consumer<CartProvider>(
              builder: (context, cart, _) => cart.isEmpty
                  ? const SizedBox.shrink()
                  : FloatingActionButton.extended(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const CartScreen()),
                      ),
                      icon: Badge(
                        label: Text('${cart.count}'),
                        backgroundColor: Colors.white,
                        textColor: AppColors.burgundy,
                        child: const Icon(
                            Icons.shopping_cart_rounded),
                      ),
                      label: Text(
                        Formatters.rupiah(cart.subtotal),
                        style: const TextStyle(
                            fontWeight: FontWeight.w800),
                      ),
                    ),
            )
          : null,
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final products = context.watch<ProductProvider>();
    final trx = context.watch<TransactionProvider>();
    final cart = context.read<CartProvider>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: false,
            pinned: true,
            expandedHeight: 232,
            backgroundColor: AppColors.burgundyDeep,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                child: SafeArea(
                  child: Padding(
                    padding:
                        const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 21,
                              backgroundColor: Colors.white,
                              child: Text(
                                auth.user.name.isNotEmpty
                                    ? auth.user.name[0]
                                        .toUpperCase()
                                    : 'A',
                                style: const TextStyle(
                                    color: AppColors.burgundy,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Halo, ${auth.user.name}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    auth.user.storeName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white
                                          .withValues(alpha: 0.8),
                                      fontSize: 12.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white
                                    .withValues(alpha: 0.16),
                                borderRadius:
                                    BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                onPressed: () =>
                                    Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const CartScreen()),
                                ),
                                icon: const Icon(
                                  Icons.shopping_cart_outlined,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        // Kartu omzet — putih di atas gradient
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(
                                    alpha: 0.12),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding:
                                              const EdgeInsets.all(
                                                  6),
                                          decoration:
                                              BoxDecoration(
                                            color: AppColors
                                                .pinkSoft,
                                            borderRadius:
                                                BorderRadius
                                                    .circular(8),
                                          ),
                                          child: const Icon(
                                            Icons
                                                .account_balance_wallet_outlined,
                                            size: 14,
                                            color: AppColors
                                                .burgundy,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        const Text(
                                          'Omzet Hari Ini',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight:
                                                FontWeight.w600,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      Formatters.rupiah(
                                          trx.todayRevenue),
                                      maxLines: 1,
                                      overflow:
                                          TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -0.5,
                                        color:
                                            AppColors.burgundyDeep,
                                      ),
                                    ),
                                    Text(
                                      '${trx.todayCount} transaksi',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              FilledButton.icon(
                                onPressed: () =>
                                    Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const CheckoutScreen()),
                                ),
                                icon: const Icon(
                                    Icons.add_shopping_cart_rounded,
                                    size: 18),
                                label:
                                    const Text('Kasir Baru'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.25,
                    children: [
                      StatCard(
                        title: 'Total Transaksi',
                        value: '${trx.transactions.length}',
                        subtitle: 'Semua waktu',
                        icon: Icons.receipt_long_rounded,
                        color: AppColors.burgundy,
                      ),
                      StatCard(
                        title: 'Total Produk',
                        value: '${products.allProducts.length}',
                        subtitle:
                            '${products.categories.length - 1} kategori',
                        icon: Icons.inventory_2_rounded,
                        color: AppColors.grape,
                      ),
                      StatCard(
                        title: 'Total Omzet',
                        value: _shortMoney(trx.totalRevenue),
                        subtitle: 'Akumulasi',
                        icon: Icons.trending_up_rounded,
                        color: const Color(0xFF15803D),
                      ),
                      StatCard(
                        title: 'Item Terjual',
                        value:
                            '${products.bestSellers.fold(0, (a, b) => a + b.sold)}+',
                        subtitle: 'Produk terlaris',
                        icon: Icons.local_fire_department_rounded,
                        color: AppColors.pink,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const SectionHeader(
                    title: 'Kategori',
                    subtitle: 'Telusuri produk per kategori',
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 104,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: products.categories.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 10),
                      itemBuilder: (context, i) {
                        final c = products.categories[i];
                        if (c.id == 'all') {
                          return const SizedBox.shrink();
                        }
                        return InkWell(
                          onTap: () {
                            context
                                .read<ProductProvider>()
                                .setCategory(c.id);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) =>
                                      const ProductListScreen()),
                            );
                          },
                          borderRadius:
                              BorderRadius.circular(18),
                          child: Container(
                            width: 88,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 10),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surface,
                              borderRadius:
                                  BorderRadius.circular(18),
                              border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .outlineVariant
                                      .withValues(alpha: 0.7)),
                            ),
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: c.color.withValues(
                                        alpha: 0.14),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(c.icon,
                                      color: c.color, size: 22),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  c.name,
                                  maxLines: 1,
                                  overflow:
                                      TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight:
                                          FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  SectionHeader(
                    title: 'Terlaris Hari Ini',
                    subtitle:
                        '${products.bestSellers.length} produk favorit pembeli',
                    actionLabel: 'Lihat Semua',
                    onAction: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) =>
                              const ProductListScreen()),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
            sliver: SliverGrid(
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.66,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final p = products.bestSellers[i];
                  return ProductCard(
                    product: p,
                    onAdd: () {
                      cart.add(p);
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                              content: Text(
                                  '${p.name} masuk keranjang')),
                        );
                    },
                    onFavorite: () => context
                        .read<ProductProvider>()
                        .toggleFavorite(p.id),
                  );
                },
                childCount: products.bestSellers.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _shortMoney(double v) {
    if (v >= 1000000) {
      return 'Rp ${(v / 1000000).toStringAsFixed(1)}jt';
    }
    if (v >= 1000) return 'Rp ${(v / 1000).toStringAsFixed(0)}rb';
    return Formatters.rupiah(v);
  }
}
