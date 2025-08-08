

// 后端服务选择
// 可选值： supabase, appwrite
const String backend = String.fromEnvironment('BACKEND', defaultValue: 'supabase');

 
// appwrite 配置
const String appwriteProjectId = String.fromEnvironment('APPWRITE_PROJECT_ID', defaultValue:'6891b9060006d7ea6d47');
const String appwriteEndpoint = String.fromEnvironment('APPWRITE_ENDPOINT', defaultValue:  'https://syd.cloud.appwrite.io/v1');
const String appwriteApiKey = String.fromEnvironment('APPWRITE_API_KEY', defaultValue: '');


// supabase 配置 
const String supabaseUrl = String.fromEnvironment('SUPABASE_URL', defaultValue: 'https://db.zenkee.com');
const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.ewogICJyb2xlIjogImFub24iLAogICJpc3MiOiAic3VwYWJhc2UiLAogICJpYXQiOiAxNzM0MzY0ODAwLAogICJleHAiOiAxODkyMTMxMjAwCn0.kGgrzOHvqWcZ60zc55c5pvH5Bb_KoOUpGaQyZH6sFGA');
const String supabaseServiceRoleKey = String.fromEnvironment('SUPABASE_SERVICE_ROLE_KEY', defaultValue: '');
