CREATE DATABASE IF NOT EXISTS eduspot;
USE eduspot;

DROP TABLE IF EXISTS params;

-- Parametres et valeurs par defaut
create table params(
	param_id 	int unsigned not null auto_increment,
	param_item	varchar(100) not null,
	param_value	varchar(100) default null,
	constraint pk_params primary key(param_id)
)engine=InnoDB;

DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS sessions;

-- Comptes invites
create table accounts(
	account_id 		int unsigned not null auto_increment,
	account_login		varchar(100) not null,
	account_passwd		varchar(40) not null,
	account_owner		varchar(8) default null,
	account_creation	TIMESTAMP not null default CURRENT_TIMESTAMP,
	constraint pk_accounts primary key(account_id),
	UNIQUE KEY login_name_must_be_unique (account_login),
	KEY `account_owner` (`account_owner`)
)engine=InnoDB;

-- Sessions invites
create table sessions(
	session_id 		int unsigned not null auto_increment,
	session_account_id	int unsigned not null,
	session_enabled		tinyint(1) not null default 1,
	session_begin		int unsigned not null,
	session_end		int unsigned not null,
	session_proposer	varchar(8) not null,
	session_comment		varchar(100) default null,
	session_creation	TIMESTAMP not null default CURRENT_TIMESTAMP,
	constraint pk_sessions primary key(session_id),
	constraint fk_sessions_accounts foreign key(session_account_id) references accounts(account_id) on delete cascade,
	KEY `session_proposer` (`session_proposer`)
)engine=InnoDB;

DROP TABLE IF EXISTS quotas;

-- Quotas
create table quotas(
	quota_id 		int unsigned not null auto_increment,
	quota_login             varchar(100) not null,
	quota_sessions		smallint unsigned default null,
	quota_time 		int unsigned default null,
	quota_duration 		int unsigned default null,
	quota_bytes_class0	bigint unsigned default null,
	quota_bytes_class1	bigint unsigned default null,
	quota_bytes_class2	bigint unsigned default null,
	quota_bytes_class3	bigint unsigned default null,
	constraint pk_quotas primary key(quota_id),
	KEY `quota_login` (`quota_login`)
)engine=InnoDB;

DROP TABLE IF EXISTS logs;

-- Logs
create table logs(
	log_id 		bigint unsigned not null auto_increment,
	log_host	varchar(20) not null,
	log_wlan_id	varchar(10) not null,
	log_login	varchar(100) not null,
	log_ip		varchar(15) not null,
	log_mac		varchar(17) not null,
	log_grant	int unsigned not null,
	log_revoke	int unsigned default null,
	log_bytes_dl0	bigint unsigned default null,
	log_bytes_up0	bigint unsigned default null,
	log_bytes_dl1	bigint unsigned default null,
	log_bytes_up1	bigint unsigned default null,
	log_bytes_dl2	bigint unsigned default null,
	log_bytes_up2	bigint unsigned default null,
	log_bytes_dl3	bigint unsigned default null,
	log_bytes_up3	bigint unsigned default null,
	constraint pk_logs primary key(log_id),
	KEY `log_host` (`log_host`),
	KEY `log_wlan_id` (`log_wlan_id`),
	KEY `log_login` (`log_login`),
	KEY `log_ip` (`log_ip`),
	KEY `log_mac` (`log_mac`),
	KEY `log_grant` (`log_grant`),
	KEY `log_revoke` (`log_revoke`)
)engine=InnoDB;

DROP TABLE IF EXISTS admins;

-- Comptes administrateurs
create table admins(
	admin_id	int unsigned not null auto_increment,
	admin_uid 	varchar(8) not null,
	constraint pk_admins primary key(admin_id)
)engine=InnoDB;


DROP VIEW IF EXISTS auth;

-- Vue authentification
create view auth as 
select distinct 
a.account_login as login,
a.account_passwd as passwd
from accounts a, sessions s
where s.session_account_id = a.account_id
and unix_timestamp() between s.session_begin and s.session_end;

-- Privileges
#grant select,insert,update,delete,create temporary tables on eduspot.* to 'eduspot'@'%';
#grant select,insert,update,delete on eduspot.* to 'esup'@'%';
#grant all on eduspot.* to 'adminEdu'@'IP' identified by 'PASSWD';
#flush privileges;
