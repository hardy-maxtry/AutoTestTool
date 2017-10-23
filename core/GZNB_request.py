import requests
import json
import threading
import queue

class GZNB_request(object):

    def __init__(self, timeout = 5):
        self.cookies = dict()
        self.headers = dict()
        self.method = 'get'
        self.body = ''
        self.timeout = timeout
        self.res = None
        self.queue = queue.Queue()

    def set_method(self, method):
        self.method = method

    def set_url(self, url):
        self.url = url

    def set_body(self, body):
        self.body = body

    def get_body(self):
        return self.body

    def set_headers(self, headers):
        self.headers = headers
    
    def add_header(self, name, value):
        self.headers[name] = value

    def set_cookies(self, cookies):
        self.cookies = cookies

    def add_cookie(self, name, value):
        self.cookies[name] = value

    def run(self):
        try:
            self.json = json.loads(self.body)
        except Exception:
            self.json = None
        if self.json == None:
            # self.res = requests.request(self.method.lower(), self.url, headers = self.headers, cookies=self.cookies, data = self.body, timeout = self.timeout)
            self.__send_request(method = self.method.lower(),
                                            url = self.url,
                                            headers = self.headers,
                                            cookies = self.cookies,
                                            json = None,
                                            data = self.body,
                                            timeout = self.timeout
                                            )
        else:
            # self.res = requests.request(self.method.lower(), self.url, headers = self.headers, cookies=self.cookies, json = self.json, timeout = self.timeout)
            self.__send_request(method = self.method.lower(),
                                            url = self.url,
                                            headers = self.headers,
                                            cookies = self.cookies,
                                            json = self.json,
                                            data = None,
                                            timeout = self.timeout
                                            )
        if not self.queue.empty():
            self.res = self.queue.get()

    def run_concurrent(self, thread_num):
        try:
            self.json = json.loads(self.body)
        except Exception:
            self.json = None
        pass
        if self.json == None:
            # self.res = requests.request(self.method.lower(), self.url, headers = self.headers, cookies=self.cookies, data = self.body, timeout = self.timeout)
            args = (
                self.method.lower(),
                self.url,
                self.headers,
                self.cookies,
                None,
                self.body,
                self.timeout
                )
        else:
            # self.res = requests.request(self.method.lower(), self.url, headers = self.headers, cookies=self.cookies, json = self.json, timeout = self.timeout)
            args = (
                self.method.lower(),
                self.url,
                self.headers,
                self.cookies,
                self.json,
                None,
                self.timeout
                )
        # 构建多线程
        for i in range(thread_num):
            t = threading.Thread(target=__send_request,args=args)  
            threads.append(t)
        # 多线程启动
        for i in threads:    
            i.start()    
        # 多线程保持    
        for i in threads:    
            i.join()  


    def __send_request(self, method, url, headers, cookies, json = None, data = None, timeout = 5):
        res = requests.request(method=method, url = url, headers = headers, cookies = cookies, json = json, data = data, timeout = timeout)
        self.queue.put(res)

    def get_res(self):
        return self.res

    def get_res_array(self):
        res_array = []
        while not self.queue.empty():
            res_array.append(self.queue.get())
        return res_array

    def get_res_json_body(self):
        if self.res is not None:
            return self.res.json()
        else:
            return None

    def get_res_status_code(self):
        if self.res is not None:
            return self.res.status_code
        else:
            return None

    def get_res_cookies(self):
        if self.res is not None:
            return self.res.cookies
        else:
            return None

    def get_res_headers(self):
        if self.res is not None:
            return self.res.headers
        else:
            return None
