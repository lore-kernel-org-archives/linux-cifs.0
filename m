From: Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Subject: Re: [PATCHv2] Add reflink copy over SMB3.11 with new FSCTL_DUPLICATE_EXTENTS
Date: Mon, 29 Jun 2015 14:41:26 -0500
Message-ID: <CALSSpE4PoRvHctE9dBP6XpcapcNyVRX=Hz+VXiO2a3JGjcNsew@mail.gmail.com>
References: <1435544465-14133-1-git-send-email-steve.french@primarydata.com>
	<20150629172704.GA10038@birch.djwong.org>
	<CALSSpE5nuE_45PMCKsNBqrg_r9z=+cdCEkBvV1bx=gmiWnRSzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALSSpE5nuE_45PMCKsNBqrg_r9z=+cdCEkBvV1bx=gmiWnRSzw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Jun 29, 2015 at 2:33 PM, Steve French
<steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org> wrote:
> On Mon, Jun 29, 2015 at 12:27 PM, Darrick J. Wong
> <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>>
>> On Sun, Jun 28, 2015 at 09:21:05PM -0500, Steve French wrote:
>> >  Update the patch to correct target file size.
>> >
>> >  Getting fantastic copy performance with cp --reflink over SMB3.11
>> >  using the new FSCTL_DUPLICATE_EXTENTS.
>> >
>> >  This FSCTL was added in the SMB3.11 dialect (testing was
>> >  against REFS file system) so have put it as a 3.11 protocol
>> >  specific operation ("vers=3.1.1" on the mount).  Tested at
>> >  the SMB3 plugfest in Redmond.
>> >
>> >  It depends on the new FS Attribute (BLOCK_REFCOUNTING) which
>> >  is used to advertise support for the ability to do this ioctl
>> >  (if you can support multiple files pointing to the same block
>> >  than this refcounting ability or equivalent is needed to
>> >  support the new reflink-like duplicate extent SMB3 ioctl.
>> >
>> > Signed-off-by: Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
>> > ---
>> >  fs/cifs/cifsglob.h |  3 +++
>> >  fs/cifs/cifspdu.h  |  2 ++
>> >  fs/cifs/ioctl.c    | 16 +++++++++++++---
>> >  fs/cifs/smb2ops.c  | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
>> >  fs/cifs/smb2pdu.h  |  8 ++++++++
>> >  fs/cifs/smbfsctl.h |  1 +
>> >  6 files changed, 75 insertions(+), 3 deletions(-)
>> >
>> > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> > index a0212ec..81194e6 100644
>> > --- a/fs/cifs/cifsglob.h
>> > +++ b/fs/cifs/cifsglob.h
>> > @@ -390,6 +390,9 @@ struct smb_version_operations {
>> >       int (*clone_range)(const unsigned int, struct cifsFileInfo *src_file,
>> >                       struct cifsFileInfo *target_file, u64 src_off, u64 len,
>> >                       u64 dest_off);
>> > +     int (*duplicate_extents)(const unsigned int, struct cifsFileInfo *src,
>> > +                     struct cifsFileInfo *target_file, u64 src_off, u64 len,
>> > +                     u64 dest_off);
>> >       int (*validate_negotiate)(const unsigned int, struct cifs_tcon *);
>> >       ssize_t (*query_all_EAs)(const unsigned int, struct cifs_tcon *,
>> >                       const unsigned char *, const unsigned char *, char *,
>> > diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
>> > index 998a66f..47b030d 100644
>> > --- a/fs/cifs/cifspdu.h
>> > +++ b/fs/cifs/cifspdu.h
>> > @@ -2255,6 +2255,8 @@ typedef struct {
>> >
>> >
>> >  /* List of FileSystemAttributes - see 2.5.1 of MS-FSCC */
>> > +#define FILE_SUPPORTS_SPARSE_VDL     0x10000000 /* faster nonsparse extend */
>> > +#define FILE_SUPPORTS_BLOCK_REFCOUNTING      0x08000000 /* allow ioctl dup extents */
>> >  #define FILE_SUPPORT_INTEGRITY_STREAMS       0x04000000
>> >  #define FILE_SUPPORTS_USN_JOURNAL    0x02000000
>> >  #define FILE_SUPPORTS_OPEN_BY_FILE_ID        0x01000000
>> > diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
>> > index 8b7898b..7843b19 100644
>> > --- a/fs/cifs/ioctl.c
>> > +++ b/fs/cifs/ioctl.c
>> > @@ -31,12 +31,14 @@
>> >  #include "cifsproto.h"
>> >  #include "cifs_debug.h"
>> >  #include "cifsfs.h"
>> > +#include <linux/btrfs.h>
>> >
>> >  #define CIFS_IOCTL_MAGIC     0xCF
>> >  #define CIFS_IOC_COPYCHUNK_FILE      _IOW(CIFS_IOCTL_MAGIC, 3, int)
>> >
>> >  static long cifs_ioctl_clone(unsigned int xid, struct file *dst_file,
>> > -                     unsigned long srcfd, u64 off, u64 len, u64 destoff)
>> > +                     unsigned long srcfd, u64 off, u64 len, u64 destoff,
>> > +                     bool dup_extents)
>> >  {
>> >       int rc;
>> >       struct cifsFileInfo *smb_file_target = dst_file->private_data;
>> > @@ -109,9 +111,14 @@ static long cifs_ioctl_clone(unsigned int xid, struct file *dst_file,
>> >       truncate_inode_pages_range(&target_inode->i_data, destoff,
>> >                                  PAGE_CACHE_ALIGN(destoff + len)-1);
>> >
>> > -     if (target_tcon->ses->server->ops->clone_range)
>> > +     if (dup_extents && target_tcon->ses->server->ops->duplicate_extents)
>> > +             rc = target_tcon->ses->server->ops->duplicate_extents(xid,
>> > +                     smb_file_src, smb_file_target, off, len, destoff);
>> > +     else if (!dup_extents && target_tcon->ses->server->ops->clone_range)
>> >               rc = target_tcon->ses->server->ops->clone_range(xid,
>> >                       smb_file_src, smb_file_target, off, len, destoff);
>> > +     else
>> > +             rc = -EOPNOTSUPP;
>> >
>> >       /* force revalidate of size and timestamps of target file now
>> >          that target is updated on the server */
>> > @@ -205,7 +212,10 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
>> >                       }
>> >                       break;
>> >               case CIFS_IOC_COPYCHUNK_FILE:
>> > -                     rc = cifs_ioctl_clone(xid, filep, arg, 0, 0, 0);
>> > +                     rc = cifs_ioctl_clone(xid, filep, arg, 0, 0, 0, false);
>> > +                     break;
>> > +             case BTRFS_IOC_CLONE:
>> > +                     rc = cifs_ioctl_clone(xid, filep, arg, 0, 0, 0, true);
>>
>> Any interest in supporting BTRFS_IOC_CLONE_RANGE or BTRFS_IOC_EXTENT_SAME?
>> It looks like you could easily support the former, and the latter would
>> enable things like duperemove.  I've been working on a pile of xfstests to
>> exercise these three ioctls, will post them later today, I hope.
>>
>> --D
>>
>
> So far Samba (server) only uses three btrfs ioctls, but that includes
> clone range:
>
> ./source3/modules/vfs_btrfs.c:#define BTRFS_IOC_CLONE_RANGE ...
> ./source3/modules/vfs_btrfs.c:#define BTRFS_IOC_SNAP_DESTROY ...
> ./source3/modules/vfs_btrfs.c:#define BTRFS_IOC_SNAP_CREATE_V2 ...
>
> But btrfs clone range is only (optionally if present) used to handle
> the "CopyChunk" API (SMB3 and CIFS network protocol requests), and
> Samba server doesn't have code for the FSCTL_DUPLICATE_EXTENTS fsctl
> (SMB3 network protocol request) yet.  It looks trivial to map that to
> BTRFS_IOC_CLONE_RANGE in the Samba server.   Would need to add trivial
> parsing in smbd/smb2_ioctl_network_fs.c and a new VFS entry point in
> the Samba VFS and a small helper routine in
> source3/modules/vfs_btrfs.c

I should also mention that cifs.ko can already do fast(er) server side
copy today by using CopyChunk on SMB2/SMB3 but it is emulated in some
cases on the Samba server (e.g. when not running on btrfs or with
vfs_btrfs enabled) but "cp --reflink" semantics required that it
actually do the clone_range/duplicate_extents and Samba can't
guarantee that with CopyChunk (FSCTL_SRV_COPYCHUNK_WRITE)  - on the
other hand the new smb3 network protocol request (SMB3
FSCTL_DUPLICATE_EXTENTS) does guarantee that it is a reflink-like
copy.

We need an "smb3cp" utility (perhaps added to cifs-utils) that can try
the various types of server side copy and accept parms which allow the
user to specify the behavior they want (and the offsets they want) -
since few people know about the existing ioctl in cifs.ko which calls
CopyChunk (and FSCTL_SRV_COPYCHUNK_WRITE is not as fast as
FSCTL_DUPLICATE_EXTENTS)

I was also looking into using DUPLICATE_EXTENTS to enable the two new
fallocate features (insert range and collapse range) because it can be
called with source and target as the same file.

-- 
Steve French

Principal Systems Engineer: Protocols

W: 512-918-9276

C:  512-501-9669

www.primarydata.com
