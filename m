From: "Mark Christiansen" <mchristi-lfcS8c3Mqgg@public.gmane.org>
Subject: help - can't stat() cifs file system
Date: Fri, 2 Mar 2012 14:29:44 -0800
Message-ID: <026601ccf8c3$faea9310$f0bfb930$@uw.edu>
Reply-To: <mchristi-lfcS8c3Mqgg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-us
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

To whom it may concern,

I am using linux kernel 2.6.32-220.4.1.el6.x86_64 (RHEL6) and cifs vers=
ion
4.8.1.=A0 Using a mount point (/mnt/tmp), we are able to read/write to =
our
Windows directories.=A0 Occasionally, a user will kill a job that is wr=
iting
to these directories.=A0 When this happens, it corrupts the mount point
somehow and we get a permission denied error when we do an =93ls=94.=A0=
=20

If I do an =93lsof=94 and grep for the path, I get a =A0message:

=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 WARNING: can=92t stat() c=
ifs file system /mnt/tmp

It seems that if I am able to successfully unmount all of these mount
points, that I can do a =93mount =96a=94 and recover.=A0=20

However, how can I avoid this problem in the first place (besides havin=
g the
user not kill jobs)?=A0 It seems like this is something a user should b=
e able
to do without bringing down the mount points.

Thank you in advance,

Mark=20
