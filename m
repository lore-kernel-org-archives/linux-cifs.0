From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 11/15] cifs: allocate kvec array for cifs_readdata as a separate allocation
Date: Mon,  6 Aug 2012 07:31:08 -0400
Message-ID: <1344252672-15244-12-git-send-email-jlayton@redhat.com>
References: <1344252672-15244-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1344252672-15244-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Eventually, we're going to want to append a list of pages to
cifs_readdata instead of a list of kvecs. To prepare for that, turn
the kvec array allocation into a separate one and just keep a
pointer to it in the readdata.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h |  2 +-
 fs/cifs/file.c     | 15 ++++++++++++---
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 0f06a57..9437162 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -981,7 +981,7 @@ struct cifs_readdata {
 	int (*marshal_iov) (struct cifs_readdata *rdata,
 			    unsigned int remaining);
 	unsigned int			nr_iov;
-	struct kvec			iov[1];
+	struct kvec			*iov;
 };
 
 struct cifs_writedata;
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 3876abb..7d822c6 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2410,19 +2410,27 @@ ssize_t cifs_strict_writev(struct kiocb *iocb, const struct iovec *iov,
 }
 
 static struct cifs_readdata *
-cifs_readdata_alloc(unsigned int nr_vecs, work_func_t complete)
+cifs_readdata_alloc(unsigned int nr_pages, work_func_t complete)
 {
 	struct cifs_readdata *rdata;
+	struct kvec *iov;
 
-	rdata = kzalloc(sizeof(*rdata) +
-			sizeof(struct kvec) * nr_vecs, GFP_KERNEL);
+	iov = kzalloc(sizeof(*iov) * (nr_pages + 1), GFP_KERNEL);
+	if (!iov)
+		return (struct cifs_readdata *)iov;
+
+	rdata = kzalloc(sizeof(*rdata), GFP_KERNEL);
 	if (rdata != NULL) {
 		kref_init(&rdata->refcount);
 		INIT_LIST_HEAD(&rdata->list);
 		init_completion(&rdata->done);
 		INIT_WORK(&rdata->work, complete);
 		INIT_LIST_HEAD(&rdata->pages);
+		rdata->iov = iov;
+	} else {
+		kfree(iov);
 	}
+
 	return rdata;
 }
 
@@ -2435,6 +2443,7 @@ cifs_readdata_release(struct kref *refcount)
 	if (rdata->cfile)
 		cifsFileInfo_put(rdata->cfile);
 
+	kfree(rdata->iov);
 	kfree(rdata);
 }
 
-- 
1.7.11.2
