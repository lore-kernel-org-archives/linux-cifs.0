From: Steve French <smfrench@gmail.com>
Subject: [PATCHv2] Add reflink copy over SMB3.11 with new FSCTL_DUPLICATE_EXTENTS
Date: Sun, 28 Jun 2015 21:21:05 -0500
Message-ID: <1435544465-14133-1-git-send-email-steve.french@primarydata.com>
Cc: linux-fsdevel@vger.kernel.org, samba-technical@lists.samba.org,
	Steve French <steve.french@primarydata.com>
To: linux-cifs@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

 Update the patch to correct target file size.

 Getting fantastic copy performance with cp --reflink over SMB3.11
 using the new FSCTL_DUPLICATE_EXTENTS.

 This FSCTL was added in the SMB3.11 dialect (testing was
 against REFS file system) so have put it as a 3.11 protocol
 specific operation ("vers=3.1.1" on the mount).  Tested at
 the SMB3 plugfest in Redmond.

 It depends on the new FS Attribute (BLOCK_REFCOUNTING) which
 is used to advertise support for the ability to do this ioctl
 (if you can support multiple files pointing to the same block
 than this refcounting ability or equivalent is needed to
 support the new reflink-like duplicate extent SMB3 ioctl.

Signed-off-by: Steve French <steve.french@primarydata.com>
---
 fs/cifs/cifsglob.h |  3 +++
 fs/cifs/cifspdu.h  |  2 ++
 fs/cifs/ioctl.c    | 16 +++++++++++++---
 fs/cifs/smb2ops.c  | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.h  |  8 ++++++++
 fs/cifs/smbfsctl.h |  1 +
 6 files changed, 75 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index a0212ec..81194e6 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -390,6 +390,9 @@ struct smb_version_operations {
 	int (*clone_range)(const unsigned int, struct cifsFileInfo *src_file,
 			struct cifsFileInfo *target_file, u64 src_off, u64 len,
 			u64 dest_off);
+	int (*duplicate_extents)(const unsigned int, struct cifsFileInfo *src,
+			struct cifsFileInfo *target_file, u64 src_off, u64 len,
+			u64 dest_off);
 	int (*validate_negotiate)(const unsigned int, struct cifs_tcon *);
 	ssize_t (*query_all_EAs)(const unsigned int, struct cifs_tcon *,
 			const unsigned char *, const unsigned char *, char *,
diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
index 998a66f..47b030d 100644
--- a/fs/cifs/cifspdu.h
+++ b/fs/cifs/cifspdu.h
@@ -2255,6 +2255,8 @@ typedef struct {
 
 
 /* List of FileSystemAttributes - see 2.5.1 of MS-FSCC */
+#define FILE_SUPPORTS_SPARSE_VDL	0x10000000 /* faster nonsparse extend */
+#define FILE_SUPPORTS_BLOCK_REFCOUNTING	0x08000000 /* allow ioctl dup extents */
 #define FILE_SUPPORT_INTEGRITY_STREAMS	0x04000000
 #define FILE_SUPPORTS_USN_JOURNAL	0x02000000
 #define FILE_SUPPORTS_OPEN_BY_FILE_ID	0x01000000
diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 8b7898b..7843b19 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -31,12 +31,14 @@
 #include "cifsproto.h"
 #include "cifs_debug.h"
 #include "cifsfs.h"
+#include <linux/btrfs.h>
 
 #define CIFS_IOCTL_MAGIC	0xCF
 #define CIFS_IOC_COPYCHUNK_FILE	_IOW(CIFS_IOCTL_MAGIC, 3, int)
 
 static long cifs_ioctl_clone(unsigned int xid, struct file *dst_file,
-			unsigned long srcfd, u64 off, u64 len, u64 destoff)
+			unsigned long srcfd, u64 off, u64 len, u64 destoff,
+			bool dup_extents)
 {
 	int rc;
 	struct cifsFileInfo *smb_file_target = dst_file->private_data;
@@ -109,9 +111,14 @@ static long cifs_ioctl_clone(unsigned int xid, struct file *dst_file,
 	truncate_inode_pages_range(&target_inode->i_data, destoff,
 				   PAGE_CACHE_ALIGN(destoff + len)-1);
 
-	if (target_tcon->ses->server->ops->clone_range)
+	if (dup_extents && target_tcon->ses->server->ops->duplicate_extents)
+		rc = target_tcon->ses->server->ops->duplicate_extents(xid,
+			smb_file_src, smb_file_target, off, len, destoff);
+	else if (!dup_extents && target_tcon->ses->server->ops->clone_range)
 		rc = target_tcon->ses->server->ops->clone_range(xid,
 			smb_file_src, smb_file_target, off, len, destoff);
+	else
+		rc = -EOPNOTSUPP;
 
 	/* force revalidate of size and timestamps of target file now
 	   that target is updated on the server */
@@ -205,7 +212,10 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 			}
 			break;
 		case CIFS_IOC_COPYCHUNK_FILE:
-			rc = cifs_ioctl_clone(xid, filep, arg, 0, 0, 0);
+			rc = cifs_ioctl_clone(xid, filep, arg, 0, 0, 0, false);
+			break;
+		case BTRFS_IOC_CLONE:
+			rc = cifs_ioctl_clone(xid, filep, arg, 0, 0, 0, true);
 			break;
 		default:
 			cifs_dbg(FYI, "unsupported ioctl\n");
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index c7d228c..b1e9c0f 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -806,6 +806,53 @@ smb2_set_file_size(const unsigned int xid, struct cifs_tcon *tcon,
 			    cfile->fid.volatile_fid, cfile->pid, &eof, false);
 }
 
+#ifdef CONFIG_CIFS_SMB311
+static int
+smb2_duplicate_extents(const unsigned int xid,
+			struct cifsFileInfo *srcfile,
+			struct cifsFileInfo *trgtfile, u64 src_off,
+			u64 len, u64 dest_off)
+{
+	int rc;
+	unsigned int ret_data_len;
+	char *retbuf = NULL;
+	struct duplicate_extents_to_file dup_ext_buf;
+	struct cifs_tcon *tcon = tlink_tcon(trgtfile->tlink);
+
+	/* server fileays advertise duplicate extent support with this flag */
+	if ((le32_to_cpu(tcon->fsAttrInfo.Attributes) &
+	     FILE_SUPPORTS_BLOCK_REFCOUNTING) == 0)
+		return -EOPNOTSUPP;
+
+	dup_ext_buf.VolatileFileHandle = srcfile->fid.volatile_fid;
+	dup_ext_buf.PersistentFileHandle = srcfile->fid.persistent_fid;
+	dup_ext_buf.SourceFileOffset = cpu_to_le64(src_off);
+	dup_ext_buf.TargetFileOffset = cpu_to_le64(dest_off);
+	dup_ext_buf.ByteCount = cpu_to_le64(len);
+	cifs_dbg(FYI, "duplicate extents: src off %lld dst off %lld len %lld",
+		src_off, dest_off, len);
+
+	rc = smb2_set_file_size(xid, tcon, trgtfile, dest_off + len, false);
+	if (rc)
+		goto duplicate_extents_out;
+
+	rc = SMB2_ioctl(xid, tcon, trgtfile->fid.persistent_fid,
+			trgtfile->fid.volatile_fid,
+			FSCTL_DUPLICATE_EXTENTS_TO_FILE,
+			true /* is_fsctl */, (char *)&dup_ext_buf,
+			sizeof(struct duplicate_extents_to_file),
+			(char **)&retbuf,
+			&ret_data_len);
+
+	if (ret_data_len > 0)
+		cifs_dbg(FYI, "non-zero response length in duplicate extents");
+
+duplicate_extents_out:
+	return rc;
+}
+#endif /* CONFIG_CIFS_SMB311 */
+
+
 static int
 smb2_set_compression(const unsigned int xid, struct cifs_tcon *tcon,
 		   struct cifsFileInfo *cfile)
@@ -1714,6 +1761,7 @@ struct smb_version_operations smb311_operations = {
 	.create_lease_buf = smb3_create_lease_buf,
 	.parse_lease_buf = smb3_parse_lease_buf,
 	.clone_range = smb2_clone_range,
+	.duplicate_extents = smb2_duplicate_extents,
 /*	.validate_negotiate = smb3_validate_negotiate, */ /* not used in 3.11 */
 	.wp_retry_size = smb2_wp_retry_size,
 	.dir_needs_close = smb2_dir_needs_close,
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 725283a..8e7bbe5 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -654,6 +654,14 @@ struct compress_ioctl {
 	__le16 CompressionState; /* See cifspdu.h for possible flag values */
 } __packed;
 
+struct duplicate_extents_to_file {
+	__u64 PersistentFileHandle; /* source file handle, opaque endianness */
+	__u64 VolatileFileHandle;
+	__le64 SourceFileOffset;
+	__le64 TargetFileOffset;
+	__le64 ByteCount;  /* Bytes to be copied */
+} __packed;
+
 struct smb2_ioctl_req {
 	struct smb2_hdr hdr;
 	__le16 StructureSize;	/* Must be 57 */
diff --git a/fs/cifs/smbfsctl.h b/fs/cifs/smbfsctl.h
index 83efa59..d098da6 100644
--- a/fs/cifs/smbfsctl.h
+++ b/fs/cifs/smbfsctl.h
@@ -78,6 +78,7 @@
 #define FSCTL_QUERY_ALLOCATED_RANGES 0x000940CF /* BB add struct */
 #define FSCTL_SET_DEFECT_MANAGEMENT  0x00098134 /* BB add struct */
 #define FSCTL_FILE_LEVEL_TRIM        0x00098208 /* BB add struct */
+#define FSCTL_DUPLICATE_EXTENTS_TO_FILE 0x00098344
 #define FSCTL_SIS_LINK_FILES         0x0009C104
 #define FSCTL_PIPE_PEEK              0x0011400C /* BB add struct */
 #define FSCTL_PIPE_TRANSCEIVE        0x0011C017 /* BB add struct */
-- 
2.1.4

