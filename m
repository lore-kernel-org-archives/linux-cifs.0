From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 07/14] cifs: update init_sg and crypt_message to take an array of rqst
Date: Tue, 13 Feb 2018 15:42:27 +1100
Message-ID: <20180213044234.18364-8-lsahlber@redhat.com>
References: <20180213044234.18364-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180213044234.18364-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is used for SMB3 encryption and compounded requests.
The first rqst begins with a smb3 transform header as the first iov.

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb2ops.c | 46 ++++++++++++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 16 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 23ff4cf3ac88..dd49354a35af 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2077,29 +2077,42 @@ fill_transform_hdr(struct smb2_transform_hdr *tr_hdr, unsigned int orig_len,
  * rqst->rq_iov[1+] data to be encrypted/decrypted
  */
 static struct scatterlist *
-init_sg(struct smb_rqst *rqst, u8 *sign)
+init_sg(int num_rqst, struct smb_rqst *rqst, u8 *sign)
 {
 	unsigned int sg_len = rqst->rq_nvec + rqst->rq_npages + 1;
 	unsigned int assoc_data_len = sizeof(struct smb2_transform_hdr) - 20;
 	struct scatterlist *sg;
 	unsigned int i;
 	unsigned int j;
+	unsigned int idx = 0;
 
 	sg = kmalloc_array(sg_len, sizeof(struct scatterlist), GFP_KERNEL);
 	if (!sg)
 		return NULL;
 
 	sg_init_table(sg, sg_len);
-	sg_set_buf(&sg[0], rqst->rq_iov[0].iov_base + 20, assoc_data_len);
-	for (i = 1; i < rqst->rq_nvec; i++)
-		sg_set_buf(&sg[i], rqst->rq_iov[i].iov_base,
-						rqst->rq_iov[i].iov_len);
-	for (j = 0; i < sg_len - 1; i++, j++) {
-		unsigned int len = (j < rqst->rq_npages - 1) ? rqst->rq_pagesz
-							: rqst->rq_tailsz;
-		sg_set_page(&sg[i], rqst->rq_pages[j], len, 0);
-	}
-	sg_set_buf(&sg[sg_len - 1], sign, SMB2_SIGNATURE_SIZE);
+	for (i = 0; i < num_rqst; i++) {
+		/* the first rqst has a transform header where the first 20
+		 * bytes are not part of the encrypted blob
+		 */
+		if (i == 0)
+			sg_set_buf(&sg[idx++], rqst[i].rq_iov[i].iov_base + 20,
+				   assoc_data_len);
+		else
+			sg_set_buf(&sg[idx++], rqst[i].rq_iov[i].iov_base,
+				   rqst[i].rq_iov[0].iov_len);
+
+		for (j = 1; j < rqst[i].rq_nvec; j++)
+			sg_set_buf(&sg[idx++], rqst[i].rq_iov[j].iov_base,
+				   rqst[i].rq_iov[j].iov_len);
+
+		for (j = 0; j < rqst[i].rq_npages; j++) {
+			unsigned int len = (j < rqst[i].rq_npages - 1) ?
+				rqst[i].rq_pagesz : rqst[i].rq_tailsz;
+			sg_set_page(&sg[idx++], rqst[i].rq_pages[j], len, 0);
+		}
+	}
+	sg_set_buf(&sg[idx], sign, SMB2_SIGNATURE_SIZE);
 	return sg;
 }
 
@@ -2131,7 +2144,8 @@ smb2_get_enc_key(struct TCP_Server_Info *server, __u64 ses_id, int enc, u8 *key)
  * untouched.
  */
 static int
-crypt_message(struct TCP_Server_Info *server, struct smb_rqst *rqst, int enc)
+crypt_message(struct TCP_Server_Info *server, int num_rqst,
+	      struct smb_rqst *rqst, int enc)
 {
 	struct smb2_transform_hdr *tr_hdr =
 			(struct smb2_transform_hdr *)rqst->rq_iov[0].iov_base;
@@ -2185,7 +2199,7 @@ crypt_message(struct TCP_Server_Info *server, struct smb_rqst *rqst, int enc)
 		crypt_len += SMB2_SIGNATURE_SIZE;
 	}
 
-	sg = init_sg(rqst, sign);
+	sg = init_sg(num_rqst, rqst, sign);
 	if (!sg) {
 		cifs_dbg(VFS, "%s: Failed to init sg", __func__);
 		rc = -ENOMEM;
@@ -2269,7 +2283,7 @@ smb3_init_transform_rq(struct TCP_Server_Info *server, int num_rqst,
 	new_rq->rq_iov = iov;
 	new_rq->rq_nvec = old_rq->rq_nvec + 1;
 
-	/* fill the 2nd iov with a transform header */
+	/* fill the 1st iov with a transform header */
 	fill_transform_hdr(tr_hdr, orig_len, old_rq);
 	new_rq->rq_iov[0].iov_base = tr_hdr;
 	new_rq->rq_iov[0].iov_len = sizeof(struct smb2_transform_hdr);
@@ -2285,7 +2299,7 @@ smb3_init_transform_rq(struct TCP_Server_Info *server, int num_rqst,
 		kunmap(old_rq->rq_pages[i]);
 	}
 
-	rc = crypt_message(server, new_rq, 1);
+	rc = crypt_message(server, num_rqst, new_rq, 1);
 	cifs_dbg(FYI, "encrypt message returned %d", rc);
 	if (rc)
 		goto err_free_iov;
@@ -2349,7 +2363,7 @@ decrypt_raw_data(struct TCP_Server_Info *server, char *buf,
 	rqst.rq_pagesz = PAGE_SIZE;
 	rqst.rq_tailsz = (page_data_size % PAGE_SIZE) ? : PAGE_SIZE;
 
-	rc = crypt_message(server, &rqst, 0);
+	rc = crypt_message(server, 1, &rqst, 0);
 	cifs_dbg(FYI, "decrypt message returned %d\n", rc);
 
 	if (rc)
-- 
2.13.3
