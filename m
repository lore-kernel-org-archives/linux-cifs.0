From: Chad William Seys <cwseys-JAjqph6Yjy/rea2nFwT0Kw@public.gmane.org>
Subject: Re: problem when testing recent cifs.upcall
Date: Thu, 23 Feb 2017 14:18:06 -0600
Message-ID: <f922a603-0095-b86a-27a0-c7a6064e93d3@physics.wisc.edu>
References: <20170215161522.17063-1-jlayton@samba.org>
 <20170215161522.17063-3-jlayton@samba.org>
 <d29a36ca-693d-e3c6-9428-90b1ee9bce10@physics.wisc.edu>
 <1487853902.7731.21.camel@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1487853902.7731.21.camel-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

> To be clear...I assume that you have a keytab set up someplace that
> has the smbadmin@ credentials in it, correct? That's the only way
> that cifs.upcall would instantiate a new credcache.

Right.  smbadmin@ credentials are in /etc/krb5.keytab.  'mount' must
check there by default.

> It sounds like you're walking into the DFS mount in a task that is
> running as root, but that has inherited a KRB5CCNAME environment
> variable from a cwseys@ login session.

The task that is walking into the DFS mount is running as 'cwseys' .  My
guess is that when cwseys tries to cd into DFS mount, cifs.upcall or the
kernel is using the wrong name for root's credential cache.

> It might be nice to see the debug level output from syslog, so we can
> tell what's actually happening in the upcall. Can you provide that?


cwseys:
$ kdestroy
$ cd /

root:
# umount /smb
# umount /smb  # to be sure!
# kdestroy
#  ls /tmp/krb5cc_* -al
ls: cannot access '/tmp/krb5cc_*': No such file or directory

cwseys:
$ kinit
Password for cwseys-8oz4Nevp0l1cSxESns1TRQ@public.gmane.org:
$ ls /tmp/krb5cc_* -al
-rw------- 1 cwseys cwseys 939 Feb 23 12:59 /tmp/krb5cc_1494_sM11PG

$ klist -c /tmp/krb5cc_1494_sM11PG
Ticket cache: FILE:/tmp/krb5cc_1494_sM11PG
Default principal: cwseys-8oz4Nevp0l1cSxESns1TRQ@public.gmane.org

Valid starting       Expires              Service principal
02/23/2017 12:59:00  03/05/2017 12:58:57
krbtgt/PHYSICS.WISC.EDU-8oz4Nevp0l1cSxESns1TRQ@public.gmane.org


root:
# mount -t cifs //smb.physics.wisc.edu/smb /smb
-osec=krb5,multiuser,username=smbadmin-8oz4Nevp0l1cSxESns1TRQ@public.gmane.org --verbose
mount.cifs kernel mount options:
ip=128.104.160.17,unc=\\smb.physics.wisc.edu\smb,sec=krb5,multiuser,user=smbadmin-8oz4Nevp0l1cSxESns1TRQ@public.gmane.org,pass=********

#  ls /tmp/krb5cc_* -al
-rw------- 1 root   root   1046 Feb 23 13:00 /tmp/krb5cc_0
-rw------- 1 cwseys cwseys  939 Feb 23 12:59 /tmp/krb5cc_1494_sM11PG

# klist -c /tmp/krb5cc_0
Ticket cache: FILE:/tmp/krb5cc_0
Default principal: smbadmin-8oz4Nevp0l1cSxESns1TRQ@public.gmane.org

Valid starting       Expires              Service principal
02/23/2017 13:00:01  03/05/2017 13:00:01
krbtgt/PHYSICS.WISC.EDU-8oz4Nevp0l1cSxESns1TRQ@public.gmane.org
02/23/2017 13:00:01  03/05/2017 13:00:01
cifs/smb.physics.wisc.edu-8oz4Nevp0l1cSxESns1TRQ@public.gmane.org

