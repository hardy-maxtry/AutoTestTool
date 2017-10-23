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
    Scenario: 主商品上架正常下单
        Given 我要测试一个API,从数据文件[inputdata2.config]的节点[主商品上架正常下单]获取参数,测试场景是[主商品上架正常下单]
        Given 添加一个header到api请求, header名是:token, header值来自上下文的变量:token
        When 我调用了api
        Then 我需要验证response code是:200
        Then 我需要验证response中指定JsonPath:$.data.shippingFee的值是:0
        Then 我需要验证response中指定JsonPath:$.data.goodsTotalCount的值是:1
        Then 我需要验证response中指定JsonPath:$.data.goodsTotalPrice的值是:88
        Then 我需要验证response中指定JsonPath:$.data.discountTotalAmount的值是:0
        Then 我需要验证response中指定JsonPath:$.data.goods[0].goodsId的值是:247
        Then 我需要验证response中指定JsonPath:$.data.couponDiscountAmount的值是:0
    
    @api
    Scenario: 主商品下架，不能结算
        Given 我要测试一个API,从数据文件[inputdata2.config]的节点[主商品下架，不能结算]获取参数,测试场景是[主商品下架，不能结算]
        Given 添加一个header到api请求, header名是:token, header值来自上下文的变量:token
        When 我调用了api
        Then 我需要验证response code是:400
        Then 我需要验证response中指定JsonPath:$.code的值是:12015
        Then 我需要验证response中指定JsonPath:$.msg的值是:自动化主商品下架-文山州丘北县山里郎QQ酥果仁味86g已下架
    
    @api
    Scenario: 主商品仅展示，不能结算
        Given 我要测试一个API,从数据文件[inputdata2.config]的节点[主商品仅展示，不能结算]获取参数,测试场景是[主商品仅展示，不能结算]
        Given 添加一个header到api请求, header名是:token, header值来自上下文的变量:token
        When 我调用了api
        Then 我需要验证response code是:400
        Then 我需要验证response中指定JsonPath:$.msg的值是:自动化测试主商品仅展示-大理洱源县邓川蝶泉特浓纯牛奶250ml*16已下架
        Then 我需要验证response中指定JsonPath:$.code的值是:12015
    
    @api
    Scenario: 主商品已作废，不能结算
        Given 我要测试一个API,从数据文件[inputdata2.config]的节点[主商品已作废，不能结算]获取参数,测试场景是[主商品已作废，不能结算]
        Given 添加一个header到api请求, header名是:token, header值来自上下文的变量:token
        When 我调用了api
        Then 我需要验证response code是:400
        Then 我需要验证response中指定JsonPath:$.msg的值是:自动化主商品已作废-山州丘北县山里郎QQ酥麻辣味86g已下架
        Then 我需要验证response中指定JsonPath:$.code的值是:12015

    @api
    Scenario: 赠品已作废，提示赠品不足，能结算
        Given 我要测试一个API,从数据文件[inputdata2.config]的节点[赠品已作废，提示赠品不足，能结算]获取参数,测试场景是[赠品已作废，提示赠品不足，能结算]
        Given 添加一个header到api请求, header名是:token, header值来自上下文的变量:token
        When 我调用了api
        Then 我需要验证response code是:200
        Then 我需要验证response中指定JsonPath:$.data.shippingFee的值是:0
        Then 我需要验证response中指定JsonPath:$.data.goodsTotalCount的值是:2
        Then 我需要验证response中指定JsonPath:$.data.goodsTotalPrice的值是:13.6
        Then 我需要验证response中指定JsonPath:$.data.discountTotalAmount的值是:0
        Then 我需要验证response中指定JsonPath:$.data.goods[0].goodsId的值是:1527
        Then 我需要验证response中指定JsonPath:$.data.couponDiscountAmount的值是:0
        Then 我需要验证response中指定JsonPath:$.data.resultMessage[0].messageType的值是:2
        Then 我需要验证response中指定JsonPath:$.data.resultMessage[0].message的值是:赠品已送完
    
    @api
    Scenario: 赠品仅展示，提示赠品不足，能结算
        Given 我要测试一个API,从数据文件[inputdata2.config]的节点[赠品仅展示，提示赠品不足，能结算]获取参数,测试场景是[赠品仅展示，提示赠品不足，能结算]
        Given 添加一个header到api请求, header名是:token, header值来自上下文的变量:token
        When 我调用了api
        Then 我需要验证response code是:200
        Then 我需要验证response中指定JsonPath:$.data.shippingFee的值是:0
        Then 我需要验证response中指定JsonPath:$.data.goodsTotalCount的值是:10
        Then 我需要验证response中指定JsonPath:$.data.goodsTotalPrice的值是:68
        Then 我需要验证response中指定JsonPath:$.data.discountTotalAmount的值是:0
        Then 我需要验证response中指定JsonPath:$.data.goods[0].goodsId的值是:1527
        Then 我需要验证response中指定JsonPath:$.data.couponDiscountAmount的值是:0
        Then 我需要验证response中指定JsonPath:$.data.resultMessage[0].messageType的值是:2
        Then 我需要验证response中指定JsonPath:$.data.resultMessage[0].message的值是:赠品已送完

    @api
    Scenario: 赠品已上架，无提示，能结算
        Given 我要测试一个API,从数据文件[inputdata2.config]的节点[赠品已上架，无提示，能结算]获取参数,测试场景是[赠品已上架，无提示，能结算]
        Given 添加一个header到api请求, header名是:token, header值来自上下文的变量:token
        When 我调用了api
        Then 我需要验证response code是:200
        Then 我需要验证response中指定JsonPath:$.data.shippingFee的值是:0
        Then 我需要验证response中指定JsonPath:$.data.goodsTotalCount的值是:8
        Then 我需要验证response中指定JsonPath:$.data.goodsTotalPrice的值是:47.6
        Then 我需要验证response中指定JsonPath:$.data.discountTotalAmount的值是:0
        Then 我需要验证response中指定JsonPath:$.data.goods[0].goodsId的值是:1527
        Then 我需要验证response中指定JsonPath:$.data.goods[0].goodsQuantity的值是:7
        Then 我需要验证response中指定JsonPath:$.data.goods[1].goodsId的值是:1246
        Then 我需要验证response中指定JsonPath:$.data.goods[1].goodsQuantity的值是:1
        Then 我需要验证response中指定JsonPath:$.data.couponDiscountAmount的值是:0
        Then 我需要验证response中指定JsonPath:$.data.resultMessage的值是:None

        
    @api
    Scenario: 赠品下架，提示赠品不足，能结算
        Given 我要测试一个API,从数据文件[inputdata2.config]的节点[赠品下架，提示赠品不足，能结算]获取参数,测试场景是[赠品下架，提示赠品不足，能结算]
        Given 添加一个header到api请求, header名是:token, header值来自上下文的变量:token
        When 我调用了api
        Then 我需要验证response code是:200
        Then 我需要验证response中指定JsonPath:$.data.shippingFee的值是:0
        Then 我需要验证response中指定JsonPath:$.data.goodsTotalCount的值是:4
        Then 我需要验证response中指定JsonPath:$.data.goodsTotalPrice的值是:27.2
        Then 我需要验证response中指定JsonPath:$.data.discountTotalAmount的值是:0
        Then 我需要验证response中指定JsonPath:$.data.goods[0].goodsId的值是:1527
        Then 我需要验证response中指定JsonPath:$.data.goods[0].goodsQuantity的值是:4
        Then 我需要验证response中指定JsonPath:$.data.couponDiscountAmount的值是:0
        Then 我需要验证response中指定JsonPath:$.data.resultMessage[0].messageType的值是:2
        Then 我需要验证response中指定JsonPath:$.data.resultMessage[0].message的值是:赠品已送完