From: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: [PATCH v2 4/5] CIFS: Fix a possible memory corruption during reconnect
Date: Mon,  5 Dec 2016 13:11:10 -0800
Message-ID: <1480972271-57692-5-git-send-email-pshilov@microsoft.com>
References: <1480972271-57692-1-git-send-email-pshilov@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1480972271-57692-1-git-send-email-pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We can not unlock/lock cifs_tcp_ses_lock while walking through ses
and tcon lists because it can corrupt list iterator pointers and
a tcon structure can be released if we don't hold an extra reference.
Fix it by moving a reconnect process to a separate delayed work
and acquiring a reference to every tcon that needs to be reconnected.
Also do not send an echo request on newly established connections.

CC: Stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Signed-off-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/cifsglob.h  |  3 +++
 fs/cifs/cifsproto.h |  3 +++
 fs/cifs/connect.c   | 34 +++++++++++++++++++-----
 fs/cifs/smb2pdu.c   | 75 ++++++++++++++++++++++++++++++++++++-----------------
 fs/cifs/smb2proto.h |  1 +
 5 files changed, 85 insertions(+), 31 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 3e95191..89a0d7f 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -647,6 +647,8 @@ struct TCP_Server_Info {
 	unsigned int	max_read;
 	unsigned int	max_write;
 	__u8		preauth_hash[512];
+	struct delayed_work reconnect; /* reconnect workqueue job */
+	struct mutex reconnect_mutex; /* prevent simultaneous reconnects */
 #endif /* CONFIG_CIFS_SMB2 */
 	unsigned long echo_interval;
 };
@@ -850,6 +852,7 @@ cap_unix(struct cifs_ses *ses)
 struct cifs_tcon {
 	struct list_head tcon_list;
 	int tc_count;
+	struct list_head rlist; /* reconnect list */
 	struct list_head openFileList;
 	spinlock_t open_file_lock; /* protects list above */
 	struct cifs_ses *ses;	/* pointer to session associated with */
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index ced0e42..cd8025a 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -206,6 +206,9 @@ extern void cifs_add_pending_open_locked(struct cifs_fid *fid,
 					 struct tcon_link *tlink,
 					 struct cifs_pending_open *open);
 extern void cifs_del_pending_open(struct cifs_pending_open *open);
+extern void cifs_put_tcp_session(struct TCP_Server_Info *server,
+				 int from_reconnect);
+extern void cifs_put_tcon(struct cifs_tcon *tcon);
 
 #if IS_ENABLED(CONFIG_CIFS_DFS_UPCALL)
 extern void cifs_dfs_release_automount_timer(void);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 5563de3..5aaf7b1 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -52,6 +52,9 @@
 #include "nterr.h"
 #include "rfc1002pdu.h"
 #include "fscache.h"
+#ifdef CONFIG_CIFS_SMB2
+#include "smb2proto.h"
+#endif
 
 #define CIFS_PORT 445
 #define RFC1001_PORT 139
@@ -2110,8 +2113,8 @@ cifs_find_tcp_session(struct smb_vol *vol)
 	return NULL;
 }
 
-static void
-cifs_put_tcp_session(struct TCP_Server_Info *server)
+void
+cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
 {
 	struct task_struct *task;
 
@@ -2128,6 +2131,19 @@ cifs_put_tcp_session(struct TCP_Server_Info *server)
 
 	cancel_delayed_work_sync(&server->echo);
 
+#ifdef CONFIG_CIFS_SMB2
+	if (from_reconnect)
+		/*
+		 * Avoid deadlock here: reconnect work calls
+		 * cifs_put_tcp_session() at its end. Need to be sure
+		 * that reconnect work does nothing with server pointer after
+		 * that step.
+		 */
+		cancel_delayed_work(&server->reconnect);
+	else
+		cancel_delayed_work_sync(&server->reconnect);
+#endif
+
 	spin_lock(&GlobalMid_Lock);
 	server->tcpStatus = CifsExiting;
 	spin_unlock(&GlobalMid_Lock);
@@ -2192,6 +2208,10 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 	INIT_LIST_HEAD(&tcp_ses->tcp_ses_list);
 	INIT_LIST_HEAD(&tcp_ses->smb_ses_list);
 	INIT_DELAYED_WORK(&tcp_ses->echo, cifs_echo_request);
+#ifdef CONFIG_CIFS_SMB2
+	INIT_DELAYED_WORK(&tcp_ses->reconnect, smb2_reconnect_server);
+	mutex_init(&tcp_ses->reconnect_mutex);
+#endif
 	memcpy(&tcp_ses->srcaddr, &volume_info->srcaddr,
 	       sizeof(tcp_ses->srcaddr));
 	memcpy(&tcp_ses->dstaddr, &volume_info->dstaddr,
@@ -2350,7 +2370,7 @@ cifs_put_smb_ses(struct cifs_ses *ses)
 	spin_unlock(&cifs_tcp_ses_lock);
 
 	sesInfoFree(ses);
-	cifs_put_tcp_session(server);
+	cifs_put_tcp_session(server, 0);
 }
 
 #ifdef CONFIG_KEYS
@@ -2524,7 +2544,7 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
 		mutex_unlock(&ses->session_mutex);
 
 		/* existing SMB ses has a server reference already */
-		cifs_put_tcp_session(server);
+		cifs_put_tcp_session(server, 0);
 		free_xid(xid);
 		return ses;
 	}
