// MoonLog 核心接口定义
// 提供日志系统的核心 trait 和全局设置

// 日志级别
pub enum LogLevel {
  Trace
  Debug
  Info
  Warn
  Error
  Fatal
} derive(Eq, Compare, Show)

pub fn LogLevel::to_int(self : LogLevel) -> Int {
  match self {
    Trace => 0
    Debug => 1
    Info => 2
    Warn => 3
    Error => 4
    Fatal => 5
  }
}

pub fn LogLevel::to_string(self : LogLevel) -> String {
  match self {
    Trace => "TRACE"
    Debug => "DEBUG"
    Info => "INFO"
    Warn => "WARN"
    Error => "ERROR"
    Fatal => "FATAL"
  }
}

// 结构化日志字段值类型
pub enum LogValue {
  String(String)
  Int(Int)
  Double(Double)
  Bool(Bool)
} derive(Eq, Show)

pub fn LogValue::to_string(self : LogValue) -> String {
  match self {
    String(s) => s
    Int(i) => i.to_string()
    Double(d) => d.to_string()
    Bool(b) => if b { "true" } else { "false" }
  }
}

// 结构化日志字段
pub struct LogField {
  key : String
  value : LogValue
} derive(Eq, Show)

pub fn LogField::new(key : String, value : LogValue) -> LogField {
  { key, value }
}

pub fn LogField::to_string(self : LogField) -> String {
  self.key + "=" + self.value.to_string()
}

// 日志条目
pub struct LogEntry {
  level : LogLevel
  message : String
  fields : Array[LogField]
  module_name : String
  timestamp : Int64
}

pub fn LogEntry::new(
  level : LogLevel,
  message : String,
  fields : Array[LogField],
  module_name : String
) -> LogEntry {
  {
    level,
    message,
    fields,
    module_name,
    timestamp: get_current_timestamp()
  }
}

// 简单的时间戳获取函数（占位实现）
fn get_current_timestamp() -> Int64 {
  1703750400L // 固定时间戳，实际使用时应该获取真实时间
}

// 核心 trait 定义 - 允许用户实现自定义 Appender
pub trait Appender {
  append(Self, LogEntry) -> Unit
}

// 用于动态分发的包装器
pub enum AppenderBox {
  Box((LogEntry) -> Unit)
}

impl Appender for AppenderBox with append(self, entry) {
  match self {
    Box(f) => f(entry)
  }
}

// 将任何 Appender 转换为 AppenderBox
pub fn[A : Appender] AppenderBox::from(appender : A) -> AppenderBox {
  AppenderBox::Box(fn(entry) { appender.append(entry) })
}

// Logger 结构定义
pub struct Logger {
  appenders : Array[AppenderBox]
  min_level : LogLevel
  module_name : String
}

// Logger 构造和方法
pub fn Logger::new(min_level : LogLevel, module_name : String) -> Logger {
  { appenders: Array::new(), min_level, module_name }
}

pub fn[A : Appender] Logger::add_appender(self : Logger, appender : A) -> Logger {
  self.appenders.push(AppenderBox::from(appender))
  self
}

pub fn Logger::set_level(self : Logger, level : LogLevel) -> Logger {
  { ..self, min_level: level }
}

pub fn Logger::set_module(self : Logger, module_name : String) -> Logger {
  { ..self, module_name }
}

// 核心日志记录方法
pub fn Logger::log(
  self : Logger,
  level : LogLevel,
  message : String,
  fields : Array[LogField]
) -> Unit {
  if level.to_int() >= self.min_level.to_int() {
    let entry = LogEntry::new(level, message, fields, self.module_name)
    for appender in self.appenders {
      appender.append(entry)
    }
  }
}

// 全局 Logger 实例 - 使用 Ref[Option[Logger]] 实现
let global_logger : Ref[Option[Logger]] = { val: None }

// 获取全局 Logger
pub fn get_global_logger() -> Logger {
  match global_logger.val {
    Some(logger) => logger
    None => {
      // 返回默认的空 Logger
      Logger::new(LogLevel::Info, "global")
    }
  }
}

