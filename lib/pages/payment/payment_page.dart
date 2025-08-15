import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_template/l10n/app_localizations.dart';
import 'package:flutter_template/models/stripe/checkout_session_create_res.dart';
import 'package:flutter_template/models/stripe/product.dart';
import 'package:flutter_template/services/backend_service.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

import '../../components/global_snackbar.dart';
import '../../components/line_button.dart';
import '../../config.dart';
import '../../logger.dart';
import '../../models/stripe/price.dart';
import '../../providers/user_provider.dart';
import '../../services/stripe_service.dart';

import 'package:url_launcher/url_launcher.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

enum PayState { unknown, opening, waiting, paid }

class _PaymentPageState extends State<PaymentPage> {
  PayState payState = PayState.unknown;

  String? payError = "";

  // bool _isProcessing = false;

  Future<bool>? _futureLoadProductData;

  CheckoutSessionCreateRes? _session;

  Price? _price;
  Product? _product;

  // Timer? heartbeatTimer;
  // Duration timeout = Duration(seconds: 30);
  // 定时器用于定期检查支付状态
  Timer? _paymentCheckTimer;

  // 检查支付状态的间隔时间
  final Duration _checkInterval = Duration(seconds: 5);

  // 最大检查次数(5分钟)
  final int _maxCheckCount = 60;

  // 当前检查次数
  int _currentCheckCount = 0;

