// 日志级别枚举

///|
pub(all) enum LogLevel {
  Trace
  Debug
  Info
  Warn
  Error
  Fatal
} derive(Eq, Compare, Show)

// 日志级别的数值表示，用于比较

///|
pub fn to_int(self : LogLevel) -> Int {
  match self {
    Trace => 0
    Debug => 1
    Info => 2
    Warn => 3
    Error => 4
    Fatal => 5
  }
}

// 日志级别的字符串表示

///|
pub fn to_string(self : LogLevel) -> String {
  match self {
    Trace => "TRACE"
    Debug => "DEBUG"
    Info => "INFO"
    Warn => "WARN"
    Error => "ERROR"
    Fatal => "FATAL"
  }
}

// 结构化日志字段 - 支持多种值类型

///|
pub(all) enum LogValue {
  String(String)
  Int(Int)
  Int64(Int64)
  Double(Double)
  Bool(Bool)
} derive(Eq, Show)

///|
pub fn LogValue::to_string(self : LogValue) -> String {
  match self {
    String(s) => s
    Int(i) => i.to_string()
    Int64(l) => l.to_string()
    Double(d) => d.to_string()
    Bool(b) => if b { "true" } else { "false" }
  }
}

///|
pub(all) struct LogField {
  key : String
  value : LogValue
} derive(Eq, Show)

// 便捷的字段构造函数

///|
pub fn field_str(key : String, value : String) -> LogField {
  { key, value: LogValue::String(value) }
}

///|
pub fn field_int(key : String, value : Int) -> LogField {
  { key, value: LogValue::Int(value) }
}

///|
pub fn field_bool(key : String, value : Bool) -> LogField {
  { key, value: LogValue::Bool(value) }
}

///|
pub fn field_double(key : String, value : Double) -> LogField {
  { key, value: LogValue::Double(value) }
}

// 日志条目

///|
pub(all) struct LogEntry {
  level : LogLevel
  message : String
  fields : Array[LogField]
  timestamp : Int64 // Unix 时间戳（毫秒）
  module_name : String // 模块名称
} derive(Show)

// 创建新的日志条目

///|
pub fn LogEntry::new(
  level : LogLevel,
  message : String,
  fields : Array[LogField],
  module_name : String,
) -> LogEntry {
  {
    level,
    message,
    fields,
    timestamp: 1703750400L, // 暂时使用固定时间戳，后续可以更新为真实实现
    module_name,
  }
}

// 使用utils.mbt中的get_current_timestamp实现

// 日志格式化器接口

///|
pub trait LogFormatter {
  format(Self, LogEntry) -> String
}

// 简单文本格式化器

///|
pub(all) struct SimpleFormatter {
  include_timestamp : Bool
  include_module : Bool
} derive(Show)

// 日志输出器接口

///|
pub trait LogAppender {
  append(Self, LogEntry) -> Unit
}

// Appender 类型定义

// 统一的格式化器枚举

///|
pub(all) enum AnyFormatter {
  Simple(SimpleFormatter)
  // Json(JsonFormatter) 
  // Color(ColorFormatter)
} derive(Show)

// 控制台输出器

///|
pub(all) struct ConsoleAppender {
  formatter : AnyFormatter
} derive(Show)

// 文件输出器

///|
pub(all) struct FileAppender {
  file_path : String
  formatter : AnyFormatter
  max_file_size : Int64 // 最大文件大小（字节）
  max_backup_files : Int // 最大备份文件数
} derive(Show)

// 通用的Appender包装器，用于在Logger中存储不同类型的Appender

///|
pub(all) enum AnyAppender {
  Console(ConsoleAppender)
  File(FileAppender)
  Multi(Array[AnyAppender]) // 直接使用Array而不是单独的结构体
  Async(AnyAppender, Array[LogEntry], Int) // inner, buffer, max_buffer_size
  Filtered(AnyAppender, LogLevel) // inner, min_level
} derive(Show)

// AnyFormatter 格式化函数

///|
pub fn format_entry(formatter : AnyFormatter, entry : LogEntry) -> String {
  match formatter {
    Simple(f) => f.format_simple(entry)
    // Json(f) => f.format_json(entry)
    // Color(f) => f.format_color(entry)
  }
}

// ConsoleAppender 实现

///|
impl LogAppender for ConsoleAppender with append(self, entry) {
  let formatted = format_entry(self.formatter, entry)
  println(formatted)
}

// FileAppender 实现

///|
impl LogAppender for FileAppender with append(self, entry) {
  let formatted = format_entry(self.formatter, entry)

  // 简化实现：直接输出到控制台（占位实现）
  println("[FILE:" + self.file_path + "] " + formatted)

  // TODO: 实现真实的文件操作
  // let current_size = get_file_size(self.file_path)
  // if current_size > self.max_file_size {
  //   let _ = rotate_file(self.file_path, self.max_backup_files)
  // }
  // let dir_path = get_directory_path(self.file_path)
  // let _ = ensure_directory_exists(dir_path)
  // let success = write_to_file(self.file_path, formatted)
}

// AnyAppender 实现

///|
impl LogAppender for AnyAppender with append(self, entry) {
  match self {
    Console(appender) => appender.append(entry)
    File(appender) => appender.append(entry)
    Multi(appenders) =>
      for appender in appenders {
        appender.append(entry)
      }
    Async(inner, buffer, max_size) => {
      buffer.push(entry)
      // 简化：当缓冲区满时立即写入
      if buffer.length() >= max_size {
        for buffered_entry in buffer {
          inner.append(buffered_entry)
        }
        buffer.clear()
      }
    }
    Filtered(inner, min_level) =>
      if entry.level.to_int() >= min_level.to_int() {
        inner.append(entry)
      }
  }
}

// 移除局部写入文件函数，使用utils.mbt中的实现

// 日志过滤器接口

///|
pub trait LogFilter {
  should_log(Self, LogLevel, String) -> Bool
}
