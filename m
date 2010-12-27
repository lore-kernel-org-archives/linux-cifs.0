From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 04/18] cifs: clean up accesses to midCount
Date: Sun, 26 Dec 2010 21:29:52 -0500
Message-ID: <1293417006-6417-5-git-send-email-jlayton@redhat.com>
References: <1293417006-6417-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1293417006-6417-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

It's an atomic_t and the code accesses the "counter" field in it directly
instead of using atomic_read(). It also is sometimes accessed under a
spinlock and sometimes not. Move it out of the spinlock since we don't need
belt-and-suspenders for something that's just informational.

Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Reviewed-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifs_debug.c |    2 +-
 fs/cifs/connect.c    |    2 +-
 fs/cifs/transport.c  |    6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index bd76527..ac7a38f 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -331,7 +331,7 @@ static int cifs_stats_proc_show(struct seq_file *m, void *v)
 				atomic_read(&totSmBufAllocCount));
 #endif /* CONFIG_CIFS_STATS2 */
 
-	seq_printf(m, "Operations (MIDs): %d\n", midCount.counter);
+	seq_printf(m, "Operations (MIDs): %d\n", atomic_read(&midCount));
 	seq_printf(m,
 		"\n%d session %d share reconnects\n",
 		tcpSesReconnectCount.counter, tconInfoReconnectCount.counter);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index d77e488..db25ea3 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -628,7 +628,7 @@ multi_t2_fnd:
 		} else if (!is_valid_oplock_break(smb_buffer, server) &&
 			   !isMultiRsp) {
 			cERROR(1, "No task to wake, unknown frame received! "
-				   "NumMids %d", midCount.counter);
+				   "NumMids %d", atomic_read(&midCount));
 			cifs_dump_mem("Received Data is: ", (char *)smb_buffer,
 				      sizeof(struct smb_hdr));
 #ifdef CONFIG_CIFS_DEBUG2
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 9a14f77..b9eb0cf 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -61,10 +61,10 @@ AllocMidQEntry(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
 		temp->tsk = current;
 	}
 
-	spin_lock(&GlobalMid_Lock);
-	list_add_tail(&temp->qhead, &server->pending_mid_q);
 	atomic_inc(&midCount);
 	temp->midState = MID_REQUEST_ALLOCATED;
+	spin_lock(&GlobalMid_Lock);
+	list_add_tail(&temp->qhead, &server->pending_mid_q);
 	spin_unlock(&GlobalMid_Lock);
 	return temp;
 }
@@ -78,8 +78,8 @@ DeleteMidQEntry(struct mid_q_entry *midEntry)
 	spin_lock(&GlobalMid_Lock);
 	midEntry->midState = MID_FREE;
 	list_del(&midEntry->qhead);
-	atomic_dec(&midCount);
 	spin_unlock(&GlobalMid_Lock);
+	atomic_dec(&midCount);
 	if (midEntry->largeBuf)
 		cifs_buf_release(midEntry->resp_buf);
 	else
-- 
1.7.3.4
