From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 07/19] cifs: break out decoding of security blob into separate function
Date: Thu, 23 May 2013 11:05:51 -0400
Message-ID: <1369321563-16893-8-git-send-email-jlayton@redhat.com>
References: <1369321563-16893-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1369321563-16893-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...cleanup.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifspdu.h |   4 +-
 fs/cifs/cifssmb.c | 109 ++++++++++++++++++++++++++++++------------------------
 2 files changed, 62 insertions(+), 51 deletions(-)

diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
index e996ff6..4e6135a 100644
--- a/fs/cifs/cifspdu.h
+++ b/fs/cifs/cifspdu.h
@@ -531,7 +531,7 @@ typedef struct lanman_neg_rsp {
 #define READ_RAW_ENABLE 1
 #define WRITE_RAW_ENABLE 2
 #define RAW_ENABLE (READ_RAW_ENABLE | WRITE_RAW_ENABLE)
-
+#define SMB1_CLIENT_GUID_SIZE (16)
 typedef struct negotiate_rsp {
 	struct smb_hdr hdr;	/* wct = 17 */
 	__le16 DialectIndex; /* 0xFFFF = no dialect acceptable */
@@ -553,7 +553,7 @@ typedef struct negotiate_rsp {
 		/* followed by 16 bytes of server GUID */
 		/* then security blob if cap_extended_security negotiated */
 		struct {
-			unsigned char GUID[16];
+			unsigned char GUID[SMB1_CLIENT_GUID_SIZE];
 			unsigned char SecurityBlob[1];
 		} __attribute__((packed)) extended_response;
 	} __attribute__((packed)) u;
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index c1c2006..9b4aea8 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -367,6 +367,56 @@ vt2_err:
 	return -EINVAL;
 }
 
+static int
+decode_ext_sec_blob(struct TCP_Server_Info *server, NEGOTIATE_RSP *pSMBr)
+{
+	int	rc = 0;
+	u16	count;
+	char	*guid = pSMBr->u.extended_response.GUID;
+
+	count = get_bcc(&pSMBr->hdr);
+	if (count < SMB1_CLIENT_GUID_SIZE)
+		return -EIO;
+
+	spin_lock(&cifs_tcp_ses_lock);
+	if (server->srv_count > 1) {
+		spin_unlock(&cifs_tcp_ses_lock);
+		if (memcmp(server->server_GUID, guid, SMB1_CLIENT_GUID_SIZE) != 0) {
+			cifs_dbg(FYI, "server UID changed\n");
+			memcpy(server->server_GUID, guid, SMB1_CLIENT_GUID_SIZE);
+		}
+	} else {
+		spin_unlock(&cifs_tcp_ses_lock);
+		memcpy(server->server_GUID, guid, SMB1_CLIENT_GUID_SIZE);
+	}
+
+	if (count == SMB1_CLIENT_GUID_SIZE) {
+		server->secType = RawNTLMSSP;
+	} else {
+		count -= SMB1_CLIENT_GUID_SIZE;
+		rc = decode_negTokenInit(
+			pSMBr->u.extended_response.SecurityBlob, count, server);
+		if (rc != 1)
+			return -EINVAL;
+
+		/* Make sure server supports what we want to use */
+		switch(server->secType) {
+		case Kerberos:
+			if (!server->sec_kerberos && !server->sec_mskerberos)
+				return -EOPNOTSUPP;
+			break;
+		case RawNTLMSSP:
+			if (!server->sec_ntlmssp)
+				return -EOPNOTSUPP;
+			break;
+		default:
+			return -EOPNOTSUPP;
+		}
+	}
+
+	return 0;
+}
+
 int
 CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses)
 {
@@ -568,61 +618,22 @@ CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses)
 	server->capabilities = le32_to_cpu(pSMBr->Capabilities);
 	server->timeAdj = (int)(__s16)le16_to_cpu(pSMBr->ServerTimeZone);
 	server->timeAdj *= 60;
-	if (pSMBr->EncryptionKeyLength == CIFS_CRYPTO_KEY_SIZE) {
+
+	if (pSMBr->EncryptionKeyLength == CIFS_CRYPTO_KEY_SIZE)
 		memcpy(ses->server->cryptkey, pSMBr->u.EncryptionKey,
 		       CIFS_CRYPTO_KEY_SIZE);
-	} else if ((pSMBr->hdr.Flags2 & SMBFLG2_EXT_SEC ||
+	else if ((pSMBr->hdr.Flags2 & SMBFLG2_EXT_SEC ||
 			server->capabilities & CAP_EXTENDED_SECURITY) &&
-				(pSMBr->EncryptionKeyLength == 0)) {
-		/* decode security blob */
-		count = get_bcc(&pSMBr->hdr);
-		if (count < 16) {
-			rc = -EIO;
-			goto neg_err_exit;
-		}
-		spin_lock(&cifs_tcp_ses_lock);
-		if (server->srv_count > 1) {
-			spin_unlock(&cifs_tcp_ses_lock);
-			if (memcmp(server->server_GUID,
-				   pSMBr->u.extended_response.
-				   GUID, 16) != 0) {
-				cifs_dbg(FYI, "server UID changed\n");
-				memcpy(server->server_GUID,
-					pSMBr->u.extended_response.GUID,
-					16);
-			}
-		} else {
-			spin_unlock(&cifs_tcp_ses_lock);
-			memcpy(server->server_GUID,
-			       pSMBr->u.extended_response.GUID, 16);
-		}
-
-		if (count == 16) {
-			server->secType = RawNTLMSSP;
-		} else {
-			rc = decode_negTokenInit(pSMBr->u.extended_response.
-						 SecurityBlob, count - 16,
-						 server);
-			if (rc == 1)
-				rc = 0;
-			else
-				rc = -EINVAL;
-			if (server->secType == Kerberos) {
-				if (!server->sec_kerberos &&
-						!server->sec_mskerberos)
-					rc = -EOPNOTSUPP;
-			} else if (server->secType == RawNTLMSSP) {
-				if (!server->sec_ntlmssp)
-					rc = -EOPNOTSUPP;
-			} else
-					rc = -EOPNOTSUPP;
-		}
-	} else if (server->sec_mode & SECMODE_PW_ENCRYPT) {
+				(pSMBr->EncryptionKeyLength == 0))
+		rc = decode_ext_sec_blob(server, pSMBr);
+	else if (server->sec_mode & SECMODE_PW_ENCRYPT)
 		rc = -EIO; /* no crypt key only if plain text pwd */
-		goto neg_err_exit;
-	} else
+	else
 		server->capabilities &= ~CAP_EXTENDED_SECURITY;
 
+	if (rc)
+		goto neg_err_exit;
+
 #ifdef CONFIG_CIFS_WEAK_PW_HASH
 signing_check:
 #endif
-- 
1.8.1.4
