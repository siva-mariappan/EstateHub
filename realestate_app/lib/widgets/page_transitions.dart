import 'package:flutter/material.dart';

/// Slide up page route with fade
class SlideUpPageRoute<T> extends PageRoute<T> {
  final WidgetBuilder builder;
  final Duration _transitionDuration;

  SlideUpPageRoute({
    required this.builder,
    Duration transitionDuration = const Duration(milliseconds: 400),
    RouteSettings? settings,
  })  : _transitionDuration = transitionDuration,
        super(settings: settings);

  @override
  Color? get barrierColor => Colors.black54;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => _transitionDuration;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        ),
      ),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}

/// Fade and scale page route
class FadeScalePageRoute<T> extends PageRoute<T> {
  final WidgetBuilder builder;
  final Duration _transitionDuration;

  FadeScalePageRoute({
    required this.builder,
    Duration transitionDuration = const Duration(milliseconds: 300),
    RouteSettings? settings,
  })  : _transitionDuration = transitionDuration,
        super(settings: settings);

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => _transitionDuration;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ),
      child: ScaleTransition(
        scale: Tween<double>(
          begin: 0.95,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          ),
        ),
        child: child,
      ),
    );
  }
}

/// Shared axis page route (Material Design 3)
enum SharedAxisTransitionType { horizontal, vertical, scaled }

class SharedAxisPageRoute<T> extends PageRoute<T> {
  final WidgetBuilder builder;
  final SharedAxisTransitionType transitionType;
  final Duration _transitionDuration;

  SharedAxisPageRoute({
    required this.builder,
    this.transitionType = SharedAxisTransitionType.horizontal,
    Duration transitionDuration = const Duration(milliseconds: 300),
    RouteSettings? settings,
  })  : _transitionDuration = transitionDuration,
        super(settings: settings);

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => _transitionDuration;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOut,
    );

    switch (transitionType) {
      case SharedAxisTransitionType.horizontal:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: FadeTransition(
            opacity: curvedAnimation,
            child: child,
          ),
        );
      case SharedAxisTransitionType.vertical:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: FadeTransition(
            opacity: curvedAnimation,
            child: child,
          ),
        );
      case SharedAxisTransitionType.scaled:
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.8,
            end: 1.0,
          ).animate(curvedAnimation),
          child: FadeTransition(
            opacity: curvedAnimation,
            child: child,
          ),
        );
    }
  }
}

/// Enhanced hero page route for property cards
class HeroPageRoute<T> extends PageRoute<T> {
  final WidgetBuilder builder;
  final Duration _transitionDuration;

  HeroPageRoute({
    required this.builder,
    Duration transitionDuration = const Duration(milliseconds: 500),
    RouteSettings? settings,
  })  : _transitionDuration = transitionDuration,
        super(settings: settings);

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => _transitionDuration;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Fade in the non-hero content
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
      child: child,
    );
  }
}

/// Slide from right page route
class SlideRightPageRoute<T> extends PageRoute<T> {
  final WidgetBuilder builder;
  final Duration _transitionDuration;

  SlideRightPageRoute({
    required this.builder,
    Duration transitionDuration = const Duration(milliseconds: 300),
    RouteSettings? settings,
  })  : _transitionDuration = transitionDuration,
        super(settings: settings);

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => _transitionDuration;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        ),
      ),
      child: child,
    );
  }
}

/// Fade through page route (fade out old, fade in new)
class FadeThroughPageRoute<T> extends PageRoute<T> {
  final WidgetBuilder builder;
  final Duration _transitionDuration;

  FadeThroughPageRoute({
    required this.builder,
    Duration transitionDuration = const Duration(milliseconds: 400),
    RouteSettings? settings,
  })  : _transitionDuration = transitionDuration,
        super(settings: settings);

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => _transitionDuration;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animation,
          curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
        ),
      ),
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.92, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
          ),
        ),
        child: child,
      ),
    );
  }
}

/// Navigation helper methods
class PageTransitions {
  /// Navigate with slide up transition
  static Future<T?> slideUp<T>(BuildContext context, Widget page) {
    return Navigator.of(context).push<T>(
      SlideUpPageRoute(builder: (context) => page),
    );
  }

  /// Navigate with fade scale transition
  static Future<T?> fadeScale<T>(BuildContext context, Widget page) {
    return Navigator.of(context).push<T>(
      FadeScalePageRoute(builder: (context) => page),
    );
  }

  /// Navigate with shared axis transition
  static Future<T?> sharedAxis<T>(
    BuildContext context,
    Widget page, {
    SharedAxisTransitionType type = SharedAxisTransitionType.horizontal,
  }) {
    return Navigator.of(context).push<T>(
      SharedAxisPageRoute(
        builder: (context) => page,
        transitionType: type,
      ),
    );
  }

  /// Navigate with hero transition
  static Future<T?> hero<T>(BuildContext context, Widget page) {
    return Navigator.of(context).push<T>(
      HeroPageRoute(builder: (context) => page),
    );
  }

  /// Navigate with slide from right
  static Future<T?> slideRight<T>(BuildContext context, Widget page) {
    return Navigator.of(context).push<T>(
      SlideRightPageRoute(builder: (context) => page),
    );
  }

  /// Navigate with fade through
  static Future<T?> fadeThrough<T>(BuildContext context, Widget page) {
    return Navigator.of(context).push<T>(
      FadeThroughPageRoute(builder: (context) => page),
    );
  }

  /// Replace current route with slide up transition
  static Future<T?> replaceWithSlideUp<T extends Object?, TO extends Object?>(
    BuildContext context,
    Widget page,
  ) {
    return Navigator.of(context).pushReplacement<T, TO>(
      SlideUpPageRoute(builder: (context) => page),
    );
  }

  /// Replace current route with fade scale transition
  static Future<T?> replaceWithFadeScale<T extends Object?, TO extends Object?>(
    BuildContext context,
    Widget page,
  ) {
    return Navigator.of(context).pushReplacement<T, TO>(
      FadeScalePageRoute(builder: (context) => page),
    );
  }

  /// Build FadeScalePageRoute for pushReplacement
  static PageRoute<T> buildFadeScale<T>({
    required WidgetBuilder builder,
  }) {
    return FadeScalePageRoute<T>(builder: builder);
  }

  /// Build SlideUpPageRoute for pushReplacement
  static PageRoute<T> buildSlideUp<T>({
    required WidgetBuilder builder,
  }) {
    return SlideUpPageRoute<T>(builder: builder);
  }

  /// Build HeroPageRoute for pushReplacement
  static PageRoute<T> buildHero<T>({
    required WidgetBuilder builder,
  }) {
    return HeroPageRoute<T>(builder: builder);
  }

  /// Build SlideRightPageRoute for pushReplacement
  static PageRoute<T> buildSlideRight<T>({
    required WidgetBuilder builder,
  }) {
    return SlideRightPageRoute<T>(builder: builder);
  }
}
