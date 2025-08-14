import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/global_snackbar.dart';
import '../../config.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool _isSubscribed = false;
  String? _currentPlan;
  bool _isLoading = false;

  // 表单控制器
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvcController = TextEditingController();
  final _nameController = TextEditingController();

  // 服务器URL和Stripe密钥（从环境变量获取）
  final String _serverUrl = stripeMyHostBaseUrl;
  final String _stripePublishableKey = stripePublishableKey;

  @override
  void initState() {
    super.initState();
    _checkSubscriptionStatus();
  }

  // 检查订阅状态
  Future<void> _checkSubscriptionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isSubscribed = prefs.getBool('isSubscribed') ?? false;
      _currentPlan = prefs.getString('currentPlan');
    });
  }

  // 创建支付方式
  Future<String?> _createPaymentMethod() async {
    try {
      // 拆分过期日期
      final expiryParts = _expiryDateController.text.split('/');
      if (expiryParts.length != 2) {
        throw Exception('请输入有效的过期日期 (MM/YY)');
      }

      final month = int.parse(expiryParts[0].trim());
      final year = int.parse('20${expiryParts[1].trim()}');

      // 调用Stripe API创建支付方式
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_methods'),
        headers: {
          'Authorization': 'Bearer $_stripePublishableKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'type': 'card',
          'card[number]': _cardNumberController.text.replaceAll(' ', ''),
          'card[exp_month]': month.toString(),
          'card[exp_year]': year.toString(),
          'card[cvc]': _cvcController.text,
          'billing_details[name]': _nameController.text,
        },
      );

      final data = json.decode(response.body);

      if (response.statusCode != 200) {
        throw Exception(data['error']['message'] ?? '创建支付方式失败');
      }

      return data['id'] as String;
    } catch (e) {

      GlobalSnackbar.show(
        message: "$e",
        icon: Icons.notifications,
        backgroundColor: Colors.blue,
      );
      // ScaffoldMessenger.of(
      //   context,
      // ).showSnackBar(SnackBar(content: Text(e.toString())));
      return null;
    }
  }

  // 订阅处理
  Future<void> _subscribe(String planType) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 1. 创建支付方式
      final paymentMethodId = await _createPaymentMethod();
      if (paymentMethodId == null) return;

      // 2. 通过后端创建订阅
      final response = await http.post(
        Uri.parse('$_serverUrl/create-subscription'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'planType': planType,
          'paymentMethodId': paymentMethodId,
          'customerId': await _getCustomerId(), // 获取或创建客户ID
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode != 200) {
        throw Exception(data['error'] ?? '创建订阅失败');
      }

      // 3. 保存订阅状态
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isSubscribed', true);
      await prefs.setString('currentPlan', planType);

      // 4. 显示成功消息并更新UI
      GlobalSnackbar.show(
        message: "订阅 $planType 成功!",
        icon: Icons.notifications,
        backgroundColor: Colors.blue,
      );
      // ScaffoldMessenger.of(
      //   context,
      // ).showSnackBar(SnackBar(content: Text('订阅 $planType 成功!')));

      _clearCardForm();
      await _checkSubscriptionStatus();
    } catch (e) {

      GlobalSnackbar.show(
        message: "$e",
        icon: Icons.notifications,
        backgroundColor: Colors.blue,
      );  
      // ScaffoldMessenger.of(
      //   context,
      // ).showSnackBar(SnackBar(content: Text('订阅失败: ${e.toString()}')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 取消订阅
  Future<void> _cancelSubscription() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$_serverUrl/cancel-subscription'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'customerId': await _getCustomerId()}),
      );

      if (response.statusCode != 200) {
        throw Exception('取消订阅失败');
      }

      // 更新本地状态
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isSubscribed', false);
      await prefs.remove('currentPlan');

      GlobalSnackbar.show(
        message: "订阅已取消",
        icon: Icons.notifications,
        backgroundColor: Colors.blue,
      );
      // ScaffoldMessenger.of(
      //   context,
      // ).showSnackBar(const SnackBar(content: Text('订阅已取消')));

      await _checkSubscriptionStatus();
    } catch (e) {

      GlobalSnackbar.show(
        message: "$e",
        icon: Icons.notifications,
        backgroundColor: Colors.blue,
      );
      // ScaffoldMessenger.of(
      //   context,
      // ).showSnackBar(SnackBar(content: Text('取消订阅失败: ${e.toString()}')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 获取或创建客户ID
  Future<String> _getCustomerId() async {
    final prefs = await SharedPreferences.getInstance();
    String? customerId = prefs.getString('customerId');

    if (customerId == null) {
      // 调用后端创建新客户
      final response = await http.post(
        Uri.parse('$_serverUrl/create-customer'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        customerId = data['customerId'];
        if (customerId == null) {
          throw Exception('创建客户失败');
        }
        await prefs.setString('customerId', customerId);
      } else {
        throw Exception('创建客户失败');
      }
    }

    return customerId;
  }

  // 清空卡片表单
  void _clearCardForm() {
    _cardNumberController.clear();
    _expiryDateController.clear();
    _cvcController.clear();
    _nameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('会员订阅')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: _isSubscribed
              ? _buildSubscriptionStatus()
              : _buildSubscriptionPlans(),
        ),
      ),
    );
  }

  Widget _buildSubscriptionStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          '您已订阅',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          '当前计划: ${_currentPlan == 'monthly' ? '月度会员' : '年度会员'}',
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: _isLoading ? null : _cancelSubscription,
          child: _isLoading
              ? const CircularProgressIndicator()
              : const Text('取消订阅'),
        ),
      ],
    );
  }

  Widget _buildSubscriptionPlans() {
    return Column(
      children: [
        const Text(
          '选择订阅计划',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),

        // 月度订阅
        Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  '月度会员',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('每月 ¥28.00'),
                const SizedBox(height: 16),
                const Text('包含所有高级功能'),
                const SizedBox(height: 16),
                _buildPaymentForm('monthly'),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // 年度订阅
        Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  '年度会员',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('每年 ¥288.00 (节省 ¥48)'),
                const SizedBox(height: 16),
                const Text('包含所有高级功能 + 额外福利'),
                const SizedBox(height: 16),
                _buildPaymentForm('yearly'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 支付表单
  Widget _buildPaymentForm(String planType) {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: '持卡人姓名',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.text,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _cardNumberController,
          decoration: const InputDecoration(
            labelText: '卡号',
            hintText: '1234 5678 9012 3456',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          maxLength: 19,
          onChanged: (value) {
            // 格式化卡号，每4位加一个空格
            var newVal = value.replaceAll(RegExp(r'\s'), '');
            if (newVal.length > 0) {
              newVal = newVal
                  .replaceAllMapped(
                    RegExp(r'.{4}'),
                    (match) => '${match.group(0)} ',
                  )
                  .trim();
            }
            if (newVal != value) {
              _cardNumberController.value = TextEditingValue(
                text: newVal,
                selection: TextSelection.collapsed(offset: newVal.length),
              );
            }
          },
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _expiryDateController,
                decoration: const InputDecoration(
                  labelText: '过期日期',
                  hintText: 'MM/YY',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                maxLength: 5,
                onChanged: (value) {
                  // 格式化过期日期
                  var newVal = value.replaceAll(RegExp(r'/'), '');
                  if (newVal.length > 2) {
                    newVal = '${newVal.substring(0, 2)}/${newVal.substring(2)}';
                  }
                  if (newVal != value) {
                    _expiryDateController.value = TextEditingValue(
                      text: newVal,
                      selection: TextSelection.collapsed(offset: newVal.length),
                    );
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _cvcController,
                decoration: const InputDecoration(
                  labelText: 'CVC',
                  hintText: '123',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                maxLength: 4,
                obscureText: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _isLoading ? null : () => _subscribe(planType),
          child: _isLoading
              ? const CircularProgressIndicator()
              : Text('订阅 ${planType == 'monthly' ? '月度' : '年度'} 会员'),
        ),
      ],
    );
  }
}
