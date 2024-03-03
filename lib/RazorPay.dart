import 'package:flt_razorpay/ApiServices.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPayIntegration{
  // Instance of razor pay
  final razorPayKey = dotenv.get("RAZOR_KEY");
  final razorPaySecret = dotenv.get("RAZOR_SECRET");
  final Razorpay _razorpay = Razorpay();
  initiateRazorPay() {
// To handle different event with previous functions
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment Complete");
// Do something when payment succeeds
  }

  void _handlePaymentError(PaymentFailureResponse response) {
// Do something when payment fails
    print("Payment Error");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
// Do something when an external wallet is selected
  }

  openSession({required num amount}) {
    createOrder(amount: amount).then((orderId) {
      print("Order ID: "+orderId);
      if (orderId.toString().isNotEmpty) {
        var options = {
          'key': razorPayKey, //Razor pay API Key
          'amount': amount, //in the smallest currency sub-unit.
          'name': 'Imperial Coldrinks',
          'order_id': orderId, // Generate order_id using Orders API
          'description': 'Description for order', //Order Description to be shown in razor pay page
          'timeout': 60, // in seconds
          'prefill': {
            'contact': '8411036307',
            'email': 'darshankhadse@gmail.com'
          },
          'external': {
            'wallets': ['amazon'] // optional, for adding support for wallets
          }//contact number and email id of user
        };
        _razorpay.open(options);
      } else {}
    });
  }

  createOrder({
    required num amount,
  }) async {
    final myData = await ApiServices().razorPayApi(amount, "rcp_id_1");
    if (myData["status"] == "success") {
      print(myData);
      return myData["body"]["id"];
    } else {
      return "";
    }
  }


}