From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: use memcpy for magic string in cifs signature generation BSRSPYL
Date: Fri, 19 Aug 2011 21:19:17 -0400
Message-ID: <1313803157-31952-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...it's more efficient since we know the length.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsencrypt.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index e76bfeb..f11dfb6 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -92,7 +92,7 @@ int cifs_sign_smb(struct smb_hdr *cifs_pdu, struct TCP_Server_Info *server,
 		return rc;
 
 	if (!server->session_estab) {
-		strncpy(cifs_pdu->Signature.SecuritySignature, "BSRSPYL", 8);
+		memcpy(cifs_pdu->Signature.SecuritySignature, "BSRSPYL", 8);
 		return rc;
 	}
 
@@ -189,7 +189,7 @@ int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_Info *server,
 		return rc;
 
 	if (!server->session_estab) {
-		strncpy(cifs_pdu->Signature.SecuritySignature, "BSRSPYL", 8);
+		memcpy(cifs_pdu->Signature.SecuritySignature, "BSRSPYL", 8);
 		return rc;
 	}
 
-- 
1.7.6
