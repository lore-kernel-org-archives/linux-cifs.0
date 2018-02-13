From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 06/14] cifs: make smb_send_rqst() take an array of requests
Date: Tue, 13 Feb 2018 15:42:26 +1100
Message-ID: <20180213044234.18364-7-lsahlber@redhat.com>
References: <20180213044234.18364-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180213044234.18364-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Update free_transform_rq to take an array of requests.
Only the first request has a transform header which needs to be freed.

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h  |  6 +++---
 fs/cifs/smb2ops.c   | 37 +++++++++++++++++++++----------------
 fs/cifs/transport.c | 22 ++++++++++++++--------
 3 files changed, 38 insertions(+), 27 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 51d0d29dceed..a5ffcaf4b144 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -440,10 +440,10 @@ struct smb_version_operations {
 	long (*fallocate)(struct file *, struct cifs_tcon *, int, loff_t,
 			  loff_t);
 	/* init transform request - used for encryption for now */
-	int (*init_transform_rq)(struct TCP_Server_Info *, struct smb_rqst *,
-				 struct smb_rqst *);
+	int (*init_transform_rq)(struct TCP_Server_Info *, int num_rqst,
+				 struct smb_rqst *, struct smb_rqst *);
 	/* free transform request */
-	void (*free_transform_rq)(struct smb_rqst *);
+	void (*free_transform_rq)(int num_rqst, struct smb_rqst *);
 	int (*is_transform_hdr)(void *buf);
 	int (*receive_transform)(struct TCP_Server_Info *,
 				 struct mid_q_entry **);
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index be1cb6aaa19c..23ff4cf3ac88 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2222,9 +2222,10 @@ crypt_message(struct TCP_Server_Info *server, struct smb_rqst *rqst, int enc)
 	return rc;
 }
 
+/* Encrypt all the requests but only add a transform header to the first */
 static int
-smb3_init_transform_rq(struct TCP_Server_Info *server, struct smb_rqst *new_rq,
-		       struct smb_rqst *old_rq)
+smb3_init_transform_rq(struct TCP_Server_Info *server, int num_rqst,
+		       struct smb_rqst *new_rq, struct smb_rqst *old_rq)
 {
 	struct kvec *iov;
 	struct page **pages;
@@ -2234,9 +2235,13 @@ smb3_init_transform_rq(struct TCP_Server_Info *server, struct smb_rqst *new_rq,
 	int i;
 	int rc = -ENOMEM;
 
+	tr_hdr = kmalloc(sizeof(struct smb2_transform_hdr), GFP_KERNEL);
+	if (!tr_hdr)
+		return rc;
+
 	pages = kmalloc_array(npages, sizeof(struct page *), GFP_KERNEL);
 	if (!pages)
-		return rc;
+		goto err_free_tr_hdr;
 
 	new_rq->rq_pages = pages;
 	new_rq->rq_npages = old_rq->rq_npages;
@@ -2264,10 +2269,6 @@ smb3_init_transform_rq(struct TCP_Server_Info *server, struct smb_rqst *new_rq,
 	new_rq->rq_iov = iov;
 	new_rq->rq_nvec = old_rq->rq_nvec + 1;
 
-	tr_hdr = kmalloc(sizeof(struct smb2_transform_hdr), GFP_KERNEL);
-	if (!tr_hdr)
-		goto err_free_iov;
-
 	/* fill the 2nd iov with a transform header */
 	fill_transform_hdr(tr_hdr, orig_len, old_rq);
 	new_rq->rq_iov[0].iov_base = tr_hdr;
@@ -2287,32 +2288,36 @@ smb3_init_transform_rq(struct TCP_Server_Info *server, struct smb_rqst *new_rq,
 	rc = crypt_message(server, new_rq, 1);
 	cifs_dbg(FYI, "encrypt message returned %d", rc);
 	if (rc)
-		goto err_free_tr_hdr;
+		goto err_free_iov;
 
 	return rc;
 
-err_free_tr_hdr:
-	kfree(tr_hdr);
 err_free_iov:
 	kfree(iov);
 err_free_pages:
 	for (i = i - 1; i >= 0; i--)
 		put_page(pages[i]);
 	kfree(pages);
+err_free_tr_hdr:
+	kfree(tr_hdr);
 	return rc;
 }
 
+/* Only the first request has a transform header */
 static void
-smb3_free_transform_rq(struct smb_rqst *rqst)
+smb3_free_transform_rq(int num_rqst, struct smb_rqst *rqst)
 {
-	int i = rqst->rq_npages - 1;
+	int i, j;
 
-	for (; i >= 0; i--)
-		put_page(rqst->rq_pages[i]);
-	kfree(rqst->rq_pages);
 	/* free transform header */
 	kfree(rqst->rq_iov[0].iov_base);
-	kfree(rqst->rq_iov);
+
+	for (i = 0; i < num_rqst; i++) {
+		for (j = rqst[i].rq_npages - 1; j >= 0; j--)
+			put_page(rqst[i].rq_pages[j]);
+		kfree(rqst[i].rq_pages);
+		kfree(rqst[i].rq_iov);
+	}
 }
 
 static int
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index b2af2341f6b8..6f3733380e41 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -327,14 +327,20 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 	return rc;
 }
 
+#define MAX_COMPOUND 5
+
 static int
-smb_send_rqst(struct TCP_Server_Info *server, struct smb_rqst *rqst, int flags)
+smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
+	      struct smb_rqst *rqst, int flags)
 {
-	struct smb_rqst cur_rqst;
+	struct smb_rqst cur_rqst[MAX_COMPOUND];
 	int rc;
 
+	if (num_rqst > MAX_COMPOUND)
+		return -ENOMEM;
+
 	if (!(flags & CIFS_TRANSFORM_REQ))
-		return __smb_send_rqst(server, 1, rqst);
+		return __smb_send_rqst(server, num_rqst, rqst);
 
 	if (!server->ops->init_transform_rq ||
 	    !server->ops->free_transform_rq) {
@@ -342,12 +348,12 @@ smb_send_rqst(struct TCP_Server_Info *server, struct smb_rqst *rqst, int flags)
 		return -EIO;
 	}
 
-	rc = server->ops->init_transform_rq(server, &cur_rqst, rqst);
+	rc = server->ops->init_transform_rq(server, num_rqst, cur_rqst, rqst);
 	if (rc)
 		return rc;
 
-	rc = __smb_send_rqst(server, 1, &cur_rqst);
-	server->ops->free_transform_rq(&cur_rqst);
+	rc = __smb_send_rqst(server, num_rqst, cur_rqst);
+	server->ops->free_transform_rq(num_rqst, cur_rqst);
 	return rc;
 }
 
@@ -561,7 +567,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
 	 */
 	cifs_save_when_sent(mid);
 	cifs_in_send_inc(server);
-	rc = smb_send_rqst(server, rqst, flags);
+	rc = smb_send_rqst(server, 1, rqst, flags);
 	cifs_in_send_dec(server);
 
 	if (rc < 0) {
@@ -751,7 +757,7 @@ cifs_send_recv(const unsigned int xid, struct cifs_ses *ses,
 
 	midQ->mid_state = MID_REQUEST_SUBMITTED;
 	cifs_in_send_inc(ses->server);
-	rc = smb_send_rqst(ses->server, rqst, flags);
+	rc = smb_send_rqst(ses->server, 1, rqst, flags);
 	cifs_in_send_dec(ses->server);
 	cifs_save_when_sent(midQ);
 
-- 
2.13.3
