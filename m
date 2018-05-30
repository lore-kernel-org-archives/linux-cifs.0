From: Long Li <longli@linuxonhyperv.com>
Subject: [Patch v2 11/15] CIFS: Pass page offset for calculating signature
Date: Wed, 30 May 2018 12:48:03 -0700
Message-ID: <20180530194807.31657-12-longli@linuxonhyperv.com>
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

When calculating signature for the packet, it needs to read into the
correct page offset for the data.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifsencrypt.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index a6ef088..e88303c 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -68,11 +68,12 @@ int __cifs_calc_signature(struct smb_rqst *rqst,
 
 	/* now hash over the rq_pages array */
 	for (i = 0; i < rqst->rq_npages; i++) {
-		void *kaddr = kmap(rqst->rq_pages[i]);
-		size_t len = rqst->rq_pagesz;
+		void *kaddr;
+		unsigned int len, offset;
 
-		if (i == rqst->rq_npages - 1)
-			len = rqst->rq_tailsz;
+		rqst_page_get_length(rqst, i, &len, &offset);
+
+		kaddr = (char *) kmap(rqst->rq_pages[i]) + offset;
 
 		crypto_shash_update(shash, kaddr, len);
 
-- 
2.7.4
