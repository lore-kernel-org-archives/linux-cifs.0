From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 06/10] CIFS: Add SMB2.1 lease break support
Date: Mon, 20 Aug 2012 22:42:56 +0400
Message-ID: <1345488180-5942-7-git-send-email-pshilovsky@samba.org>
References: <1345488180-5942-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1345488180-5942-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/smb2file.c  |    2 +
 fs/cifs/smb2misc.c  |  132 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/cifs/smb2ops.c   |    4 ++
 fs/cifs/smb2pdu.c   |   46 +++++++++++++-----
 fs/cifs/smb2pdu.h   |   25 ++++++++++
 fs/cifs/smb2proto.h |    4 ++
 6 files changed, 199 insertions(+), 14 deletions(-)

diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index b344bd3..2782a33 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -38,6 +38,8 @@ void
 smb2_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock)
 {
 	oplock &= 0xFF;
+	if (oplock == SMB2_OPLOCK_LEVEL_NOCHANGE)
+		return;
 	if (oplock == SMB2_OPLOCK_LEVEL_EXCLUSIVE) {
 		cinode->clientCanCacheAll = true;
 		cinode->clientCanCacheRead = true;
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 01479a3..877bccb 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -148,6 +148,13 @@ smb2_check_message(char *buf, unsigned int length)
 			cERROR(1, "Illegal response size %u for command %d",
 				   le16_to_cpu(pdu->StructureSize2), command);
 			return 1;
+		} else if (command == SMB2_OPLOCK_BREAK_HE && (hdr->Status == 0)
+			   && (le16_to_cpu(pdu->StructureSize2) != 44)
+			   && (le16_to_cpu(pdu->StructureSize2) != 36)) {
+			/* special case for SMB2.1 lease break message */
+			cERROR(1, "Illegal response size %d for oplock break",
+				   le16_to_cpu(pdu->StructureSize2));
+			return 1;
 		}
 	}
 
@@ -360,6 +367,126 @@ cifs_convert_path_to_utf16(const char *from, struct cifs_sb_info *cifs_sb)
 	return to;
 }
 
