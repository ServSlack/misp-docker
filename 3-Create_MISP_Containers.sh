#!/bin/bash
echo "##################################"
echo "##################################"
echo "####___CREATE NECESSARY ENV___####"
echo "##################################"
echo "##################################"
#
cp template.env .env
#
GPG_PASSPHRASE="$(openssl rand -hex 32)"
> password.txt && echo "GPG_PASSPHRASE=$GPG_PASSPHRASE" |tee -a password.txt | tee -a .env
#
SECURITY_ENCRYPTION_KEY="$(openssl rand -hex 32)"
echo "SECURITY_ENCRYPTION_KEY=$SECURITY_ENCRYPTION_KEY" | tee -a password.txt | tee -a .env
#
MYSQL_PASSWORD="$(openssl rand -hex 32)"
echo "MYSQL_PASSWORD=$MYSQL_PASSWORD" | tee -a password.txt | tee -a .env
#
MYSQL_ROOT_PASSWORD="$(openssl rand -hex 32)"
echo "MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD" | tee -a password.txt | tee -a .env
#
timeout -s 9 125s docker compose up 
# MISP_WEB:
docker cp web/files/supervisord.conf misp_web:/etc/supervisor/conf.d/supervisord.conf
docker cp web/files/first-start-misp.sh misp_web:/tmp/
docker exec misp_web bash /tmp/first-start-misp.sh
#
# Enable Apache ModSecurity3:
docker exec -it misp_web bash -c 'apt update && apt install -qy libapache2-mod-security2 libmodsecurity3 modsecurity-crs' 
docker cp web/files/modsecurity/security2.conf misp_web:/etc/apache2/mods-enabled/security2.conf
docker cp web/files/modsecurity/modsecurity.conf misp_web:/etc/modsecurity/modsecurity.conf
docker cp web/files/modsecurity/modsec_rotate misp_web:/etc/logrotate.d/modsec
#
#
# MariaDB Tunning for " misp_db ":
export num_cpu=$(cat /proc/cpuinfo | grep processor | wc -l | awk '{print int($1 * 0.90)}')
export innodb_buffer_pool_instances=$num_cpu
export ram_70=$(free -h | grep Mem | awk '{print $2}' | tr -d "Gi" | awk '{print int($1 * 0.7)}')
export innodb_buffer_pool_size=$ram_70
export max_connections=$((num_cpu * 10))
#
# Create MariaDB Tunned file:
cat <<EOF > db/files/my.cnf
[mariadbd]
performance_schema=ON
performance-schema-instrument='stage/%=ON'
performance-schema-consumer-events-stages-current=ON
performance-schema-consumer-events-stages-history=ON
performance-schema-consumer-events-stages-history-long=ON

# === Required Settings ===
basedir                         = /usr
bind_address                    = 0.0.0.0 # Change to 0.0.0.0 to allow remote connections
datadir                         = /var/lib/mysql
max_allowed_packet              = 256M
max_connect_errors              = 1000000
pid_file                        = /var/run/mysqld/mysqld.pid
port                            = 3306
socket                          = /run/mysqld/mysqld.sock
secure_file_priv                = /var/lib/mysql
tmpdir                          = /tmp
user                            = mysql

# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0
log-error                       = /var/log/mysql/mysqld.log
pid-file                        = /var/run/mysqld/mysqld.pid

# === InnoDB Settings ===
default_storage_engine          = InnoDB
innodb_buffer_pool_instances    = ${innodb_buffer_pool_instances}
innodb_buffer_pool_size         = ${innodb_buffer_pool_size}G
innodb_file_per_table           = 1
innodb_flush_log_at_trx_commit  = 1
innodb_flush_method             = O_DIRECT
innodb_log_buffer_size          = 16M
innodb_log_file_size            = 1G
innodb_stats_on_metadata        = 0
innodb_read_io_threads          = ${num_cpu}
innodb_write_io_threads         = ${num_cpu}
innodb_io_capacity             = 4000
innodb_io_capacity_max         = 8000

# === Connection Settings ===
max_connections                 = ${max_connections}
back_log                        = 512
thread_cache_size               = ${num_cpu}
thread_stack                    = 192K

# === Buffer Settings ===
innodb_sort_buffer_size         = 2M
join_buffer_size                = 4M
read_buffer_size                = 3M
read_rnd_buffer_size            = 4M
sort_buffer_size                = 4M

# === Table Settings ===
table_definition_cache          = 40000
table_open_cache                = 40000
open_files_limit                = 60000
max_heap_table_size             = 256M
tmp_table_size                  = 256M

# === Search Settings ===
ft_min_word_len                 = 3

# === Logging ===
log_bin=ON
binlog_format=ROW
expire_logs_days=7
log_error=/var/log/mysql/mysqld.log
log_queries_not_using_indexes=ON
long_query_time=1
slow_query_log=OFF
slow_query_log_file=/var/log/mysql/slow.log
EOF
#
docker exec -it misp_db bash -c 'apt update && apt upgrade -qy && apt install vim mysql-client pv -qy'
docker cp db/files/my.cnf misp_db:/etc/mysql/my.cnf
#
docker container restart misp_db misp_web
#
clear && cat web/files/misp.txt
