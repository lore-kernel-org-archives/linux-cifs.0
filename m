From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] Handle mismatched open calls
Date: Mon, 27 Feb 2017 13:42:18 -0800
Message-ID: <20170227214218.17749-1-sprabhu@redhat.com>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

A signal can interrupt a SendReceive call which result in incoming
responses to the call being ignored. This is a problem for calls such as
open which results in the successful response being ignored. This
results in an open file resource on the server.

The patch looks into responses which were cancelled after being sent and
in case of successful open closes the open fids.

For this patch, the check is only done in SendReceive2()

RH-bz: 1403319

v2: Search for sess and tcon while under spinlock

Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h      | 11 +++++++++
 fs/cifs/connect.c       |  9 +++++--
 fs/cifs/smb2misc.c      | 47 +++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2ops.c       |  4 ++++
 fs/cifs/smb2proto.h     |  8 +++++++
 fs/cifs/smb2transport.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++---
 fs/cifs/transport.c     |  3 +++
 7 files changed, 139 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 7ea8a33..cc97d73 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -241,6 +241,7 @@ struct smb_version_operations {
 	/* verify the message */
 	int (*check_message)(char *, unsigned int, struct TCP_Server_Info *);
 	bool (*is_oplock_break)(char *, struct TCP_Server_Info *);
+	int (*handle_cancelled_mid)(char *, struct TCP_Server_Info *);
 	void (*downgrade_oplock)(struct TCP_Server_Info *,
 					struct cifsInodeInfo *, bool);
 	/* process transaction2 response */
@@ -1319,12 +1320,19 @@ struct mid_q_entry {
 	void *callback_data;	  /* general purpose pointer for callback */
 	void *resp_buf;		/* pointer to received SMB header */
 	int mid_state;	/* wish this were enum but can not pass to wait_event */
+	unsigned int mid_flags;
 	__le16 command;		/* smb command code */
 	bool large_buf:1;	/* if valid response, is pointer to large buf */
 	bool multiRsp:1;	/* multiple trans2 responses for one request  */
 	bool multiEnd:1;	/* both received */
 };
 
+struct close_cancelled_open {
+	struct cifs_fid         fid;
+	struct cifs_tcon        *tcon;
+	struct work_struct      work;
+};
+
 /*	Make code in transport.c a little cleaner by moving
 	update of optional stats into function below */
 #ifdef CONFIG_CIFS_STATS2
@@ -1456,6 +1464,9 @@ static inline void free_dfs_info_array(struct dfs_info3_param *param,
 #define   MID_RESPONSE_MALFORMED 0x10
 #define   MID_SHUTDOWN		 0x20
 
+/* Flags */
+#define   MID_WAIT_CANCELLED	 1 /* Cancelled while waiting for response */
+
 /* Types of response buffer returned from SendReceive2 */
 #define   CIFS_NO_BUFFER        0    /* Response buffer not returned */
 #define   CIFS_SMALL_BUFFER     1
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 35ae49e..95bd14d 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -887,10 +887,15 @@ cifs_demultiplex_thread(void *p)
 
 		server->lstrp = jiffies;
 		if (mid_entry != NULL) {
+			if ((mid_entry->mid_flags & MID_WAIT_CANCELLED) &&
+					(server->ops->handle_cancelled_mid))
+				server->ops->handle_cancelled_mid(buf, server);
 			if (!mid_entry->multiRsp || mid_entry->multiEnd)
 				mid_entry->callback(mid_entry);
-		} else if (!server->ops->is_oplock_break ||
-			   !server->ops->is_oplock_break(buf, server)) {
+		} else if (server->ops->is_oplock_break &&
+			   server->ops->is_oplock_break(buf, server)) {
+			cifs_dbg(FYI, "Received oplock break\n");
+		} else {
 			cifs_dbg(VFS, "No task to wake, unknown frame received! NumMids %d\n",
 				 atomic_read(&midCount));
 			cifs_dump_mem("Received Data is: ", buf,
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 3d38348..ce94607 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -654,3 +654,50 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
 	cifs_dbg(FYI, "Can not process oplock break for non-existent connection\n");
 	return false;
 }
+
+void
+smb2_cancelled_close_fid(struct work_struct *work)
+{
+	struct close_cancelled_open *cancelled = container_of(work,
+					struct close_cancelled_open, work);
+
+	cifs_dbg(VFS, "Close unmatched open\n");
+
+	SMB2_close(0, cancelled->tcon, cancelled->fid.persistent_fid,
+					   cancelled->fid.volatile_fid);
+	cifs_put_tcon(cancelled->tcon);
+	kfree(cancelled);
+}
+
+int
+smb2_handle_cancelled_mid(char *buffer, struct TCP_Server_Info *server)
+{
+	struct smb2_create_rsp *rsp = (struct smb2_create_rsp *)buffer;
+	struct smb2_hdr *smb2hdr = &rsp->hdr;
+	struct cifs_tcon *tcon;
+	struct close_cancelled_open *cancelled;
+
+	if ((smb2hdr->Command != SMB2_CREATE) ||
+		(smb2hdr->Status != STATUS_SUCCESS))
+		return 0;
+
+	tcon = smb2_find_smb_hdr_tcon(smb2hdr, server);
+	if (!tcon)
+		return -ENOENT;
+
+	cancelled = (struct close_cancelled_open *)
+			kzalloc(sizeof(struct close_cancelled_open),
+				GFP_KERNEL);
+	if (!cancelled) {
+		cifs_put_tcon(tcon);
+		return -ENOMEM;
+	}
+
+	cancelled->fid.persistent_fid = rsp->PersistentFileId;
+	cancelled->fid.volatile_fid = rsp->VolatileFileId;
+	cancelled->tcon = tcon;
+	INIT_WORK(&cancelled->work, smb2_cancelled_close_fid);
+	queue_work(cifsiod_wq, &cancelled->work);
+
+	return 0;
+}
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 5d456eb..007abf7 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1565,6 +1565,7 @@ struct smb_version_operations smb20_operations = {
 	.clear_stats = smb2_clear_stats,
 	.print_stats = smb2_print_stats,
 	.is_oplock_break = smb2_is_valid_oplock_break,
+	.handle_cancelled_mid = smb2_handle_cancelled_mid,
 	.downgrade_oplock = smb2_downgrade_oplock,
 	.need_neg = smb2_need_neg,
 	.negotiate = smb2_negotiate,
@@ -1645,6 +1646,7 @@ struct smb_version_operations smb21_operations = {
 	.clear_stats = smb2_clear_stats,
 	.print_stats = smb2_print_stats,
 	.is_oplock_break = smb2_is_valid_oplock_break,
+	.handle_cancelled_mid = smb2_handle_cancelled_mid,
 	.downgrade_oplock = smb2_downgrade_oplock,
 	.need_neg = smb2_need_neg,
 	.negotiate = smb2_negotiate,
@@ -1727,6 +1729,7 @@ struct smb_version_operations smb30_operations = {
 	.print_stats = smb2_print_stats,
 	.dump_share_caps = smb2_dump_share_caps,
 	.is_oplock_break = smb2_is_valid_oplock_break,
+	.handle_cancelled_mid = smb2_handle_cancelled_mid,
 	.downgrade_oplock = smb2_downgrade_oplock,
 	.need_neg = smb2_need_neg,
 	.negotiate = smb2_negotiate,
@@ -1815,6 +1818,7 @@ struct smb_version_operations smb311_operations = {
 	.print_stats = smb2_print_stats,
 	.dump_share_caps = smb2_dump_share_caps,
 	.is_oplock_break = smb2_is_valid_oplock_break,
+	.handle_cancelled_mid = smb2_handle_cancelled_mid,
 	.downgrade_oplock = smb2_downgrade_oplock,
 	.need_neg = smb2_need_neg,
 	.negotiate = smb2_negotiate,
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index f2d511a..8786e05 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -48,6 +48,11 @@ extern struct mid_q_entry *smb2_setup_request(struct cifs_ses *ses,
 			      struct smb_rqst *rqst);
 extern struct mid_q_entry *smb2_setup_async_request(
 			struct TCP_Server_Info *server, struct smb_rqst *rqst);
+extern struct cifs_ses *smb2_find_smb_ses(struct smb2_hdr *smb2hdr,
+					struct TCP_Server_Info *server);
+extern struct cifs_tcon *smb2_find_smb_sess_tcon(struct cifs_ses *ses, __u32  tid);
+extern struct cifs_tcon *smb2_find_smb_hdr_tcon(struct smb2_hdr *smb2hdr,
+						struct TCP_Server_Info *server);
 extern int smb2_calc_signature(struct smb_rqst *rqst,
 				struct TCP_Server_Info *server);
 extern int smb3_calc_signature(struct smb_rqst *rqst,
@@ -158,6 +163,9 @@ extern int SMB2_set_compression(const unsigned int xid, struct cifs_tcon *tcon,
 extern int SMB2_oplock_break(const unsigned int xid, struct cifs_tcon *tcon,
 			     const u64 persistent_fid, const u64 volatile_fid,
 			     const __u8 oplock_level);
+extern int smb2_handle_cancelled_mid(char *buffer,
+					struct TCP_Server_Info *server);
+void smb2_cancelled_close_fid(struct work_struct *work);
 extern int SMB2_QFS_info(const unsigned int xid, struct cifs_tcon *tcon,
 			 u64 persistent_file_id, u64 volatile_file_id,
 			 struct kstatfs *FSData);
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index bc9a7b6..c178649 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -115,22 +115,77 @@ smb3_crypto_shash_allocate(struct TCP_Server_Info *server)
 }
 
 static struct cifs_ses *
-smb2_find_smb_ses(struct smb2_hdr *smb2hdr, struct TCP_Server_Info *server)
+_smb2_find_smb_ses(struct smb2_hdr *smb2hdr, struct TCP_Server_Info *server)
 {
 	struct cifs_ses *ses;
 
-	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
 		if (ses->Suid != smb2hdr->SessionId)
 			continue;
-		spin_unlock(&cifs_tcp_ses_lock);
 		return ses;
 	}
+
+	return NULL;
+}
+
+struct cifs_ses *
+smb2_find_smb_ses(struct smb2_hdr *smb2hdr, struct TCP_Server_Info *server)
+{
+	struct cifs_ses *ses;
+
+	spin_lock(&cifs_tcp_ses_lock);
+	ses = _smb2_find_smb_ses(smb2hdr, server);
 	spin_unlock(&cifs_tcp_ses_lock);
 
+	return ses;
+}
+
+static struct cifs_tcon *
+_smb2_find_smb_sess_tcon(struct cifs_ses *ses, __u32  tid)
+{
+	struct list_head *tmp;
+	struct cifs_tcon *tcon;
+
+	list_for_each(tmp, &ses->tcon_list) {
+		tcon = list_entry(tmp, struct cifs_tcon, tcon_list);
+		if (tcon->tid != tid)
+			continue;
+		++tcon->tc_count;
+		return tcon;
+	}
+
 	return NULL;
 }
 
+/*
+ * Obtain tcon corresponding to the tid in the given
+ * cifs_ses
+ */
+struct cifs_tcon *
+smb2_find_smb_sess_tcon(struct cifs_ses *ses, __u32  tid)
+{
+	struct cifs_tcon *tcon;
+
+	spin_lock(&cifs_tcp_ses_lock);
+	tcon = _smb2_find_smb_sess_tcon(ses, tid);
+	spin_unlock(&cifs_tcp_ses_lock);
+
+	return tcon;
+}
+
+struct cifs_tcon *
+smb2_find_smb_hdr_tcon(struct smb2_hdr *smb2hdr, struct TCP_Server_Info *server)
+{
+	struct cifs_ses *ses;
+	struct cifs_tcon *tcon;
+
+	spin_lock(&cifs_tcp_ses_lock);
+	ses = _smb2_find_smb_ses(smb2hdr, server);
+	tcon = _smb2_find_smb_sess_tcon(ses, smb2hdr->TreeId);
+	spin_unlock(&cifs_tcp_ses_lock);
+
+	return tcon;
+}
 
 int
 smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
@@ -509,6 +564,7 @@ smb2_mid_entry_alloc(const struct smb2_hdr *smb_buffer,
 
 	atomic_inc(&midCount);
 	temp->mid_state = MID_REQUEST_ALLOCATED;
+	temp->mid_flags = 0;
 	return temp;
 }
 
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index fbb84c0..e97e80e 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -728,9 +728,12 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 
 	rc = wait_for_response(ses->server, midQ);
 	if (rc != 0) {
+		cifs_dbg(FYI, "Cancelling wait for mid %lu\n",
+				(unsigned long)midQ->mid);
 		send_cancel(ses->server, buf, midQ);
 		spin_lock(&GlobalMid_Lock);
 		if (midQ->mid_state == MID_REQUEST_SUBMITTED) {
+			midQ->mid_flags |= MID_WAIT_CANCELLED;
 			midQ->callback = DeleteMidQEntry;
 			spin_unlock(&GlobalMid_Lock);
 			cifs_small_buf_release(buf);
-- 
2.9.3
