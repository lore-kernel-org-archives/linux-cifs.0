From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/4] cifs: move "ntlmssp" and "local_leases" options out of experimental code
Date: Tue,  7 Dec 2010 09:23:53 -0500
Message-ID: <1291731835-1120-3-git-send-email-jlayton@redhat.com>
References: <1291731835-1120-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1291731835-1120-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I see no real need to leave these sorts of options under an
EXPERIMENTAL ifdef. Since you need a mount option to turn this code
on, that only blows out the testing matrix.

local_leases has been under the EXPERIMENTAL tag for some time, but
it's only the mount option that's under this label. Move it out
from under this tag.

The NTLMSSP code is also under EXPERIMENTAL, but it needs a mount
option to turn it on, and in the future any distro will reasonably
want this enabled. Go ahead and move it out from under the
EXPERIMENTAL tag.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifssmb.c |    5 +--
 fs/cifs/connect.c |    4 --
 fs/cifs/sess.c    |  103 ++++++++++++++++++++++++-----------------------------
 3 files changed, 48 insertions(+), 64 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index d7957a3..4df1d10 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -401,15 +401,12 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSesInfo *ses)
 	else if ((secFlags & CIFSSEC_AUTH_MASK) == CIFSSEC_MAY_KRB5) {
 		cFYI(1, "Kerberos only mechanism, enable extended security");
 		pSMB->hdr.Flags2 |= SMBFLG2_EXT_SEC;
-	}
-#ifdef CONFIG_CIFS_EXPERIMENTAL
-	else if ((secFlags & CIFSSEC_MUST_NTLMSSP) == CIFSSEC_MUST_NTLMSSP)
+	} else if ((secFlags & CIFSSEC_MUST_NTLMSSP) == CIFSSEC_MUST_NTLMSSP)
 		pSMB->hdr.Flags2 |= SMBFLG2_EXT_SEC;
 	else if ((secFlags & CIFSSEC_AUTH_MASK) == CIFSSEC_MAY_NTLMSSP) {
 		cFYI(1, "NTLMSSP only mechanism, enable extended security");
 		pSMB->hdr.Flags2 |= SMBFLG2_EXT_SEC;
 	}
