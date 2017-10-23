import time
FORMAT = '%Y-%m-%d %H:%M:%S'

class GZNB_report(object):
    def __init__(self, log_type, log_name, log_level = 'info'):
        self.start = time.strftime(FORMAT, time.localtime(time.time()))
        self.log_type = log_type
        self.log_level = log_level
        self.log_name = log_name
        self.sub_report = []
        self.log_status = 'passed'
        self.sub_passed = 0
        self.sub_failed = 0

    def set_status(self, status):
        self.log_status = status

    def set_detail(self, detail):
        self.log_detail = detail
    
    def set_log_level(self, log_level):
        self.log_level = log_level

    def set_end(self):
        self.end = time.strftime(FORMAT, time.localtime(time.time()))

    def add_sub_report(self, GZNB_report_obj):
        # 为了json序列化，这里直接将对象转成dict
        self.sub_report.append(GZNB_report_obj.__dict__)

    def get_report(self):
        return self.__dict__

    def add_sub_passed(self):
        self.sub_passed += 1
    
    def add_sub_failed(self):
        self.sub_failed += 1