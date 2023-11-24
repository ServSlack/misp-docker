MISP Docker Ubuntu 22.04
========================

Project created by Weliton Souza, please give the credits and lets coonect " https://www.linkedin.com/in/weliton-souza/ "

This project can be used to create two Docker containers running Ubuntu 22.04 with [MISP](http://www.misp-project.org) ("Malware Information Sharing Platform").

The MISP containers needs at least a MySQL container to store the data. By default it listen to port 443 and port 80, which is redirected to 443.

The build is based on Ubuntu 22.04 and will install all the required components, using the " INSTALL.sh " script. 

Follow configurations and improvements performed:

* Optimization of the PHP environment (php.ini) to match the MISP recommended values
* Creation of the MySQL database with latest MariaDB version.
* Configure Static IPÂ´s for MISP_WEB and MISP_DB.
* Enabled new " SimpleBackGroudJobs " as default way to manage Workers 
* Generation of the admin PGP key
* Enabled password complexity
* Installation and Enabled MISP Modules
* Installation and Configuration of CLAMAV
* Installation and Configuration of cron
* Installation and Configuration of rsyslog
* Installation and Tunning about all Security Audit, PHP Settings, PHP Extensions, PHP Dependencies and Attachment scan module.
* Defining default Passwords really Strong with long 65 carachters:
    *  GPG_PASSPHRASE
    *  SECURITY_ENCRYPTION_KEY
    *  MYSQL_PASSWORD
    *  MYSQL_ROOT_PASSWORD

* MISP_DB Container:
    - Enable MariaDB " performance_schema "
    - Include " my.cnf " tunning filed:
        * It will redirect 90% of CPU to be used by " innodb_buffer_pool_instances, innodb_read_io_threads and innodb_write_io_threads "
        * It will redirect 70% of POD server memory directly for Database
            - If you want you can change this value directly on " misp_db " container inside file ( /etc/bash.bashrc ) and search from the lasts two variables ( " num_cpu " and " ram_total " )

# Building your image and containers: Only RUN one by one of those files in the follow order and wait finish:

1-) 1_Install_Docker.sh
2-) 2_Build_MISP_Image.sh
3-) 3_Create_MISP_Containers.sh

