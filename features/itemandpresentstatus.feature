Feature: 判断主商品和赠品的商品状态

  @api
  Scenario: 主商品下架，不能下单
    Given 我要测试一个API,从数据文件[inputdata.config]的节点[itemIsUndercarriage]获取参数,测试场景是[Call /orders/submit API]
      when 我调用了api
      then 我需要验证response code是:400
      then 我需要验证response中指定JsonPath:$.msg的值是:牟定天台福泉生姜片素腐乳220g已下架
      then 我需要验证response中指定JsonPath:$.code的值是:12015

  @api
  Scenario: 主商品仅展示，不能下单
    Given 我要测试一个API,从数据文件[inputdata.config]的节点[itemDisplayOnly]获取参数,测试场景是[Call /orders/submit API]
      when 我调用了api
      then 我需要验证response code是:400
      then 我需要验证response中指定JsonPath:$.msg的值是:自动化测试主商品仅展示-大理洱源县邓川蝶泉特浓纯牛奶250ml*16已下架
      then 我需要验证response中指定JsonPath:$.code的值是:12015

  @api
  Scenario: 主商品已作废，不能下单
    Given 我要测试一个API,从数据文件[inputdata.config]的节点[itemCancel]获取参数,测试场景是[Call /orders/submit API]
      when 我调用了api
      then 我需要验证response code是:400
      then 我需要验证response中指定JsonPath:$.msg的值是:自动化主商品已作废-山州丘北县山里郎QQ酥麻辣味86g已下架
      then 我需要验证response中指定JsonPath:$.code的值是:12015

  @api
  Scenario: 赠品已作废，提示赠品不足，点击继续按钮，能下单
    Given 我要测试一个API,从数据文件[inputdata.config]的节点[presentCancel]获取参数,测试场景是[Call /orders/submit API]
      when 我调用了api
      then 我需要验证response code是:400
      then 我需要验证response中指定JsonPath:$.msg的值是:赠品已送完是否继续提交订单？
      then 我需要验证response中指定JsonPath:$.code的值是:1021

  @api
  Scenario: 赠品已作废，提示赠品不足，点击继续按钮，能下单，二次确认
    Given 我要测试一个API,从数据文件[inputdata.config]的节点[presentCancelAgain]获取参数,测试场景是[Call /orders/submit API]
      when 我调用了api
      then 我需要验证response code是:200
      then 我需要验证response中指定JsonPath:$.data.resultMessage[0].message的值是:赠品已送完是否继续提交订单？
      then 我需要验证response中指定JsonPath:$.data.resultMessage[0].messageType的值是:2
      then 我需要验证response中指定JsonPath:$.data.paymentAmount的值是:13.60

  @api
  Scenario: 赠品仅展示，提示赠品不足，点击继续按钮，能下单
    Given 我要测试一个API,从数据文件[inputdata.config]的节点[presentDisplay]获取参数,测试场景是[Call /orders/submit API]
      when 我调用了api
      then 我需要验证response code是:400
      then 我需要验证response中指定JsonPath:$.msg的值是:赠品已送完是否继续提交订单？
      then 我需要验证response中指定JsonPath:$.code的值是:1021

  @api
  Scenario: 赠品已上架，无提示，能下单
    Given 我要测试一个API,从数据文件[inputdata.config]的节点[itemOnSale]获取参数,测试场景是[Call /orders/submit API]
      when 我调用了api
      then 我需要验证response code是:200
      then 我需要验证response中指定JsonPath:$.data.paymentAmount的值是:47.60

  @api
  Scenario: 赠品下架，提示赠品不足，点击继续按钮，能下单
    Given DB初始化，从[presentNoEnoughAndItemCancel]获取SQL语句执行,测试数据文件来自于[inputdata.config]
    Given 我要测试一个API,从数据文件[inputdata.config]的节点[presentNoEnoughAndItemCancel]获取参数,测试场景是[Call /orders/submit API]
      when 我调用了api
      then 我需要验证response code是:400
      then 我需要验证response中指定JsonPath:$.msg的值是:赠品已送完是否继续提交订单？
      then 我需要验证response中指定JsonPath:$.code的值是:1021

  @api
  Scenario: 赠品下架，提示赠品不足，点击继续按钮，能下单，二次确认
    Given DB初始化，从[presentNoEnoughAndItemCancelAgain]获取SQL语句执行,测试数据文件来自于[inputdata.config]
    Given 我要测试一个API,从数据文件[inputdata.config]的节点[presentNoEnoughAndItemCancelAgain]获取参数,测试场景是[Call /orders/submit API]
      when 我调用了api
      then 我需要验证response code是:200
      then 我需要验证response中指定JsonPath:$.data.resultMessage[0].message的值是:赠品已送完是否继续提交订单？
      then 我需要验证response中指定JsonPath:$.data.resultMessage[0].messageType的值是:2
      then 我需要验证response中指定JsonPath:$.data.paymentAmount的值是:17.20