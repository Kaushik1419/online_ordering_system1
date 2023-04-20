import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:online_ordering_system1/account.dart';
import 'package:online_ordering_system1/addtocart.dart';
import 'package:online_ordering_system1/bottomnav.dart';
import 'package:online_ordering_system1/detailscreen.dart';
import 'package:online_ordering_system1/edit.dart';
import 'package:online_ordering_system1/favouriteitem.dart';
import 'package:online_ordering_system1/forgot_otp.dart';
import 'package:online_ordering_system1/forgot_password_email.dart';
import 'package:online_ordering_system1/homescreen.dart';
import 'package:online_ordering_system1/login.dart';
import 'package:online_ordering_system1/provider/cart_provider.dart';
import 'package:online_ordering_system1/provider/fav_provider.dart';
import 'package:online_ordering_system1/provider/get_Item_provider.dart';
import 'package:online_ordering_system1/provider/get_cart_item_provider.dart';
import 'package:online_ordering_system1/signup.dart';
import 'package:online_ordering_system1/splash.dart';
import 'package:online_ordering_system1/trial_page.dart';
import 'package:online_ordering_system1/verification.dart';
import 'package:provider/provider.dart';
import 'change_password_page.dart';
Future<void> backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(message.data.toString());
  print("Message is the ${message.notification!.title}");
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(const MyApp());
}
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  importance: Importance.high,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
class MyApp extends StatelessWidget {
  Future<void> backgroundHandler(RemoteMessage message) async {
    print(message.data.toString());
    print(message.notification!.title);
  }
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AddcartProvider>(
            create: (context) => AddcartProvider()),
        ChangeNotifierProvider<AddFavProvider>(
            create: (context) => AddFavProvider()),
        ChangeNotifierProvider<GetItems>(create: (context) => GetItems()),
        ChangeNotifierProvider<GetItemsCart>(
            create: (context) => GetItemsCart()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        initialRoute: '/',
        routes: {
          '/': (context) => const Splash(),
          '/loginpage': (context) => const LoginPage(),
          '/singuppage': (context) => const SignUpPage(),
          '/verificationpage': (context) => const Verification(),
          '/forgotpassword': (context) => ForgotPassword(),
          '/forgotOTP': (context) => ForGotOtp(),
          '/homescreen': (context) => const HomeScreen(
                Producttitle: '',
              ),
          '/account': (context) => const Account(),
          '/navbar': (context) => const BottomBar(),
          '/editprofile': (context) => const EditProfile(),
          '/addtocart': (context) => const AddToCart(),
          '/favouriteitem': (context) => const FavouriteItem(),
          '/detailitem': (context) => const DetailItem(),
          '/trialpage': (context) => const TrailOnly(),
          '/changeThePassword': (context) => const ChangePassword(),
        },
        getPages: [
          GetPage(name: '/', page: () => Splash()),
          GetPage(name: '/navbar', page: () => BottomBar(), transition: Transition.fadeIn),
          GetPage(name: '/verificationpage', page: () => Verification()),
        ],
        title: 'Online Ordering System',
      ),
    );
  }
}
