From: =?iso-8859-1?Q?Rolf_G=2E_=D8kland?= <Rolf-xckQ04E5ShYXWF+eFR7m5Q@public.gmane.org>
Subject: VS: DM800 Linux client use CIFS/SMB to connect to Windows 2008 R2
 Share
Date: Sun, 29 Aug 2010 20:52:14 +0000
Message-ID: <B1837CC6F2D935468F8A9E98BA0E8BCC0109D5D0@MAILMAN.pconline.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: nb-NO
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi

I got an annoying problem, when I'm trying to mount my Dreambox DM800 (=
Linux client) to a windows server 2008 R2 share I get access denied for=
 some reason.
This have been working like a charm on my old Windows 2003 Server, but =
not a chance in h. to my new 2008R2 server.
I'm using this script on my DM800:=A0 "mount -t cifs //192.168.0.5/xdb.=
tv-serier -o udp,rw,nolock,wsize=3D8192,rsize=3D8192,user=3Dmyuser,pass=
=3Dmypass /media/net/tv/"

I also got a QNAP NMP-1000 that does mount to the same share on the win=
dows 2008R2 without any issues what so ever.

I'm at a dead end now, so I'm hoping someone here have some input I may=
 try

Thanx=A0 :-)=20



mvh / Best regards
Rolf G. Okland
E-mail rolf-xckQ04E5ShYXWF+eFR7m5Q@public.gmane.org=20
