import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'RazorPay.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final RazorPayIntegration _integration = RazorPayIntegration();

  @override
  void initState() {
    _integration.initiateRazorPay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Razorpay"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _integration.openSession(amount: 10);
        },
        tooltip: 'Razorpay',
        child: const Icon(Icons.add),
      ),
    );
  }
}
