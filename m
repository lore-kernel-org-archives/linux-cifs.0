From: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Zero size and zero blocks mountpoint.
Date: Sun, 19 Sep 2010 21:28:41 +0200
Message-ID: <AANLkTi=GPOoF5bOdySz2izWTEEBShZ8LG=SWPKZVHCU8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello,

whe mounting a smb filesystem using cifs, the mountpoint gets zero
size and zero blocks:


ls -al
total 12
drwxr-xr-x =C2=A0 2 root root =C2=A0 =C2=A0 4096 2010-09-19 16:53 .
drwxr-xr-x =C2=A0 3 root root =C2=A0 =C2=A0 4096 2010-09-19 16:53 ..
drwxr-xr-x =C2=A0 6 root root =C2=A0 =C2=A0 =C2=A0 =C2=A00 2010-09-03 2=
3:41 bononline
-rw-r--r-- =C2=A0 1 root root =C2=A0 =C2=A0 =C2=A0 40 2010-09-19 16:53 =
=2Edirectory
drwxr-xr-x 673 gast netgroup =C2=A0 =C2=A00 2010-09-12 23:40 ftp
drwxrwxr-x =C2=A010 gast netgroup =C2=A0 =C2=A00 2010-08-06 23:28 publi=
c
drwxr-xr-x =C2=A034 sbon netgroup =C2=A0 =C2=A00 2010-09-19 16:03 sbon
drwxr-xr-x =C2=A010 root root =C2=A0 =C2=A0 =C2=A0 =C2=A00 2010-08-06 2=
3:26 video

The directories bononline, ftp, public, sbon adn video are all
mountpoints of smb shares.

It's causing some unwanted behaviour.
How can I change that, or is this not changeable?
Stef
