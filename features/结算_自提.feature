Feature: 结算功能-自提

    @api
    Scenario: 初始化数据, 调用接口登录并获取token
        Given 我要测试一个API, API属于子系统:frontapi, API的别名是:signin
        Given API的method是:post
        Given API的body来自测试数据文件inputdata2.config中user_info节点的signin关键字
        Given 将API的body中的变量userID赋值为AutoTest1
        Given 将API的body中的变量password赋值为AutoTest1
        When 我调用了api
        Then 我需要验证response code是:200
        Then 将response(json)的body中的某个值作为变量存入上下文, JsonPath:$.data.sessionId, 存为变量名:token
    
    @api
    Scenario: 全部是自提商品进行结算
        Given 我要测试一个API,从数据文件[inputdata2.config]的节点[all_willcall_item]获取参数,测试场景是[全部是自提商品进行结算]
        Given 添加一个header到api请求, header名是:token, header值来自上下文的变量:token
        When 我调用了api
        Then 我需要验证response code是:200
        Then 我需要验证response中指定JsonPath:$.data.shippingFee的值是:2
        Then 我需要验证response中指定JsonPath:$.data.goodsTotalCount的值是:2
        Then 我需要验证response中指定JsonPath:$.data.goodsTotalPrice的值是:2.5
        Then 我需要验证response中指定JsonPath:$.data.discountTotalAmount的值是:0
        Then 我需要验证response中指定JsonPath:$.data.goods[0].goodsId的值是:179
        Then 我需要验证response中指定JsonPath:$.data.goods[1].goodsId的值是:146
        Then 我需要验证response中指定JsonPath:$.data.couponDiscountAmount的值是:0
    
    @api
    Scenario: 一件是自提商品，一件是自提商品进行结算
        Given 我要测试一个API,从数据文件[inputdata2.config]的节点[one_willcall_item_one_normal_item]获取参数,测试场景是[一件是自提商品，一件是自提商品进行结算]
        Given 添加一个header到api请求, header名是:token, header值来自上下文的变量:token
        When 我调用了api
        Then 我需要验证response code是:400
        Then 我需要验证response中指定JsonPath:$.msg的值是:自提商品和普通商品不支持同时购买，请分别勾选结算！
        Then 我需要验证response中指定JsonPath:$.code的值是:12025
    
    