// 主要的日志器结构  
pub(all) struct Logger {
  appenders : Array[AnyAppender]
  min_level : LogLevel
  module_name : String
} derive(Show)

pub fn Logger::new(
  min_level : LogLevel,
  module_name : String
) -> Logger {
  { appenders: Array::new(), min_level, module_name }
}

// 添加输出器
pub fn add_appender(self : Logger, appender : AnyAppender) -> Logger {
  self.appenders.push(appender)
  self
}

// 便捷的添加方法
pub fn add_console_appender(self : Logger, appender : ConsoleAppender) -> Logger {
  self.add_appender(AnyAppender::Console(appender))
}

pub fn add_file_appender(self : Logger, appender : FileAppender) -> Logger {
  self.add_appender(AnyAppender::File(appender))
}

pub fn add_any_appender(self : Logger, appender : AnyAppender) -> Logger {
  self.add_appender(appender)
}

// 设置最小日志级别
pub fn set_level(self : Logger, level : LogLevel) -> Logger {
  { ..self, min_level: level }
}

// 设置模块名
pub fn set_module(self : Logger, module_name : String) -> Logger {
  { ..self, module_name }
}

// 核心日志记录方法
pub fn log(
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

// Logger的实例方法改为使用log方法直接调用

// Logger实例方法只保留基本的log方法，其他便捷方法在global模块中定义

// 扩展的格式化方法，支持结构化参数
pub fn logf_with_fields(
  self : Logger, 
  level : LogLevel, 
  template : String, 
  args : Array[String],
  fields : Array[LogField]
) -> Unit {
  let message = format_message(template, args)
  self.log(level, message, fields)
}