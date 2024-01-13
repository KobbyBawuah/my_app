import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry/sentry.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Go to Profile'),
              onPressed: () {
                context.go("/profile");
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Go to Widget'),
              onPressed: () {
                context.go("/widget");
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Counter: $_counter',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Throw Sample Error'),
              onPressed: _throwSampleError,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Create CustomTransaction'),
              onPressed: _createTransaction,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _throwSampleError() {
    try {
      // Call a method that might fail
      aMethodThatMightFail();
    } catch (exception, stackTrace) {
      // Capture the exception and send it to Sentry
      Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
    }
  }

  void _createTransaction() async {
    final transaction =
        Sentry.startTransaction('processOrderBatch()', 'task');

    try {
      // Call a method to process order batch
      processOrderBatch();
    } catch (exception) {
      transaction.throwable = exception;
      transaction.status = SpanStatus.internalError();
    } finally {
      await transaction.finish();
    }
  }

  // Sample method that might fail
  void aMethodThatMightFail() {
    throw Exception('This is a sample error');
  }

  // Sample method to process order batch
  void processOrderBatch() {
    // Your order batch processing logic goes here
  }
}
