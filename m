From: Jeff Berman <spamact-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: CIFS VFS: Send error in Flush = -9
Date: Thu, 30 Jan 2014 11:38:37 -0800 (PST)
Message-ID: <1391110717.91906.YahooMailNeo@web140302.mail.bf1.yahoo.com>
References: <1382078007.96414.YahooMailNeo@web140303.mail.bf1.yahoo.com>
Reply-To: Jeff Berman <spamact-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1382078007.96414.YahooMailNeo-GNkJ2jOaCZIeBhY5O9xny5EhsgyP+Z75VpNB7YpNyf8@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi there,

I'm getting lots of CIFS errors in my system log:

Jan 30 08:46:05 Server1 kernel: [747319.264235] CIFS VFS: Send error in=
 Flush =3D -9
Jan 30 08:46:05 Server1 kernel: [747319.264235] CIFS VFS: Send error in=
 Flush =3D -9
Jan 30 08:46:05 Server1 kernel: [747319.264235] CIFS VFS: Send error in=
 Flush =3D -9

Usually 10-20 messages will appear at once like this.=A0 This had happe=
ned occasionally when I was on Ubuntu 12.04 LTS, but since upgrading to=
 Ubuntu 13.10 they are appearing daily (I actually upgraded to get a ne=
wer version of cifs-utils in the hopes that the problem would go away).

Modinfo cifs shows cifs.ko at version 2.01, and cifs-utils is at 6.0.

The share is mounted via fstab:
//server2/share /media/tm cifs credentials=3D/home/jeff/.smbcredentials=
,_netdev,uid=3Djeff,gid=3Djeff,file_mode=3D0777,dir_mode=3D0777,iochars=
et=3Dutf8,sec=3Dntlm 0 0


Any suggestions of how to work around this or how to provide more info?

Thanks!
