import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry/sentry.dart';

/// Widget that executes an expensive operation
class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  MyWidgetState createState() => MyWidgetState();
}

class MyWidgetState extends State<MyWidget> {
  static const delayInSeconds = 5;

  @override
  void initState() {
    super.initState();
    _doComplexOperation();
    _doComplexOperation2();
  }

  /// Attach child spans to the routing transaction
  /// or the transaction will not be sent to Sentry.
  Future<void> _doComplexOperation() async {
    final activeTransaction = Sentry.getSpan();
    final childSpan = activeTransaction?.startChild(
      'complex operation',
      description: 'running a $delayInSeconds seconds operation',
    );
    await Future.delayed(const Duration(seconds: delayInSeconds));
    childSpan?.finish();
  }

  /// Attach child spans to the routing transaction
  /// or the transaction will not be sent to Sentry.
  Future<void> _doComplexOperation2() async {

    // final activeTransaction = Sentry.getSpan();
    // final childSpan = activeTransaction?.startChild(
    //   'complex operation',
    //   description: 'running a second $delayInSeconds seconds operation',
    // );


    await Future.delayed(const Duration(seconds: delayInSeconds));

    // childSpan?.finish();

    // After the delay, navigate back to the home page
    GoRouter.of(context)?.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'This screen will automatically close in $delayInSeconds seconds...',
        textAlign: TextAlign.center,
      ),
    );
  }
}
