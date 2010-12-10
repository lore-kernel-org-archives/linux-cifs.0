From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 07/13] cifs: allow for different handling of received response
Date: Fri, 10 Dec 2010 10:44:31 -0500
Message-ID: <1291995877-2276-8-git-send-email-jlayton@redhat.com>
References: <1291995877-2276-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1291995877-2276-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

In order to incorporate async requests, we need to allow for a more
general way to do things on receive, rather than just waking up a
process.

Turn the task pointer in the mid_q_entry into a callback function and a
generic data pointer. When a response comes in, or the socket is
reconnected, cifsd can call the callback function in order to wake up
the process.

The default is to just wake up the current process which should mean no
change in behavior for existing code.

Also, clean up the locking in cifs_reconnect. There doesn't seem to be
any need to hold both the srv_mutex and GlobalMid_Lock when walking the
list of mids.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifs_debug.c |    8 +++---
 fs/cifs/cifsglob.h   |    7 +++++-
 fs/cifs/connect.c    |   54 ++++++++++++++++++++++++++++---------------------
 fs/cifs/transport.c  |   15 +++++++++++++-
 4 files changed, 55 insertions(+), 29 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index bd76527..c81934f 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -79,11 +79,11 @@ void cifs_dump_mids(struct TCP_Server_Info *server)
 	spin_lock(&GlobalMid_Lock);
 	list_for_each(tmp, &server->pending_mid_q) {
 		mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
-		cERROR(1, "State: %d Cmd: %d Pid: %d Tsk: %p Mid %d",
+		cERROR(1, "State: %d Cmd: %d Pid: %d Cbdata: %p Mid %d",
 			mid_entry->midState,
 			(int)mid_entry->command,
 			mid_entry->pid,
-			mid_entry->tsk,
+			mid_entry->callback_data,
 			mid_entry->mid);
 #ifdef CONFIG_CIFS_STATS2
 		cERROR(1, "IsLarge: %d buf: %p time rcv: %ld now: %ld",
@@ -218,11 +218,11 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 				mid_entry = list_entry(tmp3, struct mid_q_entry,
 					qhead);
 				seq_printf(m, "\tState: %d com: %d pid:"
-						" %d tsk: %p mid %d\n",
+						" %d cbdata: %p mid %d\n",
 						mid_entry->midState,
 						(int)mid_entry->command,
 						mid_entry->pid,
-						mid_entry->tsk,
+						mid_entry->callback_data,
 						mid_entry->mid);
 			}
 			spin_unlock(&GlobalMid_Lock);
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index cf0dfda..cc43ada 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -511,6 +511,10 @@ static inline void cifs_stats_bytes_read(struct cifsTconInfo *tcon,
 
 #endif
 
+struct mid_q_entry;
+
+typedef void (mid_callback_t)(struct mid_q_entry *mid);
+
 /* one of these for every pending CIFS request to the server */
 struct mid_q_entry {
 	struct list_head qhead;	/* mids waiting on reply from this server */
@@ -522,7 +526,8 @@ struct mid_q_entry {
 	unsigned long when_sent; /* time when smb send finished */
 	unsigned long when_received; /* when demux complete (taken off wire) */
 #endif
-	struct task_struct *tsk;	/* task waiting for response */
+	mid_callback_t *callback; /* call completion callback */
+	void *callback_data;	  /* general purpose pointer for callback */
 	struct smb_hdr *resp_buf;	/* response buffer */
 	int midState;	/* wish this were enum but can not pass to wait_event */
 	__u8 command;	/* smb command code */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 9fbe7c5..7e20ece 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -133,6 +133,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
 {
 	int rc = 0;
 	struct list_head *tmp, *tmp2;
+	struct list_head retry;
 	struct cifsSesInfo *ses;
 	struct cifsTconInfo *tcon;
 	struct mid_q_entry *mid_entry;
@@ -152,6 +153,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
 
 	/* before reconnecting the tcp session, mark the smb session (uid)
 		and the tid bad so they are not used until reconnected */
+	cFYI(1, "%s: marking sessions and tcons for reconnect", __func__);
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each(tmp, &server->smb_ses_list) {
 		ses = list_entry(tmp, struct cifsSesInfo, smb_ses_list);
@@ -163,7 +165,9 @@ cifs_reconnect(struct TCP_Server_Info *server)
 		}
 	}
 	spin_unlock(&cifs_tcp_ses_lock);
+
 	/* do not want to be sending data on a socket we are freeing */
+	cFYI(1, "%s: tearing down socket", __func__);
 	mutex_lock(&server->srv_mutex);
 	if (server->ssocket) {
 		cFYI(1, "State: 0x%x Flags: 0x%lx", server->ssocket->state,
@@ -180,22 +184,21 @@ cifs_reconnect(struct TCP_Server_Info *server)
 	kfree(server->session_key.response);
 	server->session_key.response = NULL;
 	server->session_key.len = 0;
+	mutex_unlock(&server->srv_mutex);
 
+	/*
+	 * move in-progress mids to a private list so that we can walk it later
+	 * without needing a lock. We'll mark them for retry after reconnect.
+	 */
+	cFYI(1, "%s: moving mids to retry list", __func__);
+	INIT_LIST_HEAD(&retry);
 	spin_lock(&GlobalMid_Lock);
-	list_for_each(tmp, &server->pending_mid_q) {
-		mid_entry = list_entry(tmp, struct
-					mid_q_entry,
-					qhead);
-		if (mid_entry->midState == MID_REQUEST_SUBMITTED) {
-				/* Mark other intransit requests as needing
-				   retry so we do not immediately mark the
-				   session bad again (ie after we reconnect
-				   below) as they timeout too */
-			mid_entry->midState = MID_RETRY_NEEDED;
-		}
+	list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
+		mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
+		if (mid_entry->midState == MID_REQUEST_SUBMITTED)
+			list_move(tmp, &retry);
 	}
 	spin_unlock(&GlobalMid_Lock);
-	mutex_unlock(&server->srv_mutex);
 
 	while ((server->tcpStatus != CifsExiting) &&
 	       (server->tcpStatus != CifsGood)) {
@@ -213,10 +216,17 @@ cifs_reconnect(struct TCP_Server_Info *server)
 			if (server->tcpStatus != CifsExiting)
 				server->tcpStatus = CifsGood;
 			spin_unlock(&GlobalMid_Lock);
-	/*		atomic_set(&server->inFlight,0);*/
-			wake_up(&server->response_q);
 		}
 	}
+
+	/* now, issue callback for all mids in flight */
+	list_for_each_safe(tmp, tmp2, &retry) {
+		list_del_init(tmp);
+		mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
+		mid_entry->midState = MID_RETRY_NEEDED;
+		mid_entry->callback(mid_entry);
+	}
+
 	return rc;
 }
 
@@ -560,8 +570,7 @@ incomplete_rcv:
 			continue;
 		}
 
-
-		task_to_wake = NULL;
+		mid_entry = NULL;
 		spin_lock(&GlobalMid_Lock);
 		list_for_each(tmp, &server->pending_mid_q) {
 			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
@@ -604,7 +613,6 @@ incomplete_rcv:
 				mid_entry->resp_buf = smb_buffer;
 				mid_entry->largeBuf = isLargeBuf;
 multi_t2_fnd:
-				task_to_wake = mid_entry->tsk;
 				mid_entry->midState = MID_RESPONSE_RECEIVED;
 #ifdef CONFIG_CIFS_STATS2
 				mid_entry->when_received = jiffies;
@@ -615,9 +623,12 @@ multi_t2_fnd:
 				server->lstrp = jiffies;
 				break;
 			}
+			mid_entry = NULL;
 		}
 		spin_unlock(&GlobalMid_Lock);
-		if (task_to_wake) {
+
+		if (mid_entry != NULL) {
+			mid_entry->callback(mid_entry);
 			/* Was previous buf put in mpx struct for multi-rsp? */
 			if (!isMultiRsp) {
 				/* smb buffer will be freed by user thread */
@@ -626,7 +637,6 @@ multi_t2_fnd:
 				else
 					smallbuf = NULL;
 			}
-			wake_up_process(task_to_wake);
 		} else if (!is_valid_oplock_break(smb_buffer, server) &&
 			   !isMultiRsp) {
 			cERROR(1, "No task to wake, unknown frame received! "
@@ -707,11 +717,9 @@ multi_t2_fnd:
 		list_for_each(tmp, &server->pending_mid_q) {
 		mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
 			if (mid_entry->midState == MID_REQUEST_SUBMITTED) {
-				cFYI(1, "Clearing Mid 0x%x - waking up ",
+				cFYI(1, "Clearing Mid 0x%x - issuing callback",
 					 mid_entry->mid);
-				task_to_wake = mid_entry->tsk;
-				if (task_to_wake)
-					wake_up_process(task_to_wake);
+				mid_entry->callback(mid_entry);
 			}
 		}
 		spin_unlock(&GlobalMid_Lock);
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 05ced17..79647db 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -36,6 +36,12 @@
 
 extern mempool_t *cifs_mid_poolp;
 
+static void
+wake_up_task(struct mid_q_entry *mid)
+{
+	wake_up_process(mid->callback_data);
+}
+
 static struct mid_q_entry *
 AllocMidQEntry(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
 {
@@ -58,7 +64,13 @@ AllocMidQEntry(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
 	/*	do_gettimeofday(&temp->when_sent);*/ /* easier to use jiffies */
 		/* when mid allocated can be before when sent */
 		temp->when_alloc = jiffies;
-		temp->tsk = current;
+
+		/*
+		 * The default is for the mid to be synchronous, so the
+		 * default callback just wakes up the current task.
+		 */
+		temp->callback = wake_up_task;
+		temp->callback_data = current;
 	}
 
 	spin_lock(&GlobalMid_Lock);
@@ -374,6 +386,7 @@ handle_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
 		}
 		mid->midState = MID_RETRY_NEEDED;
 	case MID_RETRY_NEEDED:
+		list_move(&mid->qhead, &server->pending_mid_q);
 		rc = -EAGAIN;
 		break;
 	default:
-- 
1.7.3.2
