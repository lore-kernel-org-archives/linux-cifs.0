From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 2/8] CIFS: Fix missing lease break from a client
Date: Fri,  6 Sep 2013 00:14:57 +0400
Message-ID: <1378412103-29047-3-git-send-email-pshilovsky@samba.org>
References: <1378412103-29047-1-git-send-email-pshilovsky@samba.org>
Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378412103-29047-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If a server sends a lease break to a connection that doesn't have
opens with a lease key specified in the server response, we don't
find an open file to send an ack. Fix this by walking through
all connections we have.

Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/smb2misc.c |  149 ++++++++++++++++++++++++++++------------------------
 1 file changed, 80 insertions(+), 69 deletions(-)

diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 38c93c3..314bd60 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -421,97 +421,108 @@ cifs_ses_oplock_break(struct work_struct *work)
 }
 
 static bool
-smb2_is_valid_lease_break(char *buffer, struct TCP_Server_Info *server)
+smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp,
+		    struct smb2_lease_break_work *lw)
 {
-	struct smb2_lease_break *rsp = (struct smb2_lease_break *)buffer;
-	struct list_head *tmp, *tmp1, *tmp2;
-	struct cifs_ses *ses;
-	struct cifs_tcon *tcon;
-	struct cifsInodeInfo *cinode;
+	bool found;
+	__u8 lease_state;
+	struct list_head *tmp;
 	struct cifsFileInfo *cfile;
 	struct cifs_pending_open *open;
-	struct smb2_lease_break_work *lw;
-	bool found;
+	struct cifsInodeInfo *cinode;
 	int ack_req = le32_to_cpu(rsp->Flags &
 				  SMB2_NOTIFY_BREAK_LEASE_FLAG_ACK_REQUIRED);
 
-	lw = kmalloc(sizeof(struct smb2_lease_break_work), GFP_KERNEL);
-	if (!lw)
-		return false;
+	lease_state = smb2_map_lease_to_oplock(rsp->NewLeaseState);
 
-	INIT_WORK(&lw->lease_break, cifs_ses_oplock_break);
-	lw->lease_state = rsp->NewLeaseState;
+	list_for_each(tmp, &tcon->openFileList) {
+		cfile = list_entry(tmp, struct cifsFileInfo, tlist);
+		cinode = CIFS_I(cfile->dentry->d_inode);
 
-	cifs_dbg(FYI, "Checking for lease break\n");
+		if (memcmp(cinode->lease_key, rsp->LeaseKey,
+							SMB2_LEASE_KEY_SIZE))
+			continue;
 
-	/* look up tcon based on tid & uid */
-	spin_lock(&cifs_tcp_ses_lock);
-	list_for_each(tmp, &server->smb_ses_list) {
-		ses = list_entry(tmp, struct cifs_ses, smb_ses_list);
+		cifs_dbg(FYI, "found in the open list\n");
+		cifs_dbg(FYI, "lease key match, lease break 0x%d\n",
+			 le32_to_cpu(rsp->NewLeaseState));
 
-		spin_lock(&cifs_file_list_lock);
-		list_for_each(tmp1, &ses->tcon_list) {
-			tcon = list_entry(tmp1, struct cifs_tcon, tcon_list);
+		smb2_set_oplock_level(cinode, lease_state);
 
-			cifs_stats_inc(&tcon->stats.cifs_stats.num_oplock_brks);
-			list_for_each(tmp2, &tcon->openFileList) {
-				cfile = list_entry(tmp2, struct cifsFileInfo,
-						   tlist);
-				cinode = CIFS_I(cfile->dentry->d_inode);
+		if (ack_req)
+			cfile->oplock_break_cancelled = false;
+		else
+			cfile->oplock_break_cancelled = true;
 
-				if (memcmp(cinode->lease_key, rsp->LeaseKey,
-					   SMB2_LEASE_KEY_SIZE))
-					continue;
+		queue_work(cifsiod_wq, &cfile->oplock_break);
+		kfree(lw);
+		return true;
+	}
 
-				cifs_dbg(FYI, "found in the open list\n");
-				cifs_dbg(FYI, "lease key match, lease break 0x%d\n",
-					 le32_to_cpu(rsp->NewLeaseState));
+	found = false;
+	list_for_each_entry(open, &tcon->pending_opens, olist) {
+		if (memcmp(open->lease_key, rsp->LeaseKey,
+			   SMB2_LEASE_KEY_SIZE))
+			continue;
+
+		if (!found && ack_req) {
+			found = true;
+			memcpy(lw->lease_key, open->lease_key,
+			       SMB2_LEASE_KEY_SIZE);
+			lw->tlink = cifs_get_tlink(open->tlink);
+			queue_work(cifsiod_wq, &lw->lease_break);
+		}
 
-				smb2_set_oplock_level(cinode,
-				  smb2_map_lease_to_oplock(rsp->NewLeaseState));
+		cifs_dbg(FYI, "found in the pending open list\n");
+		cifs_dbg(FYI, "lease key match, lease break 0x%d\n",
+			 le32_to_cpu(rsp->NewLeaseState));
 
-				if (ack_req)
-					cfile->oplock_break_cancelled = false;
-				else
-					cfile->oplock_break_cancelled = true;
+		open->oplock = lease_state;
+	}
+	return found;
+}
 
-				queue_work(cifsiod_wq, &cfile->oplock_break);
+static bool
+smb2_is_valid_lease_break(char *buffer)
+{
+	struct smb2_lease_break *rsp = (struct smb2_lease_break *)buffer;
+	struct list_head *tmp, *tmp1, *tmp2;
+	struct TCP_Server_Info *server;
+	struct cifs_ses *ses;
+	struct cifs_tcon *tcon;
+	struct smb2_lease_break_work *lw;
 
-				kfree(lw);
-				spin_unlock(&cifs_file_list_lock);
-				spin_unlock(&cifs_tcp_ses_lock);
-				return true;
-			}
+	lw = kmalloc(sizeof(struct smb2_lease_break_work), GFP_KERNEL);
+	if (!lw)
+		return false;
 
-			found = false;
-			list_for_each_entry(open, &tcon->pending_opens, olist) {
-				if (memcmp(open->lease_key, rsp->LeaseKey,
-					   SMB2_LEASE_KEY_SIZE))
-					continue;
+	INIT_WORK(&lw->lease_break, cifs_ses_oplock_break);
+	lw->lease_state = rsp->NewLeaseState;
 
-				if (!found && ack_req) {
-					found = true;
-					memcpy(lw->lease_key, open->lease_key,
-					       SMB2_LEASE_KEY_SIZE);
-					lw->tlink = cifs_get_tlink(open->tlink);
-					queue_work(cifsiod_wq,
-						   &lw->lease_break);
-				}
+	cifs_dbg(FYI, "Checking for lease break\n");
+
+	/* look up tcon based on tid & uid */
+	spin_lock(&cifs_tcp_ses_lock);
+	list_for_each(tmp, &cifs_tcp_ses_list) {
+		server = list_entry(tmp, struct TCP_Server_Info, tcp_ses_list);
 
-				cifs_dbg(FYI, "found in the pending open list\n");
-				cifs_dbg(FYI, "lease key match, lease break 0x%d\n",
-					 le32_to_cpu(rsp->NewLeaseState));
+		list_for_each(tmp1, &server->smb_ses_list) {
+			ses = list_entry(tmp1, struct cifs_ses, smb_ses_list);
 
-				open->oplock =
-				  smb2_map_lease_to_oplock(rsp->NewLeaseState);
-			}
-			if (found) {
-				spin_unlock(&cifs_file_list_lock);
-				spin_unlock(&cifs_tcp_ses_lock);
-				return true;
+			spin_lock(&cifs_file_list_lock);
+			list_for_each(tmp2, &ses->tcon_list) {
+				tcon = list_entry(tmp2, struct cifs_tcon,
+						  tcon_list);
+				cifs_stats_inc(
+				    &tcon->stats.cifs_stats.num_oplock_brks);
+				if (smb2_tcon_has_lease(tcon, rsp, lw)) {
+					spin_unlock(&cifs_file_list_lock);
+					spin_unlock(&cifs_tcp_ses_lock);
+					return true;
+				}
 			}
+			spin_unlock(&cifs_file_list_lock);
 		}
-		spin_unlock(&cifs_file_list_lock);
 	}
 	spin_unlock(&cifs_tcp_ses_lock);
 	kfree(lw);
@@ -537,7 +548,7 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
 	if (rsp->StructureSize !=
 				smb2_rsp_struct_sizes[SMB2_OPLOCK_BREAK_HE]) {
 		if (le16_to_cpu(rsp->StructureSize) == 44)
-			return smb2_is_valid_lease_break(buffer, server);
+			return smb2_is_valid_lease_break(buffer);
 		else
 			return false;
 	}
-- 
1.7.10.4
