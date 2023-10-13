import "package:flutter/material.dart";

import "package:firebase_auth/firebase_auth.dart";
import "package:money_formatter/money_formatter.dart";

import "package:mobile/services/cart.dart";
import "package:mobile/services/paystack.dart";
import "package:mobile/components/scroll_to_hide.dart";

import "course_item_card.dart";

class CourseItems extends StatefulWidget {
  final List<CartItem> cartItems;

  final PaymentService paymentService = PaymentService();
  CourseItems({
    super.key,
    required this.cartItems,
  });

  @override
  State<CourseItems> createState() => _CourseItems();
}

class _CourseItems extends State<CourseItems> {
  late ScrollController _controller;

  String? _discountCode;
  double _totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onCheckout() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var initializePayment = await widget.paymentService.initializePayment(
        userId: user.uid,
        discountCode: _discountCode,
        courseIds: widget.cartItems,
      );
      // checkout
      // ignore: use_build_context_synchronously
      await widget.paymentService.checkout(
        context: context,
        email: user.email!,
        reference: initializePayment.reference,
        accessCode: initializePayment.accessCode,
      );

      // verify the payment
      try {
        var verifyResponse = await widget.paymentService.verifyPayment(
          initializePayment.reference,
        );
        if (verifyResponse == false) {
          throw Exception("Payment is invalid");
        }
      } catch (e) {
        print("Payment verification failed");
        print(e);
        throw e;
      }
    }
  }

  void _buildLoadingDialog(
    BuildContext context,
    Future Function(BuildContext) future,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        future(context);
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void _onApplyCoupon(String discountCode) async {
    _buildLoadingDialog(
      context,
      (dialogContext) async {
        var res = await widget.paymentService.validateDiscount(
          discountCode: discountCode,
          courseIds: widget.cartItems,
        );

        var valid = res["valid"] as bool;
        if (valid) {
          setState(() {
            _totalAmount = res["resultantAmount"] as double;
          });
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Discount applied"),
            ),
          );
        } else {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Discount code is invalid"),
            ),
          );
        }
        // ignore: use_build_context_synchronously
        Navigator.of(dialogContext).pop();
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      },
    );
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CourseItemsBottomNavigation(
        totalAmount: 500.0,
        onCheckout: _onCheckout,
        controller: _controller,
        onApplyCoupon: _onApplyCoupon,
      ),
      body: Container(
        margin: const EdgeInsets.only(
          bottom: 8,
        ),
        child: ListView.separated(
          itemCount: widget.cartItems.length,
          controller: _controller,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            // final cartItem = cartItems[index];
            return const CourseItem(
              price: 123.00,
              title: "Hello World",
              program: "ICAN ATS Level 1",
            );
          },
        ),
      ),
    );
  }
}

class CourseItemsBottomNavigation extends StatelessWidget {
  final double totalAmount;
  final VoidCallback onCheckout;
  final ScrollController controller;
  final Function(String) onApplyCoupon;

  final TextEditingController _couponTextController = TextEditingController();

  CourseItemsBottomNavigation({
    super.key,
    required this.controller,
    required this.onCheckout,
    required this.totalAmount,
    required this.onApplyCoupon,
  });

  void _buildCouponModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Enter coupon code"),
          content: TextField(
            autofocus: true,
            controller: _couponTextController,
            decoration: const InputDecoration(
              hintText: "Enter coupon code",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => onApplyCoupon(_couponTextController.text),
              child: const Text("Apply"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScrollToHideWidget(
      controller: controller,
      child: Material(
        child: Container(
          height: 150,
          padding: const EdgeInsets.only(
            top: 12,
          ),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    // Total amount
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total amount",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            MoneyFormatter(
                              amount: totalAmount,
                            ).output.symbolOnLeft,
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        ],
                      ),
                    ),

                    // Discount button
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: GestureDetector(
                        onTap: () {
                          _buildCouponModal(context);
                        },
                        child: Material(
                          elevation: 0,
                          clipBehavior: Clip.antiAlias,
                          borderRadius: BorderRadius.circular(4),
                          color: Theme.of(context).colorScheme.primary,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.local_offer,
                                color: Colors.white,
                              ),
                              SizedBox(height: 6),
                              Text(
                                "Apply Coupon",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Checkout button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(55),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                ),
                onPressed: onCheckout,
                child: const Text("Proceed to Checkout"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
