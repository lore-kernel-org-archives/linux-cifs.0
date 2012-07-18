From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 45/45] CIFS: Add statfs support for SMB2
Date: Wed, 18 Jul 2012 19:49:01 +0400
Message-ID: <1342626541-29872-46-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/smb2glob.h  |    2 +
 fs/cifs/smb2ops.c   |   22 ++++++++++++++
 fs/cifs/smb2pdu.c   |   81 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.h   |   19 ++++++++++++
 fs/cifs/smb2proto.h |    3 ++
 5 files changed, 127 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/smb2glob.h b/fs/cifs/smb2glob.h
index 05d429b..7c0e214 100644
--- a/fs/cifs/smb2glob.h
+++ b/fs/cifs/smb2glob.h
@@ -23,6 +23,8 @@
 #ifndef _SMB2_GLOB_H
 #define _SMB2_GLOB_H
 
+#define SMB2_MAGIC_NUMBER 0xFE534D42
+
 /*
  *****************************************************************
  * Constants go here
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 99dbb8c..a1333d2 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -17,12 +17,14 @@
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#include <linux/vfs.h>
 #include "cifsglob.h"
 #include "smb2pdu.h"
 #include "smb2proto.h"
 #include "cifsproto.h"
 #include "cifs_debug.h"
 #include "smb2status.h"
+#include "smb2glob.h"
 
 static int
 change_conf(struct TCP_Server_Info *server)
@@ -501,6 +503,25 @@ smb2_oplock_response(struct cifs_tcon *tcon, struct cifs_fid *fid,
 				 cinode->clientCanCacheRead ? 1 : 0);
 }
 
+static int
+smb2_queryfs(const unsigned int xid, struct cifs_tcon *tcon,
+	     struct kstatfs *buf)
+{
+	int rc;
+	u64 persistent_fid, volatile_fid;
+	__le16 srch_path = 0; /* Null - open root of share */
+	u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
+
+	rc = SMB2_open(xid, tcon, &srch_path, &persistent_fid, &volatile_fid,
+		       FILE_READ_ATTRIBUTES, FILE_OPEN, 0, 0, &oplock, NULL);
+	if (rc)
+		return rc;
+	buf->f_type = SMB2_MAGIC_NUMBER;
+	rc = SMB2_QFS_info(xid, tcon, persistent_fid, volatile_fid, buf);
+	SMB2_close(xid, tcon, persistent_fid, volatile_fid);
+	return rc;
+}
+
 struct smb_version_operations smb21_operations = {
 	.setup_request = smb2_setup_request,
 	.setup_async_request = smb2_setup_async_request,
@@ -557,6 +578,7 @@ struct smb_version_operations smb21_operations = {
 	.calc_smb_size = smb2_calc_size,
 	.is_status_pending = smb2_is_status_pending,
 	.oplock_response = smb2_oplock_response,
+	.queryfs = smb2_queryfs,
 };
 
 struct smb_version_values smb21_values = {
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index a04917e..61a4b88 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1971,3 +1971,84 @@ SMB2_oplock_break(const unsigned int xid, struct cifs_tcon *tcon,
 
 	return rc;
 }
+
+static void
+copy_fs_info_to_kstatfs(struct smb2_fs_full_size_info *pfs_inf,
+			struct kstatfs *kst)
+{
+	kst->f_bsize = le32_to_cpu(pfs_inf->BytesPerSector) *
+			  le32_to_cpu(pfs_inf->SectorsPerAllocationUnit);
+	kst->f_blocks = le64_to_cpu(pfs_inf->TotalAllocationUnits);
+	kst->f_bfree  = le64_to_cpu(pfs_inf->ActualAvailableAllocationUnits);
+	kst->f_bavail = le64_to_cpu(pfs_inf->CallerAvailableAllocationUnits);
+	return;
+}
+
+static int
+build_qfs_info_req(struct kvec *iov, struct cifs_tcon *tcon, int level,
+		   int outbuf_len, u64 persistent_fid, u64 volatile_fid)
+{
+	int rc;
+	struct smb2_query_info_req *req;
+
+	cFYI(1, "Query FSInfo level %d", level);
+
+	if ((tcon->ses == NULL) || (tcon->ses->server == NULL))
+		return -EIO;
+
+	rc = small_smb2_init(SMB2_QUERY_INFO, tcon, (void **) &req);
+	if (rc)
+		return rc;
+
+	req->InfoType = SMB2_O_INFO_FILESYSTEM;
+	req->FileInfoClass = level;
+	req->PersistentFileId = persistent_fid;
+	req->VolatileFileId = volatile_fid;
+	/* 4 for rfc1002 length field and 1 for pad */
+	req->InputBufferOffset =
+			cpu_to_le16(sizeof(struct smb2_query_info_req) - 1 - 4);
+	req->OutputBufferLength = cpu_to_le32(
+		outbuf_len + sizeof(struct smb2_query_info_rsp) - 1 - 4);
+
+	iov->iov_base = (char *)req;
+	/* 4 for rfc1002 length field */
+	iov->iov_len = get_rfc1002_length(req) + 4;
+	return 0;
+}
+
+int
+SMB2_QFS_info(const unsigned int xid, struct cifs_tcon *tcon,
+	      u64 persistent_fid, u64 volatile_fid, struct kstatfs *fsdata)
+{
+	struct smb2_query_info_rsp *rsp = NULL;
+	struct kvec iov;
+	int rc = 0;
+	int resp_buftype;
+	struct cifs_ses *ses = tcon->ses;
+	struct smb2_fs_full_size_info *info = NULL;
+
+	rc = build_qfs_info_req(&iov, tcon, FS_FULL_SIZE_INFORMATION,
+				sizeof(struct smb2_fs_full_size_info),
+				persistent_fid, volatile_fid);
+	if (rc)
+		return rc;
+
+	rc = SendReceive2(xid, ses, &iov, 1, &resp_buftype, 0);
+	if (rc) {
+		cifs_stats_fail_inc(tcon, SMB2_QUERY_INFO_HE);
+		goto qinf_exit;
+	}
+	rsp = (struct smb2_query_info_rsp *)iov.iov_base;
+
+	info = (struct smb2_fs_full_size_info *)(4 /* RFC1001 len */ +
+		le16_to_cpu(rsp->OutputBufferOffset) + (char *)&rsp->hdr);
+	rc = validate_buf(le16_to_cpu(rsp->OutputBufferOffset),
+			  le32_to_cpu(rsp->OutputBufferLength), &rsp->hdr,
+			  sizeof(struct smb2_fs_full_size_info));
+	if (!rc)
+		copy_fs_info_to_kstatfs(info, fsdata);
+
+qinf_exit:
+	free_rsp_buf(resp_buftype, iov.iov_base);
+	return rc;
+}
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 0e5afb7..30c7d73 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -628,6 +628,25 @@ struct smb2_oplock_break {
  *	BB consider moving to a different header
  */
 
+/* File System Information Classes */
+#define FS_VOLUME_INFORMATION		1 /* Query */
+#define FS_LABEL_INFORMATION		2 /* Set */
+#define FS_SIZE_INFORMATION		3 /* Query */
+#define FS_DEVICE_INFORMATION		4 /* Query */
+#define FS_ATTRIBUTE_INFORMATION	5 /* Query */
+#define FS_CONTROL_INFORMATION		6 /* Query, Set */
+#define FS_FULL_SIZE_INFORMATION	7 /* Query */
+#define FS_OBJECT_ID_INFORMATION	8 /* Query, Set */
+#define FS_DRIVER_PATH_INFORMATION	9 /* Query */
+
+struct smb2_fs_full_size_info {
+	__le64 TotalAllocationUnits;
+	__le64 CallerAvailableAllocationUnits;
+	__le64 ActualAvailableAllocationUnits;
+	__le32 SectorsPerAllocationUnit;
+	__le32 BytesPerSector;
+} __packed;
+
 /* partial list of QUERY INFO levels */
 #define FILE_DIRECTORY_INFORMATION	1
 #define FILE_FULL_DIRECTORY_INFORMATION 2
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index de554b7..a73a963 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -138,5 +138,8 @@ extern int SMB2_set_info(const unsigned int xid, struct cifs_tcon *tcon,
 extern int SMB2_oplock_break(const unsigned int xid, struct cifs_tcon *tcon,
 			     const u64 persistent_fid, const u64 volatile_fid,
 			     const __u8 oplock_level);
+extern int SMB2_QFS_info(const unsigned int xid, struct cifs_tcon *tcon,
+			 u64 persistent_file_id, u64 volatile_file_id,
+			 struct kstatfs *FSData);
 
 #endif			/* _SMB2PROTO_H */
-- 
1.7.1
