import 'package:flutter/material.dart';
import 'package:flutter_navigation/routes/router.dart';
import 'package:go_router/go_router.dart';

class ProductPage extends StatefulWidget {
  final String productId;
  final String? source;
  final String? coupon;
  const ProductPage({
    required this.productId,
    this.source,
    this.coupon,
    super.key,
  });

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> with RouteAware {
  @override
  void didChangeDependencies() {
    final route = ModalRoute.of(context);

    if (route is PageRoute) {
      homeObserver.subscribe(this, route);
    }
    super.didChangeDependencies();
  }

  @override
  void didPush() {
    print('ProductPage of ${widget.productId} visible');
  }

  @override
  void didPopNext() {
    print('Returned to ProductPage of ${widget.productId}');
  }

  @override
  void didPushNext() {
    print('Another screen covered ProductPage of ${widget.productId}');
  }

  @override
  void dispose() {
    homeObserver.unsubscribe(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product')),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Text('Product ID: ${widget.productId}'),

            Text('Source: ${widget.source}'),

            Text('Coupon: ${widget.coupon}'),

            ElevatedButton(
              onPressed: () {
                context.push('/home/product/P2002');
              },

              child: const Text('Push Another Product'),
            ),
          ],
        ),
      ),
    );
  }
}
