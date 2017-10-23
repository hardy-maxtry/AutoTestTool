Feature: 自提

  @api
  Scenario: 全部是自提商品进行结算
    Given 我要测试一个API,从数据文件[inputdata.config]的节点[willCall]获取参数,测试场景是[Call /orders/submit API]
      when 我调用了api
      then 我需要验证response code是:200
      then 我需要验证response中指定JsonPath:$.data.paymentAmount的值是:4.50