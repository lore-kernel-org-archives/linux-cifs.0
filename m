From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] CIFS: Add rwpidforward mount option (try #2)
Date: Mon, 18 Apr 2011 09:11:06 -0400
Message-ID: <20110418091106.386447c5@corrin.poochiereds.net>
References: <1303129252-7006-1-git-send-email-piastry@etersoft.ru>
	<20110418084414.295ef417@tlielax.poochiereds.net>
	<BANLkTinFCrP=VzG6b6-WR-S6af6Jc91Tzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTinFCrP=VzG6b6-WR-S6af6Jc91Tzg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 18 Apr 2011 16:58:09 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> 2011/4/18 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> > On Mon, 18 Apr 2011 16:20:52 +0400
> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> >
> >> Add rwpidforward mount option that switches on a mode when we forw=
ard
> >> pid of a process who opened a file to any read and write operation=
=2E
> >>
> >> This can prevent applications like WINE from failing on read or wr=
ite
> >> operation on a previously locked file region from the same netfd f=
rom
> >> another process if we use mandatory brlock style.
> >> It is actual for WINE because during a run of WINE program two pro=
cesses
> >> work on the same netfd - share the same file struct between severa=
l VFS
> >> fds:
> >> 1) WINE-server does open and lock;
> >> 2) WINE-application does read and write.
> >>
> >> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> >> ---
> >> =C2=A0fs/cifs/README =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=A03 ++
> >> =C2=A0fs/cifs/cifs_fs_sb.h | =C2=A0 =C2=A01 +
> >> =C2=A0fs/cifs/cifsfs.c =C2=A0 =C2=A0 | =C2=A0 =C2=A08 ++++++
> >> =C2=A0fs/cifs/cifsproto.h =C2=A0| =C2=A0 21 ++++++++-------
> >> =C2=A0fs/cifs/cifssmb.c =C2=A0 =C2=A0| =C2=A0 31 +++++++++++++++--=
-----
> >> =C2=A0fs/cifs/connect.c =C2=A0 =C2=A0| =C2=A0 =C2=A05 +++
> >> =C2=A0fs/cifs/dir.c =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0 =C2=A04 +-
> >> =C2=A0fs/cifs/file.c =C2=A0 =C2=A0 =C2=A0 | =C2=A0 69 ++++++++++++=
++++++++++++++++++++++++++-----------
> >> =C2=A0fs/cifs/inode.c =C2=A0 =C2=A0 =C2=A0| =C2=A0 10 ++++---
> >> =C2=A0fs/cifs/link.c =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=A06 ++--
> >> =C2=A010 files changed, 113 insertions(+), 45 deletions(-)
> >>
> >> diff --git a/fs/cifs/README b/fs/cifs/README
> >> index 4a3ca0e..33f4ba0 100644
> >> --- a/fs/cifs/README
> >> +++ b/fs/cifs/README
> >> @@ -457,6 +457,9 @@ A partial list of the supported mount options =
follows:
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 otherwise - read =
from the server. All written data are stored
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 in the cache, but=
 if the client doesn't have Exclusive Oplock,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 it writes the dat=
a to the server.
> >> + =C2=A0rwpidforward =C2=A0Forward pid of a process who opened a f=
ile to any read or write
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 operation on that file=
=2E This revent application like WINE
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 ^^^^^^
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0"prevents applications"
>=20
> Ok, thanks, will fix it.
>=20
> >
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 from failing on read a=
nd write if we use mandatory brlock style.
> >> =C2=A0 =C2=A0acl =C2=A0 =C2=A0 =C2=A0 =C2=A0Allow setfacl and getf=
acl to manage posix ACLs if server
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 supports them. =C2=
=A0(default)
> >> =C2=A0 =C2=A0noacl =C2=A0 =C2=A0 =C2=A0Do not allow setfacl and ge=
tfacl calls on this mount
> >
> > [...]
> >
> >> @@ -1112,6 +1119,7 @@ static int cifs_writepages(struct address_sp=
ace *mapping,
> >> =C2=A0 =C2=A0 =C2=A0 struct pagevec pvec;
> >> =C2=A0 =C2=A0 =C2=A0 int rc =3D 0;
> >> =C2=A0 =C2=A0 =C2=A0 int scanned =3D 0;
> >> + =C2=A0 =C2=A0 __u32 netpid;
> >> =C2=A0 =C2=A0 =C2=A0 int xid;
> >>
> >> =C2=A0 =C2=A0 =C2=A0 cifs_sb =3D CIFS_SB(mapping->host->i_sb);
> >> @@ -1251,10 +1259,15 @@ retry_write:
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cERROR(1, "No writable handles f=
or inode");
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D -EBADF;
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 } else {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (cifs_sb->mnt_cifs_flags &
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CIFS_MOUNT_RWPIDFORWARD)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 netpid =3D =
open_file->pid;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 netpid =3D =
current->tgid;
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D CIFSSMBWrite2(xid, tcon, =
open_file->netfid,
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0bytes_to_write, offset,
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0&bytes_written, iov, n_iov,
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A00);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0netpid, bytes_to_write,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0offset, &bytes_written,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0iov, n_iov, 0);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifsFileInfo_put(open_file);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 }
> >>
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0^^^^^^^^^^^^=
^^^
> > When flushing data for writeback (writepage or writepages), I don't
> > think we should care if a lock is held or by whom. The kernel has
> > memory that needs to be freed and it wants to perform writes to mak=
e
> > that happen.
> >
> > I don't think these codepaths ought to care about the RWPIDFORWARD =
flag
> > at all. I think you ought to try to make sure that writes in those
> > cases use whatever pid will allow the writes to succeed.
>=20
> Ok, we have an oplock, set brlock and do write - it succeed (stored i=
n
> cache). Then we close a file, do flushing, and failes (because of
> wrong pid). Why not to forward a pid in this situation?
>=20

I think we should do whatever is necessary for that write to succeed.
If that means forwarding the pid then that's fine. I just don't see why
the RWPIDFORWARD flag should matter at all in that case.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
