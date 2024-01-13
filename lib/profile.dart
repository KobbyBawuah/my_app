import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sentry/sentry.dart';

//The aim of this page is to show there is a transaction waiting for spans. The delays will not be instrumented but their time will 
//be acknowledged in the total navigation spans.

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Go to Dashboard'),
          onPressed: () {
            // Simulate a complex operation that takes 5-10 seconds
            _simulateComplexOperation(context);
          },
        ),
      ),
    );
  }

  Future<void> _simulateComplexOperation(BuildContext context) async {
    // Show loading indicator or perform any other UI update if needed
    // before starting the complex operation.
    // For example:
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Performing complex operation...')),
    );

    final transaction = Sentry.startTransaction(
      'webrequest',
      'request',
      bindToScope: true,
    );
    var client = SentryHttpClient();

    try {
      // Simulate the complex operation using Future.delayed
      await Future.delayed(Duration(seconds: 2)); // Adjust the duration as needed

      // Perform a GET request
      final response = await client.get(Uri.parse('https://jsonplaceholder.typicode.com/todos/1'));

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Parse the response JSON if needed
        final responseData = json.decode(response.body);
        print('GET request successful: $responseData');
        
        // Show the response in a SnackBar for 3 seconds
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Response: $responseData'),
            duration: Duration(seconds: 3),
          ),
        );

        // Wait for 3 seconds before navigating to the dashboard
        await Future.delayed(Duration(seconds: 3));

      } else {
        // Handle the error if the request was not successful
        print('GET request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      // Handle any exceptions that may occur during the request
      print('Error during GET request: $error');
    } finally {
      // Close the SentryHttpClient and finish the transaction
      client.close();
      await transaction.finish(status: SpanStatus.ok());
    }

    // After the operation is complete, navigate to the dashboard
    // GoRouter.of(context).go("/");
    context.go("/");
  }
}
