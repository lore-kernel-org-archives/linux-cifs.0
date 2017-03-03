From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4] Handle mismatched open calls
Date: Fri,  3 Mar 2017 15:41:38 -0800
Message-ID: <20170303234138.8234-1-sprabhu@redhat.com>
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
v3: Allocate struct cancelled before we pick the tcon
    Remove smb2_find_smb_sess_tcon() of the global functions
v4: rebase against latest upstream.

Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h      | 11 ++++++++
 fs/cifs/connect.c       |  9 +++++--
 fs/cifs/smb2misc.c      | 47 ++++++++++++++++++++++++++++++++++
 fs/cifs/smb2ops.c       |  4 +++
 fs/cifs/smb2proto.h     |  7 ++++++
 fs/cifs/smb2transport.c | 67 ++++++++++++++++++++++++++++++++++++++++++++++---
 fs/cifs/transport.c     |  3 +++
 7 files changed, 142 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index d42dd32..c34bdb1 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -243,6 +243,7 @@ struct smb_version_operations {
 	/* verify the message */
 	int (*check_message)(char *, unsigned int, struct TCP_Server_Info *);
 	bool (*is_oplock_break)(char *, struct TCP_Server_Info *);
+	int (*handle_cancelled_mid)(char *, struct TCP_Server_Info *);
 	void (*downgrade_oplock)(struct TCP_Server_Info *,
 					struct cifsInodeInfo *, bool);
 	/* process transaction2 response */
@@ -1343,6 +1344,7 @@ struct mid_q_entry {
 	void *callback_data;	  /* general purpose pointer for callback */
 	void *resp_buf;		/* pointer to received SMB header */
 	int mid_state;	/* wish this were enum but can not pass to wait_event */
+	unsigned int mid_flags;
 	__le16 command;		/* smb command code */
 	bool large_buf:1;	/* if valid response, is pointer to large buf */
 	bool multiRsp:1;	/* multiple trans2 responses for one request  */
@@ -1350,6 +1352,12 @@ struct mid_q_entry {
 	bool decrypted:1;	/* decrypted entry */
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
@@ -1481,6 +1489,9 @@ static inline void free_dfs_info_array(struct dfs_info3_param *param,
 #define   MID_RESPONSE_MALFORMED 0x10
 #define   MID_SHUTDOWN		 0x20
 
+/* Flags */
+#define   MID_WAIT_CANCELLED	 1 /* Cancelled while waiting for response */
+
 /* Types of response buffer returned from SendReceive2 */
 #define   CIFS_NO_BUFFER        0    /* Response buffer not returned */
 #define   CIFS_SMALL_BUFFER     1
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index de4c56e..6180166 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -903,10 +903,15 @@ cifs_demultiplex_thread(void *p)
 
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
index fd516ea..33e66cf 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -659,3 +659,50 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
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
+	struct smb2_sync_hdr *sync_hdr = get_sync_hdr(buffer);
+	struct smb2_create_rsp *rsp = (struct smb2_create_rsp *)buffer;
+	struct cifs_tcon *tcon;
+	struct close_cancelled_open *cancelled;
+
+	if ((sync_hdr->Command != SMB2_CREATE) ||
+		(sync_hdr->Status != STATUS_SUCCESS))
+		return 0;
+
+	cancelled = (struct close_cancelled_open *)
+			kzalloc(sizeof(struct close_cancelled_open),
+				GFP_KERNEL);
+	if (!cancelled)
+		return -ENOMEM;
+
+	tcon = smb2_find_smb_tcon(server, sync_hdr->SessionId, sync_hdr->TreeId);;
+	if (!tcon) {
+		kfree(cancelled);
+		return -ENOENT;
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
index 0231108..c6d14cc 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2322,6 +2322,7 @@ struct smb_version_operations smb20_operations = {
 	.clear_stats = smb2_clear_stats,
 	.print_stats = smb2_print_stats,
 	.is_oplock_break = smb2_is_valid_oplock_break,
+	.handle_cancelled_mid = smb2_handle_cancelled_mid,
 	.downgrade_oplock = smb2_downgrade_oplock,
 	.need_neg = smb2_need_neg,
 	.negotiate = smb2_negotiate,
@@ -2404,6 +2405,7 @@ struct smb_version_operations smb21_operations = {
 	.clear_stats = smb2_clear_stats,
 	.print_stats = smb2_print_stats,
 	.is_oplock_break = smb2_is_valid_oplock_break,
+	.handle_cancelled_mid = smb2_handle_cancelled_mid,
 	.downgrade_oplock = smb2_downgrade_oplock,
 	.need_neg = smb2_need_neg,
 	.negotiate = smb2_negotiate,
@@ -2488,6 +2490,7 @@ struct smb_version_operations smb30_operations = {
 	.print_stats = smb2_print_stats,
 	.dump_share_caps = smb2_dump_share_caps,
 	.is_oplock_break = smb2_is_valid_oplock_break,
+	.handle_cancelled_mid = smb2_handle_cancelled_mid,
 	.downgrade_oplock = smb2_downgrade_oplock,
 	.need_neg = smb2_need_neg,
 	.negotiate = smb2_negotiate,
@@ -2582,6 +2585,7 @@ struct smb_version_operations smb311_operations = {
 	.print_stats = smb2_print_stats,
 	.dump_share_caps = smb2_dump_share_caps,
 	.is_oplock_break = smb2_is_valid_oplock_break,
+	.handle_cancelled_mid = smb2_handle_cancelled_mid,
 	.downgrade_oplock = smb2_downgrade_oplock,
 	.need_neg = smb2_need_neg,
 	.negotiate = smb2_negotiate,
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 69e3587..6853454 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -48,6 +48,10 @@ extern struct mid_q_entry *smb2_setup_request(struct cifs_ses *ses,
 			      struct smb_rqst *rqst);
 extern struct mid_q_entry *smb2_setup_async_request(
 			struct TCP_Server_Info *server, struct smb_rqst *rqst);
+extern struct cifs_ses *smb2_find_smb_ses(struct TCP_Server_Info *server,
+					   __u64 ses_id);
+extern struct cifs_tcon *smb2_find_smb_tcon(struct TCP_Server_Info *server,
+						__u64 ses_id, __u32  tid);
 extern int smb2_calc_signature(struct smb_rqst *rqst,
 				struct TCP_Server_Info *server);
 extern int smb3_calc_signature(struct smb_rqst *rqst,
@@ -164,6 +168,9 @@ extern int SMB2_set_compression(const unsigned int xid, struct cifs_tcon *tcon,
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
index 7c3bb1b..78b4135 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -115,23 +115,81 @@ smb3_crypto_shash_allocate(struct TCP_Server_Info *server)
 	return 0;
 }
 
-struct cifs_ses *
-smb2_find_smb_ses(struct TCP_Server_Info *server, __u64 ses_id)
+static struct cifs_ses *
+_smb2_find_smb_ses(struct TCP_Server_Info *server, __u64 ses_id)
 {
 	struct cifs_ses *ses;
 
-	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
 		if (ses->Suid != ses_id)
 			continue;
-		spin_unlock(&cifs_tcp_ses_lock);
 		return ses;
 	}
+
+	return NULL;
+}
+
+struct cifs_ses *
+smb2_find_smb_ses(struct TCP_Server_Info *server, __u64 ses_id)
+{
+	struct cifs_ses *ses;
+
+	spin_lock(&cifs_tcp_ses_lock);
+	ses = _smb2_find_smb_ses(server, ses_id);
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
+smb2_find_smb_tcon(struct TCP_Server_Info *server, __u64 ses_id, __u32  tid)
+{
+	struct cifs_ses *ses;
+	struct cifs_tcon *tcon;
+
+	spin_lock(&cifs_tcp_ses_lock);
+	ses = _smb2_find_smb_ses(server, ses_id );
+	if (!ses)
+		return NULL;
+	tcon = _smb2_find_smb_sess_tcon(ses, tid);
+	spin_unlock(&cifs_tcp_ses_lock);
+
+	return tcon;
+}
+
 int
 smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 {
@@ -511,6 +569,7 @@ smb2_mid_entry_alloc(const struct smb2_sync_hdr *shdr,
 
 	atomic_inc(&midCount);
 	temp->mid_state = MID_REQUEST_ALLOCATED;
+	temp->mid_flags = 0;
 	return temp;
 }
 
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 526f053..d82a4ae 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -752,9 +752,12 @@ cifs_send_recv(const unsigned int xid, struct cifs_ses *ses,
 
 	rc = wait_for_response(ses->server, midQ);
 	if (rc != 0) {
+		cifs_dbg(FYI, "Cancelling wait for mid %lu\n",
+				(unsigned long)midQ->mid);
 		send_cancel(ses->server, rqst, midQ);
 		spin_lock(&GlobalMid_Lock);
 		if (midQ->mid_state == MID_REQUEST_SUBMITTED) {
+			midQ->mid_flags |= MID_WAIT_CANCELLED;
 			midQ->callback = DeleteMidQEntry;
 			spin_unlock(&GlobalMid_Lock);
 			add_credits(ses->server, 1, optype);
-- 
2.9.3
