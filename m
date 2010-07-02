From: James Green <james.mk.green-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Severe performance issue (Ubuntu 10.04 mounting an XP share)
Date: Fri, 2 Jul 2010 16:39:06 +0100
Message-ID: <AANLkTilXnPMMoY-54RbO4CUeqP9b-zaM7NZQZQpHH5Gk@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

I'm currently seeing a serious performance problem with a cifs-mounted
WinXP share, and I've not found any reference to it yet.

Basically my hardware is a desktop with Windows XP. VMWare server is
installed and I have Ubuntu 10.04 as an image. The ubuntu VM
cifs-mounts this XP share that's called 'ControlPanel'.

This has been running just fine until yesterday morning then I was
prompted to install an updated kernel and reboot.

Since then, I can mount the share, I can look in the files and do
everything normally, except run phpunit which now runs dog-slow.

Previously, I would expect 15-30s for total phpunit execution. Now,
it's between 2m30s and 5m30s. I traced the code through and found it
to be trying to load the files up.

syslog shows every fifteen seconds:

Jul  2 16:09:13 ubuntu kernel: [ 1033.820126] CIFS VFS: No response
for cmd 50 mid 6469
Jul  2 16:09:27 ubuntu kernel: [ 1048.779718] CIFS VFS: No response
for cmd 50 mid 6593
Jul  2 16:09:42 ubuntu kernel: [ 1063.816102] CIFS VFS: No response
for cmd 50 mid 6722
Jul  2 16:09:57 ubuntu kernel: [ 1078.787182] CIFS VFS: No response
for cmd 50 mid 6855
Jul  2 16:10:12 ubuntu kernel: [ 1093.820243] CIFS VFS: No response
for cmd 50 mid 6991
Jul  2 16:10:27 ubuntu kernel: [ 1108.793428] CIFS VFS: No response
for cmd 50 mid 7120
Jul  2 16:10:43 ubuntu kernel: [ 1123.828834] CIFS VFS: No response
for cmd 50 mid 7260
Jul  2 16:10:57 ubuntu kernel: [ 1138.798723] CIFS VFS: No response
for cmd 50 mid 7395
Jul  2 16:11:13 ubuntu kernel: [ 1153.836951] CIFS VFS: No response
for cmd 50 mid 7544
Jul  2 16:11:27 ubuntu kernel: [ 1168.803846] CIFS VFS: No response
for cmd 50 mid 7677
Jul  2 16:11:43 ubuntu kernel: [ 1183.844863] CIFS VFS: No response
for cmd 50 mid 7829
Jul  2 16:11:57 ubuntu kernel: [ 1198.808690] CIFS VFS: No response
for cmd 50 mid 7955
Jul  2 16:12:13 ubuntu kernel: [ 1213.840801] CIFS VFS: No response
for cmd 50 mid 8073
Jul  2 16:12:27 ubuntu kernel: [ 1228.813492] CIFS VFS: No response
for cmd 50 mid 8219
Jul  2 16:12:43 ubuntu kernel: [ 1243.844349] CIFS VFS: No response
for cmd 50 mid 8338
Jul  2 16:12:57 ubuntu kernel: [ 1258.817835] CIFS VFS: No response
for cmd 50 mid 8425
Jul  2 16:13:13 ubuntu kernel: [ 1273.852591] CIFS VFS: No response
for cmd 50 mid 8557
Jul  2 16:13:27 ubuntu kernel: [ 1288.822119] CIFS VFS: No response
for cmd 50 mid 8687
Jul  2 16:14:26 ubuntu kernel: [ 1347.512906] CIFS VFS: No response
for cmd 50 mid 10970
Jul  2 16:14:43 ubuntu kernel: [ 1363.848978] CIFS VFS: No response
for cmd 50 mid 11040
Jul  2 16:14:58 ubuntu kernel: [ 1378.833956] CIFS VFS: No response
for cmd 50 mid 11112

You get the idea...

I downgraded to the previously installed kernel without any
improvement. I upgraded to
http://kernel.ubuntu.com/~kernel-ppa/mainline/daily/current/linux-image-2.6.35-999-generic_2.6.35-999.201007021009_i386.deb
again without any improvement.

Using wireshark I noticed lots of QUERY_PATH_INFO requests but I have
no idea what is normal.

When connecting a remote 9.10 machine to my share, I again see the
QUERY_PATH_INFO but the performance is as expected - much improved.

I've raised a ticket with Ubuntu which I've been making notes in:
https://bugs.launchpad.net/ubuntu/+source/samba/+bug/600565

Can anyone help or give me further instructions for debugging this?
I'm working at a snails pace otherwise :(

FYI my smbfs version is 2:3.4.7~dfsg-1ubuntu3.

Thanks,

James
