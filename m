From: adcromitus <adcromitus-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Accented characters not working with CIFS (but ok with smbclient)
Date: Sat, 20 Sep 2014 23:44:57 +0100
Message-ID: <541E0369.8070205@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hy,

I'm not sure of what can be relevant so I'll tell the whole story.

I have a router (that I got from my ISP) which allows the connection of=
=20
a pen/HDD by USB. That pen is shared on the network as a Windows Share=20
folder.

In Windows 7 I can see all the files name correctly, but when I mount=20
the drive in Linux, with the command:

mount -t cifs //<local share ip-address>/<shared-folder> --verbose -o=20
user=3Duser,pass=3D"",uid=3D1000,gid=3D1000

(there is no password)

All file names with special characters (like =C3=87=C3=A3=C3=B5=C3=A9..=
=2E) have a question=20
mark in place of the accented character and I can't open the file or=20
folder, as any command responds the file doesn't exist. This happens in=
=20
dolphin, thunar and in the command line with simple commands like cat.

I tried adding the following option without success

iocharset=3Dutf-8
iocharset=3Dutf-8,codepage=3Dcp437
iocharset=3Dutf-8,codepage=3Dcp850
iocharset=3Diso8859-1

This also happens if I access the share from my android device, so I wa=
s=20
convinced it was a problem related to old firmware (from the router).

However, recently I connected to the drive using smbclient and the file=
=20
names appeared correctly. I would like to mount this share folder at=20
fstab, and so smbclient is not a good solution.

I'm using:
Linux kernel 3.2.0-4-amd64
(Debian Wheezy)
mount.cifs version: 5.5

And I get this information from smbclient -L <local share ip address>:
(smbclient version 4.1.11-Debian)
Server=3D[Samba 2.2.12]

So. Is there something else I can try?

Thanks in advance.
