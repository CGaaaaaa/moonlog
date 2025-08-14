// MoonLog 演示程序
//
// 这个程序展示了moonlog库的主要功能

///| 运行MoonLog演示
pub fn demo() -> Unit {
  println("🌙 MoonLog 日志库演示")
  println("===================")

  // 基本的全局日志
  println("\n1. 基本全局日志:")
  info_msg("应用程序启动")
  warn_msg("这是一个警告")
  error_msg("这是一个错误")

  // 结构化日志
  println("\n2. 结构化日志:")
  let user_fields : Array[LogField] = [
    field_str("user_id", "12345"),
    field_str("username", "alice"),
    field_int("age", 25),
    field_bool("is_admin", true),
  ]
  info("用户登录事件", user_fields)

  // 格式化日志
  println("\n3. 格式化日志:")
  infof("用户 {} 在 {} 登录", ["alice", "2023-12-28 10:30:00"])
  errorf("连接失败，重试次数: {}", ["3"])

  // 配置演示
  println("\n4. 彩色日志演示:")
  configure_colored_console()
  info_msg("这是彩色的Info消息")
  warn_msg("这是彩色的Warn消息")
  error_msg("这是彩色的Error消息")
  println("\n5. JSON格式演示:")
  configure_json_console()
  info("JSON格式的结构化日志", [
    field_str("service", "auth"),
    field_int("user_id", 123),
    field_bool("success", true),
  ])
  println("\n6. 级别过滤演示:")
  set_global_level(LogLevel::Warn)
  info_msg("这条Info消息不会显示")
  warn_msg("这条Warn消息会显示")
  error_msg("这条Error消息会显示")

  // 恢复简单控制台
  println("\n7. 恢复简单格式:")
  configure_simple_console()
  info_msg("恢复到简单格式")
  println("\n✨ 演示完成！")
}
