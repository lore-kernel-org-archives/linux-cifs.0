From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 03/19] cifs: make decode_ascii_ssetup void return
Date: Tue, 28 May 2013 08:11:44 -0400
Message-ID: <1369743120-18941-4-git-send-email-jlayton@redhat.com>
References: <1369743120-18941-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1369743120-18941-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...rc is always set to 0.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Acked-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/sess.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index f230571..838e224 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -310,11 +310,10 @@ decode_unicode_ssetup(char **pbcc_area, int bleft, struct cifs_ses *ses,
 	return;
 }
 
-static int decode_ascii_ssetup(char **pbcc_area, __u16 bleft,
-			       struct cifs_ses *ses,
-			       const struct nls_table *nls_cp)
+static void decode_ascii_ssetup(char **pbcc_area, __u16 bleft,
+				struct cifs_ses *ses,
+				const struct nls_table *nls_cp)
 {
-	int rc = 0;
 	int len;
 	char *bcc_ptr = *pbcc_area;
 
@@ -322,7 +321,7 @@ static int decode_ascii_ssetup(char **pbcc_area, __u16 bleft,
 
 	len = strnlen(bcc_ptr, bleft);
 	if (len >= bleft)
-		return rc;
+		return;
 
 	kfree(ses->serverOS);
 
@@ -339,7 +338,7 @@ static int decode_ascii_ssetup(char **pbcc_area, __u16 bleft,
 
 	len = strnlen(bcc_ptr, bleft);
 	if (len >= bleft)
-		return rc;
+		return;
 
 	kfree(ses->serverNOS);
 
@@ -352,7 +351,7 @@ static int decode_ascii_ssetup(char **pbcc_area, __u16 bleft,
 
 	len = strnlen(bcc_ptr, bleft);
 	if (len > bleft)
-		return rc;
+		return;
 
 	/* No domain field in LANMAN case. Domain is
 	   returned by old servers in the SMB negprot response */
@@ -360,8 +359,6 @@ static int decode_ascii_ssetup(char **pbcc_area, __u16 bleft,
 	   but thus do return domain here we could add parsing
 	   for it later, but it is not very important */
 	cifs_dbg(FYI, "ascii: bytes left %d\n", bleft);
-
-	return rc;
 }
 
 int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
@@ -938,8 +935,7 @@ ssetup_ntlmssp_authenticate:
 		}
 		decode_unicode_ssetup(&bcc_ptr, bytes_remaining, ses, nls_cp);
 	} else {
-		rc = decode_ascii_ssetup(&bcc_ptr, bytes_remaining,
-					 ses, nls_cp);
+		decode_ascii_ssetup(&bcc_ptr, bytes_remaining, ses, nls_cp);
 	}
 
 ssetup_exit:
-- 
1.8.1.4
