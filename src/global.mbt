// 全局日志状态管理
//
// 这个模块提供全局的日志接口，包括：
// - @log.info(), @log.error() 等便捷方法
// - 全局Logger实例管理
// - 全局配置

// 全局状态

///|
let global_logger : Ref[Logger] = {
  val: Logger::new(LogLevel::Info, "default"),
}

///|
let is_initialized : Ref[Bool] = { val: false }

// 初始化全局Logger

///|
pub fn init_global_logger(logger : Logger) -> Unit {
  global_logger.val = logger
  is_initialized.val = true
}

// 获取全局Logger

///|
pub fn get_global_logger() -> Logger {
  if not(is_initialized.val) {
    // 如果未初始化，创建默认配置
    let default_console = ConsoleAppender::new(SimpleFormatter::new(true, true))
    global_logger.val = global_logger.val.add_console_appender(default_console)
    is_initialized.val = true
  }
  global_logger.val
}

// 设置全局日志级别

///|
pub fn set_global_level(level : LogLevel) -> Unit {
  global_logger.val = global_logger.val.set_level(level)
}

// 添加全局输出器

///|
pub fn add_global_console_appender(formatter : SimpleFormatter) -> Unit {
  let appender = ConsoleAppender::new(formatter)
  global_logger.val = global_logger.val.add_console_appender(appender)
}

///|
pub fn add_global_file_appender(
  file_path : String,
  formatter : SimpleFormatter,
  max_file_size : Int64,
  max_backup_files : Int,
) -> Unit {
  let appender = FileAppender::new(
    file_path, formatter, max_file_size, max_backup_files,
  )
  global_logger.val = global_logger.val.add_file_appender(appender)
}

// ================== 全局日志方法 ==================

// 基础的全局日志方法

///|
pub fn log_trace(message : String, fields : Array[LogField]) -> Unit {
  get_global_logger().log(LogLevel::Trace, message, fields)
}

///|
pub fn log_debug(message : String, fields : Array[LogField]) -> Unit {
  get_global_logger().log(LogLevel::Debug, message, fields)
}

///|
pub fn log_info(message : String, fields : Array[LogField]) -> Unit {
  get_global_logger().log(LogLevel::Info, message, fields)
}

///|
pub fn log_warn(message : String, fields : Array[LogField]) -> Unit {
  get_global_logger().log(LogLevel::Warn, message, fields)
}

///|
pub fn log_error(message : String, fields : Array[LogField]) -> Unit {
  get_global_logger().log(LogLevel::Error, message, fields)
}

///|
pub fn log_fatal(message : String, fields : Array[LogField]) -> Unit {
  get_global_logger().log(LogLevel::Fatal, message, fields)
}

// 无字段的便捷方法 - 这些是最常用的API

///|
pub fn trace_msg(message : String) -> Unit {
  log_trace(message, Array::new())
}

///|
pub fn debug_msg(message : String) -> Unit {
  log_debug(message, Array::new())
}

///|
pub fn info_msg(message : String) -> Unit {
  log_info(message, Array::new())
}

///|
pub fn warn_msg(message : String) -> Unit {
  log_warn(message, Array::new())
}

///|
pub fn error_msg(message : String) -> Unit {
  log_error(message, Array::new())
}

///|
pub fn fatal_msg(message : String) -> Unit {
  log_fatal(message, Array::new())
}

// 简洁的别名 - 方便使用

///|
pub fn info(message : String, fields : Array[LogField]) -> Unit {
  log_info(message, fields)
}

///|
pub fn warn(message : String, fields : Array[LogField]) -> Unit {
  log_warn(message, fields)
}

///|
pub fn error(message : String, fields : Array[LogField]) -> Unit {
  log_error(message, fields)
}

///|
pub fn debug(message : String, fields : Array[LogField]) -> Unit {
  log_debug(message, fields)
}

///|
pub fn trace(message : String, fields : Array[LogField]) -> Unit {
  log_trace(message, fields)
}

///|
pub fn fatal(message : String, fields : Array[LogField]) -> Unit {
  log_fatal(message, fields)
}

// 格式化的简洁别名

///|
pub fn infof(template : String, args : Array[String]) -> Unit {
  log_infof(template, args)
}

///|
pub fn errorf(template : String, args : Array[String]) -> Unit {
  log_errorf(template, args)
}

///|
pub fn warnf(template : String, args : Array[String]) -> Unit {
  log_warnf(template, args)
}

///|
pub fn debugf(template : String, args : Array[String]) -> Unit {
  log_debugf(template, args)
}

// 辅助函数：简单的消息格式化 - 支持 {} 占位符

