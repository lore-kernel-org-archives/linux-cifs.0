From: "John P. Hartmann" <jphartmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: stat fails for directory in cifs that contains latin-1 accented character.
Date: Thu, 24 May 2012 11:30:35 +0200
Message-ID: <CANM685KZP6_=ymS0RA3Mwm1PiVTPb-WpmuvdVjmF0tehBf7+zQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Kernel is 2.6.34.9-69.fc13.i686.

The server is configured with charset en_US.iso88591.  Mount options
include iocharset=3Diso8859-1.

ls shows the directory correctly, but  ls -l fails:

ls: N=F8digt, Men Dog Gerne: No such file or directory
total 0
drwxr-xr-x 2 john staff 0 Jun 12  2011 N=F8digt, Men Dog Gerne

strace shows that lstat fails with ENOENT:

lstat64("N\370digt, Men Dog Gerne", 0x9ca6bb0) =3D -1 ENOENT (No such
file or directory)

The character is x'f8' as shown, which is the correct encoding of o-sla=
sh.

The same happens when I diropen() and then stat() the contents.

What is the real problem here?
