__author__ = 'wuguojun'
import configparser
import os

__cached_config = {}
cached_read_time = 0

def configInfo(sign,filename):
    #0,表示读取环境的config信息
    #1，表示读取测试数据的信息
    curr_dir = os.getcwd()
    if sign :
        CONFIGURATION=curr_dir+'\\features\\test_data\\'+filename
    else:
        CONFIGURATION = curr_dir+'\\features\\env.config'
    return get_config(CONFIGURATION)
    # config =configparser.ConfigParser()
    # config.read(CONFIGURATION,encoding='utf-8')
    # return config

def get_config(filename):
    global __cached_config
    global cached_read_time
    if filename not in __cached_config.keys():
        config =configparser.ConfigParser()
        config.read(filename,encoding='utf-8')
        __cached_config[filename] = config
        # print('配置文件读取完毕')
    cached_read_time += 1
    # print('缓存读取了'+ str(cached_read_time)+'次')
    return __cached_config[filename]

if __name__ == "__main__":
    print(configInfo(0,'').get('test','ip'))