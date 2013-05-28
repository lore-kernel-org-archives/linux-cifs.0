From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 09/19] cifs: move handling of signed connections into separate function
Date: Tue, 28 May 2013 08:11:50 -0400
Message-ID: <1369743120-18941-10-git-send-email-jlayton@redhat.com>
References: <1369743120-18941-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1369743120-18941-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Move the sanity checks for signed connections into a separate function.
SMB2's was a cut-and-paste job from CIFS code, so we can make them use
the same function.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsproto.h |  1 +
 fs/cifs/cifssmb.c   | 68 +++++++++++++++++++++++++++--------------------------
 fs/cifs/smb2pdu.c   | 33 ++++----------------------
 3 files changed, 40 insertions(+), 62 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index dda188a..f0e93ff 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -212,6 +212,7 @@ extern int cifs_negotiate_protocol(const unsigned int xid,
 				   struct cifs_ses *ses);
 extern int cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 			      struct nls_table *nls_info);
+extern int cifs_enable_signing(struct TCP_Server_Info *server, unsigned int secFlags);
 extern int CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses);
 
 extern int CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 5dd4f8a..1a37763 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -417,6 +417,38 @@ decode_ext_sec_blob(struct TCP_Server_Info *server, NEGOTIATE_RSP *pSMBr)
 	return 0;
 }
 
+int
+cifs_enable_signing(struct TCP_Server_Info *server, unsigned int secFlags)
+{
+	if ((secFlags & CIFSSEC_MAY_SIGN) == 0) {
+		/* MUST_SIGN already includes the MAY_SIGN FLAG
+		   so if this is zero it means that signing is disabled */
+		cifs_dbg(FYI, "Signing disabled\n");
+		if (server->sec_mode & SECMODE_SIGN_REQUIRED) {
+			cifs_dbg(VFS, "Server requires packet signing to be enabled in /proc/fs/cifs/SecurityFlags\n");
+			return -EOPNOTSUPP;
+		}
+		server->sec_mode &=
+			~(SECMODE_SIGN_ENABLED | SECMODE_SIGN_REQUIRED);
+	} else if ((secFlags & CIFSSEC_MUST_SIGN) == CIFSSEC_MUST_SIGN) {
+		/* signing required */
+		cifs_dbg(FYI, "Must sign - secFlags 0x%x\n", secFlags);
+		if ((server->sec_mode &
+			(SECMODE_SIGN_ENABLED | SECMODE_SIGN_REQUIRED)) == 0) {
+			cifs_dbg(VFS, "signing required but server lacks support\n");
+			return -EOPNOTSUPP;
+		} else
+			server->sec_mode |= SECMODE_SIGN_REQUIRED;
+	} else {
+		/* signing optional ie CIFSSEC_MAY_SIGN */
+		if ((server->sec_mode & SECMODE_SIGN_REQUIRED) == 0)
+			server->sec_mode &=
+				~(SECMODE_SIGN_ENABLED | SECMODE_SIGN_REQUIRED);
+	}
+
+	return 0;
+}
+
 #ifdef CONFIG_CIFS_WEAK_PW_HASH
 static int
 decode_lanman_negprot_rsp(struct TCP_Server_Info *server, NEGOTIATE_RSP *pSMBr,
@@ -577,10 +609,7 @@ CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses)
 		goto neg_err_exit;
 	} else if (pSMBr->hdr.WordCount == 13) {
 		rc = decode_lanman_negprot_rsp(server, pSMBr, secFlags);
-		if (!rc)
-			goto signing_check;
-		else
-			goto neg_err_exit;
+		goto signing_check;
 	} else if (pSMBr->hdr.WordCount != 17) {
 		/* unknown wct */
 		rc = -EOPNOTSUPP;
@@ -642,36 +671,9 @@ CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses)
 	else
 		server->capabilities &= ~CAP_EXTENDED_SECURITY;
 
-	if (rc)
-		goto neg_err_exit;
-
 signing_check:
