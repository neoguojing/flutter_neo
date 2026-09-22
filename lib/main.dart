import 'package:flutter/material.dart';
import 'package:flutter_neo/features/home/ui/home_page.dart';
import 'package:provider/provider.dart';
import 'core/repositories/investment_repository_impl.dart';
import 'features/diversified_investment/provider/investment_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: InvestmentRepositoryImpl()),
        ChangeNotifierProvider(
          create: (context) => InvestmentProvider(
            context.read<InvestmentRepositoryImpl>(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Neo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
