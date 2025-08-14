// 基本使用示例
//
// 这个文件展示了如何使用moonlog日志库的各种功能

// 导入必要的日志模块
// import moonlog/global
// import moonlog/logger
// import moonlog/types

// 示例1: 基本的全局日志记录
fn example_basic_global_logging() -> Unit {
  println("=== 基本全局日志记录示例 ===")
  
  // 直接使用全局日志方法
  info_msg("应用程序已启动")
  warn_msg("这是一个警告消息")
  error_msg("发生了一个错误")
  
  // 带字段的结构化日志
  let user_fields = [
    field_str("user_id", "12345"),
    field_str("username", "alice"),
    field_int("age", 25)
  ]
  info("用户登录", user_fields)
  
  // 格式化日志
  infof("用户 {} 在 {} 登录", ["alice", "2023-12-28"])
}

// 示例2: 配置全局Logger
fn example_configure_global_logger() -> Unit {
  println("\n=== 配置全局Logger示例 ===")
  
  // 配置控制台Logger
  configure_console_logger(
    LogLevel::Debug,
    true, 
    true,
    true
  )
  
  debug_msg("这是一条调试消息")
  info_msg("配置完成")
  
  // 配置文件Logger
  configure_file_logger(
    LogLevel::Info,
    "logs/app.log",
    1024L * 1024L,  // 1MB
    5,
    false
  )
  
  info_msg("文件日志配置完成")
}

// 示例3: 创建自定义Logger实例
fn example_custom_logger() -> Unit {
  println("\n=== 自定义Logger实例示例 ===")
  
  // 创建一个专门用于数据库操作的Logger
  let db_logger = Logger::new(LogLevel::Debug, "database")
    .add_console_appender(
      ConsoleAppender::new(
        SimpleFormatter::new(true, true)
      )
    )
    .add_file_appender(
      FileAppender::new(
        "logs/database.log",
        SimpleFormatter::new(true, true),
        512L * 1024L,  // 512KB
        3
      )
    )
  
  // 使用自定义Logger（通过基本log方法）
  db_logger.log(LogLevel::Info, "数据库连接已建立", [
    field_str("host", "localhost"),
    field_int("port", 5432)
  ])
  
  db_logger.logf_with_fields(LogLevel::Debug, "执行查询: {}", ["SELECT * FROM users"], [])
  
  db_logger.log(LogLevel::Error, "数据库连接失败", [
    field_str("error", "connection timeout"),
    field_int("retry_count", 3)
  ])
}

// 示例4: 不同格式化器的使用
fn example_different_formatters() -> Unit {
  println("\n=== 不同格式化器示例 ===")
  
  // JSON格式化器
  let json_logger = Logger::new(LogLevel::Info, "json-module")
    .add_console_appender(
      ConsoleAppender::new(
        SimpleFormatter::new(true, true)
      )
    )
  
  json_logger.log(LogLevel::Info, "JSON格式的日志", [
    field_str("event", "user_action"),
    field_str("action", "login"),
    field_bool("success", true)
  ])
  
  // 彩色格式化器演示
  println("\n彩色格式化器演示：")
  debug_msg("这是调试信息")
  info_msg("这是信息日志") 
  warn_msg("这是警告信息")
  error_msg("这是错误信息")
}

// 示例5: 复杂的结构化日志
fn example_structured_logging() -> Unit {
  println("\n=== 结构化日志示例 ===")
  
  // 用户活动跟踪
  let user_activity_fields = [
    field_str("user_id", "user_12345"),
    field_str("session_id", "sess_abcdef"),
    field_str("ip_address", "192.168.1.100"),
    field_str("user_agent", "Mozilla/5.0"),
    field_int("duration_ms", 1500)
  ]
  
  info("用户活动记录", user_activity_fields)
  
  // API请求日志
  let api_request_fields = [
    field_str("method", "POST"),
    field_str("endpoint", "/api/v1/users"),
    field_int("status_code", 201),
    field_int("response_time_ms", 45),
    field_int("request_size", 1024),
    field_int("response_size", 256)
  ]
  
  info("API请求处理", api_request_fields)
  
  // 错误详情
  let error_fields = [
    field_str("error_type", "ValidationError"),
    field_str("error_code", "INVALID_EMAIL"),
    field_str("field_name", "email"),
    field_str("provided_value", "invalid-email"),
    field_str("stack_trace", "at validate_email:42")
  ]
  
  error("输入验证失败", error_fields)
}

// 示例6: 不同级别的日志和过滤
fn example_log_levels() -> Unit {
  println("\n=== 日志级别和过滤示例 ===")
  
  // 设置为Info级别，Debug和Trace将被过滤掉
  set_global_level(LogLevel::Info)
  
  trace_msg("这条trace日志不会显示")
  debug_msg("这条debug日志不会显示") 
  info_msg("这条info日志会显示")
  warn_msg("这条warn日志会显示")
  error_msg("这条error日志会显示")
  
  // 改为Debug级别
  set_global_level(LogLevel::Debug)
  println("\n切换到Debug级别:")
  
  debug_msg("现在debug日志会显示了")
  trace_msg("但trace日志仍然不会显示")
}

// 主函数：运行所有示例
pub fn run_examples() -> Unit {
  println("🌙 MoonLog 日志库使用示例")
  println("================================\n")
  
  example_basic_global_logging()
  example_configure_global_logger()
  example_custom_logger()
  example_different_formatters() 
  example_structured_logging()
  example_log_levels()
  
  println("\n================================")
  println("✅ 所有示例运行完成!")
}