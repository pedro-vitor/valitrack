import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:valitrack/providers/product_list.dart';
import 'package:valitrack/providers/store_list.dart';
import 'package:valitrack/screens/product_form.dart';
import 'package:valitrack/screens/settings_screen.dart';
import 'package:valitrack/screens/short_dated_product.dart';
import 'package:valitrack/screens/store_screen.dart';
import 'package:valitrack/util/app_routes.dart';

void main() => runApp(const ValiTrack());

class ValiTrack extends StatelessWidget {
  const ValiTrack({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StoreList()),
        ChangeNotifierProvider(create: (ctx) => ProductList(context: ctx)),
      ],
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 57, 124, 201),
            secondary: const Color.fromARGB(255, 238, 115, 60),
            onPrimary: Colors.white,
            onSecondary: Colors.black,
          ),
        ),
        routes: {
          AppRoutes.home: (_) => const StoreScreen(),
          AppRoutes.productScreen: (ctx) => const ShortDatedProduct(),
          AppRoutes.productForm: (_) => const ProductForm(),
          AppRoutes.settingsScreen: (_) => const SettingsScreen(),
        },
        debugShowCheckedModeBanner: false,
        
        // Configurações para o portugues
        // 1. Define os delegados de tradução do Flutter
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        // 2. Define os idiomas suportados (incluindo o pt_BR)
        supportedLocales: const [
          Locale('pt', 'BR'), // Português do Brasil
          Locale('en', 'US'), // Inglês como fallback
        ],

        locale: const Locale('pt', 'BR'),
      ),
    );
  }
}