```

$ 1-) If you don´t have Docker installed yeat only run " 1_Install_Docker.sh "
# ATTENTION !!!! " ---> ALL DATA PRESENT IN "/DEV/SDB1" WILL BEE LOST. <--- ATTENTION !!!! #
# ATTENTION !!!! " ---> ALL DATA PRESENT IN "/DEV/SDB1" WILL BEE LOST. <--- ATTENTION !!!! #
# ATTENTION !!!! " ---> ALL DATA PRESENT IN "/DEV/SDB1" WILL BEE LOST. <--- ATTENTION !!!! #
 
$ 2-) Once you have Docker installed propertly RUN: " 2_Build_MISP_Image.sh "

$ 3-) After complete BUILD Image RUN: " 3_Create_MISP_Containers.sh " to create MISP Containers.

$ 4-) When image below apears you can access your instance directly using your IP as example: " https://192.168.1.5 "
# ATTENTION !!!! ---> Will be generated a file asked " password.txt " and I recommend you save this information in some Key Vault and after REMOVE the file.

                                                                  ddooooooooooooooooooooooooooooooooooooooooooooooooooooook:
                                                               ddloooooooooooooooooooooooooooooooooooooooooooooooooooooooooodx
                                                             .xooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooox.
                                                             ;ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo;
                                                             ,ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo;
                                                             ,ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo;
                                                             ,ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo;
                                                             ,ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo;
                                                             ,oooooooooooo;      cooooooool      .ooooooooo;      coooooooooooo;   .xxxk0c
                                                             ,oooooooooooc        'ooooooo        .ooooooo.        looooooooooo;   .oooooox
                                                             ,oooooooooool        ;ooooooo.       .ooooooo;        oooooooooooo;   .ooooooo.
                                                             ,ooooooooooookd    lOoooooooox0.   'KdooooooooO:    dxoooooooooooo;   .ooooooo.
                                                             ,oooooooooooooodxxxoooooooooooodxxxlooooooooooooxxxdoooooooooooooo;   .ooooooo.
                                                             ,ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo;   .ooooooo.
                                                             ,ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo;   .ooooooo.
                                                             ,ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo;   .ooooooo.
                                                             ,ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo;   .ooooooo.
                                                             ,ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo;   .ooooooo.
                                                             'ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo,   .ooooooo.
                                                               :oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooool     .ooooooo.
                                                                 .looooooooooooooooooooooooooooooooooooooooooooooooooooooooc       ;ooooooo.
                                                                     'oooooooooool                                                ;oooooooo.
                                                                     cooooooooc                                                 lxooooooooo.
                                                                    ,ooooooc       ,xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxooooooooooo.
                                                                   .ooo,            coooooooooooooooooooooooooooooooooooooooooooooooooooooc
                                                                   cc                .oooooooooooooooooooooooooooooooooooooooooooooooooooo
                                                                                          ';;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;ooooooooooc'
                                                                                                                             .oooooooo
                                                                                                                                  cooo;
                                                                      .',..                                                          :l
kkkkkkkkkkkd             ckkkkkkkkkkk;    :kkkkkkkkkkd          lkdooc;;;;;;ooodkx,        ;ooooooooooooooooodkkk;
;;;;;;;;;;;;l.         'x;;;;;;;;;;;;'    ,;;;;;;;;;;,       dxc;;;;;;;;;;;;;;;;;;;llkl    .;;;;;;;;;;;;;;;;;;;;;;coxd
;;;;;;;;;;;;;c.       .c;;;;;;;;;;;;;'    ,;;;;;;;;;;,      c;;;;;;;;;;;;;;;;;;;;;;;;;.    .;;;;;;;;;;;;;;;;;;;;;;;;;;d
;;;;;;;;;;;;;;;o     ;c;;;;;;;;;;;;;;'    ,;;;;;;;;;;,    ,;;;;;;;;;;;;;;;;;;;;;;;;;,      .;;;;;;;;;;;;;;;;;;;;;;;;;;;c.
;;;;;;;;;;;;;;;;c   c;;;;;;;;;;;;;;;;'    ,;;;;;;;;;;,    ';;;;;;;;;;'        ';;;;.       .;;;;;;;;;;.     .;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;o.c;;;;;;;;;;;;;;;;;'    ,;;;;;;;;;;,    ';;;;;;;;;;;ko.        .         .;;;;;;;;;;.       ;;;;;;;;;;;.
;;;;;;;;;;;;;;;;;;c;;;;;;;;;;;;;;;;;;'    ,;;;;;;;;;;,    .;;;;;;;;;;;;;;cl:xx00o          .;;;;;;;;;;.      .;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;'    ,;;;;;;;;;;,      ;;;;;;;;;;;;;;;;;;;;;;ok:      .;;;;;;;;;;.     .o;;;;;;;;;;.
;;;;;;;;;;';;;;;;;;;;;;;;,,;;;;;;;;;;'    ,;;;;;;;;;;,        ,;;;;;;;;;;;;;;;;;;;;;;:o    .;;;;;;;;;;;xxoll;;;;;;;;;;;.
;;;;;;;;;;. ';;;;;;;;;;;, ,;;;;;;;;;;'    ,;;;;;;;;;;,           .,;;;;;;;;;;;;;;;;;;;;'   .;;;;;;;;;;;;;;;;;;;;;;;;;;.
;;;;;;;;;;.  ';;;;;;;;;.  ,;;;;;;;;;;'    ,;;;;;;;;;;,        l         .;;;;;;;;;;;;;;.   .;;;;;;;;;;;;;;;;;;;;;;;;.
;;;;;;;;;;.    ,;;;;;;    ,;;;;;;;;;;'    ,;;;;;;;;;;,      cl;co0O.         ;;;;;;;;;;'   .;;;;;;;;;;;;;;;;;,.
;;;;;;;;;;.     ,;;;;     ,;;;;;;;;;;'    ,;;;;;;;;;;,    .o;;;;;;;;ooxkkkkkc;;;;;;;;;;.   .;;;;;;;;;;.
;;;;;;;;;;.      .;.      ,;;;;;;;;;;'    ,;;;;;;;;;;,   x,;;;;;;;;;;;;;;;;;;;;;;;;;;;.    .;;;;;;;;;;.
;;;;;;;;;;.               ,;;;;;;;;;;'    ,;;;;;;;;;;,    .;;;;;;;;;;;;;;;;;;;;;;;;;;.     .;;;;;;;;;;.
;;;;;;;;;;.               ,;;;;;;;;;;'    ,;;;;;;;;;;,       .,;;;;;;;;;;;;;;;;;;;;        .;;;;;;;;;;.
...........               ............    ............                  ...

   ,000000000000  xxx.                                           ',,.             d00000k,   cxx;                               dxx.
   .;;;;;;;;;;;;  ;;;.                                           ;;;.           c;;;,',;;.   ';;.                                ..
        ;;;.      ;;;.xkkk;    xkk.dkk,  :kkkkkx    .kkkkkkk,  ,k;;;;kk;        ;;;          ';;.;kkkk'   :kkkkkkk:    kkk.xkk' loo.  :kk:ckkkk,     dkkk:lkk
        ;;;.      ;;;'  ,;;l   ;;;,    ll;.   .;co        .;;;   ;;;.           .;;clxx0k.   ';;;   ;;;.        .;;c   ;;;,     ,;;.  .;;;   ;;;'  o;;.   ;;;
        ;;;.      ;;;.  .;;;   ;;;.    ,;;;kkk;;;;. .kdooo;;;'   ;;;.               .';;;c.  ';;.   ';;.  ,kdooo;;;,   ;;;      ,;;.  .;;.   ';;,  ;;;.   ';;
        ;;;.      ;;;.  .;;;   ;;;.    .;;'      . ';;,   ,;;'   ,;;'           O:    .;;;.  ';;.   ';;. .;;;   ,;;,   ;;;      ,;;.  .;;.   ';;,  ';;:  ';;;
        ;;;.      ;;;.  .;;;   ;;;.     .;;odkooc.  ';;cko';;'    ;;;oo.        ;;coooc;;.   ';;.   ';;.  ';;ckd';;,   ;;;      ,;;.  .;;.   ';;,   .;;co,';;
                                                                                                                                                          ;;;
                                                                                                                                                    llxxxc;.
                                                                                                                                                    .';;;,.
```
