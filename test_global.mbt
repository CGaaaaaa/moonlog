// 全局日志功能测试

test "global logger basic functionality" {
  // 重置全局logger为默认状态
  let default_logger = Logger::new(LogLevel::Info, "global")
  set_global_logger(default_logger)
  
  let logger = get_global_logger()
  inspect!(logger.min_level, content="Info")
  inspect!(logger.module_name, content="global")
  inspect!(logger.appenders.length(), content="0")
}

test "logger creation and methods" {
  let logger = Logger::new(LogLevel::Debug, "test_module")
  inspect!(logger.min_level, content="Debug")
  inspect!(logger.module_name, content="test_module")
  
  let updated_logger = logger.set_level(LogLevel::Warn)
  inspect!(updated_logger.min_level, content="Warn")
  
  let renamed_logger = logger.set_module("new_module")
  inspect!(renamed_logger.module_name, content="new_module")
}

test "global level setting" {
  set_global_level(LogLevel::Debug)
  let logger = get_global_logger()
  inspect!(logger.min_level, content="Debug")
  
  // 恢复默认级别
  set_global_level(LogLevel::Info)
}

// 简单的测试：调用全局日志函数（即使没有appender也会执行代码路径）
test "global logging functions coverage" {
  // 设置为最低级别确保所有函数都会被执行
  set_global_level(LogLevel::Trace)
  
  // 测试所有级别的日志函数 - 即使没有appender，函数也会被调用
  trace("trace message")
  debug("debug message") 
  info("info message")
  warn("warn message")
  error("error message")
  fatal("fatal message")
  
  // 这些调用会增加代码覆盖率，即使没有visible的输出
}

test "global logging functions with fields coverage" {
  set_global_level(LogLevel::Trace)
  
  let fields = [field_str("user", "alice"), field_int("count", 42)]
  
  // 测试所有带字段的日志函数
  trace_with_fields("trace with fields", fields)
  debug_with_fields("debug with fields", fields)
  info_with_fields("info with fields", fields)
  warn_with_fields("warn with fields", fields)
  error_with_fields("error with fields", fields)
  fatal_with_fields("fatal with fields", fields)
}

test "logger log method coverage" {
  let logger = Logger::new(LogLevel::Debug, "test")
  
  // 测试log方法（即使没有appender）
  logger.log(LogLevel::Info, "test message", Array::new())
  logger.log(LogLevel::Trace, "filtered message", Array::new()) // 应该被过滤
  
  // 测试带字段的日志
  let fields = [field_str("key", "value")]
  logger.log(LogLevel::Error, "error with fields", fields)
} 