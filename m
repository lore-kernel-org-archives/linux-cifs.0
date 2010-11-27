From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: [PATCH 05/14] cifs: allow for different handling of received response
Date: Sat, 27 Nov 2010 08:01:17 -0500
Message-ID: <1290862886-2914-6-git-send-email-jlayton@redhat.com>
References: <1290862886-2914-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1290862886-2914-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifs_debug.c |    8 ++++----
 fs/cifs/cifsglob.h   |    7 ++++++-
 fs/cifs/connect.c    |   25 ++++++++++++++-----------
 fs/cifs/transport.c  |   14 +++++++++++++-
 4 files changed, 37 insertions(+), 17 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 103ab8b..c15c1ca 100644
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
@@ -220,11 +220,11 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
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
index 2ffa029..dfd41a1 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -501,6 +501,10 @@ static inline void cifs_stats_bytes_read(struct cifsTconInfo *tcon,
 
 #endif
 
+struct mid_q_entry;
+
+typedef void (mid_callback_t)(struct mid_q_entry *mid);
+
 /* one of these for every pending CIFS request to the server */
 struct mid_q_entry {
 	struct list_head qhead;	/* mids waiting on reply from this server */
@@ -512,7 +516,8 @@ struct mid_q_entry {
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
index 7758120..770b3c4 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -212,10 +212,15 @@ cifs_reconnect(struct TCP_Server_Info *server)
 			if (server->tcpStatus != CifsExiting)
 				server->tcpStatus = CifsGood;
 			spin_unlock(&GlobalMid_Lock);
-	/*		atomic_set(&server->inFlight,0);*/
-			wake_up(&server->response_q);
 		}
 	}
+
+	/* now, issue callback for all mids in flight */
+	spin_lock(&GlobalMid_Lock);
+	list_for_each_entry(mid_entry, &server->pending_mid_q, qhead)
+		mid_entry->callback(mid_entry);
+	spin_unlock(&GlobalMid_Lock);
+
 	return rc;
 }
 
@@ -559,8 +564,7 @@ incomplete_rcv:
 			continue;
 		}
 
-
-		task_to_wake = NULL;
+		mid_entry = NULL;
 		spin_lock(&GlobalMid_Lock);
 		list_for_each(tmp, &server->pending_mid_q) {
 			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
@@ -603,7 +607,6 @@ incomplete_rcv:
 				mid_entry->resp_buf = smb_buffer;
 				mid_entry->largeBuf = isLargeBuf;
 multi_t2_fnd:
-				task_to_wake = mid_entry->tsk;
 				mid_entry->midState = MID_RESPONSE_RECEIVED;
 #ifdef CONFIG_CIFS_STATS2
 				mid_entry->when_received = jiffies;
@@ -614,9 +617,12 @@ multi_t2_fnd:
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
@@ -625,7 +631,6 @@ multi_t2_fnd:
 				else
 					smallbuf = NULL;
 			}
-			wake_up_process(task_to_wake);
 		} else if (!is_valid_oplock_break(smb_buffer, server) &&
 			   !isMultiRsp) {
 			cERROR(1, "No task to wake, unknown frame received! "
@@ -706,11 +711,9 @@ multi_t2_fnd:
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
index 258ea16..42177bc 100644
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
-- 
1.7.3.2
