import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/product_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/transaction_provider.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/main_shell.dart';
import 'presentation/screens/history_screen.dart';

class KasirApp extends StatelessWidget {
  const KasirApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, theme, _) => MaterialApp(
          title: 'Kasir Premium',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: theme.mode,
          initialRoute: '/',
          routes: {
            '/': (_) => const SplashScreen(),
            '/login': (_) => const LoginScreen(),
            '/main': (_) => const MainShell(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/detail' &&
                settings.arguments is String) {
              final id = settings.arguments as String;
              return MaterialPageRoute(
                builder: (ctx) {
                  final trx = ctx
                      .read<TransactionProvider>()
                      .byId(id);
                  if (trx == null) {
                    return const Scaffold(
                      body: Center(
                          child:
                              Text('Transaksi tidak ditemukan')),
                    );
                  }
                  return TransactionDetailScreen(trx: trx);
                },
              );
            }
            return null;
          },
        ),
      ),
    );
  }
}
