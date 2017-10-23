Feature: 主商品上下限

  @api
  Scenario: 商品数量超出库存（无虚库）
    Given 我要测试一个API,从数据文件[inputdata.config]的节点[noEnoughInventory]获取参数,测试场景是[Call /orders/submit API]
      when 我调用了api
      then 我需要验证response code是:400
      then 我需要验证response中指定JsonPath:$.msg的值是:玉溪市通海斯贝佳普洱茶糕215g商品库存不足
      then 我需要验证response中指定JsonPath:$.code的值是:12005

  @api
  Scenario: 商品数量超出商品本身的上限
    Given 我要测试一个API,从数据文件[inputdata.config]的节点[aboveTheLimit]获取参数,测试场景是[Call /orders/submit API]
      when 我调用了api
      then 我需要验证response code是:400
      then 我需要验证response中指定JsonPath:$.msg的值是:楚雄州武定壮鸡熟食800g盒装超出限购数量
      then 我需要验证response中指定JsonPath:$.code的值是:1005

  @api
  Scenario: 商品数量低于商品本身的下限
    Given 我要测试一个API,从数据文件[inputdata.config]的节点[belowUpperLimit]获取参数,测试场景是[Call /orders/submit API]
      when 我调用了api
      then 我需要验证response code是:400
      then 我需要验证response中指定JsonPath:$.msg的值是:楚雄州武定壮鸡熟食800g盒装超出限购数量
      then 我需要验证response中指定JsonPath:$.code的值是:1005