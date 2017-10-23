Feature: 赠品上下限

  @api
  Scenario: 有赠品，赠品库存充足
    Given 我要测试一个API,从数据文件[inputdata.config]的节点[EnoughPresentInventory]获取参数,测试场景是[Call /orders/submit API]
      when 我调用了api
      then 我需要验证response code是:200
      then 我需要验证response中指定JsonPath:$.data.paymentAmount的值是:70.00

  @api
  Scenario: 有赠品，但赠品库存为0
    Given 我要测试一个API,从数据文件[inputdata.config]的节点[PresentInventoryIsZero]获取参数,测试场景是[Call /orders/submit API]
      when 我调用了api
      then 我需要验证response code是:400
      then 我需要验证response中指定JsonPath:$.msg的值是:赠品已送完是否继续提交订单？
      then 我需要验证response中指定JsonPath:$.code的值是:1021

  @api
  Scenario: 有赠品，但赠品库存为0时二次确认
    Given 我要测试一个API,从数据文件[inputdata.config]的节点[PresentInventoryIsZeroAgain]获取参数,测试场景是[Call /orders/submit API]
      when 我调用了api
      then 我需要验证response code是:200
      then 我需要验证response中指定JsonPath:$.data.resultMessage[0].message的值是:赠品已送完是否继续提交订单？
      then 我需要验证response中指定JsonPath:$.data.resultMessage[0].messageType的值是:2
      then 我需要验证response中指定JsonPath:$.data.paymentAmount的值是:58.00

  @api
  Scenario: 有赠品，但赠品库存不足
    Given 我要测试一个API,从数据文件[inputdata.config]的节点[noEnoughPresentInventory]获取参数,测试场景是[Call /orders/submit API]
      when 我调用了api
      then 我需要验证response code是:400
      then 我需要验证response中指定JsonPath:$.msg的值是:赠品已送完是否继续提交订单？
      then 我需要验证response中指定JsonPath:$.code的值是:1021

  @api
  Scenario: 有赠品，但赠品库存不足 ,二次确认
    Given 我要测试一个API,从数据文件[inputdata.config]的节点[noEnoughPresentInventoryAgain]获取参数,测试场景是[Call /orders/submit API]
      when 我调用了api
      then 我需要验证response code是:200
      then 我需要验证response中指定JsonPath:$.data.resultMessage[0].message的值是:赠品已送完是否继续提交订单？
      then 我需要验证response中指定JsonPath:$.data.resultMessage[0].messageType的值是:2
      then 我需要验证response中指定JsonPath:$.data.paymentAmount的值是:15.60

