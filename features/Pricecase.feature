Feature: 价格

  @api
  Scenario: 入参价格与实际价格不一致
    Given 我要测试一个API,从数据文件[inputdata.config]的节点[differentPrice]获取参数,测试场景是[Call /orders/submit API]
      when 我调用了api
      then 我需要验证response code是:400
      then 我需要验证response中指定JsonPath:$.msg的值是:结算金额发生变化请重新结算

  @api
  Scenario: 入参价格与实际价格一致
    Given 我要测试一个API,从数据文件[inputdata.config]的节点[thesametPrice]获取参数,测试场景是[Call /orders/submit API]
      when 我调用了api
      then 我需要验证response code是:200
      then 我需要验证response中指定JsonPath:$.data.paymentAmount的值是:118.00

