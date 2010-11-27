From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: [PATCH 07/14] cifs: handle cancelled requests better
Date: Sat, 27 Nov 2010 08:01:19 -0500
Message-ID: <1290862886-2914-8-git-send-email-jlayton@redhat.com>
References: <1290862886-2914-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1290862886-2914-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Currently, when a request is cancelled via signal, we delete the mid
immediately. If the request was already transmitted however, the client
is still likely to receive a response. When it does, it won't recognize
it however and will pop a printk.

It's also a little dangerous to just delete the mid entry like this. We
may end up reusing that mid. If we do then we could potentially get the
response from the first request confused with the later one.

Prevent the reuse of mids by marking them as cancelled and keeping them
on the pending_mid_q list. If the reply comes in, we'll delete it from
the list then. If it never comes, then we'll delete it at reconnect
or when cifsd comes down.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    2 +-
 fs/cifs/cifsproto.h |    1 +
 fs/cifs/connect.c   |   50 ++++++++++++++++++++++++++++++++++++++++----------
 fs/cifs/transport.c |   30 ++++++++++++++++++++++--------
 4 files changed, 64 insertions(+), 19 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index dfd41a1..62d3aa2 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -611,7 +611,7 @@ static inline void free_dfs_info_array(struct dfs_info3_param *param,
 #define   MID_REQUEST_SUBMITTED 2
 #define   MID_RESPONSE_RECEIVED 4
 #define   MID_RETRY_NEEDED      8 /* session closed while this request out */
-#define   MID_NO_RESP_NEEDED 0x10
+#define   MID_REQUEST_CANCELLED 0x10 /* discard any reply */
 
 /* Types of response buffer returned from SendReceive2 */
 #define   CIFS_NO_BUFFER        0    /* Response buffer not returned */
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 7b0ca3a..d64867e 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -60,6 +60,7 @@ extern char *cifs_compose_mount_options(const char *sb_mountdata,
 		const char *fullpath, const struct dfs_info3_param *ref,
 		char **devname);
 /* extern void renew_parental_timestamps(struct dentry *direntry);*/
+extern void DeleteMidQEntry(struct mid_q_entry *midEntry);
 extern int SendReceive(const unsigned int /* xid */ , struct cifsSesInfo *,
 			struct smb_hdr * /* input */ ,
 			struct smb_hdr * /* out */ ,
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 770b3c4..8c4c39f 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -132,9 +132,10 @@ cifs_reconnect(struct TCP_Server_Info *server)
 {
 	int rc = 0;
 	struct list_head *tmp, *tmp2;
+	struct list_head dispose;
 	struct cifsSesInfo *ses;
 	struct cifsTconInfo *tcon;
-	struct mid_q_entry *mid_entry;
+	struct mid_q_entry *mid_entry, *tmp_mid;
 
 	spin_lock(&GlobalMid_Lock);
 	if (server->tcpStatus == CifsExiting) {
@@ -180,22 +181,30 @@ cifs_reconnect(struct TCP_Server_Info *server)
 	server->session_key.response = NULL;
 	server->session_key.len = 0;
 
+	INIT_LIST_HEAD(&dispose);
 	spin_lock(&GlobalMid_Lock);
 	list_for_each(tmp, &server->pending_mid_q) {
 		mid_entry = list_entry(tmp, struct
 					mid_q_entry,
 					qhead);
 		if (mid_entry->midState == MID_REQUEST_SUBMITTED) {
-				/* Mark other intransit requests as needing
-				   retry so we do not immediately mark the
-				   session bad again (ie after we reconnect
-				   below) as they timeout too */
+			/* Mark other intransit requests as needing
+			   retry so we do not immediately mark the
+			   session bad again (ie after we reconnect
+			   below) as they timeout too */
 			mid_entry->midState = MID_RETRY_NEEDED;
+		} else if (mid_entry->midState == MID_REQUEST_CANCELLED) {
+			/* move canceled entries to dispose list */
+			list_move(tmp, &dispose);
 		}
 	}
 	spin_unlock(&GlobalMid_Lock);
 	mutex_unlock(&server->srv_mutex);
 
+	/* now walk private dispose list and delete entries */
+	list_for_each_entry_safe(mid_entry, tmp_mid, &dispose, qhead)
+		DeleteMidQEntry(mid_entry);
+
 	while ((server->tcpStatus != CifsExiting) &&
 	       (server->tcpStatus != CifsGood)) {
 		try_to_freeze();
@@ -569,9 +578,13 @@ incomplete_rcv:
 		list_for_each(tmp, &server->pending_mid_q) {
 			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
 
-			if ((mid_entry->mid == smb_buffer->Mid) &&
-			    (mid_entry->midState == MID_REQUEST_SUBMITTED) &&
-			    (mid_entry->command == smb_buffer->Command)) {
+			if (mid_entry->mid != smb_buffer->Mid)
+				goto next_mid;
+			if (mid_entry->command != smb_buffer->Command)
+				goto next_mid;
+			if (mid_entry->midState == MID_REQUEST_CANCELLED)
+				break;
+			if (mid_entry->midState == MID_REQUEST_SUBMITTED) {
 				if (check2ndT2(smb_buffer,server->maxBuf) > 0) {
 					/* We have a multipart transact2 resp */
 					isMultiRsp = true;
@@ -617,11 +630,16 @@ multi_t2_fnd:
 				server->lstrp = jiffies;
 				break;
 			}
+next_mid:
 			mid_entry = NULL;
 		}
 		spin_unlock(&GlobalMid_Lock);
 
 		if (mid_entry != NULL) {
+			if (mid_entry->midState == MID_REQUEST_CANCELLED) {
+				DeleteMidQEntry(mid_entry);
+				continue;
+			}
 			mid_entry->callback(mid_entry);
 			/* Was previous buf put in mpx struct for multi-rsp? */
 			if (!isMultiRsp) {
@@ -698,6 +716,9 @@ multi_t2_fnd:
 		}
 		spin_unlock(&cifs_tcp_ses_lock);
 	} else {
+		struct mid_q_entry *tmp_mid;
+		struct list_head dispose;
+
 		/* although we can not zero the server struct pointer yet,
 		since there are active requests which may depnd on them,
 		mark the corresponding SMB sessions as exiting too */
@@ -707,17 +728,26 @@ multi_t2_fnd:
 			ses->status = CifsExiting;
 		}
 
+		INIT_LIST_HEAD(&dispose);
 		spin_lock(&GlobalMid_Lock);
-		list_for_each(tmp, &server->pending_mid_q) {
-		mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
+		list_for_each_entry_safe(mid_entry, tmp_mid,
+					 &server->pending_mid_q, qhead) {
 			if (mid_entry->midState == MID_REQUEST_SUBMITTED) {
 				cFYI(1, "Clearing Mid 0x%x - issuing callback",
 					 mid_entry->mid);
 				mid_entry->callback(mid_entry);
+			} else if (mid_entry->midState == MID_REQUEST_CANCELLED) {
+				cFYI(1, "Clearing Mid 0x%x - Cancelled",
+					mid_entry->mid);
+				list_move(&mid_entry->qhead, &dispose);
 			}
 		}
 		spin_unlock(&GlobalMid_Lock);
 		spin_unlock(&cifs_tcp_ses_lock);
+
+		/* now delete all of the cancelled mids */
+		list_for_each_entry_safe(mid_entry, tmp_mid, &dispose, qhead)
+			DeleteMidQEntry(mid_entry);
 		/* 1/8th of sec is more than enough time for them to exit */
 		msleep(125);
 	}
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 42177bc..1ed8f6b 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -81,7 +81,7 @@ AllocMidQEntry(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
 	return temp;
 }
 
-static void
+void
 DeleteMidQEntry(struct mid_q_entry *midEntry)
 {
 #ifdef CONFIG_CIFS_STATS2
@@ -479,8 +479,13 @@ SendReceive2(const unsigned int xid, struct cifsSesInfo *ses,
 		goto out;
 
 	rc = wait_for_response(ses->server, midQ);
-	if (rc != 0)
-		goto out;
+	if (rc != 0) {
+		/* no longer considered to be "in-flight" */
+		midQ->midState = MID_REQUEST_CANCELLED;
+	        atomic_dec(&ses->server->inFlight);
+		wake_up(&ses->server->request_q);
+		return rc;
+	}
 
 	rc = handle_mid_result(midQ, ses->server);
 	if (rc != 0)
@@ -622,8 +627,13 @@ SendReceive(const unsigned int xid, struct cifsSesInfo *ses,
 		goto out;
 
 	rc = wait_for_response(ses->server, midQ);
-	if (rc != 0)
-		goto out;
+	if (rc != 0) {
+		/* no longer considered to be "in-flight" */
+		midQ->midState = MID_REQUEST_CANCELLED;
+	        atomic_dec(&ses->server->inFlight);
+		wake_up(&ses->server->request_q);
+		return rc;
+	}
 
 	rc = handle_mid_result(midQ, ses->server);
 	if (rc != 0)
@@ -841,10 +851,14 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifsTconInfo *tcon,
 			}
 		}
 
-		if (wait_for_response(ses->server, midQ) == 0) {
-			/* We got the response - restart system call. */
-			rstart = 1;
+		rc = wait_for_response(ses->server, midQ);
+		if (rc) {
+			midQ->midState = MID_REQUEST_CANCELLED;
+			return rc;
 		}
+
+		/* We got the response - restart system call. */
+		rstart = 1;
 	}
 
 	rc = handle_mid_result(midQ, ses->server);
-- 
1.7.3.2
