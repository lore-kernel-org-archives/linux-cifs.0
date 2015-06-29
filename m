From: Steve French <steve.french@primarydata.com>
Subject: Re: [PATCHv2] Add reflink copy over SMB3.11 with new
	FSCTL_DUPLICATE_EXTENTS
Date: Mon, 29 Jun 2015 14:32:33 -0500
Message-ID: <CALSSpE7Q5sjGUPCamTNSdiwy1aq6BN05izOHsT7NvdJgJG6h_w@mail.gmail.com>
References: <1435544465-14133-1-git-send-email-steve.french@primarydata.com>
	<20150629172704.GA10038@birch.djwong.org>
Mime-Version: 1.0
Content-Type: multipart/related; boundary=089e0158c73ec06f4a0519ad268a
Cc: linux-fsdevel@vger.kernel.org, Steve French <smfrench@gmail.com>,
	samba-technical@lists.samba.org, linux-cifs@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20150629172704.GA10038@birch.djwong.org>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

--089e0158c73ec06f4a0519ad268a
Content-Type: text/plain; charset=UTF-8

So far Samba (server) only uses three btrfs ioctls, but that includes clone
range:

./source3/modules/vfs_btrfs.c:#define BTRFS_IOC_CLONE_RANGE ...
./source3/modules/vfs_btrfs.c:#define BTRFS_IOC_SNAP_DESTROY ...
./source3/modules/vfs_btrfs.c:#define BTRFS_IOC_SNAP_CREATE_V2 ...

But btrfs clone range is only (optionally if present) used to handle the
"CopyChunk" API (SMB3 and CIFS network protocol requests), and Samba server
doesn't have code for the FSCTL_DUPLICATE_EXTENTS fsctl (SMB3 network
protocol request) yet.  It looks trivial to map that to
BTRFS_IOC_CLONE_RANGE in the Samba server.   Would need to add trivial
parsing in smbd/smb2_ioctl_network_fs.c and a new VFS entry point in the
Samba VFS and a small helper routine in source3/modules/vfs_btrfs.c

On Mon, Jun 29, 2015 at 12:27 PM, Darrick J. Wong <darrick.wong@oracle.com>
wrote:

