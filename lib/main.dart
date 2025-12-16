import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:one_ds/one_ds.dart';
import 'package:parking/core/database/app_database.dart';
import 'package:parking/core/purchase/purchase.dart';
import 'package:parking/src/module/cash_register/presenters/page/cash_register_page.dart';
import 'package:parking/src/module/category/presenters/controller/category_controller.dart';
import 'package:parking/src/module/category/presenters/page/category_page.dart';
import 'package:parking/src/module/home/presenters/controller/home_controller.dart';
import 'package:parking/src/module/home/presenters/page/home_page.dart';
import 'package:parking/src/module/plans/presenters/page/plans_page.dart';
import 'package:parking/src/module/printer/presenters/page/printer_page.dart';
import 'package:parking/src/module/receipt/presenters/page/receipt_page.dart';
import 'package:parking/src/module/reports/presenters/controller/reports_controller.dart';
import 'package:parking/src/module/reports/presenters/page/reports_page.dart';
import 'package:parking/src/module/settings/presenters/controller/settings_controller.dart';
import 'package:parking/src/module/settings/presenters/page/settings_page.dart';
import 'package:parking/src/module/splash/page/splash_page.dart';
import 'package:parking/src/module/ticket/presenters/controller/ticket_controller.dart';
import 'package:parking/src/module/ticket/presenters/page/ticket_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = await AppDatabase.instance.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: HomeController()),
        ChangeNotifierProvider.value(value: SettingsController(briteDb: db)),
        ChangeNotifierProvider.value(value: CategoryController(briteDb: db)),
        ChangeNotifierProvider.value(value: TicketController(briteDb: db)),
        ChangeNotifierProvider.value(value: ReportsController(briteDb: db)),
        ChangeNotifierProvider.value(value: PurchaseApp()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MaterialApp(
        title: 'Gestor Estacionamento',
        theme: ThemeData(
          useMaterial3: false,
          primarySwatch: generateMaterialColor(color: const Color(0xff273D4A)),
        ),
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: const [Locale('pt', 'BR')],
        locale: const Locale('pt', 'BR'),
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.splash,
        routes: {
          Routes.splash: (context) => SplashPage(),
          Routes.home: (context) => HomePage(),
          Routes.ticket: (context) => TicketPage(),
          Routes.receipt: (context) => ReceiptPage(),
          Routes.settings: (context) => SettingsPage(),
          Routes.category: (context) => CategoryPage(),
          Routes.reports: (context) => ReportsPage(),
          Routes.cashRegister: (context) => CashRegisterPage(),
          Routes.printer: (context) => PrinterPage(),
          Routes.plans: (context) => PlansPage(),
        },
      ),
    );
  }
}

abstract class Routes {
  static String splash = '/splash';
  static String home = '/home';
  static String ticket = '/ticket';
  static String receipt = '/receipt';
  static String settings = '/settings';
  static String printer = '/printer';
  static String category = '/category';
  static String reports = '/reports';
  static String cashRegister = '/cash_register';
  static String plans = '/plans';
}
