From: "Hamid Majidy" <hamid-1WA2RWJAdEzQnzwC+xcbyw@public.gmane.org>
Subject: CIFS Mount Error -5
Date: Sun, 30 Mar 2014 14:10:44 -0700
Message-ID: <02a101cf4c5c$83e79c10$8bb6d430$@pcsourcenet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
References: 
In-Reply-To: 
Content-Language: en-us
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello list. I am getting on my CentOS 5 & 6 servers=92 /var/log/message=
s like:
Mar 24 20:54:47 server kernel:=A0 CIFS VFS: cifs_mount failed w/return =
code =3D
-5

When I try to mount a Windows 2008 R2 share with:
mount.cifs //server_name/share /win/case -o
username=3D'user_name',password=3D'user_password'

whereas when I do the exact same mount with IP it is successful.
mount.cifs //server_IP/share /win/case -o
username=3D'user_name',password=3D'user_password'

I have checked DNS which does resolve the name correctly, added the ent=
ry to
/etc/hosts (so resolver does not have to contact DNS), checked
/etc/resolv.conf, added =91strace=92 before command, added =91-av=92 as=
 argument all
to no avail. I am just give on using the server name.

This happening on CentOS 5.5, 5.6 & 6.5 with different versions of Samb=
a and
CIFS (on CentOS 6.5).

Anyone have any ideas?

Thanks,
Hamid.
