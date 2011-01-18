From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/5] cifs: clean up unaligned accesses in validate_t2
Date: Tue, 18 Jan 2011 15:33:16 -0500
Message-ID: <1295382799-7902-3-git-send-email-jlayton@redhat.com>
References: <1295382799-7902-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1295382799-7902-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...and clean up function to reduce indentation.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifssmb.c |   44 +++++++++++++++++++++++---------------------
 1 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 3b3072c..75a1559 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -331,31 +331,33 @@ smb_init_no_reconnect(int smb_command, int wct, struct cifsTconInfo *tcon,
 
 static int validate_t2(struct smb_t2_rsp *pSMB)
 {
-	int rc = -EINVAL;
-	int total_size;
+	unsigned int total_size;
+
+	/* check for plausible wct */
+	if (pSMB->hdr.WordCount < 10)
+		goto vt2_err;
 
-	/* check for plausible wct, bcc and t2 data and parm sizes */
 	/* check for parm and data offset going beyond end of smb */
-	if (pSMB->hdr.WordCount >= 10) {
-		if ((le16_to_cpu(pSMB->t2_rsp.ParameterOffset) <= 1024) &&
-		   (le16_to_cpu(pSMB->t2_rsp.DataOffset) <= 1024)) {
-			/* check that bcc is at least as big as parms + data */
-			/* check that bcc is less than negotiated smb buffer */
-			total_size = le16_to_cpu(pSMB->t2_rsp.ParameterCount);
-			if (total_size < 512) {
-				total_size +=
-					le16_to_cpu(pSMB->t2_rsp.DataCount);
-				if (total_size <= get_bcc(&pSMB->hdr) &&
-				    total_size <
-					CIFSMaxBufSize + MAX_CIFS_HDR_SIZE) {
-					return 0;
-				}
-			}
-		}
-	}
+	if (get_unaligned_le16(&pSMB->t2_rsp.ParameterOffset) > 1024 ||
+	    get_unaligned_le16(&pSMB->t2_rsp.DataOffset) > 1024)
+		goto vt2_err;
+
+	/* check that bcc is at least as big as parms + data */
+	/* check that bcc is less than negotiated smb buffer */
+	total_size = get_unaligned_le16(&pSMB->t2_rsp.ParameterCount);
+	if (total_size >= 512)
+		goto vt2_err;
+
+	total_size += get_unaligned_le16(&pSMB->t2_rsp.DataCount);
+	if (total_size > get_bcc(&pSMB->hdr) ||
+	    total_size >= CIFSMaxBufSize + MAX_CIFS_HDR_SIZE)
+		goto vt2_err;
+
+	return 0;
+vt2_err:
 	cifs_dump_mem("Invalid transact2 SMB: ", (char *)pSMB,
 		sizeof(struct smb_t2_rsp) + 16);
-	return rc;
+	return -EINVAL;
 }
 
 int
-- 
1.7.3.4