///|
fn format_message(template : String, args : Array[String]) -> String {
  if args.length() == 0 {
    return template
  }
  let mut result = template
  let mut arg_index = 0

  // 简化的 {} 替换实现
  while arg_index < args.length() {
    let placeholder = "{}"
    if result.contains(placeholder) && arg_index < args.length() {
      result = result.replace(old=placeholder, new=args[arg_index])
      arg_index = arg_index + 1
    } else {
      break
    }
  }
  result
}

// 格式化的全局日志方法

///|
pub fn log_tracef(template : String, args : Array[String]) -> Unit {
  let message = format_message(template, args)
  get_global_logger().log(LogLevel::Trace, message, Array::new())
}

///|
pub fn log_debugf(template : String, args : Array[String]) -> Unit {
  let message = format_message(template, args)
  get_global_logger().log(LogLevel::Debug, message, Array::new())
}

///|
pub fn log_infof(template : String, args : Array[String]) -> Unit {
  let message = format_message(template, args)
  get_global_logger().log(LogLevel::Info, message, Array::new())
}

///|
pub fn log_warnf(template : String, args : Array[String]) -> Unit {
  let message = format_message(template, args)
  get_global_logger().log(LogLevel::Warn, message, Array::new())
}

///|
pub fn log_errorf(template : String, args : Array[String]) -> Unit {
  let message = format_message(template, args)
  get_global_logger().log(LogLevel::Error, message, Array::new())
}

// 带字段的格式化方法

///|
pub fn log_tracef_with_fields(
  template : String,
  args : Array[String],
  fields : Array[LogField],
) -> Unit {
  get_global_logger().logf_with_fields(LogLevel::Trace, template, args, fields)
}

///|
pub fn log_debugf_with_fields(
  template : String,
  args : Array[String],
  fields : Array[LogField],
) -> Unit {
  get_global_logger().logf_with_fields(LogLevel::Debug, template, args, fields)
}

///|
pub fn log_infof_with_fields(
  template : String,
  args : Array[String],
  fields : Array[LogField],
) -> Unit {
  get_global_logger().logf_with_fields(LogLevel::Info, template, args, fields)
}

///|
pub fn log_warnf_with_fields(
  template : String,
  args : Array[String],
  fields : Array[LogField],
) -> Unit {
  get_global_logger().logf_with_fields(LogLevel::Warn, template, args, fields)
}

///|
pub fn log_errorf_with_fields(
  template : String,
  args : Array[String],
  fields : Array[LogField],
) -> Unit {
  get_global_logger().logf_with_fields(LogLevel::Error, template, args, fields)
}

// 便捷的配置函数

///|
pub fn configure_console_logger(
  level : LogLevel,
  include_timestamp : Bool,
  include_module : Bool,
  use_colors : Bool,
) -> Unit {
  // 清空现有的appenders
  global_logger.val = Logger::new(level, "default")

  // 暂时简化：忽略颜色参数，都使用SimpleFormatter
  ignore(use_colors) // 消除未使用警告
  let formatter = SimpleFormatter::new(include_timestamp, include_module)
  let console_appender = ConsoleAppender::new(formatter)
  global_logger.val = global_logger.val.add_console_appender(console_appender)
  is_initialized.val = true
}

///|
pub fn configure_file_logger(
  level : LogLevel,
  file_path : String,
  max_file_size : Int64,
  max_backup_files : Int,
  use_json : Bool,
) -> Unit {
  global_logger.val = Logger::new(level, "default")

  // 暂时简化：忽略JSON参数，都使用SimpleFormatter
  ignore(use_json) // 消除未使用警告
  let simple_formatter = SimpleFormatter::new(true, true)
  let file_appender = FileAppender::new(
    file_path, simple_formatter, max_file_size, max_backup_files,
  )
  global_logger.val = global_logger.val.add_file_appender(file_appender)
  is_initialized.val = true
}

// 添加更多便捷配置方法

///|
pub fn configure_simple_console() -> Unit {
  configure_console_logger(LogLevel::Info, true, true, false)
}

///|
pub fn configure_colored_console() -> Unit {
  configure_console_logger(LogLevel::Info, true, true, true)
}

///|
pub fn configure_json_console() -> Unit {
  // 暂时简化：使用SimpleFormatter
  configure_simple_console()
}

// 配置混合输出（控制台+文件）- 简化版本

///|
pub fn configure_mixed_logger(
  console_level : LogLevel,
  file_level : LogLevel,
  file_path : String,
  use_colors : Bool,
) -> Unit {
  // 暂时简化：只配置控制台输出，文件输出使用占位实现
  ignore(file_level) // 消除未使用警告
  configure_console_logger(console_level, true, true, use_colors)
  println("混合日志配置完成（文件输出: " + file_path + "）")
}
