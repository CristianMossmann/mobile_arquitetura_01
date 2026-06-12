import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_arquitetura_01/data/datasources/auth_remote_datasource.dart';
import 'package:mobile_arquitetura_01/data/datasources/product_cache_datasource.dart';
import 'package:mobile_arquitetura_01/data/datasources/product_remote_datasource.dart';
import 'package:mobile_arquitetura_01/data/repositories/auth_repository_impl.dart';
import 'package:mobile_arquitetura_01/data/repositories/product_repository_impl.dart';
import 'package:mobile_arquitetura_01/data/session/auth_session.dart';
import 'package:mobile_arquitetura_01/presentation/pages/login_page.dart';
import 'package:mobile_arquitetura_01/presentation/pages/product_page.dart';
import 'package:mobile_arquitetura_01/presentation/viewmodel/auth_viewmodel.dart';
import 'package:mobile_arquitetura_01/presentation/viewmodel/product_viewmodel.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final httpClient = http.Client();
    final productRepository = ProductRepositoryImpl(
      ProductRemoteDatasource(httpClient),
      ProductCacheDatasource(),
    );
    final authRepository = AuthRepositoryImpl(
      AuthRemoteDatasource(httpClient),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthSession()),
        ChangeNotifierProxyProvider<AuthSession, AuthViewModel>(
          create: (ctx) =>
              AuthViewModel(authRepository, ctx.read<AuthSession>()),
          update: (_, session, previous) =>
              previous ?? AuthViewModel(authRepository, session),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductViewModel(productRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Mobile Arquitetura',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Consumer<AuthSession>(
          builder: (_, session, __) {
            return session.isAuthenticated
                ? const ProductPage()
                : const LoginPage();
          },
        ),
      ),
    );
  }
}
