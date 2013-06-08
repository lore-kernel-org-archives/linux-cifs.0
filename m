From: =?ISO-8859-1?Q?Peter_Valdemar_M=F8rch?= <peter-Fsal10Ed6HEAvxtiuMwx3w@public.gmane.org>
Subject: How to automatically umount a "broken" CIFS mount?
Date: Sat, 8 Jun 2013 13:39:33 +0200
Message-ID: <CANh5envke45j_91cZHNDjL=r7pn489_NJ-454euD6O1bRbfjAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

Is there some way to detect if the mount no longer "works"? There
could be many reasons for this: network error, Windows server has been
shut down, etc.

I can of course periodically do this:

> time ls -l /mnt/cifs/
ls: cannot access /mnt/cifs/: Host is down

real    0m10.000s
user    0m0.000s
sys    0m0.000s

And use that error to umount, which is what I'll do if I don't have
any other options.

But I'm hoping for some timeout / auto-umount mechanism or some way to
query if the mount is still "good", that doesn't take 10 seconds pr.
mountpoint...

Peter
--
Peter Valdemar M=F8rch
http://www.morch.com
