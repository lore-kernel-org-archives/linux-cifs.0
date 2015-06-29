From: Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Subject: Fwd: [PATCHv2] Add reflink copy over SMB3.11 with new FSCTL_DUPLICATE_EXTENTS
Date: Mon, 29 Jun 2015 16:50:57 -0500
Message-ID: <CALSSpE6_5C3UzA-qGMWXLW9PNk6DwGX5A-BcNT7dEcPXmikdEA@mail.gmail.com>
References: <1435544465-14133-1-git-send-email-steve.french@primarydata.com>
	<20150629172704.GA10038@birch.djwong.org>
	<CALSSpE5nuE_45PMCKsNBqrg_r9z=+cdCEkBvV1bx=gmiWnRSzw@mail.gmail.com>
	<20150629213126.GB10038@birch.djwong.org>
	<CALSSpE6YTLmB6zQ6foRYXOMH+SyhhHGEvSNPo0iMqQWTs9hbDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALSSpE6YTLmB6zQ6foRYXOMH+SyhhHGEvSNPo0iMqQWTs9hbDw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Jun 29, 2015 at 4:31 PM, Darrick J. Wong
<darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Mon, Jun 29, 2015 at 02:33:56PM -0500, Steve French wrote:
> > On Mon, Jun 29, 2015 at 12:27 PM, Darrick J. Wong
> > <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> > >
> > > On Sun, Jun 28, 2015 at 09:21:05PM -0500, Steve French wrote:
> > > >  Update the patch to correct target file size.
> > > >
> > > >  Getting fantastic copy performance with cp --reflink over SMB3.11
> > > >  using the new FSCTL_DUPLICATE_EXTENTS.
> > > >
> > > >  This FSCTL was added in the SMB3.11 dialect (testing was
> > > >  against REFS file system) so have put it as a 3.11 protocol
> > > >  specific operation ("vers=3.1.1" on the mount).  Tested at
> > > >  the SMB3 plugfest in Redmond.
> > > >
> > > >  It depends on the new FS Attribute (BLOCK_REFCOUNTING) which
> > > >  is used to advertise support for the ability to do this ioctl
> > > >  (if you can support multiple files pointing to the same block
> > > >  than this refcounting ability or equivalent is needed to
> > > >  support the new reflink-like duplicate extent SMB3 ioctl.
> > > >
> > > > Signed-off-by: Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
> > > > ---
> > > >  fs/cifs/cifsglob.h |  3 +++
> > > >  fs/cifs/cifspdu.h  |  2 ++
> > > >  fs/cifs/ioctl.c    | 16 +++++++++++++---
> > > >  fs/cifs/smb2ops.c  | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  fs/cifs/smb2pdu.h  |  8 ++++++++
> > > >  fs/cifs/smbfsctl.h |  1 +
> > > >  6 files changed, 75 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> > > > index a0212ec..81194e6 100644
> > > > --- a/fs/cifs/cifsglob.h
> > > > +++ b/fs/cifs/cifsglob.h
> > > > @@ -390,6 +390,9 @@ struct smb_version_operations {
> > > >       int (*clone_range)(const unsigned int, struct cifsFileInfo *src_file,
> > > >                       struct cifsFileInfo *target_file, u64 src_off, u64 len,
> > > >                       u64 dest_off);
> > > > +     int (*duplicate_extents)(const unsigned int, struct cifsFileInfo *src,
> > > > +                     struct cifsFileInfo *target_file, u64 src_off, u64 len,
> > > > +                     u64 dest_off);
> > > >       int (*validate_negotiate)(const unsigned int, struct cifs_tcon *);
> > > >       ssize_t (*query_all_EAs)(const unsigned int, struct cifs_tcon *,
> > > >                       const unsigned char *, const unsigned char *, char *,
> > > > diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
> > > > index 998a66f..47b030d 100644
> > > > --- a/fs/cifs/cifspdu.h
> > > > +++ b/fs/cifs/cifspdu.h
> > > > @@ -2255,6 +2255,8 @@ typedef struct {
> > > >
> > > >
> > > >  /* List of FileSystemAttributes - see 2.5.1 of MS-FSCC */
> > > > +#define FILE_SUPPORTS_SPARSE_VDL     0x10000000 /* faster nonsparse extend */
> > > > +#define FILE_SUPPORTS_BLOCK_REFCOUNTING      0x08000000 /* allow ioctl dup extents */
> > > >  #define FILE_SUPPORT_INTEGRITY_STREAMS       0x04000000
> > > >  #define FILE_SUPPORTS_USN_JOURNAL    0x02000000
> > > >  #define FILE_SUPPORTS_OPEN_BY_FILE_ID        0x01000000
> > > > diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
> > > > index 8b7898b..7843b19 100644
> > > > --- a/fs/cifs/ioctl.c
> > > > +++ b/fs/cifs/ioctl.c
> > > > @@ -31,12 +31,14 @@
> > > >  #include "cifsproto.h"
> > > >  #include "cifs_debug.h"
> > > >  #include "cifsfs.h"
> > > > +#include <linux/btrfs.h>
> > > >
> > > >  #define CIFS_IOCTL_MAGIC     0xCF
> > > >  #define CIFS_IOC_COPYCHUNK_FILE      _IOW(CIFS_IOCTL_MAGIC, 3, int)
> > > >
> > > >  static long cifs_ioctl_clone(unsigned int xid, struct file *dst_file,
> > > > -                     unsigned long srcfd, u64 off, u64 len, u64 destoff)
> > > > +                     unsigned long srcfd, u64 off, u64 len, u64 destoff,
> > > > +                     bool dup_extents)
> > > >  {
> > > >       int rc;
> > > >       struct cifsFileInfo *smb_file_target = dst_file->private_data;
> > > > @@ -109,9 +111,14 @@ static long cifs_ioctl_clone(unsigned int xid, struct file *dst_file,
> > > >       truncate_inode_pages_range(&target_inode->i_data, destoff,
> > > >                                  PAGE_CACHE_ALIGN(destoff + len)-1);
> > > >
> > > > -     if (target_tcon->ses->server->ops->clone_range)
> > > > +     if (dup_extents && target_tcon->ses->server->ops->duplicate_extents)
> > > > +             rc = target_tcon->ses->server->ops->duplicate_extents(xid,
> > > > +                     smb_file_src, smb_file_target, off, len, destoff);
> > > > +     else if (!dup_extents && target_tcon->ses->server->ops->clone_range)
> > > >               rc = target_tcon->ses->server->ops->clone_range(xid,
> > > >                       smb_file_src, smb_file_target, off, len, destoff);
> > > > +     else
> > > > +             rc = -EOPNOTSUPP;
> > > >
> > > >       /* force revalidate of size and timestamps of target file now
> > > >          that target is updated on the server */
> > > > @@ -205,7 +212,10 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
> > > >                       }
> > > >                       break;
> > > >               case CIFS_IOC_COPYCHUNK_FILE:
> > > > -                     rc = cifs_ioctl_clone(xid, filep, arg, 0, 0, 0);
> > > > +                     rc = cifs_ioctl_clone(xid, filep, arg, 0, 0, 0, false);
> > > > +                     break;
> > > > +             case BTRFS_IOC_CLONE:
> > > > +                     rc = cifs_ioctl_clone(xid, filep, arg, 0, 0, 0, true);
> > >
> > > Any interest in supporting BTRFS_IOC_CLONE_RANGE or BTRFS_IOC_EXTENT_SAME?
> > > It looks like you could easily support the former, and the latter would
> > > enable things like duperemove.  I've been working on a pile of xfstests to
> > > exercise these three ioctls, will post them later today, I hope.
> > >
> > > --D
> > >
> >
> > So far Samba (server) only uses three btrfs ioctls, but that includes
> > clone range:
>
> Oh, my question was mostly about support for CLONE_RANGE within
> cifs.ko so that clients could ask for a reflink, which would then be
> sent off to the server as FSCTL_DUPLICATE_EXTENTS.  That doesn't seem
> too hard, but I didn't see it in ioctl.c and wondered why. :)
>
> >
> > ./source3/modules/vfs_btrfs.c:#define BTRFS_IOC_CLONE_RANGE ...
> > ./source3/modules/vfs_btrfs.c:#define BTRFS_IOC_SNAP_DESTROY ...
> > ./source3/modules/vfs_btrfs.c:#define BTRFS_IOC_SNAP_CREATE_V2 ...
> >
> > But btrfs clone range is only (optionally if present) used to handle
> > the "CopyChunk" API (SMB3 and CIFS network protocol requests), and
> > Samba server doesn't have code for the FSCTL_DUPLICATE_EXTENTS fsctl
> > (SMB3 network protocol request) yet.  It looks trivial to map that to
> > BTRFS_IOC_CLONE_RANGE in the Samba server.   Would need to add trivial
> > parsing in smbd/smb2_ioctl_network_fs.c and a new VFS entry point in
> > the Samba VFS and a small helper routine in
> > source3/modules/vfs_btrfs.c
>
> Sounds fairly straightforward on the server side.  I'm working on adding
> the three ioctls I mentioned (CLONE, CLONE_RANGE, EXTENT_SAME) to XFS and
> others are working on it for ext4; do you think it would be difficult to
> adapt Samba server to talk to these three btrfs APIs even with a non-btrfs
> backend?
>
> (Or, maybe someday we might refactor all this into a common syscall or
> something.)
>
> I guess BTRFS_IOC_EXTENT_SAME would be harder since you'd want to compare
> file contents on the server, and I'm not sure if SMB can actually do that.
>


 cifs.ko with the recent patches, does support IOC_CLONE (ie
BTRFS_IOC_CLONE) but I didn't add BTRFS_CLONE_RANGE which would be
easy enough to add to cifs.ko (although would be a little better, and
perhaps less confusing, if there were a system ioctl definition that
was an exact equivalent of BTRFS_IOC_CLONE and BTRFS_IOC_CLONE_RANGE
but didn't use the name BTRFS, but last I checked the cp command it
only knows about BTRFS_IOC_CLONE so we are stuck using that ioctl
number).

If you call CIFS_IOC_COPYCHUNK_FILE ioctl today in cifs.ko (even
without the patches), for SMB3 mounts it will send a
FSCTL_SRV_COPYCHUNK_WRITE SMB3 request to the server which Samba will
either emulate in user space as a somewhat faster file copy, or pass
directly to btrfs if vfs_btrfs is loaded and the server will do a
BTRFS_IOC_CLONE_RANGE.

With the recent patch to cifs.ko it will be easier since for cifs
--reflink we will only issue DUPLICATE_EXTENTS IOCTL over the wire
(which Samba can convert to BRTFS_IOC_CLONE or BTRFS_IOC_CLONE_RANGE)
if the server advertises the file system support for the corresponding
attribute flag.


-- 

Steve French

Principal Systems Engineer: Protocols

W: 512-918-9276

C:  512-501-9669

www.primarydata.com





-- 

Steve French

Principal Systems Engineer: Protocols

W: 512-918-9276

C:  512-501-9669

www.primarydata.com