> On Sun, Jun 28, 2015 at 09:21:05PM -0500, Steve French wrote:
> >  Update the patch to correct target file size.
> >
> >  Getting fantastic copy performance with cp --reflink over SMB3.11
> >  using the new FSCTL_DUPLICATE_EXTENTS.
> >
> >  This FSCTL was added in the SMB3.11 dialect (testing was
> >  against REFS file system) so have put it as a 3.11 protocol
> >  specific operation ("vers=3.1.1" on the mount).  Tested at
> >  the SMB3 plugfest in Redmond.
> >
> >  It depends on the new FS Attribute (BLOCK_REFCOUNTING) which
> >  is used to advertise support for the ability to do this ioctl
> >  (if you can support multiple files pointing to the same block
> >  than this refcounting ability or equivalent is needed to
> >  support the new reflink-like duplicate extent SMB3 ioctl.
> >
> > Signed-off-by: Steve French <steve.french@primarydata.com>
> > ---
> >  fs/cifs/cifsglob.h |  3 +++
> >  fs/cifs/cifspdu.h  |  2 ++
> >  fs/cifs/ioctl.c    | 16 +++++++++++++---
> >  fs/cifs/smb2ops.c  | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  fs/cifs/smb2pdu.h  |  8 ++++++++
> >  fs/cifs/smbfsctl.h |  1 +
> >  6 files changed, 75 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> > index a0212ec..81194e6 100644
> > --- a/fs/cifs/cifsglob.h
> > +++ b/fs/cifs/cifsglob.h
> > @@ -390,6 +390,9 @@ struct smb_version_operations {
> >       int (*clone_range)(const unsigned int, struct cifsFileInfo
> *src_file,
> >                       struct cifsFileInfo *target_file, u64 src_off, u64
> len,
> >                       u64 dest_off);
> > +     int (*duplicate_extents)(const unsigned int, struct cifsFileInfo
> *src,
> > +                     struct cifsFileInfo *target_file, u64 src_off, u64
> len,
> > +                     u64 dest_off);
> >       int (*validate_negotiate)(const unsigned int, struct cifs_tcon *);
> >       ssize_t (*query_all_EAs)(const unsigned int, struct cifs_tcon *,
> >                       const unsigned char *, const unsigned char *, char
> *,
> > diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
> > index 998a66f..47b030d 100644
> > --- a/fs/cifs/cifspdu.h
> > +++ b/fs/cifs/cifspdu.h
> > @@ -2255,6 +2255,8 @@ typedef struct {
> >
> >
> >  /* List of FileSystemAttributes - see 2.5.1 of MS-FSCC */
> > +#define FILE_SUPPORTS_SPARSE_VDL     0x10000000 /* faster nonsparse
> extend */
> > +#define FILE_SUPPORTS_BLOCK_REFCOUNTING      0x08000000 /* allow ioctl
> dup extents */
> >  #define FILE_SUPPORT_INTEGRITY_STREAMS       0x04000000
> >  #define FILE_SUPPORTS_USN_JOURNAL    0x02000000
> >  #define FILE_SUPPORTS_OPEN_BY_FILE_ID        0x01000000
> > diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
> > index 8b7898b..7843b19 100644
> > --- a/fs/cifs/ioctl.c
> > +++ b/fs/cifs/ioctl.c
> > @@ -31,12 +31,14 @@
> >  #include "cifsproto.h"
> >  #include "cifs_debug.h"
> >  #include "cifsfs.h"
> > +#include <linux/btrfs.h>
> >
> >  #define CIFS_IOCTL_MAGIC     0xCF
> >  #define CIFS_IOC_COPYCHUNK_FILE      _IOW(CIFS_IOCTL_MAGIC, 3, int)
> >
> >  static long cifs_ioctl_clone(unsigned int xid, struct file *dst_file,
> > -                     unsigned long srcfd, u64 off, u64 len, u64 destoff)
> > +                     unsigned long srcfd, u64 off, u64 len, u64 destoff,
> > +                     bool dup_extents)
> >  {
> >       int rc;
> >       struct cifsFileInfo *smb_file_target = dst_file->private_data;
> > @@ -109,9 +111,14 @@ static long cifs_ioctl_clone(unsigned int xid,
> struct file *dst_file,
> >       truncate_inode_pages_range(&target_inode->i_data, destoff,
> >                                  PAGE_CACHE_ALIGN(destoff + len)-1);
> >
> > -     if (target_tcon->ses->server->ops->clone_range)
> > +     if (dup_extents &&
> target_tcon->ses->server->ops->duplicate_extents)
> > +             rc = target_tcon->ses->server->ops->duplicate_extents(xid,
> > +                     smb_file_src, smb_file_target, off, len, destoff);
> > +     else if (!dup_extents &&
> target_tcon->ses->server->ops->clone_range)
> >               rc = target_tcon->ses->server->ops->clone_range(xid,
> >                       smb_file_src, smb_file_target, off, len, destoff);
> > +     else
> > +             rc = -EOPNOTSUPP;
> >
> >       /* force revalidate of size and timestamps of target file now
> >          that target is updated on the server */
> > @@ -205,7 +212,10 @@ long cifs_ioctl(struct file *filep, unsigned int
> command, unsigned long arg)
> >                       }
> >                       break;
> >               case CIFS_IOC_COPYCHUNK_FILE:
> > -                     rc = cifs_ioctl_clone(xid, filep, arg, 0, 0, 0);
> > +                     rc = cifs_ioctl_clone(xid, filep, arg, 0, 0, 0,
> false);
> > +                     break;
> > +             case BTRFS_IOC_CLONE:
> > +                     rc = cifs_ioctl_clone(xid, filep, arg, 0, 0, 0,
> true);
>
> Any interest in supporting BTRFS_IOC_CLONE_RANGE or BTRFS_IOC_EXTENT_SAME?
> It looks like you could easily support the former, and the latter would
> enable things like duperemove.  I've been working on a pile of xfstests to
> exercise these three ioctls, will post them later today, I hope.
>
> --D
>
> >                       break;
> >               default:
> >                       cifs_dbg(FYI, "unsupported ioctl\n");
> > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > index c7d228c..b1e9c0f 100644
> > --- a/fs/cifs/smb2ops.c
> > +++ b/fs/cifs/smb2ops.c
> > @@ -806,6 +806,53 @@ smb2_set_file_size(const unsigned int xid, struct
> cifs_tcon *tcon,
> >                           cfile->fid.volatile_fid, cfile->pid, &eof,
> false);
> >  }
> >
> > +#ifdef CONFIG_CIFS_SMB311
> > +static int
> > +smb2_duplicate_extents(const unsigned int xid,
> > +                     struct cifsFileInfo *srcfile,
> > +                     struct cifsFileInfo *trgtfile, u64 src_off,
> > +                     u64 len, u64 dest_off)
> > +{
> > +     int rc;
> > +     unsigned int ret_data_len;
> > +     char *retbuf = NULL;
> > +     struct duplicate_extents_to_file dup_ext_buf;
> > +     struct cifs_tcon *tcon = tlink_tcon(trgtfile->tlink);
> > +
> > +     /* server fileays advertise duplicate extent support with this
> flag */
> > +     if ((le32_to_cpu(tcon->fsAttrInfo.Attributes) &
> > +          FILE_SUPPORTS_BLOCK_REFCOUNTING) == 0)
> > +             return -EOPNOTSUPP;
> > +
> > +     dup_ext_buf.VolatileFileHandle = srcfile->fid.volatile_fid;
> > +     dup_ext_buf.PersistentFileHandle = srcfile->fid.persistent_fid;
> > +     dup_ext_buf.SourceFileOffset = cpu_to_le64(src_off);
> > +     dup_ext_buf.TargetFileOffset = cpu_to_le64(dest_off);
> > +     dup_ext_buf.ByteCount = cpu_to_le64(len);
> > +     cifs_dbg(FYI, "duplicate extents: src off %lld dst off %lld len
> %lld",
> > +             src_off, dest_off, len);
> > +
> > +     rc = smb2_set_file_size(xid, tcon, trgtfile, dest_off + len,
> false);
> > +     if (rc)
> > +             goto duplicate_extents_out;
> > +
> > +     rc = SMB2_ioctl(xid, tcon, trgtfile->fid.persistent_fid,
> > +                     trgtfile->fid.volatile_fid,
> > +                     FSCTL_DUPLICATE_EXTENTS_TO_FILE,
> > +                     true /* is_fsctl */, (char *)&dup_ext_buf,
> > +                     sizeof(struct duplicate_extents_to_file),
> > +                     (char **)&retbuf,
> > +                     &ret_data_len);
> > +
> > +     if (ret_data_len > 0)
> > +             cifs_dbg(FYI, "non-zero response length in duplicate
> extents");
> > +
> > +duplicate_extents_out:
> > +     return rc;
> > +}
> > +#endif /* CONFIG_CIFS_SMB311 */
> > +
> > +
> >  static int
> >  smb2_set_compression(const unsigned int xid, struct cifs_tcon *tcon,
> >                  struct cifsFileInfo *cfile)
> > @@ -1714,6 +1761,7 @@ struct smb_version_operations smb311_operations = {
> >       .create_lease_buf = smb3_create_lease_buf,
> >       .parse_lease_buf = smb3_parse_lease_buf,
> >       .clone_range = smb2_clone_range,
> > +     .duplicate_extents = smb2_duplicate_extents,
> >  /*   .validate_negotiate = smb3_validate_negotiate, */ /* not used in
> 3.11 */
> >       .wp_retry_size = smb2_wp_retry_size,
> >       .dir_needs_close = smb2_dir_needs_close,
> > diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
> > index 725283a..8e7bbe5 100644
> > --- a/fs/cifs/smb2pdu.h
> > +++ b/fs/cifs/smb2pdu.h
> > @@ -654,6 +654,14 @@ struct compress_ioctl {
> >       __le16 CompressionState; /* See cifspdu.h for possible flag values
> */
> >  } __packed;
> >
> > +struct duplicate_extents_to_file {
> > +     __u64 PersistentFileHandle; /* source file handle, opaque
> endianness */
> > +     __u64 VolatileFileHandle;
> > +     __le64 SourceFileOffset;
> > +     __le64 TargetFileOffset;
> > +     __le64 ByteCount;  /* Bytes to be copied */
> > +} __packed;
> > +
> >  struct smb2_ioctl_req {
> >       struct smb2_hdr hdr;
> >       __le16 StructureSize;   /* Must be 57 */
> > diff --git a/fs/cifs/smbfsctl.h b/fs/cifs/smbfsctl.h
> > index 83efa59..d098da6 100644
> > --- a/fs/cifs/smbfsctl.h
> > +++ b/fs/cifs/smbfsctl.h
> > @@ -78,6 +78,7 @@
> >  #define FSCTL_QUERY_ALLOCATED_RANGES 0x000940CF /* BB add struct */
> >  #define FSCTL_SET_DEFECT_MANAGEMENT  0x00098134 /* BB add struct */
> >  #define FSCTL_FILE_LEVEL_TRIM        0x00098208 /* BB add struct */
> > +#define FSCTL_DUPLICATE_EXTENTS_TO_FILE 0x00098344
> >  #define FSCTL_SIS_LINK_FILES         0x0009C104
> >  #define FSCTL_PIPE_PEEK              0x0011400C /* BB add struct */
> >  #define FSCTL_PIPE_TRANSCEIVE        0x0011C017 /* BB add struct */
> > --
> > 2.1.4
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel"
> in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 

*Steve French*

Principal Systems Engineer: Protocols

W: 512-918-9276

C:  512-501-9669

www.primarydata.com

[image: cid:E5DD7677-4C3D-4DB7-95DC-31E18398703A]

--089e0158c73ec06f4a0519ad268a
Content-Type: image/png; name="image001.png"
Content-Disposition: inline; filename="image001.png"
Content-Transfer-Encoding: base64
Content-ID: <image001.png@01D04524.155251C0>
X-Attachment-Id: e91162232469e4a6_0.1

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
--089e0158c73ec06f4a0519ad268a--
