From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: SMB2.1 leases support for CIFS kernel client
Date: Tue, 9 Aug 2011 21:11:20 +0400
Message-ID: <CAKywueQXSfX9bEySehuG_C_ikVnn8AK1zxuoybFx8JL9JKezGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi all!

I implemented SMB2.1 leases support for cifs kernel module (in my
smb2-dev branch -
http://git.altlinux.org/people/piastry/public/?p=3Dcifs-2.6.git;a=3Dsho=
rtlog;h=3Drefs/heads/smb2-dev).
Now open and create work with leases support - it means that we can
have several simul=C1neous opens for the same file and use cache for
read and write operations (in the case when we use the same superblock
for these opens).

Whole list of changes since the last status update:
1) SMB2 oplocks support (open, breaks).
2) SMB2.1 leases support (open, breaks).
3) strictcache i/o support for SMB2.

and other minor bugfixes and cleanups.

Your comments are appreciated!

--=20
Best regards,
Pavel Shilovsky.
