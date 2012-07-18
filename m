From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 43/45] CIFS: Add oplock break support for SMB2
Date: Wed, 18 Jul 2012 19:48:59 +0400
Message-ID: <1342626541-29872-44-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/smb2misc.c  |   75 +++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/cifs/smb2ops.c   |   19 +++++++++++-
 fs/cifs/smb2pdu.c   |   35 +++++++++++++++++++++++
 fs/cifs/smb2pdu.h   |   10 +++++++
 fs/cifs/smb2proto.h |    5 +++
 5 files changed, 140 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 81fb162..15e0d8d 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -141,8 +141,8 @@ smb2_check_message(char *buf, unsigned int length)
 	}
 
 	if (smb2_rsp_struct_sizes[command] != pdu->StructureSize2) {
-		if (hdr->Status == 0 ||
-		    pdu->StructureSize2 != SMB2_ERROR_STRUCTURE_SIZE2) {
+		if (command != SMB2_OPLOCK_BREAK_HE && (hdr->Status == 0 ||
+		    pdu->StructureSize2 != SMB2_ERROR_STRUCTURE_SIZE2)) {
 			/* error packets have 9 byte structure size */
 			cERROR(1, "Illegal response size %u for command %d",
 				   le16_to_cpu(pdu->StructureSize2), command);
@@ -161,6 +161,8 @@ smb2_check_message(char *buf, unsigned int length)
 	if (4 + len != clc_len) {
 		cFYI(1, "Calculated size %u length %u mismatch mid %llu",
 			clc_len, 4 + len, mid);
+		if (clc_len + 20 == len && command == SMB2_OPLOCK_BREAK_HE)
+			return 0; /* Windows 7 server returns 24 bytes more */
 		if (clc_len == 4 + len + 1) /* BB FIXME (fix samba) */
 			return 0; /* BB workaround Samba 3 bug SessSetup rsp */
 		return 1;
@@ -354,3 +356,72 @@ cifs_convert_path_to_utf16(const char *from, struct cifs_sb_info *cifs_sb)
 					CIFS_MOUNT_MAP_SPECIAL_CHR);
 	return to;
 }
+
+bool
+smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
+{
+	struct smb2_oplock_break *rsp = (struct smb2_oplock_break *)buffer;
+	struct list_head *tmp, *tmp1, *tmp2;
+	struct cifs_ses *ses;
+	struct cifs_tcon *tcon;
+	struct cifsInodeInfo *cinode;
+	struct cifsFileInfo *cfile;
+
+	cFYI(1, "Checking for oplock break");
+
+	if (rsp->hdr.Command != SMB2_OPLOCK_BREAK)
+		return false;
+
+	if (le16_to_cpu(rsp->StructureSize) !=
+				smb2_rsp_struct_sizes[SMB2_OPLOCK_BREAK_HE]) {
+		return false;
+	}
+
+	cFYI(1, "oplock level 0x%d", rsp->OplockLevel);
+
+	/* look up tcon based on tid & uid */
+	spin_lock(&cifs_tcp_ses_lock);
+	list_for_each(tmp, &server->smb_ses_list) {
+		ses = list_entry(tmp, struct cifs_ses, smb_ses_list);
+		list_for_each(tmp1, &ses->tcon_list) {
+			tcon = list_entry(tmp1, struct cifs_tcon, tcon_list);
+
+			cifs_stats_inc(&tcon->stats.cifs_stats.num_oplock_brks);
+			spin_lock(&cifs_file_list_lock);
+			list_for_each(tmp2, &tcon->openFileList) {
+				cfile = list_entry(tmp2, struct cifsFileInfo,
+						     tlist);
+				if (rsp->PersistentFid !=
+				    cfile->fid.persistent_fid ||
+				    rsp->VolatileFid !=
+				    cfile->fid.volatile_fid)
+					continue;
+
+				cFYI(1, "file id match, oplock break");
+				cinode = CIFS_I(cfile->dentry->d_inode);
+
+				if (!cinode->clientCanCacheAll &&
+				    rsp->OplockLevel == SMB2_OPLOCK_LEVEL_NONE)
+					cfile->oplock_break_cancelled = true;
+				else
+					cfile->oplock_break_cancelled = false;
+
+				smb2_set_oplock_level(cinode,
+				  rsp->OplockLevel ? SMB2_OPLOCK_LEVEL_II : 0);
+
+				queue_work(cifsiod_wq, &cfile->oplock_break);
+
+				spin_unlock(&cifs_file_list_lock);
+				spin_unlock(&cifs_tcp_ses_lock);
+				return true;
+			}
+			spin_unlock(&cifs_file_list_lock);
+			spin_unlock(&cifs_tcp_ses_lock);
+			cFYI(1, "No matching file for oplock break");
+			return true;
+		}
+	}
+	spin_unlock(&cifs_tcp_ses_lock);
+	cFYI(1, "Can not process oplock break for non-existent connection");
+	return false;
+}
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 25f4263..99dbb8c 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -483,11 +483,24 @@ smb2_is_status_pending(char *buf, struct TCP_Server_Info *server, int length)
 	if (le32_to_cpu(hdr->Status) != STATUS_PENDING)
 		return false;
 
-	if (!length)
-		add_credits(server, le16_to_cpu(hdr->CreditRequest), 0);
+	if (!length) {
+		spin_lock(&server->req_lock);
+		server->credits += le16_to_cpu(hdr->CreditRequest);
+		spin_unlock(&server->req_lock);
+		wake_up(&server->request_q);
+	}
 	return true;
 }
 
+static int
+smb2_oplock_response(struct cifs_tcon *tcon, struct cifs_fid *fid,
+		     struct cifsInodeInfo *cinode)
+{
+	return SMB2_oplock_break(0, tcon, fid->persistent_fid,
+				 fid->volatile_fid,
+				 cinode->clientCanCacheRead ? 1 : 0);
+}
+
 struct smb_version_operations smb21_operations = {
 	.setup_request = smb2_setup_request,
 	.setup_async_request = smb2_setup_async_request,
@@ -505,6 +518,7 @@ struct smb_version_operations smb21_operations = {
 	.dump_detail = smb2_dump_detail,
 	.clear_stats = smb2_clear_stats,
 	.print_stats = smb2_print_stats,
+	.is_oplock_break = smb2_is_valid_oplock_break,
 	.need_neg = smb2_need_neg,
 	.negotiate = smb2_negotiate,
 	.negotiate_wsize = smb2_negotiate_wsize,
@@ -542,6 +556,7 @@ struct smb_version_operations smb21_operations = {
 	.close_dir = smb2_close_dir,
 	.calc_smb_size = smb2_calc_size,
 	.is_status_pending = smb2_is_status_pending,
+	.oplock_response = smb2_oplock_response,
 };
 
 struct smb_version_values smb21_values = {
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 58c1e91..a04917e 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1936,3 +1936,38 @@ SMB2_set_info(const unsigned int xid, struct cifs_tcon *tcon,
 			     current->tgid, FILE_BASIC_INFORMATION, 1,
 			     (void **)&buf, &size);
 }
+
+int
+SMB2_oplock_break(const unsigned int xid, struct cifs_tcon *tcon,
+		  const u64 persistent_fid, const u64 volatile_fid,
+		  __u8 oplock_level)
+{
+	int rc = 0, buf_type;
+	struct smb2_oplock_break *req = NULL;
+	struct kvec iov[1];
+
+	cFYI(1, "SMB2_oplock_break");
+	rc = small_smb2_init(SMB2_OPLOCK_BREAK, tcon, (void **) &req);
+
+	if (rc)
+		return rc;
+
+	req->VolatileFid = volatile_fid;
+	req->PersistentFid = persistent_fid;
+	req->OplockLevel = oplock_level;
+	req->hdr.CreditRequest = cpu_to_le16(1);
+
+	iov->iov_base = (char *)req;
+	/* 4 for rfc1002 length */
+	iov->iov_len = get_rfc1002_length(req) + 4;
+
+	rc = SendReceive2(xid, tcon->ses, iov, 1, &buf_type, CIFS_OBREAK_OP);
+	/* SMB2 buffer freed by function above */
+
+	if (rc) {
+		cifs_stats_fail_inc(tcon, SMB2_OPLOCK_BREAK_HE);
+		cFYI(1, "Send error in Oplock Break = %d", rc);
+	}
+
+	return rc;
+}
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index cd64385..0e5afb7 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -613,6 +613,16 @@ struct smb2_set_info_rsp {
 	__le16 StructureSize; /* Must be 2 */
 } __packed;
 
+struct smb2_oplock_break {
+	struct smb2_hdr hdr;
+	__le16 StructureSize; /* Must be 24 */
+	__u8   OplockLevel;
+	__u8   Reserved;
+	__le32 Reserved2;
+	__u64  PersistentFid;
+	__u64  VolatileFid;
+} __packed;
+
 /*
  *	PDU infolevel structure definitions
  *	BB consider moving to a different header
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index d18339f..de554b7 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -49,6 +49,8 @@ extern int smb2_setup_async_request(struct TCP_Server_Info *server,
 				    struct kvec *iov, unsigned int nvec,
 				    struct mid_q_entry **ret_mid);
 extern void smb2_echo_request(struct work_struct *work);
+extern bool smb2_is_valid_oplock_break(char *buffer,
+				       struct TCP_Server_Info *srv);
 
 extern void move_smb2_info_to_cifs(FILE_ALL_INFO *dst,
 				   struct smb2_file_all_info *src);
@@ -133,5 +135,8 @@ extern int SMB2_set_eof(const unsigned int xid, struct cifs_tcon *tcon,
 extern int SMB2_set_info(const unsigned int xid, struct cifs_tcon *tcon,
 			 u64 persistent_fid, u64 volatile_fid,
 			 FILE_BASIC_INFO *buf);
+extern int SMB2_oplock_break(const unsigned int xid, struct cifs_tcon *tcon,
+			     const u64 persistent_fid, const u64 volatile_fid,
+			     const __u8 oplock_level);
 
 #endif			/* _SMB2PROTO_H */
-- 
1.7.1
