Feature: 是否满足满减活动金额

  @api
  Scenario: 满足满减活动，减免金额
    Given 我要测试一个API,从数据文件[inputdata.config]的节点[fullReduction]获取参数,测试场景是[Call /orders/submit API]
      when 我调用了api
      then 我需要验证response code是:200
      then 我需要验证response中指定JsonPath:$.data.paymentAmount的值是:74.00

  @api
  Scenario: 不满足满减活动，不减免金额
    Given DB初始化，从[noFullReduction]获取SQL语句执行,测试数据文件来自于[inputdata.config]
    Given 我要测试一个API,从数据文件[inputdata.config]的节点[noFullReduction]获取参数,测试场景是[Call /orders/submit API]
      when 我调用了api
      then 我需要验证response code是:200
      then 我需要验证response中指定JsonPath:$.data.paymentAmount的值是:32.00

