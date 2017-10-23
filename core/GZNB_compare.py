from jsonpath_ng import jsonpath, parse
from hamcrest import *

class GZNB_compare(object):
    
    ### compare_type = 0: actual equals expect
    ### compare_type = 1: actual contains expect
    def __init__(self, expect, actual, compare_type = 0):
        self.expect = expect
        self.actual = actual
        self.compare_type = compare_type

    def compare_json(self, json_path):
        jsonpath_expr = parse(json_path)
        parsed_actual = [match.value for match in jsonpath_expr.find(self.actual)]
        if type(self.expect) != list and self.compare_type == 0 and len(parsed_actual) == 1:
            return self.__compare(self.expect, parsed_actual[0])
        else:     
            return self.__compare(self.expect, parsed_actual)

    def compare(self):
        return self.__compare(self.expect, self.actual)

    def __compare(self, expect, actual):
        if self.compare_type == 0:
            # 比较前先将expect类型转换成和actual一致的
            converted_expect = self.__convert_type(expect, actual)
            print(converted_expect)
            print(actual)
            return self.__is_equal(converted_expect, actual)
        elif self.compare_type == 1:
            return self.__is_contain(expect, actual)
        else:
            raise Exception('Invalid compare_type', self.compare_type)

    def __is_equal(self, expect, actual):
        print('gznb expect: '+ str(expect))
        print('gznb actual: '+ str(actual))
        assert_that(actual, equal_to(expect))
        return expect == actual
    
    def __is_contain(self, expect, actual):
        print('gznb expect: '+ str(expect))
        print('gznb actual: '+ str(actual))
        if type(expect) == str and type(actual) == str:
            return expect in actual
        if type(expect) != list and type(actual) == list:
            return expect in actual
        if type(expect) == list and type(actual) == list:
            for ele in expect:
                if ele not in actual:
                    return False
    
    # 由于期望值来自文件，输入时为str型，因此，根据实际值，动态处理期望值的类型
    def __convert_type(self, expect, actual):
        if expect == 'None' and actual is None:
            return None
        try:
            if type(expect)!=list and isinstance(actual,list):
                pass
            else:
                converted_expect = type(actual)(expect)
            return converted_expect
        except Exception as ex:
            return expect

if __name__ == "__main__":
    pass