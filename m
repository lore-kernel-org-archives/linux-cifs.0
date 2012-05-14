From: VALETTE Eric RD-MAPS-REN <eric2.valette-C0LM0jrOve7QT0dZR+AlfA@public.gmane.org>
Subject: Linux 3.2.17 and netapp 8.1
Date: Mon, 14 May 2012 14:43:06 +0200
Message-ID: <4FB0FDDA.5080604@orange.com>
Reply-To: eric2.valette-C0LM0jrOve7QT0dZR+AlfA@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

Middle of next week, a netapp filer was replaced by a new netapp FAS=20
3270 with 8.1 firmware. While previously I had no problem accessing, al=
l=20
the share, now, my log is full of CIFS errors preventing me to access m=
y=20
own content:

Mount options:

domain=3DZZZZ,credentials=3D/xxxx/xxxx/.sambaShareId,uid=3Dyyyyy,gid=3D=
zzz,iocharset=3Dutf8,noserverino=20
0 0

Is there any known problem with this netapp firmware?

Note that I have other shares on different using different netapp=20
machine with older firmware that work like a charm.

-- eric


        _______________________________________________________________=
_
[  315.788485] CIFS VFS: RFC1001 size 248 smaller than SMB for mid=3D34
[  315.788493] Bad SMB: : dump of 48 bytes of data at 0xffff880123045c0=
0
[  315.788501]  f8000000 424d53ff 00000032 80018800 . . . \xfffffff8=20
\xffffffff S M B 2 . . . . . . .
[  315.788508]  00000000 00000000 00000000 19db0040 . . . . . . . . . .=
=20
=2E . @ . \xffffffdb .
[  315.788518]  00220800 c400020a 02000000 00003800 . . " . . . .=20
\xffffffc4 . . . . . 8 . .
[  315.791476] CIFS VFS: RFC1001 size 248 smaller than SMB for mid=3D35
[  315.791481] Bad SMB: : dump of 48 bytes of data at 0xffff880123045dc=
0
[  315.791489]  f8000000 424d53ff 00000032 80018800 . . . \xfffffff8=20
\xffffffff S M B 2 . . . . . . .
[  315.791495]  00000000 00000000 00000000 19db0040 . . . . . . . . . .=
=20
=2E . @ . \xffffffdb .
[  315.791502]  00230800 c400020a 02000000 00003800 . . # . . . .=20
\xffffffc4 . . . . . 8 . .
[  315.791577] CIFS VFS: Unexpected lookup error -5
[  315.794489] CIFS VFS: RFC1001 size 248 smaller than SMB for mid=3D36
[  315.794495] Bad SMB: : dump of 48 bytes of data at 0xffff880126a8fb8=
0
[  315.794503]  f8000000 424d53ff 00000032 80018800 . . . \xfffffff8=20
\xffffffff S M B 2 . . . . . . .
[  315.794510]  00000000 00000000 00000000 19db0040 . . . . . . . . . .=
=20
=2E . @ . \xffffffdb .
[  315.794516]  00240800 c400020a 02000000 00003800 . . $ . . . .=20
\xffffffc4 . . . . . 8 . .
[  315.794542] CIFS VFS: Unexpected lookup error -5
[  315.797494] CIFS VFS: RFC1001 size 248 smaller than SMB for mid=3D37
[  315.797500] Bad SMB: : dump of 48 bytes of data at 0xffff8801115c588=
0
[  315.797507]  f8000000 424d53ff 00000032 80018800 . . . \xfffffff8=20
\xffffffff S M B 2 . . . . . . .
[  315.797514]  00000000 00000000 00000000 19db0040 . . . . . . . . . .=
=20
=2E . @ . \xffffffdb .
[  315.797521]  00250800 c400020a 02000000 00003800 . . % . . . .=20
\xffffffc4 . . . . . 8 . .
[  315.797542] CIFS VFS: Unexpected lookup error -5

--=20
Eric Valette
=46rance Telecom
Recherche&  Developpement
Middleware et Plateformes Avanc=C3=A9es
Architecte Livebox et Set Top Box
t=C3=A9l : (+33) 2 99 12 45 71
m=C3=A9l :<mailto:Eric2.Valette-C0LM0jrOve7QT0dZR+AlfA@public.gmane.org>
