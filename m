From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/3] cifs: add new cifsiod_wq workqueue
Date: Fri, 17 Feb 2012 09:31:44 -0500
Message-ID: <1329489104-7823-4-git-send-email-jlayton@redhat.com>
References: <1329489104-7823-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org,
	tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1329489104-7823-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...and convert existing cifs users of system_nrt_wq to use that instead.

Also, make it freezable, and set WQ_MEM_RECLAIM since we use it to
deal with write reply handling.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsfs.c   |   13 ++++++++++++-
 fs/cifs/cifsglob.h |    1 +
 fs/cifs/cifssmb.c  |    4 ++--
 fs/cifs/connect.c  |    8 ++++----
 fs/cifs/misc.c     |    2 +-
 5 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index a848082..8193c92 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -90,6 +90,8 @@ extern mempool_t *cifs_sm_req_poolp;
 extern mempool_t *cifs_req_poolp;
 extern mempool_t *cifs_mid_poolp;
 
+struct workqueue_struct	*cifsiod_wq;
+
 static int
 cifs_read_super(struct super_block *sb)
 {
@@ -1121,9 +1123,15 @@ init_cifs(void)
 		cFYI(1, "cifs_max_pending set to max of 256");
 	}
 
+	cifsiod_wq = alloc_workqueue("cifsiod", WQ_FREEZABLE|WQ_MEM_RECLAIM, 0);
+	if (!cifsiod_wq) {
+		rc = -ENOMEM;
+		goto out_clean_proc;
+	}
+
 	rc = cifs_fscache_register();
 	if (rc)
-		goto out_clean_proc;
+		goto out_destroy_wq;
 
 	rc = cifs_init_inodecache();
 	if (rc)
@@ -1171,6 +1179,8 @@ out_destroy_inodecache:
 	cifs_destroy_inodecache();
 out_unreg_fscache:
 	cifs_fscache_unregister();
+out_destroy_wq:
+	destroy_workqueue(cifsiod_wq);
 out_clean_proc:
 	cifs_proc_clean();
 	return rc;
@@ -1193,6 +1203,7 @@ exit_cifs(void)
 	cifs_destroy_mids();
 	cifs_destroy_inodecache();
 	cifs_fscache_unregister();
+	destroy_workqueue(cifsiod_wq);
 	cifs_proc_clean();
 }
 
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 76e7d8b..5d0c4b6 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1027,5 +1027,6 @@ GLOBAL_EXTERN spinlock_t gidsidlock;
 void cifs_oplock_break(struct work_struct *work);
 
 extern const struct slow_work_ops cifs_oplock_break_ops;
+extern struct workqueue_struct *cifsiod_wq;
 
 #endif	/* _CIFS_GLOB_H */
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 8b7794c..4fb1643 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1667,7 +1667,7 @@ cifs_readv_callback(struct mid_q_entry *mid)
 		rdata->result = -EIO;
 	}
 
-	queue_work(system_nrt_wq, &rdata->work);
+	queue_work(cifsiod_wq, &rdata->work);
 	DeleteMidQEntry(mid);
 	atomic_dec(&server->inFlight);
 	wake_up(&server->request_q);
@@ -2108,7 +2108,7 @@ cifs_writev_callback(struct mid_q_entry *mid)
 		break;
 	}
 
-	queue_work(system_nrt_wq, &wdata->work);
+	queue_work(cifsiod_wq, &wdata->work);
 	DeleteMidQEntry(mid);
 	atomic_dec(&tcon->ses->server->inFlight);
 	wake_up(&tcon->ses->server->request_q);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 602f77c..fff5e5d 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -334,7 +334,7 @@ cifs_echo_request(struct work_struct *work)
 			server->hostname);
 
 requeue_echo:
-	queue_delayed_work(system_nrt_wq, &server->echo, SMB_ECHO_INTERVAL);
+	queue_delayed_work(cifsiod_wq, &server->echo, SMB_ECHO_INTERVAL);
 }
 
 static bool
@@ -1974,7 +1974,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 	cifs_fscache_get_client_cookie(tcp_ses);
 
 	/* queue echo request delayed work */
-	queue_delayed_work(system_nrt_wq, &tcp_ses->echo, SMB_ECHO_INTERVAL);
+	queue_delayed_work(cifsiod_wq, &tcp_ses->echo, SMB_ECHO_INTERVAL);
 
 	return tcp_ses;
 
@@ -3539,7 +3539,7 @@ remote_path_check:
 	tlink_rb_insert(&cifs_sb->tlink_tree, tlink);
 	spin_unlock(&cifs_sb->tlink_tree_lock);
 
-	queue_delayed_work(system_nrt_wq, &cifs_sb->prune_tlinks,
+	queue_delayed_work(cifsiod_wq, &cifs_sb->prune_tlinks,
 				TLINK_IDLE_EXPIRE);
 
 mount_fail_check:
@@ -4091,6 +4091,6 @@ cifs_prune_tlinks(struct work_struct *work)
 	}
 	spin_unlock(&cifs_sb->tlink_tree_lock);
 
-	queue_delayed_work(system_nrt_wq, &cifs_sb->prune_tlinks,
+	queue_delayed_work(cifsiod_wq, &cifs_sb->prune_tlinks,
 				TLINK_IDLE_EXPIRE);
 }
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 703ef5c..bd215f2 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -584,7 +584,7 @@ is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
 
 				cifs_set_oplock_level(pCifsInode,
 					pSMB->OplockLevel ? OPLOCK_READ : 0);
-				queue_work(system_nrt_wq,
+				queue_work(cifsiod_wq,
 					   &netfile->oplock_break);
 				netfile->oplock_break_cancelled = false;
 
-- 
1.7.7.6