[debug.log after mount]
Feb 23 13:00:01 trog cifs.upcall: key description:
cifs.spnego;0;0;39010000;ver=0x2;host=smb.physics.wisc.edu;ip4=128.104.160
.17;sec=krb5;uid=0x0;creduid=0x0;user=smbadmin-8oz4Nevp0l1cSxESns1TRQ@public.gmane.org;pid=0x6abf
Feb 23 13:00:01 trog cifs.upcall: ver=2
Feb 23 13:00:01 trog cifs.upcall: host=smb.physics.wisc.edu
Feb 23 13:00:01 trog cifs.upcall: ip=128.104.160.17
Feb 23 13:00:01 trog cifs.upcall: sec=1
Feb 23 13:00:01 trog cifs.upcall: uid=0
Feb 23 13:00:01 trog cifs.upcall: creduid=0
Feb 23 13:00:01 trog cifs.upcall: user=smbadmin-8oz4Nevp0l1cSxESns1TRQ@public.gmane.org
Feb 23 13:00:01 trog cifs.upcall: pid=27327
Feb 23 13:00:01 trog cifs.upcall: get_cachename_from_process_env:
pathname=/proc/27327/environ
Feb 23 13:00:01 trog cifs.upcall: get_existing_cc: default ccache is
FILE:/tmp/krb5cc_0
Feb 23 13:00:01 trog cifs.upcall: get_tgt_time: unable to get principal
Feb 23 13:00:01 trog cifs.upcall: handle_krb5_mech: getting service
ticket for smb.physics.wisc.edu
Feb 23 13:00:01 trog cifs.upcall: handle_krb5_mech: obtained service ticket
Feb 23 13:00:01 trog cifs.upcall: Exit status 0
Feb 23 13:00:01 trog cifs.upcall: key description:
cifs.spnego;0;0;39010000;ver=0x2;host=smb.physics.wisc.edu;ip4=128.104.160.17;sec=krb5;uid=0x0;creduid=0x0;user=smbadmin-8oz4Nevp0l1cSxESns1TRQ@public.gmane.org;pid=0x6abf
Feb 23 13:00:01 trog cifs.upcall: ver=2
Feb 23 13:00:01 trog cifs.upcall: host=smb.physics.wisc.edu
Feb 23 13:00:01 trog cifs.upcall: ip=128.104.160.17
Feb 23 13:00:01 trog cifs.upcall: sec=1
Feb 23 13:00:01 trog cifs.upcall: uid=0
Feb 23 13:00:01 trog cifs.upcall: creduid=0
Feb 23 13:00:01 trog cifs.upcall: user=smbadmin-8oz4Nevp0l1cSxESns1TRQ@public.gmane.org
Feb 23 13:00:01 trog cifs.upcall: pid=27327
Feb 23 13:00:01 trog cifs.upcall: get_cachename_from_process_env:
pathname=/proc/27327/environ
Feb 23 13:00:01 trog cifs.upcall: get_existing_cc: default ccache is
FILE:/tmp/krb5cc_0
Feb 23 13:00:01 trog cifs.upcall: handle_krb5_mech: getting service
ticket for smb.physics.wisc.edu
Feb 23 13:00:01 trog cifs.upcall: handle_krb5_mech: obtained service ticket
Feb 23 13:00:01 trog cifs.upcall: Exit status 0
Feb 23 13:00:01 trog cifs.upcall: key description:
cifs.spnego;0;0;39010000;ver=0x2;host=smb.physics.wisc.edu;ip4=128.104.160.17;sec=krb5;uid=0x5d6;creduid=0x5d6;pid=0x6725
Feb 23 13:00:01 trog cifs.upcall: ver=2
Feb 23 13:00:01 trog cifs.upcall: host=smb.physics.wisc.edu
Feb 23 13:00:01 trog cifs.upcall: ip=128.104.160.17
Feb 23 13:00:01 trog cifs.upcall: sec=1
Feb 23 13:00:01 trog cifs.upcall: uid=1494
Feb 23 13:00:01 trog cifs.upcall: creduid=1494
Feb 23 13:00:01 trog cifs.upcall: pid=26405
Feb 23 13:00:01 trog cifs.upcall: get_cachename_from_process_env:
pathname=/proc/26405/environ
Feb 23 13:00:01 trog cifs.upcall: get_cachename_from_process_env:
cachename = FILE:/tmp/krb5cc_1494_bkfO2z
Feb 23 13:00:01 trog cifs.upcall: get_existing_cc: default ccache is
FILE:/tmp/krb5cc_1494_bkfO2z
Feb 23 13:00:01 trog cifs.upcall: get_tgt_time: unable to get principal
Feb 23 13:00:01 trog cifs.upcall: Exit status 1

cwseys:
$ cd /smb

