#!/usr/bin/env bash

#JAIL=/tmp/jail-dir
JAIL=$1
#rm -fr $JAIL/*
ANALYSIS_FILE=$2 #time.R

DIST_ARCHIVE=$3

#echo "vkoulakov:vkoulakov:1000:1000:vkoulakov,,,:/home/test:/bin/bash" > $JAIL/etc/passwd
#echo ".libPaths('~/.R/libs')" > $JAIL/home/vkoulakov/.Rprofile


sudo tar xzf $DIST_ARCHIVE -C $JAIL

export R_HOME=/usr/lib/R
sudo cp /etc/resolv.conf $JAIL/etc/resolv.conf
sudo cp $KRB_CONF $JAIL/etc/krb5.conf
sudo cp $KRB_KEYTAB $JAIL/etc/krb.keytab
sudo cp /etc/R-with-krb.sh $JAIL/etc/R-with-krb.sh
sudo cp -R /impala/. $JAIL/impala/
sudo chmod +x $JAIL/etc/R-with-krb.sh
sudo mount --bind /proc $JAIL/proc



#cd $JAIL
sudo chroot $JAIL /usr/bin/env -i DBMS_USERNAME=$DBMS_USERNAME \
 DBMS_PASSWORD=$DBMS_PASSWORD DBMS_TYPE=$DBMS_TYPE \
 CONNECTION_STRING=$CONNECTION_STRING DBMS_SCHEMA=$DBMS_SCHEMA \
 TARGET_SCHEMA=$TARGET_SCHEMA RESULT_SCHEMA=$RESULT_SCHEMA \
 COHORT_TARGET_TABLE=$COHORT_TARGET_TABLE PATH=$PATH \
 HOME=$HOME IMPALA_DRIVER_PATH=$IMPALA_DRIVER_PATH \
 /etc/R-with-krb.sh "$KINIT_PARAMS" "$ANALYSIS_FILE"
