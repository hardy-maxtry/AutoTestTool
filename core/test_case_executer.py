import pymysql
import configparser
import os
from core.GZNB_config import configInfo

def execDB(SQL):
    conn = pymysql.connect(host=configInfo(0,'').get('DBInfo','host'), port=int(configInfo(0,'').get('DBInfo','port')), user=configInfo(0,'').get('DBInfo','user'), passwd=configInfo(0,'').get('DBInfo','passwd'), db=configInfo(0,'').get('DBInfo','db'), charset='utf8')
    cursor = conn.cursor()
    cursor.execute(SQL)
    conn.commit()
    cursor.close()
    conn.close()

def exec_db_with_para(sql, params):
    conn = pymysql.connect(host=configInfo(0,'').get('DBInfo','host'), port=int(configInfo(0,'').get('DBInfo','port')), user=configInfo(0,'').get('DBInfo','user'), passwd=configInfo(0,'').get('DBInfo','passwd'), db=configInfo(0,'').get('DBInfo','db'), charset='utf8')
    cursor = conn.cursor()
    cursor.execute(sql, params)
    conn.commit()
    cursor.close()
    conn.close()


if __name__ == "__main__":
    SQL = 'update data_gz_b2c_rma.rma_refund_audit set refund_total_amount = 0.02 where id = 5006455342174211'
    execDB(SQL)
    pass