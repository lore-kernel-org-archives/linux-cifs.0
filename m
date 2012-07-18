From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 07/11] cifs: teach signing routines how to deal with arrays of pages in a smb_rqst
Date: Wed, 18 Jul 2012 13:59:02 -0400
Message-ID: <1342634346-22818-8-git-send-email-jlayton@redhat.com>
References: <1342634346-22818-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342634346-22818-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Use the smb_send_rqst helper function to kmap each page in the array
and update the hash for that chunk.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsencrypt.c |   11 +++++++++++
 fs/cifs/cifsproto.h   |    3 +++
 fs/cifs/transport.c   |    2 +-
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index e8953a0..511d1ae 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -29,6 +29,7 @@
 #include "ntlmssp.h"
 #include <linux/ctype.h>
 #include <linux/random.h>
+#include <linux/highmem.h>
 
 /*
  * Calculate and return the CIFS signature based on the mac key and SMB PDU.
@@ -93,6 +94,16 @@ static int cifs_calc_signature(struct smb_rqst *rqst,
 		}
 	}
 
+	/* now hash over the rq_pages array */
+	for (i = 0; i < rqst->rq_npages; i++) {
+		struct kvec p_iov;
+
+		cifs_rqst_page_to_kvec(rqst, i, &p_iov);
+		crypto_shash_update(&server->secmech.sdescmd5->shash,
+					p_iov.iov_base, p_iov.iov_len);
+		kunmap(rqst->rq_pages[i]);
+	}
+
 	rc = crypto_shash_final(&server->secmech.sdescmd5->shash, signature);
 	if (rc)
 		cERROR(1, "%s: Could not generate md5 hash", __func__);
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index b59e066..b2daad4 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -24,6 +24,7 @@
 
 struct statfs;
 struct smb_vol;
+struct smb_rqst;
 
 /*
  *****************************************************************
@@ -35,6 +36,8 @@ extern struct smb_hdr *cifs_buf_get(void);
 extern void cifs_buf_release(void *);
 extern struct smb_hdr *cifs_small_buf_get(void);
 extern void cifs_small_buf_release(void *);
+extern void cifs_rqst_page_to_kvec(struct smb_rqst *rqst, unsigned int idx,
+					struct kvec *iov);
 extern int smb_send(struct TCP_Server_Info *, struct smb_hdr *,
 			unsigned int /* length */);
 extern unsigned int _GetXid(void);
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 006c3fb..8e689d1 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -252,7 +252,7 @@ smb_send_kvec(struct TCP_Server_Info *server, struct kvec *iov, size_t n_vec,
  * The page will be kmapped and the address placed into iov_base. The length
  * will then be adjusted according to the ptailoff.
  */
-static void
+void
 cifs_rqst_page_to_kvec(struct smb_rqst *rqst, unsigned int idx,
 			struct kvec *iov)
 {
-- 
1.7.10.4
