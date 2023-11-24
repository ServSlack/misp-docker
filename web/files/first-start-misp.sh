echo " FIRT START MISP_WEB "
#
# ZeroMQ settings:
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "Plugin.ZeroMQ_enable" true
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "Plugin.ZeroMQ_host" "127.0.0.1"
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "Plugin.ZeroMQ_port" 50000
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "Plugin.ZeroMQ_redis_host" "127.0.0.1"
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "Plugin.ZeroMQ_redis_port" 6379
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "Plugin.ZeroMQ_redis_database" 1
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "Plugin.ZeroMQ_redis_namespace" "mispq"
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "Plugin.ZeroMQ_event_notifications_enable" false
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "Plugin.ZeroMQ_object_notifications_enable" false
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "Plugin.ZeroMQ_object_reference_notifications_enable" false
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "Plugin.ZeroMQ_attribute_notifications_enable" false
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "Plugin.ZeroMQ_sighting_notifications_enable" false
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "Plugin.ZeroMQ_user_notifications_enable" false
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "Plugin.ZeroMQ_organisation_notifications_enable" false
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "Plugin.ZeroMQ_include_attachments" false
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "Plugin.ZeroMQ_tag_notifications_enable" false
#
# SimpleBackGroundJobs:
# https://github.com/MISP/MISP/blob/2.4/docs/background-jobs-migration-guide.md
#
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "SimpleBackgroundJobs.enabled" true
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "SimpleBackgroundJobs.redis_host" localhost
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "SimpleBackgroundJobs.redis_port" 6379
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "SimpleBackgroundJobs.redis_database" 1
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "SimpleBackgroundJobs.redis_namespace" background_jobs
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "SimpleBackgroundJobs.max_job_history_ttl" 86400
sleep 1 && sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "SimpleBackgroundJobs.supervisor_host" localhost
sleep 1 && sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "SimpleBackgroundJobs.supervisor_port" 9001
sleep 2 && sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "SimpleBackgroundJobs.supervisor_user" supervisor
sleep 2 && sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "SimpleBackgroundJobs.supervisor_password" supervisor
sleep 2 && sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "SimpleBackgroundJobs.redis_serializer" JSON
#
# Update MISP - All in one Shoot
cd $PATH_TO_MISP
${SUDO_WWW} ${RUN_PHP} -- ${CAKE} Admin updateMISP
#
# Update MISP Database:
sudo -E -Hu www-data /var/www/MISP/app/Console/cake Admin runUpdates
#
sudo -E -Hu www-data /var/www/MISP/app/Console/cake Admin updateJSON
# Configure MISP Security settings:
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "Security.disable_browser_cache" true
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "Security.check_sec_fetch_site_header" true
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "Security.csp_enforce" true
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "Security.advanced_authkeys" true
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "Security.do_not_log_authkeys" true
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "Security.username_in_response_header" true
#
# MISP Security settings;
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "Security.disable_browser_cache" true
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "Security.check_sec_fetch_site_header" true
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "Security.csp_enforce" true
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "Security.advanced_authkeys" true
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "Security.do_not_log_authkeys" true
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "Security.username_in_response_header" true
#
# Disable OTP Authentication to Prevent Problems ( " After if need fill free to enable it " )
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "Security.otp_required" false
#
#
# Disable E-mail Alert:
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "MISP.disable_emailing" true --force
#
# Principal Security AUDIT´s:
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "MISP.log_user_ips" true
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "MISP.log_new_audit" true
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "MISP.log_user_ips" true
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "MISP.log_client_ip" true
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "MISP.log_user_ips_authkeys" true
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "Security.advanced_authkeys" true
#
# Enable GnuPG;
# Export Environment:
export PATH_TO_MISP=/var/www/MISP
export WWW_USER=www-data
export SUDO_WWW='sudo -H -u www-data'
export CAKE="/var/www/MISP/app/Console/cake"
GPG_PASSPHRASE="$(openssl rand -hex 32)"
export GPG_PASSPHRASE="${GPG_PASSPHRASE:-(openssl rand -hex 32)}"
export GPG_EMAIL_ADDRESS=misp@admin.test
#
cat <<EOF > /tmp/gen-key-script
Key-Type: default
Key-Length: 4096
Subkey-Type: default
Name-Real: MISP-gpg-key
Name-Email: ${GPG_EMAIL_ADDRESS}
Passphrase: ${GPG_PASSPHRASE}
Expire-Date: 0
EOF
#
$SUDO_WWW gpg --homedir $PATH_TO_MISP/.gnupg --batch --gen-key /tmp/gen-key-script
$SUDO_WWW sh -c "gpg --homedir $PATH_TO_MISP/.gnupg --export --armor $GPG_EMAIL_ADDRESS" | $SUDO_WWW tee $PATH_TO_MISP/app/webroot/gpg.asc
#
# Enable GnuPG
${SUDO_WWW} ${RUN_PHP} -- ${CAKE} Admin setSetting "GnuPG.email" "${GPG_EMAIL_ADDRESS}"
${SUDO_WWW} ${RUN_PHP} -- ${CAKE} Admin setSetting "GnuPG.homedir" "${PATH_TO_MISP}/.gnupg"
${SUDO_WWW} ${RUN_PHP} -- ${CAKE} Admin setSetting "GnuPG.password" "${GPG_PASSPHRASE}"
${SUDO_WWW} ${RUN_PHP} -- ${CAKE} Admin setSetting "GnuPG.obscure_subject" true
${SUDO_WWW} ${RUN_PHP} -- ${CAKE} Admin setSetting "GnuPG.key_fetching_disabled" false
${SUDO_WWW} ${RUN_PHP} -- ${CAKE} Admin setSetting "GnuPG.binary" "$(which gpg)"
#
#
# Enable Workflow, Action and Enrichment Modules: ( Only Enable if MISP Modules is Enabled before )
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "Plugin.Enrichment_services_enable" true
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "Plugin.Action_services_enable" true
#
# Enable CLAMAV Scan for Vírus:
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "Plugin.Enrichment_clamav_enabled" "clamav"
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "Plugin.Enrichment_clamav_connection" "unix:///var/run/clamav/clamd.ctl"
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "MISP.attachment_scan_module" "clamav"
#
#
${SUDO_WWW} ${RUN_PHP} -- ${CAKE} Admin setSetting "Security.encryption_key" "${SECURITY_ENCRYPTION_KEY}"
#
# Change CLAMD necessary features:
sed -i 's/^Foreground false/Foreground true/g' /etc/clamav/clamd.conf
sed -i 's/^MaxThreads 12/MaxThreads 15/g' /etc/clamav/clamd.conf
sed -i 's/^MaxEmbeddedPE 10M/MaxEmbeddedPE 20M/g' /etc/clamav/clamd.conf
sed -i 's/^IdleTimeout 30/IdleTimeout 120/g' /etc/clamav/clamd.conf
sed -i 's/^CommandReadTimeout 5/CommandReadTimeout 30/g' /etc/clamav/clamd.conf
sed -i 's/^SendBufTimeout 200/SendBufTimeout 300/g' /etc/clamav/clamd.conf
echo "TCPSocket 3310 " >> /etc/clamav/clamd.conf
service clamav-freshclam no-daemon
supervisorctl start clamd
supervisorctl status clamd
#
# Enable CLAMAV Scan for Vírus:
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "Plugin.Enrichment_clamav_enabled" "clamav"
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "Plugin.Enrichment_clamav_connection" "unix:///var/run/clamav/clamd.ctl"
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "MISP.attachment_scan_module" "clamav"
#
# According reintered problems with this module I really recommend that you enable it afte UP your containers and check if it´s working:
# If you receive some error message, chage the parametter "Workflow_enable" inside file " /var/www/MISP/app/tmp/logs/Config/config.php " to " false " and save.
sudo -Hu www-data /var/www/MISP/app/Console/cake Admin setSetting "Plugin.Workflow_enable" true 
#
# Solve ldconfig - libfuzzy
cd /lib/ && mv libfuzzy.so.2 libfuzzy.so.2-old && ln -s libfuzzy.so.2.1.0 libfuzzy.so.2
#
# Remove Temporary files about MISP installation.
rm -rf /tmp/*
