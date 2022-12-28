import 'package:flutter/material.dart';
import 'package:tripmap/screens/contentscreen.dart';
import 'package:tripmap/screens/forgotpassword.dart';
import 'package:tripmap/screens/loadingscreen.dart';
import 'package:tripmap/screens/mainscreen.dart';
import 'package:tripmap/screens/loginscreen.dart';
import 'package:tripmap/screens/polyline_screen.dart';
import 'package:tripmap/screens/registerscreen.dart';
import 'package:tripmap/screens/showallscreen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final List<dynamic> args = settings.arguments as List<dynamic>;

    switch (settings.name) {
      case '/main':
        return CustomPageRoute(child: const MainScreen());
      case '/content':
        return CustomPageRoute(
            child: ContentScreen(
          location: args.elementAt(0),
        ));
      case '/loading':
        return CustomPageRoute(child: const LoadingScreen());
      case '/login':
        return CustomPageRoute(child: const LoginScreen());
      case '/register':
        return CustomPageRoute(child: const RegisterScreen());
      case '/showAll':
        return CustomPageRoute(
            child: ShowAllScreen(
          currentindex: args.elementAt(0),
        ));
      case '/forgotpassword':
        return CustomPageRoute(child: const ForgotPasswordScreen());
      case '/map':
        return CustomPageRoute(
            child: PolylineScreen(
          destinationLocation: args.elementAt(0),
        ));
      default:
        return CustomPageRoute(child: const LoginScreen());
    }
  }
}

class CustomPageRoute extends PageRouteBuilder {
  final Widget child;

  CustomPageRoute({
    required this.child,
  }) : super(
          transitionDuration: const Duration(seconds: 0),
          pageBuilder: (context, animtation, secondaryAnimation) => child,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
      SlideTransition(
        position: Tween<Offset>(
          begin: Offset.zero,
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
}
