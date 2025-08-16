import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/line_button.dart';
import '../../config.dart';
import '../../l10n/app_localizations.dart';
import '../../logger.dart';
import '../../models/stripe/price.dart';
import '../../providers/user_provider.dart';
import '../../services/backend_service.dart';
import '../../services/stripe_service.dart';

class PlansPage extends StatefulWidget {
  const PlansPage({super.key});

  @override
  State<PlansPage> createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  Future<List<Price>>? _futureLoadProductData;

  List<Price> _prices = [];

  @override
  void initState() {
    super.initState();
    _futureLoadProductData = _loadProductInfo(stripeProductId);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
    // 加载stripe产品信息
    FutureBuilder<List<Price>>(
      future: _futureLoadProductData,
      builder: (context, snapshot) {
        // if (snapshot.data == null) {
        //   return Text(" Not found Product");
        // }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('加载失败: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('暂无可用套餐'));
        }
        return Column(
          children: [
            Text("Plans", style: TextStyle(fontSize: 24)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _prices.map((e) {
                return _buildPlanWidget(e, () {
                  final pro = Provider.of<UserProvider>(context, listen: false);
                  pro.toBuyPriceId = e.id;
                  pro.toBuyAmount = 1;
                  pro.navigateTo("/payment");
                });
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPlanWidget(
    // String productId,
    // String planName,
    // String price,
    Price price,
    VoidCallback onPressed,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.all(12),

      child: Container(
        constraints: BoxConstraints(minWidth: 300, minHeight: 200),
        child: Column(
          children: [
            Text(price.nickname),
            Text(price.currency),
            Text("${price.unit_amount / 100}"),
            if (price.metadata['plan'] != null)
              Text(price.metadata['plan'] ?? ""),
            // 数量输入框
            if (price.metadata['plan'] != "one_time")
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      // TODO: 处理减少数量
                    },
                    icon: Icon(Icons.remove),
                  ),
                  Container(
                    width: 50,
                    child: TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      ),
                      controller: TextEditingController(text: "1"),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // TODO: 处理增加数量
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
            // Expanded(child: Container()),
            LineButton(
              onPress: onPressed,
              isLoading: false,
              text: AppLocalizations.of(context)!.purchase,
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Price>> _loadProductInfo(String prodId) async {
    final pro = Provider.of<UserProvider>(context, listen: false);

    _prices = await StripeService().getPricesOfProduct(
      await BackendService.instance.token ?? "",
      prodId,
    );
    return _prices;
  }

  void _reloadData() {
    setState(() {
      // 创建一个新的 Future 对象
      _futureLoadProductData = _loadProductInfo(stripeProductId);
    });
  }
}