-	if ((secFlags & CIFSSEC_MAY_SIGN) == 0) {
-		/* MUST_SIGN already includes the MAY_SIGN FLAG
-		   so if this is zero it means that signing is disabled */
-		cifs_dbg(FYI, "Signing disabled\n");
-		if (server->sec_mode & SECMODE_SIGN_REQUIRED) {
-			cifs_dbg(VFS, "Server requires packet signing to be enabled in /proc/fs/cifs/SecurityFlags\n");
-			rc = -EOPNOTSUPP;
-		}
-		server->sec_mode &=
-			~(SECMODE_SIGN_ENABLED | SECMODE_SIGN_REQUIRED);
-	} else if ((secFlags & CIFSSEC_MUST_SIGN) == CIFSSEC_MUST_SIGN) {
-		/* signing required */
-		cifs_dbg(FYI, "Must sign - secFlags 0x%x\n", secFlags);
-		if ((server->sec_mode &
-			(SECMODE_SIGN_ENABLED | SECMODE_SIGN_REQUIRED)) == 0) {
-			cifs_dbg(VFS, "signing required but server lacks support\n");
-			rc = -EOPNOTSUPP;
-		} else
-			server->sec_mode |= SECMODE_SIGN_REQUIRED;
-	} else {
-		/* signing optional ie CIFSSEC_MAY_SIGN */
-		if ((server->sec_mode & SECMODE_SIGN_REQUIRED) == 0)
-			server->sec_mode &=
-				~(SECMODE_SIGN_ENABLED | SECMODE_SIGN_REQUIRED);
-	}
-
+	if (!rc)
+		rc = cifs_enable_signing(server, secFlags);
 neg_err_exit:
 	cifs_buf_release(pSMB);
 
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 3af66aa..ebb97b4 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -423,36 +423,11 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 	}
 
 	cifs_dbg(FYI, "sec_flags 0x%x\n", sec_flags);
-	if ((sec_flags & CIFSSEC_MUST_SIGN) == CIFSSEC_MUST_SIGN) {
-		cifs_dbg(FYI, "Signing required\n");
-		if (!(server->sec_mode & (SMB2_NEGOTIATE_SIGNING_REQUIRED |
-		      SMB2_NEGOTIATE_SIGNING_ENABLED))) {
-			cifs_dbg(VFS, "signing required but server lacks support\n");
-			rc = -EOPNOTSUPP;
-			goto neg_exit;
-		}
-		server->sec_mode |= SECMODE_SIGN_REQUIRED;
-	} else if (sec_flags & CIFSSEC_MAY_SIGN) {
-		cifs_dbg(FYI, "Signing optional\n");
-		if (server->sec_mode & SMB2_NEGOTIATE_SIGNING_REQUIRED) {
-			cifs_dbg(FYI, "Server requires signing\n");
-			server->sec_mode |= SECMODE_SIGN_REQUIRED;
-		} else {
-			server->sec_mode &=
-				~(SECMODE_SIGN_ENABLED | SECMODE_SIGN_REQUIRED);
-		}
-	} else {
-		cifs_dbg(FYI, "Signing disabled\n");
-		if (server->sec_mode & SMB2_NEGOTIATE_SIGNING_REQUIRED) {
-			cifs_dbg(VFS, "Server requires packet signing to be enabled in /proc/fs/cifs/SecurityFlags\n");
-			rc = -EOPNOTSUPP;
-			goto neg_exit;
-		}
-		server->sec_mode &=
-			~(SECMODE_SIGN_ENABLED | SECMODE_SIGN_REQUIRED);
-	}
-
+	rc = cifs_enable_signing(server, sec_flags);
 #ifdef CONFIG_SMB2_ASN1  /* BB REMOVEME when updated asn1.c ready */
+	if (rc)
+		goto neg_exit;
+
 	rc = decode_neg_token_init(security_blob, blob_length,
 				   &server->sec_type);
 	if (rc == 1)
-- 
1.8.1.4
