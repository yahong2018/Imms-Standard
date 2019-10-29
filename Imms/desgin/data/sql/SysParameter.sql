insert into system_parameter_class(record_id,class_name) values(1,'B003');

insert into system_parameter(record_id,parameter_class_id,parameter_code,parameter_name,parameter_value) values(2,1,'grant_type','grant_type','password');
insert into system_parameter(record_id,parameter_class_id,parameter_code,parameter_name,parameter_value) values(3,1,'client_id','client_id','ZWUwN2E0NmItYjUzMC00YjRlLTlkYWMtZTY3YmExMDdkYzE0');
insert into system_parameter(record_id,parameter_class_id,parameter_code,parameter_name,parameter_value) values(4,1,'client_secret','client_secret','YzUzMzMzOWUtZTk2MS00MDNiLTg4NjMtM2E3ZjU1OGMxZjk2');
insert into system_parameter(record_id,parameter_class_id,parameter_code,parameter_name,parameter_value) values(5,1,'username','username','19101001');
insert into system_parameter(record_id,parameter_class_id,parameter_code,parameter_name,parameter_value) values(6,1,'password','password','c8b3c62c7edb60d3c4c3ca488a9d81c564eb2329');

insert into system_parameter(record_id,parameter_class_id,parameter_code,parameter_name,parameter_value) values(7,1,'server_host','服务器','http://202.105.31.227');
insert into system_parameter(record_id,parameter_class_id,parameter_code,parameter_name,parameter_value) values(8,1,'login_url','登录验证地址','jsf/rfws/oauth/token');
insert into system_parameter(record_id,parameter_class_id,parameter_code,parameter_name,parameter_value) values(9,1,'progress_report_url','报工数据同步地址','jsf/rfws/aisa/savepc');
insert into system_parameter(record_id,parameter_class_id,parameter_code,parameter_name,parameter_value) values(10,1,'moving_report_url','移库数据同步地址','jsf/rfws/aisa/savemove');
insert into system_parameter(record_id,parameter_class_id,parameter_code,parameter_name,parameter_value) values(11,1,'qualitycheck_report_url','品质数据同步地址','');

insert into system_parameter(record_id,parameter_class_id,parameter_code,parameter_name,parameter_value) values(12,1,'account_id','账套Id','63');

insert into system_parameter(record_id,parameter_class_id,parameter_code,parameter_name,parameter_value) values(13,1,'last_sync_id_progress','最后报工数据同步的Id','1');
insert into system_parameter(record_id,parameter_class_id,parameter_code,parameter_name,parameter_value) values(14,1,'last_sync_id_progress_ww','最后委外数据同步的Id','1');
insert into system_parameter(record_id,parameter_class_id,parameter_code,parameter_name,parameter_value) values(15,1,'last_sync_id_move','最后移库数据同步的Id','1');
insert into system_parameter(record_id,parameter_class_id,parameter_code,parameter_name,parameter_value) values(16,1,'last_sync_id_qualitycheck','最后品质数据同步的Id','1');