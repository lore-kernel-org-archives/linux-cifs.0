From: Gregor Beck <gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH 7/9] fix some cFYI in cifssmb.c
Date: Fri, 22 Nov 2013 11:26:56 +0100
Message-ID: <1385116018-14068-8-git-send-email-gbeck@sernet.de>
References: <E1VjSnS-004B9V-Fo@intern.SerNet.DE>
 <1385116018-14068-1-git-send-email-gbeck@sernet.de>
Cc: Gregor Beck <gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1385116018-14068-1-git-send-email-gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

---
 cifssmb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/cifssmb.c b/cifssmb.c
index 38be854..5d10afc 100644
--- a/cifssmb.c
+++ b/cifssmb.c
@@ -3935,7 +3935,7 @@ QFileInfoRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cifs_dbg(FYI, "Send error in QPathInfo = %d\n", rc);
+		cifs_dbg(FYI, "Send error in QFileInfo = %d", rc);
 	} else {		/* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
@@ -4131,7 +4131,7 @@ UnixQFileInfoRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cifs_dbg(FYI, "Send error in QPathInfo = %d\n", rc);
+		cifs_dbg(FYI, "Send error in UnixQFileInfo = %d", rc);
 	} else {		/* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
@@ -4215,7 +4215,7 @@ UnixQPathInfoRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cifs_dbg(FYI, "Send error in QPathInfo = %d\n", rc);
+		cifs_dbg(FYI, "Send error in UnixQPathInfo = %d", rc);
 	} else {		/* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
-- 
1.7.9.5
