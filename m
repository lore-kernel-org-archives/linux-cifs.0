From: <a.sluik-HVpl4/oQiP/z+pZb47iToQ@public.gmane.org>
Subject: FW: kernel:  CIFS VFS: Filldir for current dir failed
Date: Tue, 1 Mar 2011 16:25:26 +0100
Message-ID: <4DF45E2A2AD923468B6688F16447BDE90508DB91@EX04.service.utwente.nl>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01CBD824.E41C70A6"
To: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-class: urn:content-classes:message
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is a multi-part message in MIME format.

------_=_NextPart_001_01CBD824.E41C70A6
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable



-----Original Message-----
From: linux-cifs-client-bounces-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
[mailto:linux-cifs-client-bounces-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org] On Behalf Of
linux-cifs-client-owner-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
Sent: Tuesday, March 01, 2011 4:15 PM
To: Sluik, A. (Arjan, ICTS)
Subject: kernel: CIFS VFS: Filldir for current dir failed

This list is now deprecated. Please post to linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
instead:

http://vger.kernel.org/vger-lists.html#linux-cifs


------_=_NextPart_001_01CBD824.E41C70A6
Content-Type: message/rfc822
Content-Transfer-Encoding: 7bit

X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Subject: kernel:  CIFS VFS: Filldir for current dir failed
Date: Tue, 1 Mar 2011 15:59:31 +0100
Message-ID: <4DF45E2A2AD923468B6688F16447BDE90508DB3A-S4MjG6e2EGO+mPTwocfnKj0g50+Wg8sO@public.gmane.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: kernel:  CIFS VFS: Filldir for current dir failed
Thread-Index: AcvYIUT6YWeQNmW5Rquo69PdA45cmw==
From: <a.sluik-HVpl4/oQiP/z+pZb47iToQ@public.gmane.org>
To: <linux-cifs-client-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>

Dear members,

=20

We did find an issue in mount.cifs on Linux.=20

=20

With modinfo cifs : version 1.60 it runs ok, but with version 1.61 we =
get the message:

=20

kernel:  CIFS VFS: Filldir for current dir failed

=20

some strace of the program:

=20

pid 18120] close(5)                    =3D 0

[pid 18120] munmap(0xf7766000, 4096)    =3D 0

[pid 18120] =
open("../stage/Components/oracle.jdk/1.5.0.11.0/1/DataFiles/", =
O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) =3D 5

[pid 18120] fcntl64(5, F_SETFD, FD_CLOEXEC) =3D 0

[pid 18120] getdents(5, 0x80975c4, 32768) =3D -1 ENOMEM (Cannot allocate =
memory)

[pid 18120] close(5)                    =3D 0

[pid 18120] =
stat64("../stage/Components/oracle.jdk/1.5.0.11.0/1/DataFiles/*.jar", =
0xff8a2eec) =3D -1 ENOENT (No such file or directory)

[pid 18120] =
stat64("../stage/Components/oracle.jdk/1.5.0.11.0/1/DataFiles/*.jar.zip",=
 0xff8a2eec) =3D -1 ENOENT (No such file or directory)

[pid 18120] =
stat64("../stage/Components/oracle.jdk/1.5.0.11.0/1/DataFiles/*.jar.ZIP",=
 0xff8a2eec) =3D -1 ENOENT (No such file or directory)

[pid 18120] exit_group(9)               =3D ?

Process 18111 resumed

=20

This was the result of an Oracle Client installation from a CIFS =
filesystem.

If the files are locally copied then there is no issue.

If the mount.cifs is version 1.60 there is no issue either.

Seems to be an Filldir type of error.

=20

=20

Arjan Sluik

ICT-Servicecentrum

Universiteit Twente, Postbus 217, 7500 AE Enschede

Telefoon 053 489 4730

 <mailto:a.sluik-HVpl4/oQiP/z+pZb47iToQ@public.gmane.org> a.sluik-HVpl4/oQiP/z+pZb47iToQ@public.gmane.org,  =
<http://www.utwente.nl/icts> http://www.utwente.nl/icts

=20


------_=_NextPart_001_01CBD824.E41C70A6--
