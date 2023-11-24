20 12 * * * root [ -f /var/log/clamav_cron.log ] || touch /var/log/clamav_cron.log && /bin/sh -c "/etc/init.d/clamav-freshclam no-daemon" >> /var/log/clamav_cron.log 2>&1 
21 12 * * * root [ -f /var/log/misp_cron.log ] || touch /var/log/misp_cron.log && sudo -Hu www-data /var/www/MISP/app/Console/cake Server cacheFeed "1" all >> /var/log/misp_cron.log 2>&1
22 12 * * * root [ -f /var/log/misp_cron.log ] || touch /var/log/misp_cron.log && sudo -Hu www-data /var/www/MISP/app/Console/cake Server fetchFeed "1" all >> /var/log/misp_cron.log 2>&1
23 12 * * * root [ -f /var/log/misp_cron.log ] || touch /var/log/misp_cron.log && sudo -Hu www-data /var/www/MISP/app/Console/cake Server pullAll "1" >> /var/log/misp_cron.log 2>&1
24 12 * * * root [ -f /var/log/misp_cron.log ] || touch /var/log/misp_cron.log && sudo -Hu www-data /var/www/MISP/app/Console/cake Server pushAll "1" >> /var/log/misp_cron.log 2>&1
25 12 * * * root [ -f /var/log/misp_cron.log ] || touch /var/log/misp_cron.log && sudo -Hu www-data /var/www/MISP/app/Console/cake Admin updateGalaxies >> /var/log/misp_cron.log 2>&1
26 12 * * * root [ -f /var/log/misp_cron.log ] || touch /var/log/misp_cron.log && sudo -Hu www-data /var/www/MISP/app/Console/cake Admin updateTaxonomies >> /var/log/misp_cron.log 2>&1
27 12 * * * root [ -f /var/log/misp_cron.log ] || touch /var/log/misp_cron.log && sudo -Hu www-data /var/www/MISP/app/Console/cake Admin updateWarningLists >> /var/log/misp_cron.log 2>&1
28 12 * * * root [ -f /var/log/misp_cron.log ] || touch /var/log/misp_cron.log && sudo -Hu www-data /var/www/MISP/app/Console/cake Admin updateNoticeLists >> /var/log/misp_cron.log 2>&1
29 12 * * * root [ -f /var/log/misp_cron.log ] || touch /var/log/misp_cron.log && sudo -Hu www-data /var/www/MISP/app/Console/cake Admin updateObjectTemplates "1" >> /var/log/misp_cron.log 2>&1
