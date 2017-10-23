Feature: 领取优惠券

  @api
  Scenario: 该笔订单没有使用优惠券
    Given 我要测试一个API,从数据文件[inputdata.config]的节点[noCoupon]获取参数,测试场景是[Call /orders/submit API]
      when 我调用了api
      then 我需要验证response code是:200
      then 我需要验证response中指定JsonPath:$.data.paymentAmount的值是:62.90

  @api
  Scenario: 该笔订单使用优惠券，但该优惠券不符合此次下单商品
    Given 我要测试一个API,从数据文件[inputdata.config]的节点[nonConformityRuleCoupon]获取参数,测试场景是[Call /orders/submit API]
      when 我调用了api
      then 我需要验证response code是:400
      then 我需要验证response中指定JsonPath:$.msg的值是:优惠券不存在
      then 我需要验证response中指定JsonPath:$.code的值是:1005

  @api
  Scenario: 该笔订单使用优惠券，但该优惠券开始时间未到
    Given 我要测试一个API,从数据文件[inputdata.config]的节点[noArrivedTimeCoupon]获取参数,测试场景是[Call /orders/submit API]
      when 我调用了api
      then 我需要验证response code是:400
      then 我需要验证response中指定JsonPath:$.msg的值是:优惠券未到使用时间
      then 我需要验证response中指定JsonPath:$.code的值是:1005

  @api
  Scenario: 该笔订单使用优惠券，但不符合此次下单总金额
    Given 我要测试一个API,从数据文件[inputdata.config]的节点[nonConformityRuleCouponbyTotolPrice]获取参数,测试场景是[Call /orders/submit API]
      when 我调用了api
      then 我需要验证response code是:200
      then 我需要验证response中指定JsonPath:$.data.paymentAmount的值是:47.00

  @api
  Scenario: 该笔订单使用优惠券，且符合此次下单流程
    Given DB初始化，从[conformityRuleCouponbyTotolPrice]获取SQL语句执行,测试数据文件来自于[inputdata.config]
    Given 我要测试一个API,从数据文件[inputdata.config]的节点[conformityRuleCouponbyTotolPrice]获取参数,测试场景是[Call /orders/submit API]
      when 我调用了api
      then 我需要验证response code是:200
      then 我需要验证response中指定JsonPath:$.data.paymentAmount的值是:64

  @api
  Scenario: 优惠券金额>商品总金额，且有运费
    Given DB初始化，从[allDeductionByCoupon]获取SQL语句执行,测试数据文件来自于[inputdata.config]
    Given 我要测试一个API,从数据文件[inputdata.config]的节点[allDeductionByCoupon]获取参数,测试场景是[Call /orders/submit API]
      when 我调用了api
      then 我需要验证response code是:200
      then 我需要验证response中指定JsonPath:$.data.paymentAmount的值是:0.01

  @api
  Scenario: 0元订单：优惠券金额>商品总金额，且免运费
    Given DB初始化，从[allDeductionByCouponNoShippingCharge]获取SQL语句执行,测试数据文件来自于[inputdata.config]
    Given 我要测试一个API,从数据文件[inputdata.config]的节点[allDeductionByCouponNoShippingCharge]获取参数,测试场景是[Call /orders/submit API]
      when 我调用了api
      then 我需要验证response code是:200
      then 我需要验证response中指定JsonPath:$.data.paymentAmount的值是:0.00

  @api
  Scenario: 该笔订单使用优惠券，但该优惠券活动已作废
    Given DB初始化，从[usingCouponAndActivityIsCancel]获取SQL语句执行,测试数据文件来自于[inputdata.config]
    Given 我要测试一个API,从数据文件[inputdata.config]的节点[usingCouponAndActivityIsCancel]获取参数,测试场景是[Call /orders/submit API]
      when 我调用了api
      then 我需要验证response code是:200
      then 我需要验证response中指定JsonPath:$.data.paymentAmount的值是:198.00