// 后端服务选择
// 可选值： supabase, appwrite
const String backend = String.fromEnvironment(
  'BACKEND',
  defaultValue: 'supabase',
);

// appwrite 配置
const String appwriteProjectId = String.fromEnvironment(
  'APPWRITE_PROJECT_ID',
  defaultValue: '6891b9060006d7ea6d47',
);
const String appwriteEndpoint = String.fromEnvironment(
  'APPWRITE_ENDPOINT',
  defaultValue: 'https://syd.cloud.appwrite.io/v1',
);
const String appwriteApiKey = String.fromEnvironment(
  'APPWRITE_API_KEY',
  defaultValue: '',
);

// supabase 配置
const String supabaseUrl = String.fromEnvironment(
  'SUPABASE_URL',
  defaultValue: 'https://db.zenkee.com',
);
const String supabaseAnonKey = String.fromEnvironment(
  'SUPABASE_ANON_KEY',
  defaultValue:
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.ewogICJyb2xlIjogImFub24iLAogICJpc3MiOiAic3VwYWJhc2UiLAogICJpYXQiOiAxNzM0MzY0ODAwLAogICJleHAiOiAxODkyMTMxMjAwCn0.kGgrzOHvqWcZ60zc55c5pvH5Bb_KoOUpGaQyZH6sFGA',
);
const String supabaseServiceRoleKey = String.fromEnvironment(
  'SUPABASE_SERVICE_ROLE_KEY',
  defaultValue: '',
);

//stripe config
const String stripeMyHostBaseUrl = String.fromEnvironment(
  'STRIPE_MY_HOST_URL',
  defaultValue: 'https://pay.zenkee.com/',
);

const String stripeMerchantIdentifier = String.fromEnvironment(
  'STRIPE_MERCHANT_IDENTIFIER',
  defaultValue: 'merchant.zenkee.com',
);

const String stripeMerchantDisplayName = String.fromEnvironment(
  'MERCHANT_DISPLAY_NAME',
  defaultValue: 'ZENKEE',
);

// Stripe API基础URL
const String stripeBaseUrl = 'https://api.stripe.com/v1';

// 从环境变量获取Stripe密钥
const String stripeSecretKey = String.fromEnvironment(
  'STRIPE_SECRET_KEY',
  defaultValue: '',
);

// 从环境变量获取Stripe发布密钥
const String stripePublishableKey = String.fromEnvironment(
  'STRIPE_PUBLISHABLE_KEY',
  defaultValue: '',
);

// 订阅计划ID（在Stripe控制台中创建）
const Map<String, Map<String, String>> stripeProducts = {
  'price_1Ruluo19p49AJ7Nj2kKo6rtW': {'name': 'Zenkee Demo APP Permanent', 'price': '\$49.90'},  
  'price_1Rulti19p49AJ7NjYJDigDBL': {'name': 'Zenkee Demo App Monthly Subscription', 'price': '\$1.99/Month'},
};
