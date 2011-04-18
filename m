From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: Add rwpidforward mount option (try #2)
Date: Mon, 18 Apr 2011 16:58:09 +0400
Message-ID: <BANLkTinFCrP=VzG6b6-WR-S6af6Jc91Tzg@mail.gmail.com>
References: <1303129252-7006-1-git-send-email-piastry@etersoft.ru>
	<20110418084414.295ef417@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110418084414.295ef417-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/4/18 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Mon, 18 Apr 2011 16:20:52 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> Add rwpidforward mount option that switches on a mode when we forwar=
d
>> pid of a process who opened a file to any read and write operation.
>>
>> This can prevent applications like WINE from failing on read or writ=
e
>> operation on a previously locked file region from the same netfd fro=
m
>> another process if we use mandatory brlock style.
>> It is actual for WINE because during a run of WINE program two proce=
sses
>> work on the same netfd - share the same file struct between several =
VFS
>> fds:
>> 1) WINE-server does open and lock;
>> 2) WINE-application does read and write.
>>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>> =A0fs/cifs/README =A0 =A0 =A0 | =A0 =A03 ++
>> =A0fs/cifs/cifs_fs_sb.h | =A0 =A01 +
>> =A0fs/cifs/cifsfs.c =A0 =A0 | =A0 =A08 ++++++
>> =A0fs/cifs/cifsproto.h =A0| =A0 21 ++++++++-------
>> =A0fs/cifs/cifssmb.c =A0 =A0| =A0 31 +++++++++++++++-------
>> =A0fs/cifs/connect.c =A0 =A0| =A0 =A05 +++
>> =A0fs/cifs/dir.c =A0 =A0 =A0 =A0| =A0 =A04 +-
>> =A0fs/cifs/file.c =A0 =A0 =A0 | =A0 69 +++++++++++++++++++++++++++++=
+++++++++-----------
>> =A0fs/cifs/inode.c =A0 =A0 =A0| =A0 10 ++++---
>> =A0fs/cifs/link.c =A0 =A0 =A0 | =A0 =A06 ++--
>> =A010 files changed, 113 insertions(+), 45 deletions(-)
>>
>> diff --git a/fs/cifs/README b/fs/cifs/README
>> index 4a3ca0e..33f4ba0 100644
>> --- a/fs/cifs/README
>> +++ b/fs/cifs/README
>> @@ -457,6 +457,9 @@ A partial list of the supported mount options fo=
llows:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 otherwise - read from the server. All wr=
itten data are stored
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 in the cache, but if the client doesn't =
have Exclusive Oplock,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 it writes the data to the server.
>> + =A0rwpidforward =A0Forward pid of a process who opened a file to a=
ny read or write
>> + =A0 =A0 =A0 =A0 =A0 =A0 operation on that file. This revent applic=
ation like WINE
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 ^^^^^^
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0"prevents applications"

Ok, thanks, will fix it.

>
>> + =A0 =A0 =A0 =A0 =A0 =A0 from failing on read and write if we use m=
andatory brlock style.
>> =A0 =A0acl =A0 =A0 =A0 =A0Allow setfacl and getfacl to manage posix =
ACLs if server
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 supports them. =A0(default)
>> =A0 =A0noacl =A0 =A0 =A0Do not allow setfacl and getfacl calls on th=
is mount
>
> [...]
>
>> @@ -1112,6 +1119,7 @@ static int cifs_writepages(struct address_spac=
e *mapping,
>> =A0 =A0 =A0 struct pagevec pvec;
>> =A0 =A0 =A0 int rc =3D 0;
>> =A0 =A0 =A0 int scanned =3D 0;
>> + =A0 =A0 __u32 netpid;
>> =A0 =A0 =A0 int xid;
>>
>> =A0 =A0 =A0 cifs_sb =3D CIFS_SB(mapping->host->i_sb);
>> @@ -1251,10 +1259,15 @@ retry_write:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1=
, "No writable handles for inode");
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -=
EBADF;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cifs_s=
b->mnt_cifs_flags &
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_MOUNT_RWPIDFORWARD)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 netpid =3D open_file->pid;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 netpid =3D current->tgid;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D C=
IFSSMBWrite2(xid, tcon, open_file->netfid,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0bytes_to_write, offset,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0&bytes_written, iov, n_iov,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A00);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0netpid, bytes_to_write,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0offset, &bytes_written,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0iov, n_iov, 0);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsFile=
Info_put(open_file);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^^^^^^^^
> When flushing data for writeback (writepage or writepages), I don't
> think we should care if a lock is held or by whom. The kernel has
> memory that needs to be freed and it wants to perform writes to make
> that happen.
>
> I don't think these codepaths ought to care about the RWPIDFORWARD fl=
ag
> at all. I think you ought to try to make sure that writes in those
> cases use whatever pid will allow the writes to succeed.

Ok, we have an oplock, set brlock and do write - it succeed (stored in
cache). Then we close a file, do flushing, and failes (because of
wrong pid). Why not to forward a pid in this situation?

--=20
Best regards,
Pavel Shilovsky.