// 设置全局 Logger
pub fn set_global_logger(logger : Logger) -> Unit {
  global_logger.val = Some(logger)
}

// 设置全局日志级别
pub fn set_global_level(level : LogLevel) -> Unit {
  match global_logger.val {
    Some(logger) => {
      global_logger.val = Some(logger.set_level(level))
    }
    None => {
      // 如果没有全局 logger，创建一个新的
      global_logger.val = Some(Logger::new(level, "global"))
    }
  }
}

// 便捷的字段构造函数
pub fn field_str(key : String, value : String) -> LogField {
  LogField::new(key, LogValue::String(value))
}

pub fn field_int(key : String, value : Int) -> LogField {
  LogField::new(key, LogValue::Int(value))
}

pub fn field_double(key : String, value : Double) -> LogField {
  LogField::new(key, LogValue::Double(value))
}

pub fn field_bool(key : String, value : Bool) -> LogField {
  LogField::new(key, LogValue::Bool(value))
}

// 全局日志函数 - 简单消息
pub fn trace(message : String) -> Unit {
  get_global_logger().log(LogLevel::Trace, message, Array::new())
}

pub fn debug(message : String) -> Unit {
  get_global_logger().log(LogLevel::Debug, message, Array::new())
}

pub fn info(message : String) -> Unit {
  get_global_logger().log(LogLevel::Info, message, Array::new())
}

pub fn warn(message : String) -> Unit {
  get_global_logger().log(LogLevel::Warn, message, Array::new())
}

pub fn error(message : String) -> Unit {
  get_global_logger().log(LogLevel::Error, message, Array::new())
}

pub fn fatal(message : String) -> Unit {
  get_global_logger().log(LogLevel::Fatal, message, Array::new())
}

// 全局日志函数 - 带字段
pub fn trace_with_fields(message : String, fields : Array[LogField]) -> Unit {
  get_global_logger().log(LogLevel::Trace, message, fields)
}

pub fn debug_with_fields(message : String, fields : Array[LogField]) -> Unit {
  get_global_logger().log(LogLevel::Debug, message, fields)
}

pub fn info_with_fields(message : String, fields : Array[LogField]) -> Unit {
  get_global_logger().log(LogLevel::Info, message, fields)
}

pub fn warn_with_fields(message : String, fields : Array[LogField]) -> Unit {
  get_global_logger().log(LogLevel::Warn, message, fields)
}

pub fn error_with_fields(message : String, fields : Array[LogField]) -> Unit {
  get_global_logger().log(LogLevel::Error, message, fields)
}

pub fn fatal_with_fields(message : String, fields : Array[LogField]) -> Unit {
  get_global_logger().log(LogLevel::Fatal, message, fields)
} 

// StdoutAppender - 标准输出日志 Appender
// 这是一个简单的实现，只依赖基础的 println 函数

// 标准输出 Appender
pub struct StdoutAppender {
  show_timestamp : Bool
  show_module : Bool
}

impl Appender for StdoutAppender with append(self, entry : LogEntry) {
  let parts : Array[String] = Array::new()
  
  // 添加时间戳（如果启用）
  if self.show_timestamp {
    parts.push(entry.timestamp.to_string())
  }
  
  // 添加日志级别
  parts.push("[" + entry.level.to_string() + "]")
  
  // 添加模块名（如果启用）
  if self.show_module {
    parts.push("[" + entry.module_name + "]")
  }
  
  // 添加消息
  parts.push(entry.message)
  
  // 构建基础日志行
  let base_line = parts.join(" ")
  
  // 添加字段（如果有）
  if entry.fields.length() > 0 {
    let field_strings = entry.fields.map(fn(f) { f.to_string() })
    let fields_str = field_strings.join(", ")
    println(base_line + " {" + fields_str + "}")
  } else {
    println(base_line)
  }
}

// 便捷构造函数
pub fn StdoutAppender::new() -> StdoutAppender {
  { show_timestamp: true, show_module: true }
}

pub fn StdoutAppender::with_config(show_timestamp : Bool, show_module : Bool) -> StdoutAppender {
  { show_timestamp, show_module }
} 

 