From: Long Li <longli@linuxonhyperv.com>
Subject: [Patch v2 06/15] CIFS: Introduce helper function to get page offset and length in smb_rqst
Date: Wed, 30 May 2018 12:47:58 -0700
Message-ID: <20180530194807.31657-7-longli@linuxonhyperv.com>
References: <20180530194807.31657-1-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180530194807.31657-1-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

Introduce a function rqst_page_get_length to return the page offset and
length for a given page in smb_rqst. This function is to be used by
following patches.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifsproto.h |  3 +++
 fs/cifs/misc.c      | 17 +++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 7933c5f..89dda14 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -557,4 +557,7 @@ int cifs_alloc_hash(const char *name, struct crypto_shash **shash,
 		    struct sdesc **sdesc);
 void cifs_free_hash(struct crypto_shash **shash, struct sdesc **sdesc);
 
+extern void rqst_page_get_length(struct smb_rqst *rqst, unsigned int page,
+				unsigned int *len, unsigned int *offset);
+
 #endif			/* _CIFSPROTO_H */
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 96849b5..e951417 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -905,3 +905,20 @@ cifs_free_hash(struct crypto_shash **shash, struct sdesc **sdesc)
 		crypto_free_shash(*shash);
 	*shash = NULL;
 }
+
+/**
+ * rqst_page_get_length - obtain the length and offset for a page in smb_rqst
+ * Input: rqst - a smb_rqst, page - a page index for rqst
+ * Output: *len - the length for this page, *offset - the offset for this page
+ */
+void rqst_page_get_length(struct smb_rqst *rqst, unsigned int page,
+				unsigned int *len, unsigned int *offset)
+{
+	*len = rqst->rq_pagesz;
+	*offset = (page == 0) ? rqst->rq_offset : 0;
+
+	if (rqst->rq_npages == 1 || page == rqst->rq_npages-1)
+		*len = rqst->rq_tailsz;
+	else if (page == 0)
+		*len = rqst->rq_pagesz - rqst->rq_offset;
+}
-- 
2.7.4
