From: "Parzer, Peter" <Peter.Parzer-A1rZ2h3LdSKdPOQpRHQ53DeJuz7u0hKX@public.gmane.org>
Subject: missing inotify CREATE event
Date: Mon, 10 Jun 2013 14:46:16 +0000
Message-ID: <CD0910ABB15D264A8E7AB76074385B0F6C838000@EXC11.ads.krz.uni-heidelberg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: de-DE
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

most of the time when I create a file the cifs mounted Samba shares, the CREATE inotify event is missing. The annoying consequence of this is that file managers like nautilus do refresh automatically and a manual refresh is necessary to see new files.

I have mounted two samba shares with cifs in my /etc/fstab:

//kjpsx/home   /home/KHD   cifs    sec=krb5,multiuser,noforceuid,noforcegid
//kjpsx/dat2   /dat        cifs    sec=krb5,multiuser,noforceuid,noforcegid

For example, creating two files on these shares with the commands

touch ~/tmp/test
touch /dat/admin/test

create the inotify events (output of "inotifywait -m ~/tmp /dat/admin/")

tmp/ CREATE test
tmp/ OPEN test
tmp/ ATTRIB test
tmp/ CLOSE_WRITE,CLOSE test
/dat/admin/ OPEN test
/dat/admin/ ATTRIB test
/dat/admin/ CLOSE_WRITE,CLOSE test

Both files were created on cifs file systems, but the second "touch" did not result in a CREATE event.

Has anybody an idea whats going on here?

I use cifs version 1.78, kernel 3.5.0-32 x86_64, Ubuntu 12.04

Peter--
To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
