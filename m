From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 19/19] cifs: remove small_smb2_init
Date: Thu,  2 Nov 2017 18:03:12 +1100
Message-ID: <20171102070312.18903-20-lsahlber@redhat.com>
References: <20171102070312.18903-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171102070312.18903-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 53 ++++++-----------------------------------------------
 1 file changed, 6 insertions(+), 47 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index d2830ab70dff..bcb02b635247 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -319,54 +319,16 @@ fill_small_buf(__le16 smb2_command, struct cifs_tcon *tcon, void *buf,
 	*total_len = parmsize + sizeof(struct smb2_sync_hdr);
 }
 
-/* init request without RFC1001 length at the beginning */
-static int
-smb2_plain_req_init(__le16 smb2_command, struct cifs_tcon *tcon,
-		    void **request_buf, unsigned int *total_len)
-{
-	int rc;
-	struct smb2_sync_hdr *shdr;
-
-	rc = smb2_reconnect(smb2_command, tcon);
-	if (rc)
-		return rc;
-
-	/* BB eventually switch this to SMB2 specific small buf size */
-	*request_buf = cifs_small_buf_get();
-	if (*request_buf == NULL) {
-		/* BB should we add a retry in here if not a writepage? */
-		return -ENOMEM;
-	}
-
-	shdr = (struct smb2_sync_hdr *)(*request_buf);
-
-	fill_small_buf(smb2_command, tcon, shdr, total_len);
-
-	if (tcon != NULL) {
-#ifdef CONFIG_CIFS_STATS2
-		uint16_t com_code = le16_to_cpu(smb2_command);
-
-		cifs_stats_inc(&tcon->stats.smb2_stats.smb2_com_sent[com_code]);
-#endif
-		cifs_stats_inc(&tcon->num_smbs_sent);
-	}
-
-	return rc;
-}
-
 /*
  * Allocate and return pointer to an SMB request hdr, and set basic
  * SMB information in the SMB header. If the return code is zero, this
- * function must have filled in request_buf pointer. The returned buffer
- * has RFC1001 length at the beginning.
+ * function must have filled in request_buf pointer.
  */
 static int
-small_smb2_init(__le16 smb2_command, struct cifs_tcon *tcon,
-		void **request_buf)
+smb2_plain_req_init(__le16 smb2_command, struct cifs_tcon *tcon,
+		    void **request_buf, unsigned int *total_len)
 {
 	int rc;
-	unsigned int total_len;
-	struct smb2_pdu *pdu;
 
 	rc = smb2_reconnect(smb2_command, tcon);
 	if (rc)
@@ -379,12 +341,9 @@ small_smb2_init(__le16 smb2_command, struct cifs_tcon *tcon,
 		return -ENOMEM;
 	}
 
-	pdu = (struct smb2_pdu *)(*request_buf);
-
-	fill_small_buf(smb2_command, tcon, get_sync_hdr(pdu), &total_len);
-
-	/* Note this is only network field converted to big endian */
-	pdu->hdr.smb2_buf_length = cpu_to_be32(total_len);
+	fill_small_buf(smb2_command, tcon,
+		       (struct smb2_sync_hdr *)(*request_buf),
+		       total_len);
 
 	if (tcon != NULL) {
 #ifdef CONFIG_CIFS_STATS2
-- 
2.13.3
