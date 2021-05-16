import 'package:color_filter/quick_checkout.dart';
import 'package:flutter/material.dart';
import 'package:paystack_manager/models/momo_number_info.dart';
import 'package:paystack_manager/models/payment_card.dart';
import 'package:paystack_manager/models/payment_info.dart';
import 'package:paystack_manager/models/payment_option.dart';
import 'package:paystack_manager/models/transaction.dart';
import 'package:paystack_manager/paystack_pay_manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: "Herrr"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Paystack Payment"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //initiate payment button
            RaisedButton(
              onPressed: _processPayment,
              child: Text(
                "Pay",
              ),
            ),
            RaisedButton(
              child: Text(
                "Momo Pay",
              ),
              onPressed: () async {
                double amount = 100;
                var info = PaymentInfo(
                  secretKey: "sk_test_cb1d525f8078e68404d95fbdd79b6c58e40203f4",
                  reference: DateTime.now().microsecondsSinceEpoch.toString(),
                  amount: double.parse(amount.toStringAsFixed(2)),
                  country: "GH",
                  currency: "GHS",
                  email: "rassay31@gmail.com",
                  firstName: "Samuel",
                  lastName: "Annin Yeboah",
                  metadata: {
                    "custom_fields": [
                      {
                        "value": "snapTask",
                        "display_name": "Payment to",
                        "variable_name": "payment_to"
                      }
                    ]
                  },
                  companyAssetImage: Image(
                    image: AssetImage("assets/images/logo.png"),
                  ),
                  momoNumberInfo: MomoNumberInfo(
                    "0551234987",
                    "MTN",
                  ),
                );

                var optionToUse = PaymentOption(
                  name: "Mobile Money",
                  iconData: Icons.smartphone,
                  slug: "momo",
                  isMomo: true,
                );

                Transaction transaction = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return PayWithMomoPage(
                    paymentInfo: info,
                    optionToUse: optionToUse,
                  );
                }));
                _onPaymentDone(transaction);
              },
            ),
            RaisedButton(
              child: Text(
                "Card Pay",
              ),
              onPressed: () async {
                double amount = 100;
                var info = PaymentInfo(
                  secretKey: "sk_test_cb1d525f8078e68404d95fbdd79b6c58e40203f4",
                  reference: DateTime.now().microsecondsSinceEpoch.toString(),
                  amount: double.parse(amount.toStringAsFixed(2)),
                  country: "GH",
                  currency: "GHS",
                  email: "rassay31@gmail.com",
                  firstName: "Samuel",
                  lastName: "Annin Yeboah",
                  metadata: {
                    "custom_fields": [
                      {
                        "value": "snapTask",
                        "display_name": "Payment to",
                        "variable_name": "payment_to"
                      }
                    ]
                  },
                  companyAssetImage: Image(
                    image: AssetImage("assets/images/logo.png"),
                  ),
                  paymentCard: PaymentCard(
                      number: "4084084084084081",
                      month: "05",
                      year: "22",
                      cvv: "408"),
                );

                var optionToUse = PaymentOption(
                  name: "Card",
                  iconData: Icons.credit_card,
                  slug: "card",
                  isCard: true,
                );

                Transaction transaction = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return PayWithMomoPage(
                    paymentInfo: info,
                    optionToUse: optionToUse,
                  );
                }));

                _onPaymentDone(transaction);
              },
            ),
          ],
        ),
      ),
    );
  }

  _onPaymentDone(Transaction transaction) {
    print("===========>msg: ${transaction.message} <===============");
    print("===========>ref: ${transaction.refrenceNumber} <===============");
    print("===========>state: ${transaction.state} <===============");
  }

  void _processPayment() {
    try {
      PaystackPayManager(context: context)
        // Don't store your secret key on users device.
        // Make sure this is retrive from your server at run time
        ..setSecretKey("sk_test_cb1d525f8078e68404d95fbdd79b6c58e40203f4")
        //accepts widget
        ..setCompanyAssetImage(Image(
          image: AssetImage("assets/images/logo.png"),
        ))
        ..setAmount(050)
        // ..setReference("your-unique-transaction-reference")
        ..setReference(DateTime.now().millisecondsSinceEpoch.toString())
        ..setCurrency("GHS")
        ..setEmail("bakoambrose@gmail.com")
        ..setFirstName("Ambrose")
        ..setLastName("Bako")
        ..setMetadata(
          {
            "custom_fields": [
              {
                "value": "snapTask",
                "display_name": "Payment to",
                "variable_name": "payment_to"
              }
            ]
          },
        )
        ..onSuccesful(_onPaymentSuccessful)
        ..onPending(_onPaymentPending)
        ..onFailed(_onPaymentFailed)
        ..onCancel(_onPaymentCancelled)
        ..initialize();
    } catch (error) {
      print("Payment Error ==> $error");
    }
  }

  void _onPaymentSuccessful(Transaction transaction) {
    print("Transaction was successful");
    print("Transaction Message ===> ${transaction.message}");
    print("Transaction Refrence ===> ${transaction.refrenceNumber}");
  }

  void _onPaymentPending(Transaction transaction) {
    print("Transaction is pendinng");
    print("Transaction Refrence ===> ${transaction.refrenceNumber}");
  }

  void _onPaymentFailed(Transaction transaction) {
    print("Transaction failed");
    print("Transaction Message ===> ${transaction.message}");
  }

  void _onPaymentCancelled(Transaction transaction) {
    print("Transaction was cancelled");
  }
}