+__le32
+smb2_get_lease_state(struct cifsInodeInfo *cinode)
+{
+	if (cinode->clientCanCacheAll)
+		return SMB2_LEASE_WRITE_CACHING | SMB2_LEASE_READ_CACHING;
+	else if (cinode->clientCanCacheRead)
+		return SMB2_LEASE_READ_CACHING;
+	return 0;
+}
+
+__u8 smb2_map_lease_to_oplock(__le32 lease_state)
+{
+	if (lease_state & SMB2_LEASE_WRITE_CACHING) {
+		if (lease_state & SMB2_LEASE_HANDLE_CACHING)
+			return SMB2_OPLOCK_LEVEL_BATCH;
+		else
+			return SMB2_OPLOCK_LEVEL_EXCLUSIVE;
+	} else if (lease_state & SMB2_LEASE_READ_CACHING)
+		return SMB2_OPLOCK_LEVEL_II;
+	return 0;
+}
+
+struct smb2_lease_work {
+	void *buf;
+	struct TCP_Server_Info *server;
+	struct work_struct lease_break;
+};
+
+static void
+smb2_lease_work_f(struct work_struct *work)
+{
+	struct smb2_lease_work *lw = container_of(work, struct smb2_lease_work,
+						  lease_break);
+	struct smb2_lease_break *rsp = (struct smb2_lease_break *)lw->buf;
+	struct TCP_Server_Info *server = lw->server;
+	struct list_head *tmp, *tmp1, *tmp2;
+	struct cifs_ses *ses;
+	struct cifs_tcon *tcon;
+	struct cifsInodeInfo *cinode;
+	struct cifsFileInfo *cfile;
+
+	cFYI(1, "Checking for lease break");
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
+				cinode = CIFS_I(cfile->dentry->d_inode);
+
+				if (memcmp(cinode->lease_key, rsp->LeaseKey,
+					   SMB2_LEASE_KEY_SIZE))
+					continue;
+
+				cFYI(1, "lease key match, lease break 0x%d",
+				     le32_to_cpu(rsp->NewLeaseState));
+
+				smb2_set_oplock_level(cinode,
+				  smb2_map_lease_to_oplock(rsp->NewLeaseState));
+
+				if (rsp->Flags &
+				    SMB2_NOTIFY_BREAK_LEASE_FLAG_ACK_REQUIRED)
+					cfile->oplock_break_cancelled = false;
+				else
+					cfile->oplock_break_cancelled = true;
+
+				queue_work(cifsiod_wq, &cfile->oplock_break);
+
+				spin_unlock(&cifs_file_list_lock);
+				spin_unlock(&cifs_tcp_ses_lock);
+				kfree(lw->buf);
+				kfree(lw);
+				return;
+			}
+			spin_unlock(&cifs_file_list_lock);
+		}
+	}
+	spin_unlock(&cifs_tcp_ses_lock);
+
+	cFYI(1, "Can not process lease break - no lease matched");
+	cERROR(1, "No task to wake, unknown frame received! NumMids %d",
+		  atomic_read(&midCount));
+
+	cifs_dump_mem("Received Data is: ", lw->buf, HEADER_SIZE(server));
+#ifdef CONFIG_CIFS_DEBUG2
+	if (server->ops->dump_detail)
+		server->ops->dump_detail(lw->buf);
+	cifs_dump_mids(server);
+#endif /* CIFS_DEBUG2 */
+	kfree(lw->buf);
+	kfree(lw);
+}
+
+static bool
+smb2_is_valid_lease_break(char *buffer, struct TCP_Server_Info *server)
+{
+	struct smb2_lease_work *lw = kmalloc(sizeof(struct smb2_lease_work),
+					     GFP_KERNEL);
+	if (!lw)
+		return false;
+	lw->buf = kmalloc(get_rfc1002_length(buffer) + 4 /* rfc1002 length */,
+			  GFP_KERNEL);
+	if (!lw->buf) {
+		kfree(lw);
+		return false;
+	}
+	memcpy(lw->buf, buffer, get_rfc1002_length(buffer) + 4);
+	lw->server = server;
+	INIT_WORK(&lw->lease_break, smb2_lease_work_f);
+	queue_work(cifsiod_wq, &lw->lease_break);
+	return true;
+}
+
 bool
 smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
 {
@@ -377,7 +504,10 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
 
 	if (le16_to_cpu(rsp->StructureSize) !=
 				smb2_rsp_struct_sizes[SMB2_OPLOCK_BREAK_HE]) {
-		return false;
+		if (le16_to_cpu(rsp->StructureSize) == 44)
+			return smb2_is_valid_lease_break(buffer, server);
+		else
+			return false;
 	}
 
 	cFYI(1, "oplock level 0x%d", rsp->OplockLevel);
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 360d907..6a11190 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -513,6 +513,10 @@ static int
 smb2_oplock_response(struct cifs_tcon *tcon, struct cifs_fid *fid,
 		     struct cifsInodeInfo *cinode)
 {
+	if (tcon->ses->server->dialect == SMB21_PROT_ID)
+		return SMB2_lease_break(0, tcon, cinode->lease_key,
+					smb2_get_lease_state(cinode));
+
 	return SMB2_oplock_break(0, tcon, fid->persistent_fid,
 				 fid->volatile_fid,
 				 cinode->clientCanCacheRead ? 1 : 0);
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 23ae3b3..8466031 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -907,7 +907,6 @@ parse_lease_state(struct smb2_create_rsp *rsp)
 {
 	char *data_offset;
 	struct create_lease *lc;
-	__u8 oplock = 0;
 	bool found = false;
 
 	data_offset = (char *)rsp;
@@ -928,19 +927,9 @@ parse_lease_state(struct smb2_create_rsp *rsp)
 	} while (le32_to_cpu(lc->ccontext.Next) != 0);
 
 	if (!found)
-		return oplock;
-
-	if (le32_to_cpu(lc->lcontext.LeaseState) & SMB2_LEASE_WRITE_CACHING) {
-		if (le32_to_cpu(lc->lcontext.LeaseState) &
-						SMB2_LEASE_HANDLE_CACHING)
-			oplock = SMB2_OPLOCK_LEVEL_BATCH;
-		else
-			oplock = SMB2_OPLOCK_LEVEL_EXCLUSIVE;
-	} else if (le32_to_cpu(lc->lcontext.LeaseState) &
-						SMB2_LEASE_READ_CACHING)
-		oplock = SMB2_OPLOCK_LEVEL_II;
+		return 0;
 
-	return oplock;
+	return smb2_map_lease_to_oplock(lc->lcontext.LeaseState);
 }
 
 int
@@ -2224,3 +2213,34 @@ SMB2_lock(const unsigned int xid, struct cifs_tcon *tcon,
 
 	return smb2_lockv(xid, tcon, persist_fid, volatile_fid, pid, 1, &lock);
 }
+
+int
+SMB2_lease_break(const unsigned int xid, struct cifs_tcon *tcon,
+		 __u8 *lease_key, const __le32 lease_state)
+{
+	int rc;
+	struct smb2_lease_ack *req = NULL;
+
+	cFYI(1, "SMB2_lease_break");
+	rc = small_smb2_init(SMB2_OPLOCK_BREAK, tcon, (void **) &req);
+
+	if (rc)
+		return rc;
+
+	req->hdr.CreditRequest = cpu_to_le16(1);
+	req->StructureSize = cpu_to_le16(36);
+	inc_rfc1001_len(req, 12);
+
+	memcpy(req->LeaseKey, lease_key, 16);
+	req->LeaseState = lease_state;
+
+	rc = SendReceiveNoRsp(xid, tcon->ses, (char *) req, CIFS_OBREAK_OP);
+	/* SMB2 buffer freed by function above */
+
+	if (rc) {
+		cifs_stats_fail_inc(tcon, SMB2_OPLOCK_BREAK_HE);
+		cFYI(1, "Send error in Lease Break = %d", rc);
+	}
+
+	return rc;
+}
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index a9eeb1b..d0c2468 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -693,6 +693,31 @@ struct smb2_oplock_break {
 	__u64  VolatileFid;
 } __packed;
 
+#define SMB2_NOTIFY_BREAK_LEASE_FLAG_ACK_REQUIRED cpu_to_le32(0x01)
+
+struct smb2_lease_break {
+	struct smb2_hdr hdr;
+	__le16 StructureSize; /* Must be 44 */
+	__le16 Reserved;
+	__le32 Flags;
+	__u8   LeaseKey[16];
+	__le32 CurrentLeaseState;
+	__le32 NewLeaseState;
+	__le32 BreakReason;
+	__le32 AccessMaskHint;
+	__le32 ShareMaskHint;
+} __packed;
+
+struct smb2_lease_ack {
+	struct smb2_hdr hdr;
+	__le16 StructureSize; /* Must be 36 */
+	__le16 Reserved;
+	__le32 Flags;
+	__u8   LeaseKey[16];
+	__le32 LeaseState;
+	__le64 LeaseDuration;
+} __packed;
+
 /*
  *	PDU infolevel structure definitions
  *	BB consider moving to a different header
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 8b4d371..7d25f8b 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -48,6 +48,8 @@ extern struct mid_q_entry *smb2_setup_request(struct cifs_ses *ses,
 extern struct mid_q_entry *smb2_setup_async_request(
 			struct TCP_Server_Info *server, struct smb_rqst *rqst);
 extern void smb2_echo_request(struct work_struct *work);
+extern __le32 smb2_get_lease_state(struct cifsInodeInfo *cinode);
+extern __u8 smb2_map_lease_to_oplock(__le32 lease_state);
 extern bool smb2_is_valid_oplock_break(char *buffer,
 				       struct TCP_Server_Info *srv);
 
@@ -151,5 +153,7 @@ extern int smb2_lockv(const unsigned int xid, struct cifs_tcon *tcon,
 		      const __u64 persist_fid, const __u64 volatile_fid,
 		      const __u32 pid, const __u32 num_lock,
 		      struct smb2_lock_element *buf);
+extern int SMB2_lease_break(const unsigned int xid, struct cifs_tcon *tcon,
+			    __u8 *lease_key, const __le32 lease_state);
 
 #endif			/* _SMB2PROTO_H */
-- 
1.7.1
