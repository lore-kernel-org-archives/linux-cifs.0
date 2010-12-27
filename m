From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 02/18] cifs: no need to mark smb_ses_list as cifs_demultiplex_thread is exiting
Date: Sun, 26 Dec 2010 21:29:50 -0500
Message-ID: <1293417006-6417-3-git-send-email-jlayton@redhat.com>
References: <1293417006-6417-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1293417006-6417-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The TCP_Server_Info is refcounted and every SMB session holds a
reference to it. Thus, smb_ses_list is always going to be empty when
cifsd is coming down. This is dead code.

Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Reviewed-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |   44 +++-----------------------------------------
 1 files changed, 3 insertions(+), 41 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index a65d311..d77e488 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -346,7 +346,6 @@ cifs_demultiplex_thread(struct TCP_Server_Info *server)
 	struct kvec iov;
 	struct socket *csocket = server->ssocket;
 	struct list_head *tmp;
-	struct cifsSesInfo *ses;
 	struct task_struct *task_to_wake = NULL;
 	struct mid_q_entry *mid_entry;
 	char temp;
@@ -677,44 +676,19 @@ multi_t2_fnd:
 	if (smallbuf) /* no sense logging a debug message if NULL */
 		cifs_small_buf_release(smallbuf);
 
-	/*
-	 * BB: we shouldn't have to do any of this. It shouldn't be
-	 * possible to exit from the thread with active SMB sessions
-	 */
-	spin_lock(&cifs_tcp_ses_lock);
-	if (list_empty(&server->pending_mid_q)) {
-		/* loop through server session structures attached to this and
-		    mark them dead */
-		list_for_each(tmp, &server->smb_ses_list) {
-			ses = list_entry(tmp, struct cifsSesInfo,
-					 smb_ses_list);
-			ses->status = CifsExiting;
-			ses->server = NULL;
-		}
-		spin_unlock(&cifs_tcp_ses_lock);
-	} else {
-		/* although we can not zero the server struct pointer yet,
-		since there are active requests which may depnd on them,
-		mark the corresponding SMB sessions as exiting too */
-		list_for_each(tmp, &server->smb_ses_list) {
-			ses = list_entry(tmp, struct cifsSesInfo,
-					 smb_ses_list);
-			ses->status = CifsExiting;
-		}
-
+	if (!list_empty(&server->pending_mid_q)) {
 		spin_lock(&GlobalMid_Lock);
 		list_for_each(tmp, &server->pending_mid_q) {
-		mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
+			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
 			if (mid_entry->midState == MID_REQUEST_SUBMITTED) {
 				cFYI(1, "Clearing Mid 0x%x - waking up ",
-					 mid_entry->mid);
+					mid_entry->mid);
 				task_to_wake = mid_entry->tsk;
 				if (task_to_wake)
 					wake_up_process(task_to_wake);
 			}
 		}
 		spin_unlock(&GlobalMid_Lock);
-		spin_unlock(&cifs_tcp_ses_lock);
 		/* 1/8th of sec is more than enough time for them to exit */
 		msleep(125);
 	}
@@ -732,18 +706,6 @@ multi_t2_fnd:
 		coming home not much else we can do but free the memory */
 	}
 
-	/* last chance to mark ses pointers invalid
-	if there are any pointing to this (e.g
-	if a crazy root user tried to kill cifsd
-	kernel thread explicitly this might happen) */
-	/* BB: This shouldn't be necessary, see above */
-	spin_lock(&cifs_tcp_ses_lock);
-	list_for_each(tmp, &server->smb_ses_list) {
-		ses = list_entry(tmp, struct cifsSesInfo, smb_ses_list);
-		ses->server = NULL;
-	}
-	spin_unlock(&cifs_tcp_ses_lock);
-
 	kfree(server->hostname);
 	task_to_wake = xchg(&server->tsk, NULL);
 	kfree(server);
-- 
1.7.3.4