[debug.log after cd /smb]
Feb 23 13:05:20 trog cifs.upcall: key description:
cifs.spnego;0;0;39010000;ver=0x2;host=smb.physics.wisc.edu;ip4=128.104.160.17;sec=krb5;uid=0x5d6;creduid=0x5d6;pid=0x3397
Feb 23 13:05:20 trog cifs.upcall: ver=2
Feb 23 13:05:20 trog cifs.upcall: host=smb.physics.wisc.edu
Feb 23 13:05:20 trog cifs.upcall: ip=128.104.160.17
Feb 23 13:05:20 trog cifs.upcall: sec=1
Feb 23 13:05:20 trog cifs.upcall: uid=1494
Feb 23 13:05:20 trog cifs.upcall: creduid=1494
Feb 23 13:05:20 trog cifs.upcall: pid=13207
Feb 23 13:05:20 trog cifs.upcall: get_cachename_from_process_env:
pathname=/proc/13207/environ
Feb 23 13:05:20 trog cifs.upcall: get_cachename_from_process_env:
cachename = FILE:/tmp/krb5cc_1494_sM11PG
Feb 23 13:05:20 trog cifs.upcall: get_existing_cc: default ccache is
FILE:/tmp/krb5cc_1494_sM11PG
Feb 23 13:05:20 trog cifs.upcall: handle_krb5_mech: getting service
ticket for smb.physics.wisc.edu
Feb 23 13:05:20 trog cifs.upcall: handle_krb5_mech: obtained service ticket
Feb 23 13:05:20 trog cifs.upcall: Exit status 0

$ kdestroy
$ ls /tmp/krb5cc_* -al
-rw------- 1 root root 1046 Feb 23 13:00 /tmp/krb5cc_0

# obs-cos is on a different server - DFS linked.
$ cd obs-cos
$ ls
ls: cannot open directory '.': Permission denied

# kerberos cache file created with root owner/group !
# The file has bytes in it, but not matching the size above. Wonder
# what's in it... ?
$ ls /tmp/krb5cc_* -al
-rw------- 1 root root 1046 Feb 23 13:00 /tmp/krb5cc_0
-rw------- 1 root root 1050 Feb 23 13:05 /tmp/krb5cc_1494_sM11PG

# now cannot kinit
$ kinit
Password for cwseys-8oz4Nevp0l1cSxESns1TRQ@public.gmane.org:
kinit: Failed to store credentials: Internal credentials cache error
(filename: /tmp/krb5cc_1494_sM11PG) while getting initial credentials

root:
# lets look in the credential cache that was created by root.
# looks like credentials used by root to mount /smb:
# My guess is the kernel was trying to stash the
# cifs/smb02.physics.wisc.edu-8oz4Nevp0l1cSxESns1TRQ@public.gmane.org
# kerberos ticket, but put it in krb5cc_1494_sM11PG instead
# of krb5cc_0
# klist -c /tmp/krb5cc_1494_sM11PG
Ticket cache: FILE:/tmp/krb5cc_1494_sM11PG
Default principal: smbadmin-8oz4Nevp0l1cSxESns1TRQ@public.gmane.org

Valid starting       Expires              Service principal
02/23/2017 13:05:59  03/05/2017 13:05:59
krbtgt/PHYSICS.WISC.EDU-8oz4Nevp0l1cSxESns1TRQ@public.gmane.org
02/23/2017 13:05:59  03/05/2017 13:05:59
cifs/smb02.physics.wisc.edu-8oz4Nevp0l1cSxESns1TRQ@public.gmane.org

# klist -c /tmp/krb5cc_0
Ticket cache: FILE:/tmp/krb5cc_0
Default principal: smbadmin-8oz4Nevp0l1cSxESns1TRQ@public.gmane.org

Valid starting       Expires              Service principal
02/23/2017 13:00:01  03/05/2017 13:00:01
krbtgt/PHYSICS.WISC.EDU-8oz4Nevp0l1cSxESns1TRQ@public.gmane.org
02/23/2017 13:00:01  03/05/2017 13:00:01
cifs/smb.physics.wisc.edu-8oz4Nevp0l1cSxESns1TRQ@public.gmane.org

[debug.log after trying to cd obs-cos]
vvvvvvvvvvvvvvvvvvvvvvvvvvvv
I think the error is here:  Notice pid=13207, that belongs
to cwseys but cifs.upcall key description is trying to use uid=0 and 
creduid=0 . The credential cache file is correct, but the uid/creduid 
are not.

cwseys   13207 /bin/bash

