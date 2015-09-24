From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] Fix sec=krb5 on smb3 mounts
Date: Wed, 23 Sep 2015 20:05:02 -0500
Message-ID: <1443056702-38137-1-git-send-email-smfrench@gmail.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Noel Power <noel.power-IBi9RG/b67k@public.gmane.org>,
	Jim McDonough <jmcd-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Kerberos, which is very important for security, was only enabled for
CIFS not SMB2/SMB3 mounts (e.g. vers=3.0)

(Updated, version two of the patch after Jim's testing at SMB3 plugfest)

Patch based on the information detailed in
http://thread.gmane.org/gmane.linux.kernel.cifs/10081/focus=10307
to enable Kerberized SMB2/SMB3

a) SMB2_negotiate: enable/use decode_negTokenInit in SMB2_negotiate
b) SMB2_sess_setup: handle Kerberos sectype and replicate Kerberos
   SMB1 processing done in sess_auth_kerberos

Signed-off-by: Noel Power <noel.power-IBi9RG/b67k@public.gmane.org>
Signed-off-by: Jim McDonough <jmcd-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
CC: Stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Signed-off-by: Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 64 ++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 56 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 070fb2a..ac82804 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -46,6 +46,7 @@
 #include "smb2status.h"
 #include "smb2glob.h"
 #include "cifspdu.h"
+#include "cifs_spnego.h"
 
 /*
  *  The following table defines the expected "StructureSize" of SMB2 requests
@@ -486,7 +487,6 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 		cifs_dbg(FYI, "missing security blob on negprot\n");
 
 	rc = cifs_enable_signing(server, ses->sign);
-#ifdef CONFIG_SMB2_ASN1  /* BB REMOVEME when updated asn1.c ready */
 	if (rc)
 		goto neg_exit;
 	if (blob_length)
@@ -497,7 +497,6 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 		rc = -EIO;
 		goto neg_exit;
 	}
-#endif
 
 neg_exit:
 	free_rsp_buf(resp_buftype, rsp);
