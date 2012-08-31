From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 3/7] CIFS: Handle SMB2 lock flags
Date: Fri, 31 Aug 2012 13:41:24 +0400
Message-ID: <1346406088-4537-4-git-send-email-pshilovsky@etersoft.ru>
References: <1346406088-4537-1-git-send-email-pshilovsky@etersoft.ru>
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1346406088-4537-1-git-send-email-pshilovsky-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/smb2ops.c |   12 ++++++++++++
 fs/cifs/smb2pdu.h |    5 +++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index b1dedf8..e4a59d1 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -537,7 +537,15 @@ smb2_queryfs(const unsigned int xid, struct cifs_tcon *tcon,
 	return rc;
 }
 
+static bool
+smb2_compare_fids(struct cifsFileInfo *ob1, struct cifsFileInfo *ob2)
+{
+	return ob1->fid.persistent_fid == ob2->fid.persistent_fid &&
+	       ob1->fid.volatile_fid == ob2->fid.volatile_fid;
+}
+
 struct smb_version_operations smb21_operations = {
+	.compare_fids = smb2_compare_fids,
 	.setup_request = smb2_setup_request,
 	.setup_async_request = smb2_setup_async_request,
 	.check_receive = smb2_check_receive,
@@ -598,6 +606,10 @@ struct smb_version_operations smb21_operations = {
 
 struct smb_version_values smb21_values = {
 	.version_string = SMB21_VERSION_STRING,
+	.large_lock_type = 0,
+	.exclusive_lock_type = SMB2_LOCKFLAG_EXCLUSIVE_LOCK,
+	.shared_lock_type = SMB2_LOCKFLAG_SHARED_LOCK,
+	.unlock_lock_type = SMB2_LOCKFLAG_UNLOCK,
 	.header_size = sizeof(struct smb2_hdr),
 	.max_header_size = MAX_SMB2_HDR_SIZE,
 	.read_rsp_size = sizeof(struct smb2_read_rsp) - 1,
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 4b31825..d12d868 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -526,6 +526,11 @@ struct smb2_write_rsp {
 	__u8   Buffer[1];
 } __packed;
 
+#define SMB2_LOCKFLAG_SHARED_LOCK	0x0001
+#define SMB2_LOCKFLAG_EXCLUSIVE_LOCK	0x0002
+#define SMB2_LOCKFLAG_UNLOCK		0x0004
+#define SMB2_LOCKFLAG_FAIL_IMMEDIATELY	0x0010
+
 struct smb2_echo_req {
 	struct smb2_hdr hdr;
 	__le16 StructureSize;	/* Must be 4 */
-- 
1.7.1
