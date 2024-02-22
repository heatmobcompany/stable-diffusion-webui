import logging
import copy
import sys
from modules import cmd_args
args, _ = cmd_args.parser.parse_known_args()
from logging.handlers import RotatingFileHandler

class ColoredFormatter(logging.Formatter):
    COLORS = {
        "DEBUG": "\033[0;36m",  # CYAN
        "INFO": "\033[0;32m",  # GREEN
        "WARNING": "\033[0;33m",  # YELLOW
        "ERROR": "\033[0;31m",  # RED
        "CRITICAL": "\033[0;37;41m",  # WHITE ON RED
        "RESET": "\033[0m",  # RESET COLOR
    }

    def format(self, record):
        colored_record = copy.copy(record)
        levelname = colored_record.levelname
        seq = self.COLORS.get(levelname, self.COLORS["RESET"])
        colored_record.levelname = f"{seq}{levelname}{self.COLORS['RESET']}"
        return super().format(colored_record)


class Logger:
    def __init__(self, name, level = "INFO") -> None:
        self.logger = logging.getLogger(name)
        self.logger.propagate = False
        if not self.logger.handlers:
            format_log = ColoredFormatter("%(asctime)s - %(name)s - %(levelname)s - %(message)s")
            
            stdout_handler = logging.StreamHandler(sys.stdout)
            stdout_handler.setFormatter(format_log)
            self.logger.addHandler(stdout_handler)
            
            if args.log_file:
                file_handler = RotatingFileHandler(args.log_file, maxBytes=1e6, backupCount=5)
                file_handler.setFormatter(format_log)
                self.logger.addHandler(file_handler)

        loglevel_string = level
        loglevel = getattr(logging, loglevel_string.upper(), None)
        self.logger.setLevel(loglevel)

    def debug(self, message, *args):
        self.logger.debug(message.format(*args) if args else message)

    def warning(self, message, *args):
        self.logger.warning(message.format(*args) if args else message)

    def info(self, message, *args):
        self.logger.info(message.format(*args) if args else message)

    def error(self, message, *args):
        self.logger.error(message.format(*args) if args else message)