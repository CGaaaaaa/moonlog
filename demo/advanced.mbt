// MoonLog 高级使用示例
// 演示完整的Logger配置和自定义Appender

// 注意：这个demo目前无法运行，因为需要导入的包中无法直接创建枚举值
// 这里作为API使用示例，展示完整的功能

///|
fn advanced_demo() -> Unit {
  println("🌙 MoonLog 高级配置示例（代码参考）")
  println("==================================================")

  // 在实际使用中，这些代码应该在同一个包内，或者通过包提供的工厂函数创建

  // === 1. 创建带Appender的Logger ===
  // let logger_with_output = Logger::new(LogLevel::Debug, "myapp")
  //   .add_appender(StdoutAppender::with_config(true, true))
  // 
  // 设置为全局Logger，这样就能看到输出了
  // set_global_logger(logger_with_output)
  // 
  // info("现在可以看到日志输出了！")
  // debug_with_fields("用户操作", [
  //   field_str("action", "login"),
  //   field_str("user", "alice")
  // ])

  // === 2. 模块化Logger示例 ===
  // let auth_logger = Logger::new(LogLevel::Info, "auth")
  //   .add_appender(StdoutAppender::with_config(true, true))
  //   
  // let db_logger = Logger::new(LogLevel::Debug, "database") 
  //   .add_appender(StdoutAppender::with_config(false, true))
  //   
  // auth_logger.log(LogLevel::Info, "认证开始", [])
  // db_logger.log(LogLevel::Debug, "执行查询", [
  //   field_str("sql", "SELECT * FROM users")
  // ])

  // === 3. 动态级别调整 ===
  // 运行时调整全局级别
  // set_global_level(LogLevel::Trace)
  // trace("现在trace级别也会输出")
  // 
  // set_global_level(LogLevel::Error) 
  // info("这条不会输出") 
  // error("这条会输出")

  println("💡 完整代码请参考主包中的测试文件")
  println(
    "   这些功能需要在主包内使用，或通过工厂函数创建",
  )
}