Also, in the above the log from 'cd /smb' cifs.upcall used  uid=1494 and 
creduid=1494 .
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Feb 23 13:05:59 trog cifs.upcall: key description:
cifs.spnego;0;0;39010000;ver=0x2;host=smb02.physics.wisc.edu;ip4=128.104.164.79;sec=krb5;uid=0x0;creduid=0x0;user=smbadmin-8oz4Nevp0l1cSxESns1TRQ@public.gmane.org;pid=0x3397
Feb 23 13:05:59 trog cifs.upcall: ver=2
Feb 23 13:05:59 trog cifs.upcall: host=smb02.physics.wisc.edu
Feb 23 13:05:59 trog cifs.upcall: ip=128.104.164.79
Feb 23 13:05:59 trog cifs.upcall: sec=1
Feb 23 13:05:59 trog cifs.upcall: uid=0
Feb 23 13:05:59 trog cifs.upcall: creduid=0
Feb 23 13:05:59 trog cifs.upcall: user=smbadmin-8oz4Nevp0l1cSxESns1TRQ@public.gmane.org
Feb 23 13:05:59 trog cifs.upcall: pid=13207
Feb 23 13:05:59 trog cifs.upcall: get_cachename_from_process_env:
pathname=/proc/13207/environ
Feb 23 13:05:59 trog cifs.upcall: get_cachename_from_process_env:
cachename = FILE:/tmp/krb5cc_1494_sM11PG
Feb 23 13:05:59 trog cifs.upcall: get_existing_cc: default ccache is
FILE:/tmp/krb5cc_1494_sM11PG
Feb 23 13:05:59 trog cifs.upcall: get_tgt_time: unable to get principal
Feb 23 13:05:59 trog cifs.upcall: handle_krb5_mech: getting service
ticket for smb02.physics.wisc.edu
Feb 23 13:05:59 trog cifs.upcall: handle_krb5_mech: obtained service ticket
Feb 23 13:05:59 trog cifs.upcall: Exit status 0
Feb 23 13:05:59 trog cifs.upcall: key description:
cifs.spnego;0;0;39010000;ver=0x2;host=smb02.physics.wisc.edu;ip4=128.104.164.79;sec=krb5;uid=0x5d6;creduid=0x5d6;pid=0x6725
Feb 23 13:05:59 trog cifs.upcall: ver=2
Feb 23 13:05:59 trog cifs.upcall: host=smb02.physics.wisc.edu
Feb 23 13:05:59 trog cifs.upcall: ip=128.104.164.79
Feb 23 13:05:59 trog cifs.upcall: sec=1
Feb 23 13:05:59 trog cifs.upcall: uid=1494
Feb 23 13:05:59 trog cifs.upcall: creduid=1494
Feb 23 13:05:59 trog cifs.upcall: pid=26405
Feb 23 13:05:59 trog cifs.upcall: get_cachename_from_process_env:
pathname=/proc/26405/environ
Feb 23 13:05:59 trog cifs.upcall: get_cachename_from_process_env:
cachename = FILE:/tmp/krb5cc_1494_bkfO2z
Feb 23 13:05:59 trog cifs.upcall: get_existing_cc: default ccache is
FILE:/tmp/krb5cc_1494_bkfO2z
Feb 23 13:05:59 trog cifs.upcall: get_tgt_time: unable to get principal
Feb 23 13:05:59 trog cifs.upcall: Exit status 1
Feb 23 13:06:03 trog cifs.upcall: key description:
cifs.spnego;0;0;39010000;ver=0x2;host=smb02.physics.wisc.edu;ip4=128.104.164.79;sec=krb5;uid=0x5d6;creduid=0x5d6;pid=0x6ba0
Feb 23 13:06:03 trog cifs.upcall: ver=2
Feb 23 13:06:03 trog cifs.upcall: host=smb02.physics.wisc.edu
Feb 23 13:06:03 trog cifs.upcall: ip=128.104.164.79
Feb 23 13:06:03 trog cifs.upcall: sec=1
Feb 23 13:06:03 trog cifs.upcall: uid=1494
Feb 23 13:06:03 trog cifs.upcall: creduid=1494
Feb 23 13:06:03 trog cifs.upcall: pid=27552
Feb 23 13:06:03 trog cifs.upcall: get_cachename_from_process_env:
pathname=/proc/27552/environ
Feb 23 13:06:03 trog cifs.upcall: get_cachename_from_process_env:
cachename = FILE:/tmp/krb5cc_1494_sM11PG
Feb 23 13:06:03 trog cifs.upcall: get_existing_cc: default ccache is
FILE:/tmp/krb5cc_1494_sM11PG
Feb 23 13:06:03 trog cifs.upcall: get_tgt_time: unable to get principal
Feb 23 13:06:03 trog cifs.upcall: Exit status 1

Thanks for your work!
Chad.
