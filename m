From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] cifs: clean up page array when uncached write send fails
Date: Fri,  7 Feb 2014 11:02:41 -0500
Message-ID: <1391788961-26028-1-git-send-email-jlayton@redhat.com>
References: <1391715764-21225-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1391715764-21225-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

In the event that a send fails in an uncached write, or we end up
needing to reissue it (-EAGAIN case), we'll kfree the wdata but
the pages currently leak.

Fix this by adding a new kref release routine for uncached writedata
that releases the pages, and have the uncached codepaths use that.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h  |  2 +-
 fs/cifs/cifsproto.h |  2 +-
 fs/cifs/cifssmb.c   |  6 +++---
 fs/cifs/file.c      | 28 +++++++++++++++++-----------
 fs/cifs/smb2pdu.c   |  4 ++--
 fs/cifs/smb2proto.h |  2 +-
 6 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index a245d1809ed8..57d07e704d97 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -323,7 +323,7 @@ struct smb_version_operations {
 	/* async read from the server */
 	int (*async_readv)(struct cifs_readdata *);
 	/* async write to the server */
-	int (*async_writev)(struct cifs_writedata *);
+	int (*async_writev)(struct cifs_writedata *, void (*release)(struct kref *));
 	/* sync read from the server */
 	int (*sync_read)(const unsigned int, struct cifsFileInfo *,
 			 struct cifs_io_parms *, unsigned int *, char **,
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 79e6e9a93a8c..a4f90c0d9950 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -488,7 +488,7 @@ void cifs_readdata_release(struct kref *refcount);
 int cifs_async_readv(struct cifs_readdata *rdata);
 int cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid);
 
-int cifs_async_writev(struct cifs_writedata *wdata);
+int cifs_async_writev(struct cifs_writedata *wdata, void (*release)(struct kref *kref));
 void cifs_writev_complete(struct work_struct *work);
 struct cifs_writedata *cifs_writedata_alloc(unsigned int nr_pages,
 						work_func_t complete);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 4d881c35eeca..0726ab413b8c 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1910,7 +1910,7 @@ cifs_writev_requeue(struct cifs_writedata *wdata)
 
 	do {
 		server = tlink_tcon(wdata->cfile->tlink)->ses->server;
-		rc = server->ops->async_writev(wdata);
+		rc = server->ops->async_writev(wdata, cifs_writedata_release);
 	} while (rc == -EAGAIN);
 
 	for (i = 0; i < wdata->nr_pages; i++) {
@@ -2031,7 +2031,7 @@ cifs_writev_callback(struct mid_q_entry *mid)
 
 /* cifs_async_writev - send an async write, and set up mid to handle result */
 int
-cifs_async_writev(struct cifs_writedata *wdata)
+cifs_async_writev(struct cifs_writedata *wdata, void (*release)(struct kref *kref))
 {
 	int rc = -EACCES;
 	WRITE_REQ *smb = NULL;
@@ -2105,7 +2105,7 @@ cifs_async_writev(struct cifs_writedata *wdata)
 	if (rc == 0)
 		cifs_stats_inc(&tcon->stats.cifs_stats.num_writes);
 	else
-		kref_put(&wdata->refcount, cifs_writedata_release);
+		kref_put(&wdata->refcount, release);
 
 async_writev_out:
 	cifs_small_buf_release(smb);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 853d6d1cc822..03d1f454c713 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2043,7 +2043,7 @@ retry:
 			}
 			wdata->pid = wdata->cfile->pid;
 			server = tlink_tcon(wdata->cfile->tlink)->ses->server;
-			rc = server->ops->async_writev(wdata);
+			rc = server->ops->async_writev(wdata, cifs_writedata_release);
 		} while (wbc->sync_mode == WB_SYNC_ALL && rc == -EAGAIN);
 
 		for (i = 0; i < nr_pages; ++i)
@@ -2331,9 +2331,20 @@ size_t get_numpages(const size_t wsize, const size_t len, size_t *cur_len)
 }
 
 static void
