Feature: 判断主商品和赠品的商品状态

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
    Scenario: 满足满减活动，减免金额
        Given 我要测试一个API,从数据文件[inputdata2.config]的节点[满足满减活动，减免金额]获取参数,测试场景是[满足满减活动，减免金额]
        Given 添加一个header到api请求, header名是:token, header值来自上下文的变量:token
        When 我调用了api
        Then 我需要验证response code是:200
        Then 我需要验证response中指定JsonPath:$.data.shippingFee的值是:0
        Then 我需要验证response中指定JsonPath:$.data.goodsTotalCount的值是:2
        Then 我需要验证response中指定JsonPath:$.data.goodsTotalPrice的值是:84
        Then 我需要验证response中指定JsonPath:$.data.discountTotalAmount的值是:10
        Then 我需要验证response中指定JsonPath:$.data.couponDiscountAmount的值是:0
        Then 我需要验证response中指定JsonPath:$.data.goods[0].goodsId的值是:408
        Then 我需要验证response中指定JsonPath:$.data.goods[0].goodsQuantity的值是:2

    @api
    Scenario: 不满足满减活动，不减免金额
        Given 我要测试一个API,从数据文件[inputdata2.config]的节点[不满足满减活动，不减免金额]获取参数,测试场景是[不满足满减活动，不减免金额]
        Given 添加一个header到api请求, header名是:token, header值来自上下文的变量:token
        When 我调用了api
        Then 我需要验证response code是:200
        Then 我需要验证response中指定JsonPath:$.data.shippingFee的值是:0
        Then 我需要验证response中指定JsonPath:$.data.goodsTotalCount的值是:1
        Then 我需要验证response中指定JsonPath:$.data.goodsTotalPrice的值是:42
        Then 我需要验证response中指定JsonPath:$.data.discountTotalAmount的值是:0
        Then 我需要验证response中指定JsonPath:$.data.goods[0].goodsId的值是:408
        Then 我需要验证response中指定JsonPath:$.data.goods[0].goodsQuantity的值是:1
        Then 我需要验证response中指定JsonPath:$.data.couponDiscountAmount的值是:0
