// MoonLog 使用示例
// 演示全局日志接口的各种用法

fn init {
  println("🌙 MoonLog Demo - 全局日志接口演示")
  println("==================================================")
}

fn main {
  // === 1. 基础全局日志函数演示 ===
  println("\n📝 1. 基础全局日志函数演示")
  
  // 直接使用全局日志函数 - 最简单的方式
  @moonlog.info("应用启动成功")
  @moonlog.warn("这是一个警告信息")  
  @moonlog.error("模拟错误信息")
  @moonlog.debug("调试信息（可能不显示，取决于日志级别）")
  
  // === 2. 结构化日志演示 ===
  println("\n🏗️ 2. 结构化日志演示")
  
  @moonlog.info_with_fields("用户登录", [
    @moonlog.field_str("user", "alice"),
    @moonlog.field_str("ip", "192.168.1.100"),
    @moonlog.field_int("user_id", 12345)
  ])
  
  @moonlog.warn_with_fields("API请求超时", [
    @moonlog.field_str("endpoint", "/api/users"),
    @moonlog.field_int("timeout_ms", 5000),
    @moonlog.field_bool("retry", true)
  ])
  
  // === 3. 实际应用场景演示 ===
  println("\n🚀 3. 实际应用场景演示")
  
  // 模拟Web服务器启动
  simulate_web_server_startup()
  
  // 模拟处理HTTP请求
  simulate_http_request_handling()
  
  // 模拟错误处理
  simulate_error_handling()
  
  println("\n✅ Demo演示完成！")
  println("\n💡 提示：当前使用的是默认配置")
  println("   - 如需自定义Logger实例，请参考API文档")
  println("   - 支持动态配置日志级别和Appender")
  println("   - 支持模块化的Logger管理")
  
  // 显示高级配置示例
  advanced_demo()
}

// 模拟Web服务器启动过程
fn simulate_web_server_startup() -> Unit {
  @moonlog.info("正在启动Web服务器...")
  
  @moonlog.debug_with_fields("加载配置文件", [
    @moonlog.field_str("config_file", "/etc/app/config.json"),
    @moonlog.field_bool("found", true)
  ])
  
  @moonlog.info_with_fields("服务器启动成功", [
    @moonlog.field_str("host", "0.0.0.0"),
    @moonlog.field_int("port", 8080),
    @moonlog.field_str("version", "1.0.0")
  ])
}

// 模拟HTTP请求处理
fn simulate_http_request_handling() -> Unit {
  @moonlog.info_with_fields("收到HTTP请求", [
    @moonlog.field_str("method", "GET"),
    @moonlog.field_str("path", "/api/users/123"),
    @moonlog.field_str("user_agent", "curl/7.68.0")
  ])
  
  @moonlog.debug_with_fields("查询数据库", [
    @moonlog.field_str("table", "users"),
    @moonlog.field_int("user_id", 123)
  ])
  
  @moonlog.info_with_fields("请求处理完成", [
    @moonlog.field_int("status_code", 200),
    @moonlog.field_int("response_time_ms", 45)
  ])
}

// 模拟错误处理
fn simulate_error_handling() -> Unit {
  @moonlog.error_with_fields("数据库连接失败", [
    @moonlog.field_str("host", "db.example.com"),
    @moonlog.field_int("port", 5432),
    @moonlog.field_str("error", "connection timeout")
  ])
  
  @moonlog.warn("启用降级模式")
  
  @moonlog.fatal_with_fields("系统关键错误", [
    @moonlog.field_str("component", "payment_service"),
    @moonlog.field_str("error_code", "PAYMENT_001"),
    @moonlog.field_bool("auto_recovery", false)
  ])
} 
