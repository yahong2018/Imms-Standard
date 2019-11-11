/*
  工位机的业务处理
      1. 验证工位机
      2. 如果是刷卡，则验证卡
      3. 获取session
      4. 根据session_type、expire_time 进行业务处理


  目前需要用到session管理的业务，主要就是工件退还和后工序发卡。
  工件退还流程：
      1. 退件人刷工卡
      2. 系统菜单显示:  1.工件退还    2.发前工程看板      
      3. 退件人 按1键，按确定
      4. 系统提示 请刷看板卡                             0
      5. 退件人刷 看板卡
      6. 系统提示 请输入退还数量                         1 
      7. 退件人 输入退还数量
      8. 系统提示 请接收人刷工卡                         2
      9. 接收人刷工卡
      10. 系统 进行退还处理，提示已成功退还xxx件          3

  
  后工序给前工序发卡
     1. 发卡人刷工卡
     2. 菜单： 1.工件退还   2.发前工程看板
     3. 选择 2
     4. 提示 请刷看板
     5. 发卡人 刷看板
     6. 提示 请输入数量
     7. 输入数量
     8. 提示 发卡完成
  
*/


drop procedure MES_ProcessIssuePlanToPrevProcedure;


drop procedure MES_ProcessIssuePlanToPrevProcedure_0;


drop procedure MES_ProcessIssuePlanToPrevProcedure_1;


drop procedure MES_ProcessIssuePlanToPrevProcedure_2;




