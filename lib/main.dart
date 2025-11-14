import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_mangment/Core/Helper/cache_helper.dart';
import 'package:store_mangment/Core/Localizations/app_localizatios.dart';
import 'package:store_mangment/Feature/Home/cubit/home_cubit.dart';
import 'package:store_mangment/Feature/Login/View/login_view.dart';
import 'package:store_mangment/Feature/Login/cubit/login_cubit.dart';
import 'package:store_mangment/Feature/Main/View/main_view.dart';
import 'package:store_mangment/Feature/Orders/cubit/order_cubit.dart';
import 'package:store_mangment/Feature/admin_booking/cubit/admin_bookings_cubit.dart';
import 'package:store_mangment/Feature/customer_section/Customer_cart/Cubit/cart_cubit.dart';
import 'package:store_mangment/Feature/customer_section/Main_customer/View/customer_main_view.dart';
import 'package:store_mangment/Feature/customer_section/book_service/cubut/book_cubit.dart';
import 'package:store_mangment/Feature/notification/cubit/notification_cubit.dart';
import 'package:store_mangment/Feature/notification/repo/notifications_repository.dart';
import 'package:store_mangment/Feature/payment/payment_view.dart';
import 'package:store_mangment/Feature/service/cubit/service_cubut.dart';
import 'package:store_mangment/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  await CachePrfHelper.init();

  String? uid = CachePrfHelper.getUid();
  print("🚀 App open and that is UID: $uid");

  runApp(MyApp(uid: uid));
}

class MyApp extends StatefulWidget {
  final String? uid;
  const MyApp({super.key, required this.uid});

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('languageCode');
    if (languageCode != null) {
      setState(() {
        _locale = Locale(languageCode);
      });
    } else {
      // ✅ لو مفيش لغة محفوظة، استخدم العربية كـ default
      setState(() {
        _locale = const Locale('ar');
      });
    }
  }

  Future<void> setLocale(Locale locale) async {
    setState(() {
      _locale = locale;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginCubit()),
        BlocProvider(
          create: (_) => AdminBookingsCubit(
            bookingRepository: BookingRepository(),
            notificationsRepository: NotificationsRepository(),
          ),
        ),
        BlocProvider(
          create: (_) => NotificationCubit(NotificationsRepository()),
        ),
        BlocProvider(create: (_) => HomeCubit()),
        BlocProvider(create: (_) => CartCubit()),
        BlocProvider(create: (_) => OrderCubit()),
        BlocProvider(
          create: (_) => BookingCubit(repository: BookingRepository()),
        ),
        BlocProvider(create: (_) => AddVetServiceCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Store Management',

        supportedLocales: const [
          Locale('en'), // English
          Locale('ar'), // Arabic
          Locale('fr'), // French
        ],

        // ✅ ✅ ✅ الحل هنا: ضيف الـ AppLocalizations.delegate
        localizationsDelegates: const [
          AppLocalizations.delegate, // ✅✅✅ هذا السطر المهم
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        locale: _locale ?? const Locale('ar'), // ✅ Default locale
        localeResolutionCallback: (deviceLocale, supportedLocales) {
          if (deviceLocale != null) {
            for (var locale in supportedLocales) {
              if (locale.languageCode == deviceLocale.languageCode) {
                return locale;
              }
            }
          }
          return supportedLocales.first; // Default to first supported locale
        },
        home: widget.uid == null
            ? const LoginView()
            : RoleBasedScreen(uid: widget.uid),
      ),
    );
  }
}

class RoleBasedScreen extends StatefulWidget {
  final String? uid;
  const RoleBasedScreen({super.key, required this.uid});

  @override
  _RoleBasedScreenState createState() => _RoleBasedScreenState();
}

class _RoleBasedScreenState extends State<RoleBasedScreen>
    with SingleTickerProviderStateMixin {
  bool? is_admin;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // إعداد الأنيميشن
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _animationController.forward();

    _checkUserRole();
  }

  Future<void> _checkUserRole() async {
    if (widget.uid != null) {
      try {
        await Future.delayed(const Duration(seconds: 2));

        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;

          setState(() {
            is_admin = userData['is_admin'] ?? false;
          });

          // الانتقال إلى الشاشة المناسبة بعد تأخير بسيط
          await Future.delayed(const Duration(milliseconds: 500));
          _navigateToMainScreen();
        } else {
          print("User document not found.");
          // يمكنك التوجيه إلى شاشة خطأ هنا
        }
      } catch (e) {
        print("Error fetching user role: $e");
      }
    } else {
      print("UID is null");
    }
  }

  void _navigateToMainScreen() {
    if (is_admin != null) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              is_admin! ? const MainView() : CustomerMainView(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // أو اللون المناسب لتطبيقك
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/img/logo.png', width: 500, height: 500),
                    const SizedBox(height: 30),

                    const SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 3,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}



//12345678
//  Haqi Aladad 
// vet
//iraq