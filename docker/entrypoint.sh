#!/bin/bash

set -e

: ${SERVERID=master}
: ${SERVERDIR=/opt/perforce/servers/master}

export P4ROOT=$SERVERDIR/root
export P4PORT=ssl:1666
export P4SSLDIR=ssl

umask 077

if ! test -d $SERVERDIR; then 
	PASSWD=$(pwgen -s 32 1)
	/opt/perforce/sbin/configure-helix-p4d.sh $SERVERID -n --debug -r $SERVERDIR -u super -P $PASSWD 2>&1 | tee configure.log
	p4dctl stop -a
	mv configure.log $SERVERDIR
	echo $PASSWD >$SERVERDIR/password.txt
	cp ~/.p4trust $SERVERDIR/p4trust.txt
	cp ~/.p4enviro $SERVERDIR/p4enviro.txt
	mv /etc/perforce/p4dctl.conf.d/*.conf $SERVERDIR/p4dctl.conf
fi

cp $SERVERDIR/p4trust.txt ~/.p4trust
cp $SERVERDIR/p4enviro.txt ~/.p4enviro
echo "include $SERVERDIR/p4dctl.conf" >>/etc/perforce/p4dctl.conf

exec gosu perforce:perforce p4d
