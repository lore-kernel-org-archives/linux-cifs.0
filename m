From: Nicolas Chauvet <kwizart-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Usage of multiuser with two shares from the same server
Date: Fri, 27 Oct 2017 16:05:58 +0200
Message-ID: <CABr+WTmoC+gEZvC+WvZgJLSYyBHe7dzHf4dnEKUf-Z1vuAWEbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

I've experienced an issue using the "multiuser" cifs mount option in a
context of two shares from the same server in a kerberos environment
and autofs. I'd like to have some advices about this setup and
eventually update the man mount.cifs.8 as appropriate.

Basically I'm experiencing a conflict when I have two shares. One is
configured for a home share, and the other as a shared folder. Both
uses cifs and kerberos authentication using the same samba server.
It seems that if both shares are located on the same samba server, I
can automount the first share (home directory) but I cannot mount the
second one (shared directory). I have the following error (1)

As you can see, the first uid is set as appropriate, but the second
one uses uid=0. As a consequence, the credential cache isn't found.
This seems to only occurs if the remote samba server is the same, not
if there are two different server for each share.

The current workaround is to use the username=autofs-client mount
option to the shares mount point (where autofs-client is the machine
account with a dedicated keytab).
I've reproduced the issue with lastest cifs-utils and various distros
for the cifs client (debian8+, fedora 26, centos7).

Is that worth an update for the man page or some documentation to say
that using multiuser might have issue when using the two shares from
the same server ? Or is there anything wrong with this setup ?

Thx for your advices.

Some more infos:
auto.home:
*   -fstype=cifs,sec=krb5,username=&,uid=&,cruid=&,file_mode=0600,dir_mode=0700,nounix,noserverino
://samba-nas01/homes/&

auto.shares:
/shares  -fstype=cifs,sec=krb5,multiuser,cruid=$UID  ://samba-nas01/shares



(1)
---
Working homes:
cifs.upcall: key description:
cifs.spnego;0;0;39010000;ver=0x2;host=samba-nas01;ip4=XX.XX.XXX.XX;sec=mskrb5;uid=0x9cb6;creduid=0x9cb6;user=samba-user;pid=0x2f3a
cifs.upcall: ver=2
cifs.upcall: host=samba-nas01
cifs.upcall: ip=XX.XX.XXX.XXX
cifs.upcall: sec=2
cifs.upcall: uid=40118
cifs.upcall: creduid=40118
cifs.upcall: user=samba-user
cifs.upcall: pid=12090
cifs.upcall: find_krb5_cc: scandir error on directory
'/run/user/40118': No such file or directory
cifs.upcall: find_krb5_cc: considering /tmp/krb5cc_40118
cifs.upcall: find_krb5_cc: FILE:/tmp/krb5cc_40118 is valid ccache
cifs.upcall: handle_krb5_mech: getting service ticket for samba-nas01
cifs.upcall: handle_krb5_mech: obtained service ticket
cifs.upcall: Exit status 0

Not working /shares :
cifs.upcall: key description:
cifs.spnego;0;0;39010000;ver=0x2;host=samba-nas01;ip4=XX.XX.XXX.XX;sec=mskrb5;uid=0x0;creduid=0x0;pid=0x2f4f
cifs.upcall: ver=2
cifs.upcall: host=samba-nas01
cifs.upcall: ip=XX.XX.XXX.XXX
cifs.upcall: sec=2
cifs.upcall: uid=0
cifs.upcall: creduid=0
ifs.upcall: pid=12111
cifs.upcall: find_krb5_cc: scandir error on directory '/run/user/0':
No such file or directory
cifs.upcall: find_krb5_cc: considering /tmp/krb5cc_40118
cifs.upcall: find_krb5_cc: /tmp/krb5cc_40118 is owned by 40118, not 0
cifs.upcall: handle_krb5_mech: getting service ticket for samba-nas01
cifs.upcall: cifs_krb5_get_req: unable to get client principal name
cifs.upcall: handle_krb5_mech: failed to obtain service ticket (-1765328189)
cifs.upcall: handle_krb5_mech: getting service ticket for
samba-nas01.example.com
cifs.upcall: cifs_krb5_get_req: unable to get client principal name
cifs.upcall: handle_krb5_mech: failed to obtain service ticket (-1765328189)
cifs.upcall: Unable to obtain service ticket
cifs.upcall: Exit status -1765328189
---


-- 
-

Nicolas (kwizart)
