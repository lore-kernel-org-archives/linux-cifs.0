From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/5] Update negotiate protocol for SMB3.11 dialect
Date: Sun, 28 Jun 2015 18:36:10 -0500
Message-ID: <1435534570-10864-5-git-send-email-steve.french@primarydata.com>
References: <1435534570-10864-1-git-send-email-steve.french@primarydata.com>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1435534570-10864-1-git-send-email-steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Send negotiate contexts when SMB3.11 dialect is negotiated
(ie the preauth and the encryption contexts) and
Initialize SMB3.11 preauth negotiate context salt to random bytes

Followon patch will update session setup and tree connect

Signed-off-by: Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/cifs/smb2pdu.h |  6 +++---
 2 files changed, 60 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 0479e3c..b8b4f08 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -304,6 +304,59 @@ small_smb2_init(__le16 smb2_command, struct cifs_tcon *tcon,
 	return rc;
 }
 
+#ifdef CONFIG_CIFS_SMB311
+/* offset is sizeof smb2_negotiate_req - 4 but rounded up to 8 bytes */
+#define OFFSET_OF_NEG_CONTEXT 0x68  /* sizeof(struct smb2_negotiate_req) - 4 */
+
+
+#define SMB2_PREAUTH_INTEGRITY_CAPABILITIES	cpu_to_le16(1)
+#define SMB2_ENCRYPTION_CAPABILITIES		cpu_to_le16(2)
+
+static void
+build_preauth_ctxt(struct smb2_preauth_neg_context *pneg_ctxt)
+{
+	pneg_ctxt->ContextType = SMB2_PREAUTH_INTEGRITY_CAPABILITIES;
+	pneg_ctxt->DataLength = cpu_to_le16(38);
+	pneg_ctxt->HashAlgorithmCount = cpu_to_le16(1);
+	pneg_ctxt->SaltLength = cpu_to_le16(SMB311_SALT_SIZE);
+	get_random_bytes(pneg_ctxt->Salt, SMB311_SALT_SIZE);
+	pneg_ctxt->HashAlgorithms = SMB2_PREAUTH_INTEGRITY_SHA512;
+}
+
+static void
+build_encrypt_ctxt(struct smb2_encryption_neg_context *pneg_ctxt)
+{
+	pneg_ctxt->ContextType = SMB2_ENCRYPTION_CAPABILITIES;
+	pneg_ctxt->DataLength = cpu_to_le16(6);
+	pneg_ctxt->CipherCount = cpu_to_le16(2);
+	pneg_ctxt->Ciphers[0] = SMB2_ENCRYPTION_AES128_GCM;
+	pneg_ctxt->Ciphers[1] = SMB2_ENCRYPTION_AES128_CCM;
+}
+
+static void
+assemble_neg_contexts(struct smb2_negotiate_req *req)
+{
+
+	/* +4 is to account for the RFC1001 len field */
+	char *pneg_ctxt = (char *)req + OFFSET_OF_NEG_CONTEXT + 4;
+
+	build_preauth_ctxt((struct smb2_preauth_neg_context *)pneg_ctxt);
+	/* Add 2 to size to round to 8 byte boundary */
+	pneg_ctxt += 2 + sizeof(struct smb2_preauth_neg_context);
+	build_encrypt_ctxt((struct smb2_encryption_neg_context *)pneg_ctxt);
+	req->NegotiateContextOffset = cpu_to_le32(OFFSET_OF_NEG_CONTEXT);
+	req->NegotiateContextCount = cpu_to_le16(2);
+	inc_rfc1001_len(req, 4 + sizeof(struct smb2_preauth_neg_context) + 2
+			+ sizeof(struct smb2_encryption_neg_context)); /* calculate hash */
+}
+#else
+static void assemble_neg_contexts(struct smb2_negotiate_req *req)
+{
+	return;
+}
+#endif /* SMB311 */
+
+
 /*
  *
  *	SMB2 Worker functions follow:
@@ -363,10 +416,12 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 	/* ClientGUID must be zero for SMB2.02 dialect */
 	if (ses->server->vals->protocol_id == SMB20_PROT_ID)
 		memset(req->ClientGUID, 0, SMB2_CLIENT_GUID_SIZE);
-	else
+	else {
 		memcpy(req->ClientGUID, server->client_guid,
 			SMB2_CLIENT_GUID_SIZE);
-
+		if (ses->server->vals->protocol_id == SMB311_PROT_ID)
+			assemble_neg_contexts(req);
+	}
 	iov[0].iov_base = (char *)req;
 	/* 4 for rfc1002 length field */
 	iov[0].iov_len = get_rfc1002_length(req) + 4;
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 2d91c2a..4511082 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -220,7 +220,7 @@ struct smb2_negotiate_req {
 
 #define SMB311_SALT_SIZE			32
 /* Hash Algorithm Types */
-#define SMB2_PREAUTH_INTEGRITY_SHA512	0x0001
+#define SMB2_PREAUTH_INTEGRITY_SHA512	cpu_to_le16(0x0001)
 
 struct smb2_preauth_neg_context {
 	__le16	ContextType; /* 1 */
@@ -240,8 +240,8 @@ struct smb2_encryption_neg_context {
 	__le16	ContextType; /* 2 */
 	__le16	DataLength;
 	__le32	Reserved;
-	__le16	CipherCount; /* 1 for time being, only AES-128-CCM */
-	__le16	Ciphers; /* Ciphers[0] since only one used now */
+	__le16	CipherCount; /* AES-128-GCM and AES-128-CCM */
+	__le16	Ciphers[2]; /* Ciphers[0] since only one used now */
 } __packed;
 
 struct smb2_negotiate_rsp {
-- 
2.1.4
