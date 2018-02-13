From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 08/14] cifs: update smb3_init_transform_rq to take an array of requests
Date: Tue, 13 Feb 2018 15:42:28 +1100
Message-ID: <20180213044234.18364-9-lsahlber@redhat.com>
References: <20180213044234.18364-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180213044234.18364-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The first request will get pre-pended with a smb3 transform header.

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb2ops.c | 119 ++++++++++++++++++++++++++++++------------------------
 1 file changed, 67 insertions(+), 52 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index dd49354a35af..80462bb3fd03 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2236,68 +2236,85 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
 	return rc;
 }
 
+static void
+smb3_free_transform_rq_one(struct smb_rqst *rqst)
+{
+	int i;
+
+	for (i = rqst->rq_npages - 1; i >= 0; i--)
+		put_page(rqst->rq_pages[i]);
+	kfree(rqst->rq_pages);
+	kfree(rqst->rq_iov);
+}
+
 /* Encrypt all the requests but only add a transform header to the first */
 static int
 smb3_init_transform_rq(struct TCP_Server_Info *server, int num_rqst,
 		       struct smb_rqst *new_rq, struct smb_rqst *old_rq)
 {
-	struct kvec *iov;
-	struct page **pages;
+	struct kvec *iov = NULL;
+	struct page **pages = NULL;
 	struct smb2_transform_hdr *tr_hdr;
-	unsigned int npages = old_rq->rq_npages;
+	unsigned int npages;
 	unsigned int orig_len = 0;
-	int i;
+	int i, j = 0;
 	int rc = -ENOMEM;
 
 	tr_hdr = kmalloc(sizeof(struct smb2_transform_hdr), GFP_KERNEL);
 	if (!tr_hdr)
 		return rc;
 
-	pages = kmalloc_array(npages, sizeof(struct page *), GFP_KERNEL);
-	if (!pages)
-		goto err_free_tr_hdr;
-
-	new_rq->rq_pages = pages;
-	new_rq->rq_npages = old_rq->rq_npages;
-	new_rq->rq_pagesz = old_rq->rq_pagesz;
-	new_rq->rq_tailsz = old_rq->rq_tailsz;
-
-	for (i = 0; i < old_rq->rq_nvec; i++)
-		orig_len += old_rq->rq_iov[i].iov_len;
+	for (i = 0; i < num_rqst; i++) {
+		for (j = 0; j < old_rq[i].rq_nvec; j++)
+			orig_len += old_rq[i].rq_iov[j].iov_len;
+
+		npages = old_rq[i].rq_npages;
+		pages = kmalloc_array(npages, sizeof(struct page *),
+				      GFP_KERNEL);
+		if (!pages)
+			goto err_free_tr_hdr;
+
+		new_rq[i].rq_pages = pages;
+		new_rq[i].rq_npages = old_rq[i].rq_npages;
+		new_rq[i].rq_pagesz = old_rq[i].rq_pagesz;
+		new_rq[i].rq_tailsz = old_rq[i].rq_tailsz;
+
+		for (j = 0; j < npages; j++) {
+			pages[j] = alloc_page(GFP_KERNEL|__GFP_HIGHMEM);
+			if (!pages[j])
+				goto err_free_pages;
+		}
 
-	for (i = 0; i < npages; i++) {
-		pages[i] = alloc_page(GFP_KERNEL|__GFP_HIGHMEM);
-		if (!pages[i])
+		/* Copy all iovs from the old. The first request has an extra
+		 * iov to hold the transform header.
+		 */
+		iov = kmalloc_array(old_rq[i].rq_nvec + (i == 0),
+				    sizeof(struct kvec), GFP_KERNEL);
+		if (!iov)
 			goto err_free_pages;
-	}
-
-	iov = kmalloc_array(old_rq->rq_nvec + 1, sizeof(struct kvec),
-			    GFP_KERNEL);
-	if (!iov)
-		goto err_free_pages;
 
-	/* copy all iovs from the old */
-	memcpy(&iov[1], &old_rq->rq_iov[0],
-				sizeof(struct kvec) * old_rq->rq_nvec);
-
-	new_rq->rq_iov = iov;
-	new_rq->rq_nvec = old_rq->rq_nvec + 1;
+		memcpy(&iov[i == 0], &old_rq[i].rq_iov[0],
+		       sizeof(struct kvec) * old_rq[i].rq_nvec);
+
+		new_rq->rq_iov = iov;
+		new_rq->rq_nvec = old_rq[i].rq_nvec + (i == 0);
+
+		/* copy pages form the old */
+		for (j = 0; j < npages; j++) {
+			char *dst = kmap(new_rq[i].rq_pages[j]);
+			char *src = kmap(old_rq[i].rq_pages[j]);
+			unsigned int len = (j < npages - 1) ?
+				new_rq[i].rq_pagesz : new_rq[i].rq_tailsz;
+			memcpy(dst, src, len);
+			kunmap(new_rq[i].rq_pages[j]);
+			kunmap(old_rq[i].rq_pages[j]);
+		}
+	}
 
 	/* fill the 1st iov with a transform header */
 	fill_transform_hdr(tr_hdr, orig_len, old_rq);
-	new_rq->rq_iov[0].iov_base = tr_hdr;
-	new_rq->rq_iov[0].iov_len = sizeof(struct smb2_transform_hdr);
-
-	/* copy pages form the old */
-	for (i = 0; i < npages; i++) {
-		char *dst = kmap(new_rq->rq_pages[i]);
-		char *src = kmap(old_rq->rq_pages[i]);
-		unsigned int len = (i < npages - 1) ? new_rq->rq_pagesz :
-							new_rq->rq_tailsz;
-		memcpy(dst, src, len);
-		kunmap(new_rq->rq_pages[i]);
-		kunmap(old_rq->rq_pages[i]);
-	}
+	new_rq[0].rq_iov[0].iov_base = tr_hdr;
+	new_rq[0].rq_iov[0].iov_len = sizeof(struct smb2_transform_hdr);
 
 	rc = crypt_message(server, num_rqst, new_rq, 1);
 	cifs_dbg(FYI, "encrypt message returned %d", rc);
@@ -2309,11 +2326,13 @@ smb3_init_transform_rq(struct TCP_Server_Info *server, int num_rqst,
 err_free_iov:
 	kfree(iov);
 err_free_pages:
-	for (i = i - 1; i >= 0; i--)
-		put_page(pages[i]);
+	for (j = j - 1; j >= 0; j--)
+		put_page(pages[j]);
 	kfree(pages);
 err_free_tr_hdr:
 	kfree(tr_hdr);
+	while (--i >= 0)
+		smb3_free_transform_rq_one(&new_rq[i]);
 	return rc;
 }
 
@@ -2321,17 +2340,13 @@ smb3_init_transform_rq(struct TCP_Server_Info *server, int num_rqst,
 static void
 smb3_free_transform_rq(int num_rqst, struct smb_rqst *rqst)
 {
-	int i, j;
+	int i;
 
 	/* free transform header */
 	kfree(rqst->rq_iov[0].iov_base);
 
-	for (i = 0; i < num_rqst; i++) {
-		for (j = rqst[i].rq_npages - 1; j >= 0; j--)
-			put_page(rqst[i].rq_pages[j]);
-		kfree(rqst[i].rq_pages);
-		kfree(rqst[i].rq_iov);
-	}
+	for (i = 0; i < num_rqst; i++)
+		smb3_free_transform_rq_one(&rqst[i]);
 }
 
 static int
-- 
2.13.3