-cifs_uncached_writev_complete(struct work_struct *work)
+cifs_uncached_writedata_release(struct kref *refcount)
 {
 	int i;
+	struct cifs_writedata *wdata = container_of(refcount,
+					struct cifs_writedata, refcount);
+
+	for (i = 0; i < wdata->nr_pages; i++)
+		put_page(wdata->pages[i]);
+	cifs_writedata_release(refcount);
+}
+
+static void
+cifs_uncached_writev_complete(struct work_struct *work)
+{
 	struct cifs_writedata *wdata = container_of(work,
 					struct cifs_writedata, work);
 	struct inode *inode = wdata->cfile->dentry->d_inode;
@@ -2347,12 +2358,7 @@ cifs_uncached_writev_complete(struct work_struct *work)
 
 	complete(&wdata->done);
 
-	if (wdata->result != -EAGAIN) {
-		for (i = 0; i < wdata->nr_pages; i++)
-			put_page(wdata->pages[i]);
-	}
-
-	kref_put(&wdata->refcount, cifs_writedata_release);
+	kref_put(&wdata->refcount, cifs_uncached_writedata_release);
 }
 
 /* attempt to send write to server, retry on any -EAGAIN errors */
@@ -2370,7 +2376,7 @@ cifs_uncached_retry_writev(struct cifs_writedata *wdata)
 			if (rc != 0)
 				continue;
 		}
-		rc = server->ops->async_writev(wdata);
+		rc = server->ops->async_writev(wdata, cifs_uncached_writedata_release);
 	} while (rc == -EAGAIN);
 
 	return rc;
@@ -2454,7 +2460,7 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 		wdata->tailsz = cur_len - ((nr_pages - 1) * PAGE_SIZE);
 		rc = cifs_uncached_retry_writev(wdata);
 		if (rc) {
-			kref_put(&wdata->refcount, cifs_writedata_release);
+			kref_put(&wdata->refcount, cifs_uncached_writedata_release);
 			break;
 		}
 
@@ -2496,7 +2502,7 @@ restart_loop:
 			}
 		}
 		list_del_init(&wdata->list);
-		kref_put(&wdata->refcount, cifs_writedata_release);
+		kref_put(&wdata->refcount, cifs_uncached_writedata_release);
 	}
 
 	if (total_written > 0)
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 2013234b73ad..8c04bdeda136 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1890,7 +1890,7 @@ smb2_writev_callback(struct mid_q_entry *mid)
 
 /* smb2_async_writev - send an async write, and set up mid to handle result */
 int
-smb2_async_writev(struct cifs_writedata *wdata)
+smb2_async_writev(struct cifs_writedata *wdata, void (*release)(struct kref *kref))
 {
 	int rc = -EACCES;
 	struct smb2_write_req *req = NULL;
@@ -1938,7 +1938,7 @@ smb2_async_writev(struct cifs_writedata *wdata)
 				smb2_writev_callback, wdata, 0);
 
 	if (rc) {
-		kref_put(&wdata->refcount, cifs_writedata_release);
+		kref_put(&wdata->refcount, release);
 		cifs_stats_fail_inc(tcon, SMB2_WRITE_HE);
 	}
 
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 93adc64666f3..1833724542cd 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -123,7 +123,7 @@ extern int SMB2_get_srv_num(const unsigned int xid, struct cifs_tcon *tcon,
 extern int smb2_async_readv(struct cifs_readdata *rdata);
 extern int SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 		     unsigned int *nbytes, char **buf, int *buf_type);
-extern int smb2_async_writev(struct cifs_writedata *wdata);
+extern int smb2_async_writev(struct cifs_writedata *wdata, void (*release)(struct kref *kref));
 extern int SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 		      unsigned int *nbytes, struct kvec *iov, int n_vec);
 extern int SMB2_echo(struct TCP_Server_Info *server);
-- 
1.8.5.3