@@ -592,7 +591,8 @@ SMB2_sess_setup(const unsigned int xid, struct cifs_ses *ses,
 	__le32 phase = NtLmNegotiate; /* NTLMSSP, if needed, is multistage */
 	struct TCP_Server_Info *server = ses->server;
 	u16 blob_length = 0;
-	char *security_blob;
+	struct key *spnego_key = NULL;
+	char *security_blob = NULL;
 	char *ntlmssp_blob = NULL;
 	bool use_spnego = false; /* else use raw ntlmssp */
 
@@ -620,7 +620,8 @@ SMB2_sess_setup(const unsigned int xid, struct cifs_ses *ses,
 	ses->ntlmssp->sesskey_per_smbsess = true;
 
 	/* FIXME: allow for other auth types besides NTLMSSP (e.g. krb5) */
-	ses->sectype = RawNTLMSSP;
+	if (ses->sectype != Kerberos && ses->sectype != RawNTLMSSP)
+		ses->sectype = RawNTLMSSP;
 
 ssetup_ntlmssp_authenticate:
 	if (phase == NtLmChallenge)
@@ -649,7 +650,48 @@ ssetup_ntlmssp_authenticate:
 	iov[0].iov_base = (char *)req;
 	/* 4 for rfc1002 length field and 1 for pad */
 	iov[0].iov_len = get_rfc1002_length(req) + 4 - 1;
-	if (phase == NtLmNegotiate) {
+
+	if (ses->sectype == Kerberos) {
+#ifdef CONFIG_CIFS_UPCALL
+		struct cifs_spnego_msg *msg;
+
+		spnego_key = cifs_get_spnego_key(ses);
+		if (IS_ERR(spnego_key)) {
+			rc = PTR_ERR(spnego_key);
+			spnego_key = NULL;
+			goto ssetup_exit;
+		}
+
+		msg = spnego_key->payload.data;
+		/*
+		 * check version field to make sure that cifs.upcall is
+		 * sending us a response in an expected form
+		 */
+		if (msg->version != CIFS_SPNEGO_UPCALL_VERSION) {
+			cifs_dbg(VFS,
+				  "bad cifs.upcall version. Expected %d got %d",
+				  CIFS_SPNEGO_UPCALL_VERSION, msg->version);
+			rc = -EKEYREJECTED;
+			goto ssetup_exit;
+		}
+		ses->auth_key.response = kmemdup(msg->data, msg->sesskey_len,
+						 GFP_KERNEL);
+		if (!ses->auth_key.response) {
+			cifs_dbg(VFS,
+				"Kerberos can't allocate (%u bytes) memory",
+				msg->sesskey_len);
+			rc = -ENOMEM;
+			goto ssetup_exit;
+		}
+		ses->auth_key.len = msg->sesskey_len;
+		blob_length = msg->secblob_len;
+		iov[1].iov_base = msg->data + msg->sesskey_len;
+		iov[1].iov_len = blob_length;
+#else
+		rc = -EOPNOTSUPP;
+		goto ssetup_exit;
+#endif /* CONFIG_CIFS_UPCALL */
+	} else if (phase == NtLmNegotiate) { /* if not krb5 must be ntlmssp */
 		ntlmssp_blob = kmalloc(sizeof(struct _NEGOTIATE_MESSAGE),
 				       GFP_KERNEL);
 		if (ntlmssp_blob == NULL) {
@@ -672,6 +714,8 @@ ssetup_ntlmssp_authenticate:
 			/* with raw NTLMSSP we don't encapsulate in SPNEGO */
 			security_blob = ntlmssp_blob;
 		}
+		iov[1].iov_base = security_blob;
+		iov[1].iov_len = blob_length;
 	} else if (phase == NtLmAuthenticate) {
 		req->hdr.SessionId = ses->Suid;
 		ntlmssp_blob = kzalloc(sizeof(struct _NEGOTIATE_MESSAGE) + 500,
@@ -699,6 +743,8 @@ ssetup_ntlmssp_authenticate:
 		} else {
 			security_blob = ntlmssp_blob;
 		}
+		iov[1].iov_base = security_blob;
+		iov[1].iov_len = blob_length;
 	} else {
 		cifs_dbg(VFS, "illegal ntlmssp phase\n");
 		rc = -EIO;
@@ -710,8 +756,6 @@ ssetup_ntlmssp_authenticate:
 				cpu_to_le16(sizeof(struct smb2_sess_setup_req) -
 					    1 /* pad */ - 4 /* rfc1001 len */);
 	req->SecurityBufferLength = cpu_to_le16(blob_length);
-	iov[1].iov_base = security_blob;
-	iov[1].iov_len = blob_length;
 
 	inc_rfc1001_len(req, blob_length - 1 /* pad */);
 
@@ -722,6 +766,7 @@ ssetup_ntlmssp_authenticate:
 
 	kfree(security_blob);
 	rsp = (struct smb2_sess_setup_rsp *)iov[0].iov_base;
+	ses->Suid = rsp->hdr.SessionId;
 	if (resp_buftype != CIFS_NO_BUFFER &&
 	    rsp->hdr.Status == STATUS_MORE_PROCESSING_REQUIRED) {
 		if (phase != NtLmNegotiate) {
@@ -739,7 +784,6 @@ ssetup_ntlmssp_authenticate:
 		/* NTLMSSP Negotiate sent now processing challenge (response) */
 		phase = NtLmChallenge; /* process ntlmssp challenge */
 		rc = 0; /* MORE_PROCESSING is not an error here but expected */
-		ses->Suid = rsp->hdr.SessionId;
 		rc = decode_ntlmssp_challenge(rsp->Buffer,
 				le16_to_cpu(rsp->SecurityBufferLength), ses);
 	}
@@ -796,6 +840,10 @@ keygen_exit:
 		kfree(ses->auth_key.response);
 		ses->auth_key.response = NULL;
 	}
+	if (spnego_key) {
+		key_invalidate(spnego_key);
+		key_put(spnego_key);
+	}
 	kfree(ses->ntlmssp);
 
 	return rc;
-- 
1.9.1
