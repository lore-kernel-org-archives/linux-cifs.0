From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 3/5] cifs: add refcounting to cifs_readdata structures
Date: Fri, 13 Apr 2012 22:23:20 -0400
Message-ID: <1334370202-30711-4-git-send-email-jlayton@redhat.com>
References: <1334370202-30711-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1334370202-30711-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This isn't strictly necessary for the async readpages code, but the
uncached version will need to be able to collect the replies after
issuing the calls. Add a kref to cifs_readdata and use change the
code to take and put references appropriately.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsproto.h |    2 ++
 fs/cifs/cifssmb.c   |    3 +++
 fs/cifs/file.c      |   21 ++++++++++++++-------
 3 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index f309b43..63e91c7 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -464,6 +464,7 @@ extern int SMBencrypt(unsigned char *passwd, const unsigned char *c8,
 
 /* asynchronous read support */
 struct cifs_readdata {
+	struct kref			refcount;
 	struct cifsFileInfo		*cfile;
 	struct address_space		*mapping;
 	__u64				offset;
@@ -478,6 +479,7 @@ struct cifs_readdata {
 	struct kvec			iov[1];
 };
 
+void cifs_readdata_release(struct kref *refcount);
 int cifs_async_readv(struct cifs_readdata *rdata);
 
 /* asynchronous write support */
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 733af77..2591bf8 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1635,12 +1635,15 @@ cifs_async_readv(struct cifs_readdata *rdata)
 	rdata->iov[0].iov_base = smb;
 	rdata->iov[0].iov_len = be32_to_cpu(smb->hdr.smb_buf_length) + 4;
 
+	kref_get(&rdata->refcount);
 	rc = cifs_call_async(tcon->ses->server, rdata->iov, 1,
 			     cifs_readv_receive, cifs_readv_callback,
 			     rdata, false);
 
 	if (rc == 0)
 		cifs_stats_inc(&tcon->num_reads);
+	else
+		kref_put(&rdata->refcount, cifs_readdata_release);
 
 	cifs_small_buf_release(smb);
 	return rc;
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 183381d..ae285e0 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2347,16 +2347,22 @@ cifs_readdata_alloc(unsigned int nr_vecs, work_func_t complete)
 	rdata = kzalloc(sizeof(*rdata) +
 			sizeof(struct kvec) * nr_vecs, GFP_KERNEL);
 	if (rdata != NULL) {
+		kref_init(&rdata->refcount);
 		INIT_WORK(&rdata->work, complete);
 		INIT_LIST_HEAD(&rdata->pages);
 	}
 	return rdata;
 }
 
-static void
-cifs_readdata_free(struct cifs_readdata *rdata)
+void
+cifs_readdata_release(struct kref *refcount)
 {
-	cifsFileInfo_put(rdata->cfile);
+	struct cifs_readdata *rdata = container_of(refcount,
+					struct cifs_readdata, refcount);
+
+	if (rdata->cfile)
+		cifsFileInfo_put(rdata->cfile);
+
 	kfree(rdata);
 }
 
@@ -2651,7 +2657,7 @@ cifs_readv_complete(struct work_struct *work)
 
 		page_cache_release(page);
 	}
-	cifs_readdata_free(rdata);
+	kref_put(&rdata->refcount, cifs_readdata_release);
 }
 
 static int
@@ -2837,9 +2843,8 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 		}
 
 		spin_lock(&cifs_file_list_lock);
-		cifsFileInfo_get(open_file);
 		spin_unlock(&cifs_file_list_lock);
-		rdata->cfile = open_file;
+		rdata->cfile = cifsFileInfo_get(open_file);
 		rdata->mapping = mapping;
 		rdata->offset = offset;
 		rdata->bytes = bytes;
@@ -2864,9 +2869,11 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 				unlock_page(page);
 				page_cache_release(page);
 			}
-			cifs_readdata_free(rdata);
+			kref_put(&rdata->refcount, cifs_readdata_release);
 			break;
 		}
+
+		kref_put(&rdata->refcount, cifs_readdata_release);
 	}
 
 	return rc;
-- 
1.7.7.6