  @override
  void initState() {
    super.initState();
    _futureLoadProductData = _loadProductInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _loadProductInfo() async {
    final pro = Provider.of<UserProvider>(context, listen: false);
    final priceId = pro.toBuyPriceId;

    _price = await StripeService().getPrice(
      await BackendService.instance.token ?? "",
      priceId!,
    );
    if (_price == null) {
      return false;
    }

    // 加载产品信息
    _product = await StripeService().getProduct(
      await BackendService.instance.token ?? "",
      _price!.product.id ?? '',
    );

    logger.d("_price!.product.id=${_price!.product.id} ${_product?.name}");

    if (_product == null) {
      return false;
    }

    return true;
  }

  void _reloadData() {
    setState(() {
      // 创建一个新的 Future 对象
      _futureLoadProductData = _loadProductInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<UserProvider>(context, listen: false);
    if (pro.userSession == null) {
      return Center(child: Text(AppLocalizations.of(context)!.login));
    }

    return FutureBuilder<bool>(
      future: _futureLoadProductData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Theme.of(context).colorScheme.onSurface,
              size: 200,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              children: [
                Text('Error: ${snapshot.error}'),
                Text(AppLocalizations.of(context)!.contactUsPlease),
                Text(AppLocalizations.of(context)!.contactEmail(adminEmail)),
                IconButton(
                  onPressed: () {
                    _reloadData();
                  },
                  icon: Icon(Icons.refresh),
                ),
              ],
            ),
          );
        } else {
          if (snapshot.data == false) {
            return Center(
              child: Text(AppLocalizations.of(context)!.priceOrProductNotFound),
            );
          }

          return Center(
            child: Card(
              margin: const EdgeInsets.all(16),

              child: SizedBox(
                width: 400,
                height: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.pricing,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    Divider(),
                    Text(
                      _product!.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      AppLocalizations.of(context)!.paymentAmountTotal(
                        _price!.unit_amount / 100,
                        _price!.currency,
                      ),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),

                    Expanded(child: Container()),
                    Divider(),
                    if (payError != null)
                      Text(
                        payError!,
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    if (payState == PayState.unknown) ..._buildButtonsUnknown(),
                    if (payState == PayState.opening) ..._buildButtonsOpening(),
                    if (payState == PayState.waiting) ..._buildButtonsWaiting(),
                    if (payState == PayState.paid) ..._buildButtonsPaid(),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  List<Widget> _buildButtonsUnknown() {
    return [
      LineButton(
        onPress: () => handlePayment(context, _price!),
        isLoading: false,
        loadingText: AppLocalizations.of(context)!.waitingPayment,
        text: AppLocalizations.of(context)!.pay,
      ),
    ];
  }

  List<Widget> _buildButtonsOpening() {
    return [
      LineButton(
        onPress: () => handlePayment(context, _price!),
        isLoading: true,
        loadingText: AppLocalizations.of(context)!.waitingPayment,
        text: AppLocalizations.of(context)!.pay,
      ),
    ];
  }

  List<Widget> _buildButtonsWaiting() {
    return [
      TextButton(
        onPressed: () {
          launchMyUrl(_session!.url);
        },
        child: Text(AppLocalizations.of(context)!.reopenPaymentPage),
      ),

      LineButton(
        onPress: () => handlePayment(context, _price!),
        isLoading: true,
        loadingText: AppLocalizations.of(context)!.waitingPayment,
        text: AppLocalizations.of(context)!.pay,
      ),
    ];
  }

  List<Widget> _buildButtonsPaid() {
    return [ 
      Icon(Icons.check,size:48, color: Colors.green,),
        Text(AppLocalizations.of(context)!.paidSuccessful, style: TextStyle(fontSize: 24),),
        SizedBox(height: 15,),
    ];
  }

  void onPaid() {
    Provider.of<UserProvider>(context).navigateTo("/paid");
  }

  Future<void> handlePayment(BuildContext context, Price price) async {
    if (payState != PayState.unknown) {
      return;
    }
    try {
      setState(() {
        payState = PayState.opening;
        payError = null;
      });

      // 启动检查支付状态。
      _stopPaymentStatusCheck();
      _startPaymentStatusCheck();

      final pro = Provider.of<UserProvider>(context, listen: false);
      final session = await StripeService().createCheckoutSession(
        await BackendService.instance.token ?? "",
        pro.userSession?.email ?? '',
        pro.referenceId, 
        price.id,
        price.type,
        1,
      );

      if (session == null) {
        return;
      }

      setState(() {
        _session = session;
        payState = PayState.waiting;
      });

      launchMyUrl(session.url);
    } catch (e) {
      setState(() {
        _session = null;
        payState = PayState.unknown;
      });
      GlobalSnackbar.show(
        message: " $e",
        icon: Icons.notifications,
        backgroundColor: Colors.blue,
      );
    } finally {}
  }

  Future<void> launchMyUrl(String payURL) async {
    final Uri url = Uri.parse(payURL);

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('无法打开链接: $url');
    }
  }

  // void startWs(String referenceId) {
  //   if (channel != null) {
  //     channel!.sink.close();
  //   }
  //   channel = StripeService().createPaymentWebSocketChannel(referenceId, (
  //     message,
  //   ) {
  //     if (message.type == "payment_success") {
  //       GlobalSnackbar.show(
  //         message: "支付成功",
  //         icon: Icons.check_circle,
  //         backgroundColor: Colors.blue,
  //       );
  //     } else if (message.type == "payment_failed") {
  //       GlobalSnackbar.show(
  //         message: "支付失败",
  //         icon: Icons.error,
  //         backgroundColor: Colors.red,
  //       );
  //     }
  //   });
  // }

  // 检查支付状态
  void _startPaymentStatusCheck() {
    _currentCheckCount = 0;
    _paymentCheckTimer?.cancel();

    _paymentCheckTimer = Timer.periodic(_checkInterval, (timer) {
      _currentCheckCount++;

      // 检查是否超过最大检查次数
      if (_currentCheckCount >= _maxCheckCount) {
        timer.cancel();
        setState(() {
          payError = AppLocalizations.of(context)!.paymentStatusCheckTimeout;
        });
        GlobalSnackbar.show(
          message: payError ?? "",
          icon: Icons.error,
          backgroundColor: Colors.orange,
        );
        return;
      }

      // 调用后端API检查支付状态
      _checkPaymentStatus();
    });
  }

  // 停止检查支付状态
  void _stopPaymentStatusCheck() {
    _paymentCheckTimer?.cancel();
    _paymentCheckTimer = null;
  }

  // 检查支付状态的具体实现
  Future<void> _checkPaymentStatus() async {
    if (_session == null) {
      return;
    }
    try {
      // final pro = Provider.of<UserProvider>(context, listen: false);
      final status = await StripeService().getCheckoutSessionStatus(
        await BackendService.instance.token ?? "",
        _session!.id,
      );

      // logger.d(" _checkPaymentStatus= status $status");

      if (status == "paid") {
        _stopPaymentStatusCheck();
        setState(() {
          payState = PayState.paid;
        });

        if (mounted) {
          GlobalSnackbar.show(
            message: AppLocalizations.of(context)!.paidSuccessful,

            icon: Icons.check_circle,
            backgroundColor: Colors.green,
          );
        }
      } else if (status == "unpaid") {
        print("unpaid");
      } else if (status == "no_payment_required") {
        print("no_payment_required");
      } else {
        payState = PayState.unknown;
        payError = "unexceptional status: $status";
      }
    } catch (e) {
      logger.e("检查支付状态失败: $e");
    }
  }
}