-#endif
 
 	count = 0;
 	for (i = 0; i < CIFS_NUM_PROT; i++) {
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 23098c2..9fbe7c5 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -985,13 +985,11 @@ cifs_parse_mount_options(char *options, const char *devname,
 				return 1;
 			} else if (strnicmp(value, "krb5", 4) == 0) {
 				vol->secFlg |= CIFSSEC_MAY_KRB5;
-#ifdef CONFIG_CIFS_EXPERIMENTAL
 			} else if (strnicmp(value, "ntlmsspi", 8) == 0) {
 				vol->secFlg |= CIFSSEC_MAY_NTLMSSP |
 					CIFSSEC_MUST_SIGN;
 			} else if (strnicmp(value, "ntlmssp", 7) == 0) {
 				vol->secFlg |= CIFSSEC_MAY_NTLMSSP;
-#endif
 			} else if (strnicmp(value, "ntlmv2i", 7) == 0) {
 				vol->secFlg |= CIFSSEC_MAY_NTLMV2 |
 					CIFSSEC_MUST_SIGN;
@@ -1342,10 +1340,8 @@ cifs_parse_mount_options(char *options, const char *devname,
 			vol->no_psx_acl = 0;
 		} else if (strnicmp(data, "noacl", 5) == 0) {
 			vol->no_psx_acl = 1;
-#ifdef CONFIG_CIFS_EXPERIMENTAL
 		} else if (strnicmp(data, "locallease", 6) == 0) {
 			vol->local_lease = 1;
-#endif
 		} else if (strnicmp(data, "sign", 4) == 0) {
 			vol->secFlg |= CIFSSEC_MUST_SIGN;
 		} else if (strnicmp(data, "seal", 4) == 0) {
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 7b01d3f..2997533 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -420,7 +420,6 @@ static int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
 	return 0;
 }
 
-#ifdef CONFIG_CIFS_EXPERIMENTAL
 /* BB Move to ntlmssp.c eventually */
 
 /* We do not malloc the blob, it is passed in pbuffer, because
@@ -572,7 +571,6 @@ static void setup_ntlmssp_neg_req(SESSION_SETUP_ANDX *pSMB,
 
 	return;
 }
-#endif
 
 int
 CIFS_SessSetup(unsigned int xid, struct cifsSesInfo *ses,
@@ -814,71 +812,64 @@ ssetup_ntlmssp_authenticate:
 		rc = -ENOSYS;
 		goto ssetup_exit;
 #endif /* CONFIG_CIFS_UPCALL */
-	} else {
-#ifdef CONFIG_CIFS_EXPERIMENTAL
-		if (type == RawNTLMSSP) {
-			if ((pSMB->req.hdr.Flags2 & SMBFLG2_UNICODE) == 0) {
-				cERROR(1, "NTLMSSP requires Unicode support");
-				rc = -ENOSYS;
+	} else if (type == RawNTLMSSP) {
+		if ((pSMB->req.hdr.Flags2 & SMBFLG2_UNICODE) == 0) {
+			cERROR(1, "NTLMSSP requires Unicode support");
+			rc = -ENOSYS;
+			goto ssetup_exit;
+		}
+
+		cFYI(1, "ntlmssp session setup phase %d", phase);
+		pSMB->req.hdr.Flags2 |= SMBFLG2_EXT_SEC;
+		capabilities |= CAP_EXTENDED_SECURITY;
+		pSMB->req.Capabilities |= cpu_to_le32(capabilities);
+		if (phase == NtLmNegotiate) {
+			setup_ntlmssp_neg_req(pSMB, ses);
+			iov[1].iov_len = sizeof(NEGOTIATE_MESSAGE);
+			iov[1].iov_base = &pSMB->req.SecurityBlob[0];
+		} else if (phase == NtLmAuthenticate) {
+			/* 5 is an empirical value, large enought to
+			 * hold authenticate message, max 10 of
+			 * av paris, doamin,user,workstation mames,
+			 * flags etc..
+			 */
+			ntlmsspblob = kmalloc(
+				5*sizeof(struct _AUTHENTICATE_MESSAGE),
+				GFP_KERNEL);
+			if (!ntlmsspblob) {
+				cERROR(1, "Can't allocate NTLMSSP");
+				rc = -ENOMEM;
 				goto ssetup_exit;
 			}
 
-			cFYI(1, "ntlmssp session setup phase %d", phase);
-			pSMB->req.hdr.Flags2 |= SMBFLG2_EXT_SEC;
-			capabilities |= CAP_EXTENDED_SECURITY;
-			pSMB->req.Capabilities |= cpu_to_le32(capabilities);
-			if (phase == NtLmNegotiate) {
-				setup_ntlmssp_neg_req(pSMB, ses);
-				iov[1].iov_len = sizeof(NEGOTIATE_MESSAGE);
-				iov[1].iov_base = &pSMB->req.SecurityBlob[0];
-			} else if (phase == NtLmAuthenticate) {
-				/* 5 is an empirical value, large enought to
-				 * hold authenticate message, max 10 of
-				 * av paris, doamin,user,workstation mames,
-				 * flags etc..
-				 */
-				ntlmsspblob = kmalloc(
-					5*sizeof(struct _AUTHENTICATE_MESSAGE),
-					GFP_KERNEL);
-				if (!ntlmsspblob) {
-					cERROR(1, "Can't allocate NTLMSSP");
-					rc = -ENOMEM;
-					goto ssetup_exit;
-				}
-
-				rc = build_ntlmssp_auth_blob(ntlmsspblob,
-							&blob_len, ses, nls_cp);
-				if (rc)
-					goto ssetup_exit;
-				iov[1].iov_len = blob_len;
-				iov[1].iov_base = ntlmsspblob;
-				pSMB->req.SecurityBlobLength =
-					cpu_to_le16(blob_len);
-				/* Make sure that we tell the server that we
-				   are using the uid that it just gave us back
-				   on the response (challenge) */
-				smb_buf->Uid = ses->Suid;
-			} else {
-				cERROR(1, "invalid phase %d", phase);
-				rc = -ENOSYS;
+			rc = build_ntlmssp_auth_blob(ntlmsspblob,
+						&blob_len, ses, nls_cp);
+			if (rc)
 				goto ssetup_exit;
-			}
-			/* unicode strings must be word aligned */
-			if ((iov[0].iov_len + iov[1].iov_len) % 2) {
-				*bcc_ptr = 0;
-				bcc_ptr++;
-			}
-			unicode_oslm_strings(&bcc_ptr, nls_cp);
+			iov[1].iov_len = blob_len;
+			iov[1].iov_base = ntlmsspblob;
+			pSMB->req.SecurityBlobLength = cpu_to_le16(blob_len);
+			/* Make sure that we tell the server that we
+			   are using the uid that it just gave us back
+			   on the response (challenge) */
+			smb_buf->Uid = ses->Suid;
 		} else {
-			cERROR(1, "secType %d not supported!", type);
+			cERROR(1, "invalid phase %d", phase);
 			rc = -ENOSYS;
 			goto ssetup_exit;
 		}
-#else
+
+		/* unicode strings must be word aligned */
+		if ((iov[0].iov_len + iov[1].iov_len) % 2) {
+			*bcc_ptr = 0;
+			bcc_ptr++;
+		}
+
+		unicode_oslm_strings(&bcc_ptr, nls_cp);
+	} else {
 		cERROR(1, "secType %d not supported!", type);
 		rc = -ENOSYS;
 		goto ssetup_exit;
-#endif
 	}
 
 	iov[2].iov_base = str_area;
-- 
1.7.3.2
