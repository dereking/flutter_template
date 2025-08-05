 
import 'package:flutter/material.dart'; 
import '../components/footer.dart'; 
 

class PricingPage extends StatelessWidget {
  const PricingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('PricingPage'),
      //   centerTitle: true,
      // ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          const Text(
            'Pick your pricing',
            style: TextStyle(fontSize: 48),
          ),
          const Text(
            'Stripe subscriptions and secure webhooks are built-in. Just add your Stripe Product IDs! Try it out below with test credit card number 4242 4242 4242 4242 4242',
            style: TextStyle(fontSize: 20),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildPricingPanel(context, 'Basic', 'Basic features',
                      '\0.00', ['Feature 1', 'Feature 2', 'Feature 3']),
                  _buildPricingPanel(context, 'Pro', 'Pro features', '\0.00',
                      ['Feature 1', 'Feature 2', 'Feature 3']),
                  _buildPricingPanel(
                      context,
                      'Enterprise',
                      'Enterprise features',
                      '\0.00',
                      ['Feature 1', 'Feature 2', 'Feature 3']),
                  _buildPricingPanel(context, 'Free', 'Free features', '\0.00',
                      ['Feature 1', 'Feature 2', 'Feature 3']),
                ],
              ),
            ),
          ),
          Footer(),
        ]),
      ),
    );
  }

  Widget _buildPricingPanel(BuildContext context, String title,
      String description, String price, List<String> features) {
    return Flexible(
      flex: 1, // 设置宽度为父组件宽度的 1/3
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(16),
          constraints: const BoxConstraints(minWidth: 200, minHeight: 300),
          height: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: const TextStyle(fontSize: 24)),
              Text(description, style: const TextStyle(fontSize: 16)),
              Text(price, style: const TextStyle(fontSize: 18)),
              Expanded(
                child: Column(
                  children: [
                    ...features.asMap().entries.map((e) {
                      return Row(
                        children: [
                          const Icon(Icons.check),
                          Text(
                            '${e.key + 1}. ${e.value}',
                            style: const TextStyle(fontSize: 16),
                          )
                        ],
                      );
                    }),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart_outlined),
                    Text('Buy plan'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
