Feature: 限时抢购

  @api
  Scenario: 入参商品与实际一致，都是限时抢购商品
    Given 我要测试一个API,从数据文件[inputdata.config]的节点[isFlashSale]获取参数,测试场景是[Call /orders/submit API]
      when 我调用了api
      then 我需要验证response code是:200
      then 我需要验证response中指定JsonPath:$.data.paymentAmount的值是:0.02

  @api
  Scenario: 入参商品与实际一致，都是普通商品
    Given 我要测试一个API,从数据文件[inputdata.config]的节点[isNotFlashSale]获取参数,测试场景是[Call /orders/submit API]
      when 我调用了api
      then 我需要验证response code是:200
      then 我需要验证response中指定JsonPath:$.data.paymentAmount的值是:0.02

