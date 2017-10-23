from behave import *
import configparser
import os
from jsonpath_ng import jsonpath, parse
import core.test_case_executer
from core.GZNB_config import configInfo
from utilites import string_handler 
from core import GZNB_compare
import json

@given('我传了一个参数叫amount: {amount},第二个参数:{amount2}')
def step_impl(context, amount, amount2):
    print("amount")
    print(amount)
    print('amount2 is ' +amount2)
    # assert isinstance(amount, int)


@given('我要测试一个API, API属于子系统:{sub_system}, API的别名是:{api_name}')
def step_start_api_test(context, sub_system, api_name):
    api_host = context.config.get(context.env, sub_system)
    api_sub_url = context.config.get('api_list', api_name)
    api_url = 'http://' +  api_host + '/' + api_sub_url
    context.request.set_url(api_url)
    
    print('api_url is ')
    print(api_url)
    # assert isinstance(amount, int)

@given('API的url是:{api_url}')
def set_api_url(context, api_url):
    context.request.set_url(api_url)

@given('API的method是:{api_method}')
def set_api_method(context, api_method):
    context.request.set_method(api_method)

@given('API的body是:{api_body}')
def set_api_body(context, api_body):
    context.request.set_body(api_body)

@given('API的body来自测试数据文件{config_file_name}中{section}节点的{key}关键字')
def set_api_body_from_config(context, config_file_name, section, key):
    context.request.set_body(configInfo(1,config_file_name).get(section,key))

@given('将API的body中的变量{parameter}赋值为{value}')
def set_api_body_from_config(context, parameter, value):
    replaced_body = string_handler.replace_keyword( context.request.get_body(), parameter, value)
    context.request.set_body(replaced_body)

@given('添加一个header到api请求, header名是:{header_name}, header值是:{header_value}')
def set_api_header(context, header_name, header_value):
    context.request.add_header(header_name, header_value)

@given('添加一个header到api请求, header名是:{header_name}, header值来自上下文的变量:{parameter}')
def set_api_header_from_context(context, header_name, parameter):
    header_value = context.parameters[parameter]
    context.request.add_header(header_name, header_value)

@given('添加一个cookie到api请求, cookie名是:{cookie_name}, cookie值是:{cookie_value}')
def set_api_cookie(context, cookie_name, cookie_value):
    context.request.add_cookie(cookie_name, cookie_value)

@given('添加一个cookie到api请求, cookie名是:{cookie_name}, cookie值来自上下文的变量:{parameter}')
def set_api_cookie(context, cookie_name, parameter):
    cookie_value = context.parameters[parameter]
    context.request.add_cookie(cookie_name, cookie_value)

@given('我要测试一个API,从数据文件[{config_file_name}]的节点[{Section}]获取参数,测试场景是[{Scenario}]')
def getParameter(context,Section,config_file_name,Scenario):
    URL =configInfo(1,config_file_name).get(Section,'URL')
    if 'http'.upper() not in str(URL).upper():
        envinfo = configInfo(0,'').get('test_env','env')
        URLInfo = configInfo(0,'').get(envinfo,'frontapi')
        URL = r'http://'+URLInfo+URL
    Method = configInfo(1,config_file_name).get(Section,'Method')
    Body = configInfo(1,config_file_name).get(Section,'Body')
    Headers =configInfo(1,config_file_name).get(Section,'Headers')
    context.request.set_url(URL)
    context.request.set_method(Method)
    context.request.set_body(Body)
    context.request.set_headers(dict(eval(Headers)))

@given('DB初始化，从[{Section}]获取SQL语句执行,测试数据文件来自于[{config_file_name}]')
def initializationDB(context,config_file_name,Section):
    SQL = configInfo(1,config_file_name).get(Section,'InitSQL')
    core.test_case_executer.execDB(SQL)

@when('我调用了api')
def invoke_api(context):
    context.request.run()

### 从response里提取值
@then('将response的cookie的某个值作为变量存入上下文, cookie名是:{cookie_name}, 存为变量名:{parameter}')
def save_cookie_value_into_context(context, cookie_name, parameter):
    cookie_value = context.request.get_res_cookies()[cookie_name]
    context.parameters[parameter] = cookie_value
    print(parameter + ':' + cookie_value)

@then('将response的header的某个值作为变量存入上下文, header:{header_name}, 存为变量名:{parameter}')
def save_header_value_into_context(context, header_name, parameter):
    header_value = context.request.get_res_headers()[header_name]
    context.parameters[parameter] = header_value
    print(parameter + ':' + header_value)

@then('将response(json)的body中的某个值作为变量存入上下文, JsonPath:{json_path}, 存为变量名:{parameter}')
def save_json_body_value_into_context(context, json_path, parameter):
    jsonpath_expr = parse(json_path)
    parsed_body = [match.value for match in jsonpath_expr.find(context.request.get_res_json_body())]
    context.parameters[parameter] = parsed_body[0]
    print(parameter + ':' + parsed_body[0])

### assert验证
@then('我需要验证response code是:{http_code}')
def assert_code(context, http_code):
    actual_code = str(context.request.get_res_status_code())
    # print('实际'+actual_code)
    # print('预期'+http_code)
    compare = GZNB_compare.GZNB_compare(http_code, actual_code,0)
    compare.compare()

@then('我需要验证response中指定JsonPath:{json_path}的值是:{expect_value}')
def assert_json_value(context, json_path, expect_value):
    compare = GZNB_compare.GZNB_compare(expect_value, context.request.get_res_json_body(),0)
    # print(json_path)
    compare.compare_json(json_path)

if __name__ == "__main__":
    getParameter('a','isFlashSale','inputdata.config','4')