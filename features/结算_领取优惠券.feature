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
    Scenario: 登录账户没有领取优惠券
        Given 删除指定用户所有优惠券领取记录, user_id是[5191573465858048]
        Given 我要测试一个API,从数据文件[inputdata2.config]的节点[登录账户没有领取优惠券]获取参数,测试场景是[登录账户没有领取优惠券]
        Given 添加一个header到api请求, header名是:token, header值来自上下文的变量:token
        When 我调用了api
        Then 我需要验证response code是:200
        Then 我需要验证response中指定JsonPath:$.data.shippingFee的值是:0
        Then 我需要验证response中指定JsonPath:$.data.goodsTotalCount的值是:2
        Then 我需要验证response中指定JsonPath:$.data.goodsTotalPrice的值是:125.8
        Then 我需要验证response中指定JsonPath:$.data.discountTotalAmount的值是:0
        Then 我需要验证response中指定JsonPath:$.data.couponDiscountAmount的值是:0
        Then 我需要验证response中指定JsonPath:$.data.goods[0].goodsId的值是:401
        Then 我需要验证response中指定JsonPath:$.data.goods[0].goodsQuantity的值是:2

    @api
    Scenario: 登录账户领取优惠券，但不符合此次下单商品
        Given 删除指定用户所有优惠券领取记录, user_id是[5191573465858048]
        Given 我要测试一个API,从数据文件[inputdata2.config]的节点[登录账户领取优惠券5179334285459456]获取参数,测试场景是[登录账户领取优惠券5179334285459456]
        Given 添加一个header到api请求, header名是:token, header值来自上下文的变量:token
        When 我调用了api
        Then 我需要验证response code是:200
        Then 我需要验证response中指定JsonPath:$.data.couponId的值是:5179334285459456
        Given 我要测试一个API,从数据文件[inputdata2.config]的节点[登录账户领取优惠券，但不符合此次下单商品]获取参数,测试场景是[登录账户领取优惠券，但不符合此次下单商品]
        Given 添加一个header到api请求, header名是:token, header值来自上下文的变量:token
        When 我调用了api
        Then 我需要验证response code是:200
        Then 我需要验证response中指定JsonPath:$.data.shippingFee的值是:0
        Then 我需要验证response中指定JsonPath:$.data.goodsTotalCount的值是:2
        Then 我需要验证response中指定JsonPath:$.data.goodsTotalPrice的值是:125.8
        Then 我需要验证response中指定JsonPath:$.data.discountTotalAmount的值是:0
        Then 我需要验证response中指定JsonPath:$.data.couponDiscountAmount的值是:0
        Then 我需要验证response中指定JsonPath:$.data.goods[0].goodsId的值是:401
        Then 我需要验证response中指定JsonPath:$.data.goods[0].goodsQuantity的值是:2


    @api
    Scenario: 登录账户领取优惠券，但优惠券开始时间未到
        Given 删除指定用户所有优惠券领取记录, user_id是[5191573465858048]
        Given 更新优惠券活动, coupon_id是[5179348579647488], 将活动时间段设定在[现在]
        Given 更新优惠券活动, coupon_id是[5179348579647488], 将优惠券可用时间段设定在[未来]
        Given 我要测试一个API,从数据文件[inputdata2.config]的节点[登录账户领取优惠券5179348579647488]获取参数,测试场景是[登录账户领取优惠券5179348579647488]
        Given 添加一个header到api请求, header名是:token, header值来自上下文的变量:token
        When 我调用了api
        Then 我需要验证response code是:200
        Then 我需要验证response中指定JsonPath:$.data.couponId的值是:5179348579647488
        Then 我需要验证response中指定JsonPath:$.data.couponName的值是:优惠券test2
        Given 我要测试一个API,从数据文件[inputdata2.config]的节点[登录账户领取优惠券，但优惠券开始时间未到]获取参数,测试场景是[登录账户领取优惠券，但优惠券开始时间未到]
        Given 添加一个header到api请求, header名是:token, header值来自上下文的变量:token
        When 我调用了api
        Then 我需要验证response code是:200
        Then 我需要验证response中指定JsonPath:$.data.shippingFee的值是:0
        Then 我需要验证response中指定JsonPath:$.data.goodsTotalCount的值是:2
        Then 我需要验证response中指定JsonPath:$.data.goodsTotalPrice的值是:35
        Then 我需要验证response中指定JsonPath:$.data.discountTotalAmount的值是:0
        Then 我需要验证response中指定JsonPath:$.data.couponDiscountAmount的值是:0
        Then 我需要验证response中指定JsonPath:$.data.goods[0].goodsId的值是:403
        Then 我需要验证response中指定JsonPath:$.data.goods[0].goodsQuantity的值是:2


        
    @api
    Scenario: 登录账户领取优惠券，但优惠券结束时间已到
        Given 删除指定用户所有优惠券领取记录, user_id是[5191573465858048]
        Given 更新优惠券活动, coupon_id是[5180055504420864], 将活动状态改为[6]
        Given 更新优惠券活动, coupon_id是[5180055504420864], 将活动时间段设定在[现在]
        Given 更新优惠券活动, coupon_id是[5180055504420864], 将优惠券可用时间段设定在[现在]
        Given 我要测试一个API,从数据文件[inputdata2.config]的节点[登录账户领取优惠券5180055504420864]获取参数,测试场景是[登录账户领取优惠券5180055504420864]
        Given 添加一个header到api请求, header名是:token, header值来自上下文的变量:token
        When 我调用了api
        Then 我需要验证response code是:200
        Then 我需要验证response中指定JsonPath:$.data.couponId的值是:5180055504420864
        Then 我需要验证response中指定JsonPath:$.data.couponName的值是:优惠券test4——结束时间
        Given 更新优惠券活动, coupon_id是[5180055504420864], 将活动时间段设定在[过去]
        Given 更新优惠券活动, coupon_id是[5180055504420864], 将优惠券可用时间段设定在[过去]
        Given 更新优惠券领取信息, coupon_id是[5180055504420864], user_id是[5191573465858048], 将优惠券可用时间段设定在[过去]
        Given 更新优惠券活动, coupon_id是[5180055504420864], 将活动状态改为[8]
        Given 我要测试一个API,从数据文件[inputdata2.config]的节点[登录账户领取优惠券，但优惠券结束时间已到]获取参数,测试场景是[登录账户领取优惠券，但优惠券结束时间已到]
        Given 添加一个header到api请求, header名是:token, header值来自上下文的变量:token
        When 我调用了api
        Then 我需要验证response code是:200
        Then 我需要验证response中指定JsonPath:$.data.shippingFee的值是:0
        Then 我需要验证response中指定JsonPath:$.data.goodsTotalCount的值是:1
        Then 我需要验证response中指定JsonPath:$.data.goodsTotalPrice的值是:10
        Then 我需要验证response中指定JsonPath:$.data.discountTotalAmount的值是:0
        Then 我需要验证response中指定JsonPath:$.data.couponDiscountAmount的值是:0
        Then 我需要验证response中指定JsonPath:$.data.goods[0].goodsId的值是:404
        Then 我需要验证response中指定JsonPath:$.data.goods[0].goodsQuantity的值是:1

    @api
    Scenario: 登录账户领取优惠券，但优惠券活动已作废
        Given 删除指定用户所有优惠券领取记录, user_id是[5191573465858048]
        Given 更新优惠券活动, coupon_id是[5180078656978944], 将活动状态改为[6]
        Given 更新优惠券活动, coupon_id是[5180078656978944], 将活动时间段设定在[现在]
        Given 更新优惠券活动, coupon_id是[5180078656978944], 将优惠券可用时间段设定在[现在]
        Given 我要测试一个API,从数据文件[inputdata2.config]的节点[登录账户领取优惠券5180078656978944]获取参数,测试场景是[登录账户领取优惠券5180078656978944]
        Given 添加一个header到api请求, header名是:token, header值来自上下文的变量:token
        When 我调用了api
        Then 我需要验证response code是:200
        Then 我需要验证response中指定JsonPath:$.data.couponId的值是:5180078656978944
        Then 我需要验证response中指定JsonPath:$.data.couponName的值是:优惠券test5——活动作废
        Given 更新优惠券活动, coupon_id是[5180078656978944], 将活动状态改为[7]
        Given 我要测试一个API,从数据文件[inputdata2.config]的节点[登录账户领取优惠券，但优惠券活动已作废]获取参数,测试场景是[登录账户领取优惠券，但优惠券活动已作废]
        Given 添加一个header到api请求, header名是:token, header值来自上下文的变量:token
        When 我调用了api
        Then 我需要验证response code是:200
        Then 我需要验证response中指定JsonPath:$.data.shippingFee的值是:0
        Then 我需要验证response中指定JsonPath:$.data.goodsTotalCount的值是:1
        Then 我需要验证response中指定JsonPath:$.data.goodsTotalPrice的值是:298
        Then 我需要验证response中指定JsonPath:$.data.discountTotalAmount的值是:0
        Then 我需要验证response中指定JsonPath:$.data.couponDiscountAmount的值是:100
        Then 我需要验证response中指定JsonPath:$.data.goods[0].goodsId的值是:405
        Then 我需要验证response中指定JsonPath:$.data.goods[0].goodsQuantity的值是:1


    @api
    Scenario: 登录账户领取优惠券，但优惠券活动已结束
        Given 删除指定用户所有优惠券领取记录, user_id是[5191573465858048]
        Given 更新优惠券活动, coupon_id是[5180114090459136], 将活动状态改为[6]
        Given 更新优惠券活动, coupon_id是[5180114090459136], 将活动时间段设定在[现在]
        Given 更新优惠券活动, coupon_id是[5180114090459136], 将优惠券可用时间段设定在[现在]
        Given 我要测试一个API,从数据文件[inputdata2.config]的节点[登录账户领取优惠券5180114090459136]获取参数,测试场景是[登录账户领取优惠券5180078656978944]
        Given 添加一个header到api请求, header名是:token, header值来自上下文的变量:token
        When 我调用了api
        Then 我需要验证response code是:200
        Then 我需要验证response中指定JsonPath:$.data.couponId的值是:5180114090459136
        Then 我需要验证response中指定JsonPath:$.data.couponName的值是:优惠券test6——活动结束
        Given 更新优惠券活动, coupon_id是[5180114090459136], 将活动状态改为[8]
        Given 更新优惠券活动, coupon_id是[5180114090459136], 将活动时间段设定在[过去]
        Given 我要测试一个API,从数据文件[inputdata2.config]的节点[登录账户领取优惠券，但优惠券活动已结束]获取参数,测试场景是[登录账户领取优惠券，但优惠券活动已结束]
        Given 添加一个header到api请求, header名是:token, header值来自上下文的变量:token
        When 我调用了api
        Then 我需要验证response code是:200
        Then 我需要验证response中指定JsonPath:$.data.shippingFee的值是:0.01
        Then 我需要验证response中指定JsonPath:$.data.goodsTotalCount的值是:1
        Then 我需要验证response中指定JsonPath:$.data.goodsTotalPrice的值是:0.01
        Then 我需要验证response中指定JsonPath:$.data.discountTotalAmount的值是:0
        Then 我需要验证response中指定JsonPath:$.data.couponDiscountAmount的值是:0.01
        Then 我需要验证response中指定JsonPath:$.data.goods[0].goodsId的值是:406
        Then 我需要验证response中指定JsonPath:$.data.goods[0].goodsQuantity的值是:1
        Then 我需要验证response中指定JsonPath:$.data.canUseCoupons[0].couponId的值是:5180114090459136

    @api
    Scenario: 登录账户领取优惠券，但不符合此次下单总金额
        Given 删除指定用户所有优惠券领取记录, user_id是[5191573465858048]
        Given 更新优惠券活动, coupon_id是[5180146302713856], 将活动状态改为[6]
        Given 更新优惠券活动, coupon_id是[5180146302713856], 将活动时间段设定在[现在]
        Given 更新优惠券活动, coupon_id是[5180146302713856], 将优惠券可用时间段设定在[现在]
        Given 我要测试一个API,从数据文件[inputdata2.config]的节点[登录账户领取优惠券5180146302713856]获取参数,测试场景是[登录账户领取优惠券5180146302713856]
        Given 添加一个header到api请求, header名是:token, header值来自上下文的变量:token
        When 我调用了api
        Then 我需要验证response code是:200
        Then 我需要验证response中指定JsonPath:$.data.couponId的值是:5180146302713856
        Then 我需要验证response中指定JsonPath:$.data.couponName的值是:优惠券test7——使用门槛值
        Given 我要测试一个API,从数据文件[inputdata2.config]的节点[登录账户领取优惠券，但不符合此次下单总金额]获取参数,测试场景是[登录账户领取优惠券，但不符合此次下单总金额]
        Given 添加一个header到api请求, header名是:token, header值来自上下文的变量:token
        When 我调用了api
        Then 我需要验证response code是:200
        Then 我需要验证response中指定JsonPath:$.data.shippingFee的值是:0
        Then 我需要验证response中指定JsonPath:$.data.goodsTotalCount的值是:1
        Then 我需要验证response中指定JsonPath:$.data.goodsTotalPrice的值是:47
        Then 我需要验证response中指定JsonPath:$.data.discountTotalAmount的值是:0
        Then 我需要验证response中指定JsonPath:$.data.couponDiscountAmount的值是:0
        Then 我需要验证response中指定JsonPath:$.data.goods[0].goodsId的值是:407
        Then 我需要验证response中指定JsonPath:$.data.goods[0].goodsQuantity的值是:1

    @api
    Scenario: 登录账户领取优惠券，且符合此次下单总金额
        Given 删除指定用户所有优惠券领取记录, user_id是[5191573465858048]
        Given 更新优惠券活动, coupon_id是[5180146302713856], 将活动状态改为[6]
        Given 更新优惠券活动, coupon_id是[5180146302713856], 将活动时间段设定在[现在]
        Given 更新优惠券活动, coupon_id是[5180146302713856], 将优惠券可用时间段设定在[现在]
        Given 我要测试一个API,从数据文件[inputdata2.config]的节点[登录账户领取优惠券5180146302713856]获取参数,测试场景是[登录账户领取优惠券5180146302713856]
        Given 添加一个header到api请求, header名是:token, header值来自上下文的变量:token
        When 我调用了api
        Then 我需要验证response code是:200
        Then 我需要验证response中指定JsonPath:$.data.couponId的值是:5180146302713856
        Then 我需要验证response中指定JsonPath:$.data.couponName的值是:优惠券test7——使用门槛值
        Given 我要测试一个API,从数据文件[inputdata2.config]的节点[登录账户领取优惠券，且符合此次下单总金额]获取参数,测试场景是[登录账户领取优惠券，且符合此次下单总金额]
        Given 添加一个header到api请求, header名是:token, header值来自上下文的变量:token
        When 我调用了api
        Then 我需要验证response code是:200
        Then 我需要验证response中指定JsonPath:$.data.shippingFee的值是:0
        Then 我需要验证response中指定JsonPath:$.data.goodsTotalCount的值是:2
        Then 我需要验证response中指定JsonPath:$.data.goodsTotalPrice的值是:94
        Then 我需要验证response中指定JsonPath:$.data.discountTotalAmount的值是:0
        Then 我需要验证response中指定JsonPath:$.data.couponDiscountAmount的值是:30
        Then 我需要验证response中指定JsonPath:$.data.goods[0].goodsId的值是:407
        Then 我需要验证response中指定JsonPath:$.data.goods[0].goodsQuantity的值是:2