# import configparser


# # read config
# config = configparser.ConfigParser()
# config.readfp()

# read testmethod


# execute testcase

import threading
from time import ctime    
threads=[]   

def test_func(i,j):
    print('in test func:' + str(i) + ':' + str(j) + ctime())

for i in range(10):
    j = i +1
    t =  threading.Thread(target=test_func,args=(i,j))  
    threads.append(t)   

if __name__ == '__main__':  
    #启动线程    
    for i in threads:    
        i.start()    
    #keep thread    
    for i in threads:    
        i.join()  