@@ -2620,7 +2640,7 @@ cifs_find_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
 	return NULL;
 }
 
-static void
+void
 cifs_put_tcon(struct cifs_tcon *tcon)
 {
 	unsigned int xid;
@@ -3824,7 +3844,7 @@ cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *volume_info)
 		else if (ses)
 			cifs_put_smb_ses(ses);
 		else
-			cifs_put_tcp_session(server);
+			cifs_put_tcp_session(server, 0);
 		bdi_destroy(&cifs_sb->bdi);
 	}
 
@@ -4135,7 +4155,7 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, kuid_t fsuid)
 	ses = cifs_get_smb_ses(master_tcon->ses->server, vol_info);
 	if (IS_ERR(ses)) {
 		tcon = (struct cifs_tcon *)ses;
-		cifs_put_tcp_session(master_tcon->ses->server);
+		cifs_put_tcp_session(master_tcon->ses->server, 0);
 		goto out;
 	}
 
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 730d57b..4ba3f68 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1972,6 +1972,54 @@ smb2_echo_callback(struct mid_q_entry *mid)
 	add_credits(server, credits_received, CIFS_ECHO_OP);
 }
 
+void smb2_reconnect_server(struct work_struct *work)
+{
+	struct TCP_Server_Info *server = container_of(work,
+					struct TCP_Server_Info, reconnect.work);
+	struct cifs_ses *ses;
+	struct cifs_tcon *tcon, *tcon2;
+	struct list_head tmp_list;
+	int tcon_exist = false;
+
+	/* Prevent simultaneous reconnects that can corrupt tcon->rlist list */
+	mutex_lock(&server->reconnect_mutex);
+
+	INIT_LIST_HEAD(&tmp_list);
+	cifs_dbg(FYI, "Need negotiate, reconnecting tcons\n");
+
+	spin_lock(&cifs_tcp_ses_lock);
+	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
+			if (tcon->need_reconnect) {
+				tcon->tc_count++;
+				list_add_tail(&tcon->rlist, &tmp_list);
+				tcon_exist = true;
+			}
+		}
+	}
+	/*
+	 * Get the reference to server struct to be sure that the last call of
+	 * cifs_put_tcon() in the loop below won't release the server pointer.
+	 */
+	if (tcon_exist)
+		server->srv_count++;
+
+	spin_unlock(&cifs_tcp_ses_lock);
+
+	list_for_each_entry_safe(tcon, tcon2, &tmp_list, rlist) {
+		smb2_reconnect(SMB2_ECHO, tcon);
+		list_del_init(&tcon->rlist);
+		cifs_put_tcon(tcon);
+	}
+
+	cifs_dbg(FYI, "Reconnecting tcons finished\n");
+	mutex_unlock(&server->reconnect_mutex);
+
+	/* now we can safely release srv struct */
+	if (tcon_exist)
+		cifs_put_tcp_session(server, 1);
+}
+
 int
 SMB2_echo(struct TCP_Server_Info *server)
 {
@@ -1984,32 +2032,11 @@ SMB2_echo(struct TCP_Server_Info *server)
 	cifs_dbg(FYI, "In echo request\n");
 
 	if (server->tcpStatus == CifsNeedNegotiate) {
-		struct list_head *tmp, *tmp2;
-		struct cifs_ses *ses;
-		struct cifs_tcon *tcon;
-
-		cifs_dbg(FYI, "Need negotiate, reconnecting tcons\n");
-		spin_lock(&cifs_tcp_ses_lock);
-		list_for_each(tmp, &server->smb_ses_list) {
-			ses = list_entry(tmp, struct cifs_ses, smb_ses_list);
-			list_for_each(tmp2, &ses->tcon_list) {
-				tcon = list_entry(tmp2, struct cifs_tcon,
-						  tcon_list);
-				/* add check for persistent handle reconnect */
-				if (tcon && tcon->need_reconnect) {
-					spin_unlock(&cifs_tcp_ses_lock);
-					rc = smb2_reconnect(SMB2_ECHO, tcon);
-					spin_lock(&cifs_tcp_ses_lock);
-				}
-			}
-		}
-		spin_unlock(&cifs_tcp_ses_lock);
+		/* No need to send echo on newly established connections */
+		queue_delayed_work(cifsiod_wq, &server->reconnect, 0);
+		return rc;
 	}
 
-	/* if no session, renegotiate failed above */
-	if (server->tcpStatus == CifsNeedNegotiate)
-		return -EIO;
-
 	rc = small_smb2_init(SMB2_ECHO, NULL, (void **)&req);
 	if (rc)
 		return rc;
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index eb2cde2..f2d511a 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -96,6 +96,7 @@ extern int smb2_open_file(const unsigned int xid,
 extern int smb2_unlock_range(struct cifsFileInfo *cfile,
 			     struct file_lock *flock, const unsigned int xid);
 extern int smb2_push_mandatory_locks(struct cifsFileInfo *cfile);
+extern void smb2_reconnect_server(struct work_struct *work);
 
 /*
  * SMB2 Worker functions - most of protocol specific implementation details
-- 
2.7.4
