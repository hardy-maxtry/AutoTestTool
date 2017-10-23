from behave import *
import configparser
import os
import core.test_case_executer
import datetime


@given('更新优惠券活动, coupon_id是[{coupon_id}], 将活动状态改为[{status}]')
def update_coupon_status(context,coupon_id,status):
    sql = """update data_gz_b2c_promotion.coupon 
            set status = %s
            where id = %s
        """
    core.test_case_executer.exec_db_with_para(sql, (status, coupon_id))

@given('更新优惠券活动, coupon_id是[{coupon_id}], 将活动时间段设定在[{time}]')
def update_coupon_time(context,coupon_id,time):
    (start_time,end_time) = get_time_period(time)
    sql = """update data_gz_b2c_promotion.coupon 
            set start_time = %s, end_time = %s
            where id = %s
    """
    core.test_case_executer.exec_db_with_para(sql, (start_time,end_time, coupon_id))


    
@given('更新优惠券活动, coupon_id是[{coupon_id}], 将优惠券可用时间段设定在[{time}]')
def update_coupon_time(context,coupon_id,time):
    (start_time,end_time) = get_time_period(time)
    sql = """update data_gz_b2c_promotion.coupon 
            set use_start_time = %s, use_end_time = %s
            where id = %s
        """
    core.test_case_executer.exec_db_with_para(sql, (start_time,end_time, coupon_id))

@given('更新优惠券领取信息, coupon_id是[{coupon_id}], user_id是[{user_id}], 将优惠券可用时间段设定在[{time}]')
def update_coupon_time(context,coupon_id,user_id,time):
    (start_time,end_time) = get_time_period(time)
    sql = """update data_gz_b2c_promotion.coupon_receiving_record 
            set use_start_time = %s, use_end_time = %s
            where coupon_id = %s and user_id = %s
        """
    core.test_case_executer.exec_db_with_para(sql, (start_time,end_time, coupon_id, user_id))


@given('删除指定用户所有优惠券领取记录, user_id是[{user_id}]')
def delete_user_coupon_record(context,user_id):
    sql = """delete from data_gz_b2c_promotion.coupon_receiving_record 
            where user_id = %s
        """
    core.test_case_executer.exec_db_with_para(sql, (user_id))


def get_time_period(time):
    if time == u'现在':
        start_delta = datetime.timedelta(-2)
        end_delta = datetime.timedelta(2)
    elif time == u'未来':
        start_delta = datetime.timedelta(2)
        end_delta = datetime.timedelta(4)
    elif time == u'过去':
        start_delta = datetime.timedelta(-4)
        end_delta = datetime.timedelta(-2)

    start_time= (datetime.datetime.now() + start_delta).strftime("%Y-%m-%d %H:%M:%S")  
    end_time= (datetime.datetime.now() + end_delta).strftime("%Y-%m-%d %H:%M:%S")  
    return (start_time,end_time)