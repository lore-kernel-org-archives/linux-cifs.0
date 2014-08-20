From: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 3/7] cifs: No need to send SIGKILL to demux_thread during umount
Date: Wed, 20 Aug 2014 19:39:17 +0900
Message-ID: <003601cfbc62$fe88d170$fb9a7450$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: 'Shirish Pargaonkar' <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	'Pavel Shilovsky' <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ashish Sangwan <a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
To: 'Steve French' <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-language: ko
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

There is no need to explicitly send SIGKILL to cifs_demultiplex_thread
as it is calling module_put_and_exit to exit cleanly.

socket sk_rcvtimeo is set to 7 HZ so the thread will wake up in 7 seconds and
clean itself.

Signed-off-by: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Ashish Sangwan <a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 fs/cifs/connect.c |   19 -------------------
 1 files changed, 0 insertions(+), 19 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 03ed8a0..b4b6d10 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -837,7 +837,6 @@ cifs_demultiplex_thread(void *p)
 	struct TCP_Server_Info *server = p;
 	unsigned int pdu_length;
 	char *buf = NULL;
-	struct task_struct *task_to_wake = NULL;
 	struct mid_q_entry *mid_entry;
 
 	current->flags |= PF_MEMALLOC;
@@ -928,19 +927,7 @@ cifs_demultiplex_thread(void *p)
 	if (server->smallbuf) /* no sense logging a debug message if NULL */
 		cifs_small_buf_release(server->smallbuf);
 
-	task_to_wake = xchg(&server->tsk, NULL);
 	clean_demultiplex_info(server);
-
-	/* if server->tsk was NULL then wait for a signal before exiting */
-	if (!task_to_wake) {
-		set_current_state(TASK_INTERRUPTIBLE);
-		while (!signal_pending(current)) {
-			schedule();
-			set_current_state(TASK_INTERRUPTIBLE);
-		}
-		set_current_state(TASK_RUNNING);
-	}
-
 	module_put_and_exit(0);
 }
 
@@ -2061,8 +2048,6 @@ cifs_find_tcp_session(struct smb_vol *vol)
 static void
 cifs_put_tcp_session(struct TCP_Server_Info *server)
 {
-	struct task_struct *task;
-
 	spin_lock(&cifs_tcp_ses_lock);
 	if (--server->srv_count > 0) {
 		spin_unlock(&cifs_tcp_ses_lock);
@@ -2086,10 +2071,6 @@ cifs_put_tcp_session(struct TCP_Server_Info *server)
 	kfree(server->session_key.response);
 	server->session_key.response = NULL;
 	server->session_key.len = 0;
-
-	task = xchg(&server->tsk, NULL);
-	if (task)
-		force_sig(SIGKILL, task);
 }
 
 static struct TCP_Server_Info *
-- 
1.7.7
