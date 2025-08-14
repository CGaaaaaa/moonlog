// 日志配置系统
pub(all) struct LogConfig {
  level : LogLevel
  use_console : Bool
  console_colored : Bool
  log_file_path : String?  // Optional 文件路径
  max_file_size : Int64
  max_backup_files : Int
  json_format : Bool
  include_timestamp : Bool
  include_module : Bool
} derive(Show)

// 默认配置
pub fn LogConfig::default() -> LogConfig {
  {
    level: LogLevel::Info,
    use_console: true,
    console_colored: true,
    log_file_path: None,
    max_file_size: 10_000_000L, // 10MB
    max_backup_files: 5,
    json_format: false,
    include_timestamp: true,
    include_module: true
  }
}

// 从环境变量加载配置
pub fn LogConfig::from_env() -> LogConfig {
  // 在MoonBit中，直接创建新的配置对象而不是修改字段
  {
    level: parse_log_level_env("INFO"),
    use_console: parse_bool_env("true"),
    console_colored: parse_bool_env("true"),
    log_file_path: None,
    max_file_size: 10485760L,
    max_backup_files: 5,
    json_format: parse_bool_env("false"),
    include_timestamp: true,
    include_module: true
  }
}

// 从配置对象创建Logger
pub fn configure_logger(config : LogConfig) -> Logger {
  let mut logger = Logger::new(config.level, "default")
  
  if config.use_console {
    let formatter = if config.json_format {
      // 这里需要创建一个通用的formatter接口
      SimpleFormatter::new(config.include_timestamp, config.include_module)
    } else if config.console_colored {
      SimpleFormatter::new(config.include_timestamp, config.include_module)
    } else {
      SimpleFormatter::new(config.include_timestamp, config.include_module)
    }
    
    let console_appender = ConsoleAppender::new(formatter)
    logger = logger.add_console_appender(console_appender)
  }
  logger
}

// 辅助函数：解析日志级别
fn parse_log_level_env(level_str : String) -> LogLevel {
  match level_str {
    "TRACE" => LogLevel::Trace
    "DEBUG" => LogLevel::Debug
    "INFO" => LogLevel::Info
    "WARN" => LogLevel::Warn
    "ERROR" => LogLevel::Error
    "FATAL" => LogLevel::Fatal
    _ => LogLevel::Info // 默认值
  }
}

// 辅助函数：解析布尔值
fn parse_bool_env(bool_str : String) -> Bool {
  match bool_str {
    "true" | "TRUE" | "1" => true
    _ => false
  }
}

// 便捷的配置方法 - 需要在global.mbt中实现
// pub fn init_with_config(config : LogConfig) -> Unit {
//   let logger = configure_logger(config)
//   global_logger.val = logger
// }

// 使用默认配置初始化 - 需要在global.mbt中实现
// pub fn init_default() -> Unit {
//   init_with_config(LogConfig::default())
// }

// 使用环境变量配置初始化 - 需要在global.mbt中实现  
// pub fn init_from_env() -> Unit {
//   init_with_config(LogConfig::from_env())
// }