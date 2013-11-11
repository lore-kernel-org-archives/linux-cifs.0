From: Pavel Shilovsky <piastryyy@gmail.com>
Subject: Re: [PATCH] [CIFS] SMB2/SMB3 Copy offload support (refcopy) phase 1
Date: Tue, 12 Nov 2013 00:14:12 +0400
Message-ID: <CAKywueSiL31wOf8EzYeMZv1HqHnPb=otqUmiT6Cy3TfDHF7FLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	samba-technical <samba-technical@lists.samba.org>,
	David Disseldorp <ddiss@suse.de>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

2013/10/18 Steve French <smfrench@gmail.com>:
> From 6b6503530681165dccf2ce59eb631542ec58288c Mon Sep 17 00:00:00 2001
> From: Steve French <smfrench@gmail.com>
> Date: Thu, 17 Oct 2013 14:16:33 -0500
> Subject: [PATCH] [CIFS] SMB2/SMB3 Copy offload support (refcopy) phase 1
>
> This first patch adds the ability for us to do a server side copy
> (ie fast copy offloaded to the server)
>
> "cp --reflink"
>
> of one file to another located on the same server.  This
> is much faster than traditional copy (which requires
> reading and writing over the network and extra
> memcpys).
>
> This first version is not going to copy
> files larger than about 1MB (to Samba) until I add
> support for multiple chunks and for autoconfiguring
> the chunksize.  To work to Samba it requires Samba 4.1 or later and
> David Disseldorp's recently posted small Samba server patch.
> It does work to Windows.
>
> It includes:
> 1) processing of the ioctl (IOC_CLONE, similar to btrfs)
> 2) marshalling and sending the SMB2/SMB3 fsctl over the network
> 3) simple parsing of the response
>
> It does not include yet (these will be in followon patches to come soon):
> 1) support for multiple chunks
> 2) support for autoconfiguring and remembering the chunksize
> 3) Support for the older style copychunk which Samba 4.1 server supports
> (because this would require read permission on the target file, which
> cp does not give you, apparently per-posix).  Use of COPYCHUNK to
> Samba 4.1 server (pre-david's patch) may require
> a distinct tool (other than cp) and another (trivial) ioctl to implement.
>
> Signed-off-by: Steve French <smfrench@gmail.com>
> ---
>  fs/cifs/cifsglob.h |   3 ++
>  fs/cifs/ioctl.c    | 103 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/cifs/smb2ops.c  |  82 ++++++++++++++++++++++++++++++++++++++++++
>  fs/cifs/smb2pdu.h  |  15 +++++++-
>  4 files changed, 202 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index de3e3e0..a67cf12 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -381,6 +381,9 @@ struct smb_version_operations {
>   char * (*create_lease_buf)(u8 *, u8);
>   /* parse lease context buffer and return oplock/epoch info */
>   __u8 (*parse_lease_buf)(void *, unsigned int *);
> + int (*clone_range)(const unsigned int, struct cifsFileInfo *src_file,
> + struct cifsFileInfo *target_file, u64 src_off, u64 len,
> + u64 dest_off);
>  };
>
>  struct smb_version_values {
> diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
> index ba54bf6..d353f6c 100644
> --- a/fs/cifs/ioctl.c
> +++ b/fs/cifs/ioctl.c
> @@ -22,12 +22,112 @@
>   */
>
>  #include <linux/fs.h>
> +#include <linux/file.h>
> +#include <linux/mount.h>
> +#include <linux/mm.h>
> +#include <linux/pagemap.h>
> +#include <linux/btrfs.h>
>  #include "cifspdu.h"
>  #include "cifsglob.h"
>  #include "cifsproto.h"
>  #include "cifs_debug.h"
>  #include "cifsfs.h"
>
> +static long cifs_ioctl_clone(unsigned int xid, struct file *dst_file,
> + unsigned long srcfd, u64 off, u64 len, u64 destoff)
> +{
> + int rc;
> + struct cifsFileInfo *smb_file_target = dst_file->private_data;
> + struct inode *target_inode = file_inode(dst_file);
> + struct cifs_tcon *target_tcon;
> + struct fd src_file;
> + struct cifsFileInfo *smb_file_src;
> + struct inode *src_inode;
> + struct cifs_tcon *src_tcon;
> +
> + cifs_dbg(FYI, "ioctl clone range\n");
> + /* the destination must be opened for writing */
> + if (!(dst_file->f_mode & FMODE_WRITE)) {
> + cifs_dbg(FYI, "file target not open for write\n");
> + return -EINVAL;
> + }
> +
> + /* check if target volume is readonly and take reference */
> + rc = mnt_want_write_file(dst_file);
> + if (rc) {
> + cifs_dbg(FYI, "mnt_want_write failed with rc %d\n", rc);
> + return rc;
> + }
> +
> + src_file = fdget(srcfd);
> + if (!src_file.file) {
> + rc = -EBADF;
> + goto out_drop_write;
> + }
> +
> + if ((!src_file.file->private_data) || (!dst_file->private_data)) {
> + rc = -EBADF;
> + cifs_dbg(VFS, "missing cifsFileInfo on copy range src file\n");
> + goto out_fput;
> + }
> +
> + rc = -EXDEV;
> + smb_file_target = dst_file->private_data;
> + smb_file_src = src_file.file->private_data;
> + src_tcon = tlink_tcon(smb_file_src->tlink);
> + target_tcon = tlink_tcon(smb_file_target->tlink);
> +
> + /* check if source and target are on same tree connection */
> + if (src_tcon != target_tcon) {
> + cifs_dbg(VFS, "file copy src and target on different volume\n");
> + goto out_fput;
> + }
> +
> + src_inode = src_file.file->f_dentry->d_inode;
> +
> + /* Note: cifs case is easier than btrfs since server responsible for */
> + /* checks for proper open modes and file type and if it wants */
> + /* server could even support copy of range where source = target */
> +
> + /* so we do not deadlock racing two ioctls on same files */
> + /* btrfs does a similar check */

The above comments don't match kernel comment style.

> + if (target_inode < src_inode) {
> + mutex_lock_nested(&target_inode->i_mutex, I_MUTEX_PARENT);
> + mutex_lock_nested(&src_inode->i_mutex, I_MUTEX_CHILD);
> + } else {
> + mutex_lock_nested(&src_inode->i_mutex, I_MUTEX_PARENT);
> + mutex_lock_nested(&target_inode->i_mutex, I_MUTEX_CHILD);
> + }
> +
> + /* determine range to clone */
> + rc = -EINVAL;
> + if (off + len > src_inode->i_size || off + len < off)
> + goto out_unlock;
> + if (len == 0)
> + len = src_inode->i_size - off;
> +
> + cifs_dbg(FYI, "about to flush pages\n");
> + /* should we flush first and last page first */
> + truncate_inode_pages_range(&target_inode->i_data, destoff,
> +   PAGE_CACHE_ALIGN(destoff + len)-1);
> +
> + if (target_tcon->ses->server->ops->clone_range)
> + rc = target_tcon->ses->server->ops->clone_range(xid,
> + smb_file_src, smb_file_target, off, len, destoff);
> +
> + /* force revalidate of size and timestamps of target file now
> +   that target is updated on the server */

The same like above.

> + CIFS_I(target_inode)->time = 0;
> +out_unlock:
> + mutex_unlock(&src_inode->i_mutex);
> + mutex_unlock(&target_inode->i_mutex);

This can end up with lock(a), lock(b), unlock(a), unlock(b) sequence
if target_inode >= src_inode. It should be lock(a), lock(b),
unlock(b), unlock(a) - so, I think we should compare target_inode and
src_inode here and unlock locks in a back order.

> +out_fput:
> + fdput(src_file);
> +out_drop_write:
> + mnt_drop_write_file(dst_file);
> + return rc;
> +}
> +
>  long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
>  {
>   struct inode *inode = file_inode(filep);
> @@ -105,6 +205,9 @@ long cifs_ioctl(struct file *filep, unsigned int
> command, unsigned long arg)
>   cifs_dbg(FYI, "set compress flag rc %d\n", rc);
>   }
>   break;
> + case BTRFS_IOC_CLONE:
> + rc = cifs_ioctl_clone(xid, filep, arg, 0, 0, 0);
> + break;
>   default:
>   cifs_dbg(FYI, "unsupported ioctl\n");
>   break;
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index c571be8..11dde4b 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -494,6 +494,85 @@ smb2_close_file(const unsigned int xid, struct
> cifs_tcon *tcon,
>  }
>
>  static int
> +SMB2_request_res_key(const unsigned int xid, struct cifs_tcon *tcon,
> +     u64 persistent_fid, u64 volatile_fid,
> +     struct copychunk_ioctl *pcchunk)
> +{
> + int rc;
> + unsigned int ret_data_len;
> + struct resume_key_req *res_key;
> +
> + rc = SMB2_ioctl(xid, tcon, persistent_fid, volatile_fid,
> + FSCTL_SRV_REQUEST_RESUME_KEY, true /* is_fsctl */,
> + NULL, 0 /* no input */,
> + (char **)&res_key, &ret_data_len);
> +
> + if (rc) {
> + cifs_dbg(VFS, "refcpy ioctl error %d getting resume key\n", rc);
> + goto req_res_key_exit;
> + }
> + if (ret_data_len < sizeof(struct resume_key_req)) {
> + cifs_dbg(VFS, "Invalid refcopy resume key length\n");
> + rc = -EINVAL;
> + goto req_res_key_exit;
> + }
> + memcpy(pcchunk->SourceKey, res_key->ResumeKey, COPY_CHUNK_RES_KEY_SIZE);
> +
> +req_res_key_exit:
> + kfree(res_key);
> + return rc;
> +}
> +
> +static int
> +smb2_clone_range(const unsigned int xid,
> + struct cifsFileInfo *srcfile,
> + struct cifsFileInfo *trgtfile, u64 src_off,
> + u64 len, u64 dest_off)
> +{
> + int rc;
> + unsigned int ret_data_len;
> + struct copychunk_ioctl *pcchunk;
> + char *retbuf = NULL;
> +
> + pcchunk = kmalloc(sizeof(struct copychunk_ioctl), GFP_KERNEL);
> +
> + if (pcchunk == NULL)
> + return -ENOMEM;
> +
> + cifs_dbg(FYI, "in smb2_clone_range - about to call request res key\n");
> + /* Request a key from the server to identify the source of the copy */
> + rc = SMB2_request_res_key(xid, tlink_tcon(srcfile->tlink),
> + srcfile->fid.persistent_fid,
> + srcfile->fid.volatile_fid, pcchunk);
> +
> + /* Note: request_res_key sets res_key null only if rc !=0 */
> + if (rc)
> + return rc;
> +
> + /* For now array only one chunk long, will make more flexible later */
> + pcchunk->ChunkCount = __constant_cpu_to_le32(1);
> + pcchunk->Reserved = 0;
> + pcchunk->SourceOffset = cpu_to_le64(src_off);
> + pcchunk->TargetOffset = cpu_to_le64(dest_off);
> + pcchunk->Length = cpu_to_le32(len);
> + pcchunk->Reserved2 = 0;
> +
> + /* Request that server copy to target from src file identified by key */
> + rc = SMB2_ioctl(xid, tlink_tcon(trgtfile->tlink),
> + trgtfile->fid.persistent_fid,
> + trgtfile->fid.volatile_fid, FSCTL_SRV_COPYCHUNK_WRITE,
> + true /* is_fsctl */, (char *)pcchunk,
> + sizeof(struct copychunk_ioctl), &retbuf, &ret_data_len);
> +
> + /* BB need to special case rc = EINVAL to alter chunk size */
> +
> + cifs_dbg(FYI, "rc %d data length out %d\n", rc, ret_data_len);
> +
> + kfree(pcchunk);
> + return rc;
> +}
> +
> +static int
>  smb2_flush_file(const unsigned int xid, struct cifs_tcon *tcon,
>   struct cifs_fid *fid)
>  {
> @@ -1017,6 +1096,7 @@ struct smb_version_operations smb20_operations = {
>   .set_oplock_level = smb2_set_oplock_level,
>   .create_lease_buf = smb2_create_lease_buf,
>   .parse_lease_buf = smb2_parse_lease_buf,
> + .clone_range = smb2_clone_range,
>  };
>
>  struct smb_version_operations smb21_operations = {
> @@ -1090,6 +1170,7 @@ struct smb_version_operations smb21_operations = {
>   .set_oplock_level = smb21_set_oplock_level,
>   .create_lease_buf = smb2_create_lease_buf,
>   .parse_lease_buf = smb2_parse_lease_buf,
> + .clone_range = smb2_clone_range,
>  };
>
>  struct smb_version_operations smb30_operations = {
> @@ -1165,6 +1246,7 @@ struct smb_version_operations smb30_operations = {
>   .set_oplock_level = smb3_set_oplock_level,
>   .create_lease_buf = smb3_create_lease_buf,
>   .parse_lease_buf = smb3_parse_lease_buf,
> + .clone_range = smb2_clone_range,
>  };
>
>  struct smb_version_values smb20_values = {
> diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
> index 6183b1b..b50a129 100644
> --- a/fs/cifs/smb2pdu.h
> +++ b/fs/cifs/smb2pdu.h
> @@ -534,9 +534,16 @@ struct create_durable {
>   } Data;
>  } __packed;
>
> +#define COPY_CHUNK_RES_KEY_SIZE 24
> +struct resume_key_req {
> + char ResumeKey[COPY_CHUNK_RES_KEY_SIZE];
> + __le32 ContextLength; /* MBZ */
> + char Context[0]; /* ignored, Windows sets to 4 bytes of zero */
> +} __packed;
> +
>  /* this goes in the ioctl buffer when doing a copychunk request */
>  struct copychunk_ioctl {
> - char SourceKey[24];
> + char SourceKey[COPY_CHUNK_RES_KEY_SIZE];
>   __le32 ChunkCount; /* we are only sending 1 */
>   __le32 Reserved;
>   /* array will only be one chunk long for us */
> @@ -546,6 +553,12 @@ struct copychunk_ioctl {
>   __u32 Reserved2;
>  } __packed;
>
> +struct copychunk_ioctl_rsp {
> + __le32 ChunksWritten;
> + __le32 ChunkBytesWritten;
> + __le32 TotalBytesWritten;
> +} __packed;
> +
>  /* Response and Request are the same format */
>  struct validate_negotiate_info {
>   __le32 Capabilities;
> --
> 1.7.11.7
>
>
>
> --
> Thanks,
>
> Steve



-- 
Best regards,
Pavel Shilovsky.
