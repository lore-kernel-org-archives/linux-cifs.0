From: Jeff Berman <spamact-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: CIFS VFS: Send error in Flush = -9
Date: Thu, 17 Oct 2013 23:33:27 -0700 (PDT)
Message-ID: <1382078007.96414.YahooMailNeo@web140303.mail.bf1.yahoo.com>
Reply-To: Jeff Berman <spamact-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi there,

I'm seeing CIFS errors in my system log:

Oct 17 21:48:21 Server1 kernel: [201068.584384] CIFS VFS: Send error in=
 Flush =3D -9
Oct 17 21:48:22 Server1 kernel: [201070.351555] CIFS VFS: Send error in=
 Flush =3D -9
Oct 17 21:48:22 Server1 kernel: [201070.352653] CIFS VFS: Send error in=
 Flush =3D -9

There's a block of 17 of those, all taking place within a few seconds. =
=A0This has happened a few times in the past several days. =A0The clien=
t machine is Ubuntu 12.04 LTS, the cifs-utils version is 2:5.1-1ubuntu2=
, and the cifs.ko version is 1.78. =A0The server is Windows Home Server=
 2011; both of these systems are virtualized in the same physical box. =
=A0The Windows event log doesn't show anything happening during this ti=
me period.

I see that this was mentioned back in February (http://article.gmane.or=
g/gmane.linux.kernel.cifs/7844). =A0Did anything ever come of this? =A0=
Is it perhaps fixed in a more recent version? =A0This is particularly b=
ad for me, because this SMB share is used to store backups, and when th=
e CIFS VFS error occurs it corrupts the backup archive.

My Linux skills aren't very strong, but I'm happy to do what I can to p=
rovide more or better info.

Thanks!
