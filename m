From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: Remove the rfc1002 header from SMB2 request structures
Date: Wed,  1 Nov 2017 12:51:44 +1100
Message-ID: <20171101015144.2034-2-lsahlber@redhat.com>
References: <20171101015144.2034-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171101015144.2034-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This header is not really part of the SMB2 header but a lower layer.
Remove this field from all the request structures that we use
in SMB2 and instead compute it and attach it when we build the
iovec in the new function SendReceive3().

This gets rid of a lot of magic +4 / -4 in length computations and also
a lot of dynamically trying to modify the value as we construct the SMB2
pdus.

At this point we now have an API where we construct SMB2 pdus without the
extra rfc1002 header which will make it easier to add compounding
as a future project.
In compounded commands we will have multiple SMB2 PDUs wrapped inside
one single rfc1002 header.

A later patch might remove the rfc1002 header also from the response
structures.

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsproto.h |   4 +
 fs/cifs/smb2misc.c  |   2 +-
 fs/cifs/smb2pdu.c   | 379 +++++++++++++++++++++++++---------------------------
 fs/cifs/smb2pdu.h   |  46 ++++---
 fs/cifs/transport.c |  38 ++++++
 5 files changed, 254 insertions(+), 215 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 4143c9dec463..a4e3c6c5aa64 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -106,6 +106,10 @@ extern int SendReceive2(const unsigned int /* xid */ , struct cifs_ses *,
 			struct kvec *, int /* nvec to send */,
 			int * /* type of buf returned */, const int flags,
 			struct kvec * /* resp vec */);
+extern int SendReceive3(const unsigned int /* xid */ , struct cifs_ses *,
+			struct kvec *, int /* nvec to send */,
+			int * /* type of buf returned */, const int flags,
+			struct kvec * /* resp vec */);
 extern int SendReceiveBlockingLock(const unsigned int xid,
 			struct cifs_tcon *ptcon,
 			struct smb_hdr *in_buf ,
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 7b08a1446a7f..76d03abaa38c 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -578,7 +578,7 @@ smb2_is_valid_lease_break(char *buffer)
 bool
 smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
 {
-	struct smb2_oplock_break *rsp = (struct smb2_oplock_break *)buffer;
+	struct smb2_oplock_break_rsp *rsp = (struct smb2_oplock_break_rsp *)buffer;
 	struct list_head *tmp, *tmp1, *tmp2;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 5331631386a2..66499511dca0 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -319,41 +319,6 @@ fill_small_buf(__le16 smb2_command, struct cifs_tcon *tcon, void *buf,
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
@@ -362,11 +327,9 @@ smb2_plain_req_init(__le16 smb2_command, struct cifs_tcon *tcon,
  */
 static int
 small_smb2_init(__le16 smb2_command, struct cifs_tcon *tcon,
-		void **request_buf)
+		void **request_buf, unsigned int *total_len)
 {
 	int rc;
-	unsigned int total_len;
-	struct smb2_pdu *pdu;
 
 	rc = smb2_reconnect(smb2_command, tcon);
 	if (rc)
@@ -379,12 +342,9 @@ small_smb2_init(__le16 smb2_command, struct cifs_tcon *tcon,
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
@@ -398,8 +358,8 @@ small_smb2_init(__le16 smb2_command, struct cifs_tcon *tcon,
 }
 
 #ifdef CONFIG_CIFS_SMB311
-/* offset is sizeof smb2_negotiate_req - 4 but rounded up to 8 bytes */
-#define OFFSET_OF_NEG_CONTEXT 0x68  /* sizeof(struct smb2_negotiate_req) - 4 */
+/* offset is sizeof smb2_negotiate_req but rounded up to 8 bytes */
+#define OFFSET_OF_NEG_CONTEXT 0x68  /* sizeof(struct smb2_negotiate_req) */
 
 
 #define SMB2_PREAUTH_INTEGRITY_CAPABILITIES	cpu_to_le16(1)
@@ -429,9 +389,7 @@ build_encrypt_ctxt(struct smb2_encryption_neg_context *pneg_ctxt)
 static void
 assemble_neg_contexts(struct smb2_negotiate_req *req)
 {
-
-	/* +4 is to account for the RFC1001 len field */
-	char *pneg_ctxt = (char *)req + OFFSET_OF_NEG_CONTEXT + 4;
+	char *pneg_ctxt = (char *)req + OFFSET_OF_NEG_CONTEXT;
 
 	build_preauth_ctxt((struct smb2_preauth_neg_context *)pneg_ctxt);
 	/* Add 2 to size to round to 8 byte boundary */
@@ -439,8 +397,6 @@ assemble_neg_contexts(struct smb2_negotiate_req *req)
 	build_encrypt_ctxt((struct smb2_encryption_neg_context *)pneg_ctxt);
 	req->NegotiateContextOffset = cpu_to_le32(OFFSET_OF_NEG_CONTEXT);
 	req->NegotiateContextCount = cpu_to_le16(2);
-	inc_rfc1001_len(req, 4 + sizeof(struct smb2_preauth_neg_context)
-			+ sizeof(struct smb2_encryption_neg_context)); /* calculate hash */
 }
 #else
 static void assemble_neg_contexts(struct smb2_negotiate_req *req)
@@ -477,6 +433,7 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 	int blob_offset, blob_length;
 	char *security_blob;
 	int flags = CIFS_NEG_OP;
+	unsigned int total_len;
 
 	cifs_dbg(FYI, "Negotiate protocol\n");
 
@@ -485,30 +442,30 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 		return -EIO;
 	}
 
-	rc = small_smb2_init(SMB2_NEGOTIATE, NULL, (void **) &req);
+	rc = small_smb2_init(SMB2_NEGOTIATE, NULL, (void **) &req, &total_len);
 	if (rc)
 		return rc;
 
-	req->hdr.sync_hdr.SessionId = 0;
+	req->sync_hdr.SessionId = 0;
 
 	if (strcmp(ses->server->vals->version_string,
 		   SMB3ANY_VERSION_STRING) == 0) {
 		req->Dialects[0] = cpu_to_le16(SMB30_PROT_ID);
 		req->Dialects[1] = cpu_to_le16(SMB302_PROT_ID);
 		req->DialectCount = cpu_to_le16(2);
-		inc_rfc1001_len(req, 4);
+		total_len += 4;
 	} else if (strcmp(ses->server->vals->version_string,
 		   SMBDEFAULT_VERSION_STRING) == 0) {
 		req->Dialects[0] = cpu_to_le16(SMB21_PROT_ID);
 		req->Dialects[1] = cpu_to_le16(SMB30_PROT_ID);
 		req->Dialects[2] = cpu_to_le16(SMB302_PROT_ID);
 		req->DialectCount = cpu_to_le16(3);
-		inc_rfc1001_len(req, 6);
+		total_len += 6;
 	} else {
 		/* otherwise send specific dialect */
 		req->Dialects[0] = cpu_to_le16(ses->server->vals->protocol_id);
 		req->DialectCount = cpu_to_le16(1);
-		inc_rfc1001_len(req, 2);
+		total_len += 2;
 	}
 
 	/* only one of SMB2 signing flags may be set in SMB2 request */
@@ -531,10 +488,9 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 			assemble_neg_contexts(req);
 	}
 	iov[0].iov_base = (char *)req;
-	/* 4 for rfc1002 length field */
-	iov[0].iov_len = get_rfc1002_length(req) + 4;
+	iov[0].iov_len = total_len;
 
-	rc = SendReceive2(xid, ses, iov, 1, &resp_buftype, flags, &rsp_iov);
+	rc = SendReceive3(xid, ses, iov, 1, &resp_buftype, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 	rsp = (struct smb2_negotiate_rsp *)rsp_iov.iov_base;
 	/*
@@ -806,20 +762,22 @@ SMB2_sess_alloc_buffer(struct SMB2_sess_data *sess_data)
 	struct cifs_ses *ses = sess_data->ses;
 	struct smb2_sess_setup_req *req;
 	struct TCP_Server_Info *server = ses->server;
+	unsigned int total_len;
 
-	rc = small_smb2_init(SMB2_SESSION_SETUP, NULL, (void **) &req);
+	rc = small_smb2_init(SMB2_SESSION_SETUP, NULL, (void **) &req,
+			     &total_len);
 	if (rc)
 		return rc;
 
 	/* First session, not a reauthenticate */
-	req->hdr.sync_hdr.SessionId = 0;
+	req->sync_hdr.SessionId = 0;
 
 	/* if reconnect, we need to send previous sess id, otherwise it is 0 */
 	req->PreviousSessionId = sess_data->previous_session;
 
 	req->Flags = 0; /* MBZ */
 	/* to enable echos and oplocks */
-	req->hdr.sync_hdr.CreditRequest = cpu_to_le16(3);
+	req->sync_hdr.CreditRequest = cpu_to_le16(3);
 
 	/* only one of SMB2 signing flags may be set in SMB2 request */
 	if (server->sign)
@@ -833,8 +791,8 @@ SMB2_sess_alloc_buffer(struct SMB2_sess_data *sess_data)
 	req->Channel = 0; /* MBZ */
 
 	sess_data->iov[0].iov_base = (char *)req;
-	/* 4 for rfc1002 length field and 1 for pad */
-	sess_data->iov[0].iov_len = get_rfc1002_length(req) + 4 - 1;
+	/* 1 for pad */
+	sess_data->iov[0].iov_len = total_len - 1;
 	/*
 	 * This variable will be used to clear the buffer
 	 * allocated above in case of any error in the calling function.
@@ -860,18 +818,15 @@ SMB2_sess_sendreceive(struct SMB2_sess_data *sess_data)
 
 	/* Testing shows that buffer offset must be at location of Buffer[0] */
 	req->SecurityBufferOffset =
-		cpu_to_le16(sizeof(struct smb2_sess_setup_req) -
-			1 /* pad */ - 4 /* rfc1001 len */);
+		cpu_to_le16(sizeof(struct smb2_sess_setup_req) - 1 /* pad */);
 	req->SecurityBufferLength = cpu_to_le16(sess_data->iov[1].iov_len);
 
-	inc_rfc1001_len(req, sess_data->iov[1].iov_len - 1 /* pad */);
-
 	/* BB add code to build os and lm fields */
 
-	rc = SendReceive2(sess_data->xid, sess_data->ses,
-				sess_data->iov, 2,
-				&sess_data->buf0_type,
-				CIFS_LOG_ERROR | CIFS_NEG_OP, &rsp_iov);
+	rc = SendReceive3(sess_data->xid, sess_data->ses,
+			  sess_data->iov, 2,
+			  &sess_data->buf0_type,
+			  CIFS_LOG_ERROR | CIFS_NEG_OP, &rsp_iov);
 	cifs_small_buf_release(sess_data->iov[0].iov_base);
 	memcpy(&sess_data->iov[0], &rsp_iov, sizeof(struct kvec));
 
@@ -1092,7 +1047,7 @@ SMB2_sess_auth_rawntlmssp_authenticate(struct SMB2_sess_data *sess_data)
 		goto out;
 
 	req = (struct smb2_sess_setup_req *) sess_data->iov[0].iov_base;
-	req->hdr.sync_hdr.SessionId = ses->Suid;
+	req->sync_hdr.SessionId = ses->Suid;
 
 	rc = build_ntlmssp_auth_blob(&ntlmssp_blob, &blob_length, ses,
 					sess_data->nls_cp);
@@ -1202,6 +1157,10 @@ SMB2_logoff(const unsigned int xid, struct cifs_ses *ses)
 	int rc = 0;
 	struct TCP_Server_Info *server;
 	int flags = 0;
+	unsigned int total_len;
+	struct kvec iov[1];
+	struct kvec rsp_iov;
+	int resp_buf_type;
 
 	cifs_dbg(FYI, "disconnect session %p\n", ses);
 
@@ -1214,19 +1173,24 @@ SMB2_logoff(const unsigned int xid, struct cifs_ses *ses)
 	if (ses->need_reconnect)
 		goto smb2_session_already_dead;
 
-	rc = small_smb2_init(SMB2_LOGOFF, NULL, (void **) &req);
+	rc = small_smb2_init(SMB2_LOGOFF, NULL, (void **) &req, &total_len);
 	if (rc)
 		return rc;
 
 	 /* since no tcon, smb2_init can not do this, so do here */
-	req->hdr.sync_hdr.SessionId = ses->Suid;
+	req->sync_hdr.SessionId = ses->Suid;
 
 	if (ses->session_flags & SMB2_SESSION_FLAG_ENCRYPT_DATA)
 		flags |= CIFS_TRANSFORM_REQ;
 	else if (server->sign)
-		req->hdr.sync_hdr.Flags |= SMB2_FLAGS_SIGNED;
+		req->sync_hdr.Flags |= SMB2_FLAGS_SIGNED;
+
+	flags |= CIFS_NO_RESP;
+
+	iov[0].iov_base = (char *)req;
+	iov[0].iov_len = total_len;
 
-	rc = SendReceiveNoRsp(xid, ses, (char *) req, flags);
+	rc = SendReceive3(xid, ses, iov, 1, &resp_buf_type, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 	/*
 	 * No tcon so can't do
@@ -1265,6 +1229,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 	int unc_path_len;
 	__le16 *unc_path = NULL;
 	int flags = 0;
+	unsigned int total_len;
 
 	cifs_dbg(FYI, "TCON\n");
 
@@ -1286,7 +1251,8 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 	if (tcon)
 		tcon->tid = 0;
 
-	rc = small_smb2_init(SMB2_TREE_CONNECT, tcon, (void **) &req);
+	rc = small_smb2_init(SMB2_TREE_CONNECT, tcon, (void **) &req,
+			     &total_len);
 	if (rc) {
 		kfree(unc_path);
 		return rc;
@@ -1297,26 +1263,24 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 			flags |= CIFS_TRANSFORM_REQ;
 
 		/* since no tcon, smb2_init can not do this, so do here */
-		req->hdr.sync_hdr.SessionId = ses->Suid;
+		req->sync_hdr.SessionId = ses->Suid;
 		if (ses->server->sign)
-			req->hdr.sync_hdr.Flags |= SMB2_FLAGS_SIGNED;
+			req->sync_hdr.Flags |= SMB2_FLAGS_SIGNED;
 	} else if (encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
 	iov[0].iov_base = (char *)req;
-	/* 4 for rfc1002 length field and 1 for pad */
-	iov[0].iov_len = get_rfc1002_length(req) + 4 - 1;
+	/* 1 for pad */
+	iov[0].iov_len = total_len - 1;
 
 	/* Testing shows that buffer offset must be at location of Buffer[0] */
 	req->PathOffset = cpu_to_le16(sizeof(struct smb2_tree_connect_req)
-			- 1 /* pad */ - 4 /* do not count rfc1001 len field */);
+			- 1 /* pad */);
 	req->PathLength = cpu_to_le16(unc_path_len - 2);
 	iov[1].iov_base = unc_path;
 	iov[1].iov_len = unc_path_len;
 
-	inc_rfc1001_len(req, unc_path_len - 1 /* pad */);
-
-	rc = SendReceive2(xid, ses, iov, 2, &resp_buftype, flags, &rsp_iov);
+	rc = SendReceive3(xid, ses, iov, 2, &resp_buftype, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 	rsp = (struct smb2_tree_connect_rsp *)rsp_iov.iov_base;
 
@@ -1389,6 +1353,10 @@ SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon)
 	int rc = 0;
 	struct cifs_ses *ses = tcon->ses;
 	int flags = 0;
+	unsigned int total_len;
+	struct kvec iov[1];
+	struct kvec rsp_iov;
+	int resp_buf_type;
 
 	cifs_dbg(FYI, "Tree Disconnect\n");
 
@@ -1398,14 +1366,20 @@ SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon)
 	if ((tcon->need_reconnect) || (tcon->ses->need_reconnect))
 		return 0;
 
-	rc = small_smb2_init(SMB2_TREE_DISCONNECT, tcon, (void **) &req);
+	rc = small_smb2_init(SMB2_TREE_DISCONNECT, tcon, (void **) &req,
+			     &total_len);
 	if (rc)
 		return rc;
 
 	if (encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
-	rc = SendReceiveNoRsp(xid, ses, (char *)req, flags);
+	flags |= CIFS_NO_RESP;
+
+	iov[0].iov_base = (char *)req;
+	iov[0].iov_len = total_len;
+
+	rc = SendReceive3(xid, ses, iov, 1, &resp_buf_type, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 	if (rc)
 		cifs_stats_fail_inc(tcon, SMB2_TREE_DISCONNECT_HE);
@@ -1505,11 +1479,10 @@ add_lease_context(struct TCP_Server_Info *server, struct kvec *iov,
 	req->RequestedOplockLevel = SMB2_OPLOCK_LEVEL_LEASE;
 	if (!req->CreateContextsOffset)
 		req->CreateContextsOffset = cpu_to_le32(
-				sizeof(struct smb2_create_req) - 4 +
+				sizeof(struct smb2_create_req) +
 				iov[num - 1].iov_len);
 	le32_add_cpu(&req->CreateContextsLength,
 		     server->vals->create_lease_size);
-	inc_rfc1001_len(&req->hdr, server->vals->create_lease_size);
 	*num_iovec = num + 1;
 	return 0;
 }
@@ -1589,10 +1562,9 @@ add_durable_v2_context(struct kvec *iov, unsigned int *num_iovec,
 	iov[num].iov_len = sizeof(struct create_durable_v2);
 	if (!req->CreateContextsOffset)
 		req->CreateContextsOffset =
-			cpu_to_le32(sizeof(struct smb2_create_req) - 4 +
+			cpu_to_le32(sizeof(struct smb2_create_req) +
 								iov[1].iov_len);
 	le32_add_cpu(&req->CreateContextsLength, sizeof(struct create_durable_v2));
-	inc_rfc1001_len(&req->hdr, sizeof(struct create_durable_v2));
 	*num_iovec = num + 1;
 	return 0;
 }
@@ -1613,12 +1585,10 @@ add_durable_reconnect_v2_context(struct kvec *iov, unsigned int *num_iovec,
 	iov[num].iov_len = sizeof(struct create_durable_handle_reconnect_v2);
 	if (!req->CreateContextsOffset)
 		req->CreateContextsOffset =
-			cpu_to_le32(sizeof(struct smb2_create_req) - 4 +
+			cpu_to_le32(sizeof(struct smb2_create_req) +
 								iov[1].iov_len);
 	le32_add_cpu(&req->CreateContextsLength,
 			sizeof(struct create_durable_handle_reconnect_v2));
-	inc_rfc1001_len(&req->hdr,
-			sizeof(struct create_durable_handle_reconnect_v2));
 	*num_iovec = num + 1;
 	return 0;
 }
@@ -1649,10 +1619,9 @@ add_durable_context(struct kvec *iov, unsigned int *num_iovec,
 	iov[num].iov_len = sizeof(struct create_durable);
 	if (!req->CreateContextsOffset)
 		req->CreateContextsOffset =
-			cpu_to_le32(sizeof(struct smb2_create_req) - 4 +
+			cpu_to_le32(sizeof(struct smb2_create_req) +
 								iov[1].iov_len);
 	le32_add_cpu(&req->CreateContextsLength, sizeof(struct create_durable));
-	inc_rfc1001_len(&req->hdr, sizeof(struct create_durable));
 	*num_iovec = num + 1;
 	return 0;
 }
@@ -1723,6 +1692,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	__u32 file_attributes = 0;
 	char *dhc_buf = NULL, *lc_buf = NULL;
 	int flags = 0;
+	unsigned int total_len;
 
 	cifs_dbg(FYI, "create/open\n");
 
@@ -1731,7 +1701,8 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	else
 		return -EIO;
 
-	rc = small_smb2_init(SMB2_CREATE, tcon, (void **) &req);
+	rc = small_smb2_init(SMB2_CREATE, tcon, (void **) &req, &total_len);
+
 	if (rc)
 		return rc;
 
@@ -1752,12 +1723,10 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	req->CreateOptions = cpu_to_le32(oparms->create_options & CREATE_OPTIONS_MASK);
 
 	iov[0].iov_base = (char *)req;
-	/* 4 for rfc1002 length field */
-	iov[0].iov_len = get_rfc1002_length(req) + 4;
 	/* -1 since last byte is buf[0] which is sent below (path) */
-	iov[0].iov_len--;
+	iov[0].iov_len = total_len - 1;
 
-	req->NameOffset = cpu_to_le16(sizeof(struct smb2_create_req) - 4);
+	req->NameOffset = cpu_to_le16(sizeof(struct smb2_create_req));
 
 	/* [MS-SMB2] 2.2.13 NameOffset:
 	 * If SMB2_FLAGS_DFS_OPERATIONS is set in the Flags field of
@@ -1770,7 +1739,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	if (tcon->share_flags & SHI1005_FLAGS_DFS) {
 		int name_len;
 
-		req->hdr.sync_hdr.Flags |= SMB2_FLAGS_DFS_OPERATIONS;
+		req->sync_hdr.Flags |= SMB2_FLAGS_DFS_OPERATIONS;
 		rc = alloc_path_with_tree_prefix(&copy_path, &copy_size,
 						 &name_len,
 						 tcon->treeName, path);
@@ -1797,8 +1766,6 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 
 	iov[1].iov_len = uni_path_len;
 	iov[1].iov_base = path;
-	/* -1 since last byte is buf[0] which was counted in smb2_buf_len */
-	inc_rfc1001_len(req, uni_path_len - 1);
 
 	if (!server->oplocks)
 		*oplock = SMB2_OPLOCK_LEVEL_NONE;
@@ -1836,7 +1803,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 		dhc_buf = iov[n_iov-1].iov_base;
 	}
 
-	rc = SendReceive2(xid, ses, iov, n_iov, &resp_buftype, flags, &rsp_iov);
+	rc = SendReceive3(xid, ses, iov, n_iov, &resp_buftype, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 	rsp = (struct smb2_create_rsp *)rsp_iov.iov_base;
 
@@ -1891,6 +1858,7 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 	int n_iov;
 	int rc = 0;
 	int flags = 0;
+	unsigned int total_len;
 
 	cifs_dbg(FYI, "SMB2 IOCTL\n");
 
@@ -1909,7 +1877,7 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 	if (!ses || !(ses->server))
 		return -EIO;
 
-	rc = small_smb2_init(SMB2_IOCTL, tcon, (void **) &req);
+	rc = small_smb2_init(SMB2_IOCTL, tcon, (void **) &req, &total_len);
 	if (rc)
 		return rc;
 
@@ -1920,8 +1888,8 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 		}
 
 		cifs_dbg(FYI, "replacing tid 0x%x with IPC tid 0x%x\n",
-			 req->hdr.sync_hdr.TreeId, ses->ipc_tid);
-		req->hdr.sync_hdr.TreeId = ses->ipc_tid;
+			 req->sync_hdr.TreeId, ses->ipc_tid);
+		req->sync_hdr.TreeId = ses->ipc_tid;
 	}
 	if (encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
@@ -1934,7 +1902,7 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 		req->InputCount = cpu_to_le32(indatalen);
 		/* do not set InputOffset if no input data */
 		req->InputOffset =
-		       cpu_to_le32(offsetof(struct smb2_ioctl_req, Buffer) - 4);
+		       cpu_to_le32(offsetof(struct smb2_ioctl_req, Buffer));
 		iov[1].iov_base = in_data;
 		iov[1].iov_len = indatalen;
 		n_iov = 2;
@@ -1969,21 +1937,19 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 	 * but if input data passed to ioctl, we do not
 	 * want to double count this, so we do not send
 	 * the dummy one byte of data in iovec[0] if sending
-	 * input data (in iovec[1]). We also must add 4 bytes
-	 * in first iovec to allow for rfc1002 length field.
+	 * input data (in iovec[1]).
 	 */
 
 	if (indatalen) {
-		iov[0].iov_len = get_rfc1002_length(req) + 4 - 1;
-		inc_rfc1001_len(req, indatalen - 1);
+		iov[0].iov_len = total_len - 1;
 	} else
-		iov[0].iov_len = get_rfc1002_length(req) + 4;
+		iov[0].iov_len = total_len;
 
 	/* validate negotiate request must be signed - see MS-SMB2 3.2.5.5 */
 	if (opcode == FSCTL_VALIDATE_NEGOTIATE_INFO)
-		req->hdr.sync_hdr.Flags |= SMB2_FLAGS_SIGNED;
+		req->sync_hdr.Flags |= SMB2_FLAGS_SIGNED;
 
-	rc = SendReceive2(xid, ses, iov, n_iov, &resp_buftype, flags, &rsp_iov);
+	rc = SendReceive3(xid, ses, iov, n_iov, &resp_buftype, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 	rsp = (struct smb2_ioctl_rsp *)rsp_iov.iov_base;
 
@@ -2073,13 +2039,14 @@ SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
 	int resp_buftype;
 	int rc = 0;
 	int flags = 0;
+	unsigned int total_len;
 
 	cifs_dbg(FYI, "Close\n");
 
 	if (!ses || !(ses->server))
 		return -EIO;
 
-	rc = small_smb2_init(SMB2_CLOSE, tcon, (void **) &req);
+	rc = small_smb2_init(SMB2_CLOSE, tcon, (void **) &req, &total_len);
 	if (rc)
 		return rc;
 
@@ -2090,10 +2057,9 @@ SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
 	req->VolatileFileId = volatile_fid;
 
 	iov[0].iov_base = (char *)req;
-	/* 4 for rfc1002 length field */
-	iov[0].iov_len = get_rfc1002_length(req) + 4;
+	iov[0].iov_len = total_len;
 
-	rc = SendReceive2(xid, ses, iov, 1, &resp_buftype, flags, &rsp_iov);
+	rc = SendReceive3(xid, ses, iov, 1, &resp_buftype, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 	rsp = (struct smb2_close_rsp *)rsp_iov.iov_base;
 
@@ -2180,13 +2146,15 @@ query_info(const unsigned int xid, struct cifs_tcon *tcon,
 	int resp_buftype;
 	struct cifs_ses *ses = tcon->ses;
 	int flags = 0;
+	unsigned int total_len;
 
 	cifs_dbg(FYI, "Query Info\n");
 
 	if (!ses || !(ses->server))
 		return -EIO;
 
-	rc = small_smb2_init(SMB2_QUERY_INFO, tcon, (void **) &req);
+	rc = small_smb2_init(SMB2_QUERY_INFO, tcon, (void **) &req,
+			     &total_len);
 	if (rc)
 		return rc;
 
@@ -2203,15 +2171,13 @@ query_info(const unsigned int xid, struct cifs_tcon *tcon,
 	 * We do not use the input buffer (do not send extra byte)
 	 */
 	req->InputBufferOffset = 0;
-	inc_rfc1001_len(req, -1);
 
 	req->OutputBufferLength = cpu_to_le32(output_len);
 
 	iov[0].iov_base = (char *)req;
-	/* 4 for rfc1002 length field */
-	iov[0].iov_len = get_rfc1002_length(req) + 4;
+	iov[0].iov_len = total_len;
 
-	rc = SendReceive2(xid, ses, iov, 1, &resp_buftype, flags, &rsp_iov);
+	rc = SendReceive3(xid, ses, iov, 1, &resp_buftype, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 	rsp = (struct smb2_query_info_rsp *)rsp_iov.iov_base;
 
@@ -2376,6 +2342,8 @@ SMB2_echo(struct TCP_Server_Info *server)
 	struct kvec iov[2];
 	struct smb_rqst rqst = { .rq_iov = iov,
 				 .rq_nvec = 2 };
+	unsigned int total_len;
+	__be32 rfc1002_marker;
 
 	cifs_dbg(FYI, "In echo request\n");
 
@@ -2385,17 +2353,17 @@ SMB2_echo(struct TCP_Server_Info *server)
 		return rc;
 	}
 
-	rc = small_smb2_init(SMB2_ECHO, NULL, (void **)&req);
+	rc = small_smb2_init(SMB2_ECHO, NULL, (void **)&req, &total_len);
 	if (rc)
 		return rc;
 
-	req->hdr.sync_hdr.CreditRequest = cpu_to_le16(1);
+	req->sync_hdr.CreditRequest = cpu_to_le16(1);
 
-	/* 4 for rfc1002 length field */
 	iov[0].iov_len = 4;
-	iov[0].iov_base = (char *)req;
-	iov[1].iov_len = get_rfc1002_length(req);
-	iov[1].iov_base = (char *)req + 4;
+	rfc1002_marker = cpu_to_be32(total_len);
+	iov[0].iov_base = &rfc1002_marker;
+	iov[1].iov_len = total_len;
+	iov[1].iov_base = (char *)req;
 
 	rc = cifs_call_async(server, &rqst, NULL, smb2_echo_callback, NULL,
 			     server, CIFS_ECHO_OP);
@@ -2417,13 +2385,14 @@ SMB2_flush(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 	int resp_buftype;
 	int rc = 0;
 	int flags = 0;
+	unsigned int total_len;
 
 	cifs_dbg(FYI, "Flush\n");
 
 	if (!ses || !(ses->server))
 		return -EIO;
 
-	rc = small_smb2_init(SMB2_FLUSH, tcon, (void **) &req);
+	rc = small_smb2_init(SMB2_FLUSH, tcon, (void **) &req, &total_len);
 	if (rc)
 		return rc;
 
@@ -2434,10 +2403,9 @@ SMB2_flush(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 	req->VolatileFileId = volatile_fid;
 
 	iov[0].iov_base = (char *)req;
-	/* 4 for rfc1002 length field */
-	iov[0].iov_len = get_rfc1002_length(req) + 4;
+	iov[0].iov_len = total_len;
 
-	rc = SendReceive2(xid, ses, iov, 1, &resp_buftype, flags, &rsp_iov);
+	rc = SendReceive3(xid, ses, iov, 1, &resp_buftype, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 
 	if (rc != 0)
@@ -2460,8 +2428,8 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 	struct smb2_read_plain_req *req = NULL;
 	struct smb2_sync_hdr *shdr;
 
-	rc = smb2_plain_req_init(SMB2_READ, io_parms->tcon, (void **) &req,
-				 total_len);
+	rc = small_smb2_init(SMB2_READ, io_parms->tcon, (void **) &req,
+			     total_len);
 	if (rc)
 		return rc;
 	if (io_parms->tcon->ses->server == NULL)
@@ -2671,7 +2639,7 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 
 	iov[0].iov_base = &req_len;
 	iov[0].iov_len = sizeof(__be32);
-	iov[1].iov_base = req;
+	iov[1].iov_base = (char *)req;
 	iov[1].iov_len = total_len;
 
 	rc = cifs_send_recv(xid, ses, &rqst, &resp_buftype, flags, &rsp_iov);
@@ -2776,8 +2744,10 @@ smb2_async_writev(struct cifs_writedata *wdata,
 	struct TCP_Server_Info *server = tcon->ses->server;
 	struct kvec iov[2];
 	struct smb_rqst rqst = { };
+	unsigned int total_len;
+	__be32 rfc1002_marker;
 
-	rc = small_smb2_init(SMB2_WRITE, tcon, (void **) &req);
+	rc = small_smb2_init(SMB2_WRITE, tcon, (void **) &req, &total_len);
 	if (rc) {
 		if (rc == -EAGAIN && wdata->credits) {
 			/* credits was reset by reconnect */
@@ -2793,7 +2763,7 @@ smb2_async_writev(struct cifs_writedata *wdata,
 	if (encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
-	shdr = get_sync_hdr(req);
+	shdr = (struct smb2_sync_hdr *)req;
 	shdr->ProcessId = cpu_to_le32(wdata->cfile->pid);
 
 	req->PersistentFileId = wdata->cfile->fid.persistent_fid;
@@ -2802,16 +2772,16 @@ smb2_async_writev(struct cifs_writedata *wdata,
 	req->WriteChannelInfoLength = 0;
 	req->Channel = 0;
 	req->Offset = cpu_to_le64(wdata->offset);
-	/* 4 for rfc1002 length field */
 	req->DataOffset = cpu_to_le16(
-				offsetof(struct smb2_write_req, Buffer) - 4);
+				offsetof(struct smb2_write_req, Buffer));
 	req->RemainingBytes = 0;
 
 	/* 4 for rfc1002 length field and 1 for Buffer */
 	iov[0].iov_len = 4;
-	iov[0].iov_base = req;
-	iov[1].iov_len = get_rfc1002_length(req) - 1;
-	iov[1].iov_base = (char *)req + 4;
+	rfc1002_marker = cpu_to_be32(total_len - 1 + wdata->bytes);
+	iov[0].iov_base = &rfc1002_marker;
+	iov[1].iov_len = total_len - 1;
+	iov[1].iov_base = (char *)req;
 
 	rqst.rq_iov = iov;
 	rqst.rq_nvec = 2;
@@ -2825,8 +2795,6 @@ smb2_async_writev(struct cifs_writedata *wdata,
 
 	req->Length = cpu_to_le32(wdata->bytes);
 
-	inc_rfc1001_len(&req->hdr, wdata->bytes - 1 /* Buffer */);
-
 	if (wdata->credits) {
 		shdr->CreditCharge = cpu_to_le16(DIV_ROUND_UP(wdata->bytes,
 						    SMB2_MAX_BUFFER_SIZE));
@@ -2869,13 +2837,15 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 	int resp_buftype;
 	struct kvec rsp_iov;
 	int flags = 0;
+	unsigned int total_len;
 
 	*nbytes = 0;
 
 	if (n_vec < 1)
 		return rc;
 
-	rc = small_smb2_init(SMB2_WRITE, io_parms->tcon, (void **) &req);
+	rc = small_smb2_init(SMB2_WRITE, io_parms->tcon, (void **) &req,
+			     &total_len);
 	if (rc)
 		return rc;
 
@@ -2885,7 +2855,7 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 	if (encryption_required(io_parms->tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
-	req->hdr.sync_hdr.ProcessId = cpu_to_le32(io_parms->pid);
+	req->sync_hdr.ProcessId = cpu_to_le32(io_parms->pid);
 
 	req->PersistentFileId = io_parms->persistent_fid;
 	req->VolatileFileId = io_parms->volatile_fid;
@@ -2894,20 +2864,16 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 	req->Channel = 0;
 	req->Length = cpu_to_le32(io_parms->length);
 	req->Offset = cpu_to_le64(io_parms->offset);
-	/* 4 for rfc1002 length field */
 	req->DataOffset = cpu_to_le16(
-				offsetof(struct smb2_write_req, Buffer) - 4);
+				offsetof(struct smb2_write_req, Buffer));
 	req->RemainingBytes = 0;
 
 	iov[0].iov_base = (char *)req;
-	/* 4 for rfc1002 length field and 1 for Buffer */
-	iov[0].iov_len = get_rfc1002_length(req) + 4 - 1;
+	/* 1 for Buffer */
+	iov[0].iov_len = total_len - 1;
 
-	/* length of entire message including data to be written */
-	inc_rfc1001_len(req, io_parms->length - 1 /* Buffer */);
-
-	rc = SendReceive2(xid, io_parms->tcon->ses, iov, n_vec + 1,
-			  &resp_buftype, flags, &rsp_iov);
+	rc = SendReceive3(xid, io_parms->tcon->ses, iov, n_vec + 1,
+			      &resp_buftype, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 	rsp = (struct smb2_write_rsp *)rsp_iov.iov_base;
 
@@ -2984,13 +2950,15 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 	unsigned int output_size = CIFSMaxBufSize;
 	size_t info_buf_size;
 	int flags = 0;
+	unsigned int total_len;
 
 	if (ses && (ses->server))
 		server = ses->server;
 	else
 		return -EIO;
 
-	rc = small_smb2_init(SMB2_QUERY_DIRECTORY, tcon, (void **) &req);
+	rc = small_smb2_init(SMB2_QUERY_DIRECTORY, tcon, (void **) &req,
+			     &total_len);
 	if (rc)
 		return rc;
 
@@ -3022,7 +2990,7 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 	memcpy(bufptr, &asteriks, len);
 
 	req->FileNameOffset =
-		cpu_to_le16(sizeof(struct smb2_query_directory_req) - 1 - 4);
+		cpu_to_le16(sizeof(struct smb2_query_directory_req) - 1);
 	req->FileNameLength = cpu_to_le16(len);
 	/*
 	 * BB could be 30 bytes or so longer if we used SMB2 specific
@@ -3033,15 +3001,13 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 	req->OutputBufferLength = cpu_to_le32(output_size);
 
 	iov[0].iov_base = (char *)req;
-	/* 4 for RFC1001 length and 1 for Buffer */
-	iov[0].iov_len = get_rfc1002_length(req) + 4 - 1;
+	/* 1 for Buffer */
+	iov[0].iov_len = total_len - 1;
 
 	iov[1].iov_base = (char *)(req->Buffer);
 	iov[1].iov_len = len;
 
-	inc_rfc1001_len(req, len - 1 /* Buffer */);
-
-	rc = SendReceive2(xid, ses, iov, 2, &resp_buftype, flags, &rsp_iov);
+	rc = SendReceive3(xid, ses, iov, 2, &resp_buftype, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 	rsp = (struct smb2_query_directory_rsp *)rsp_iov.iov_base;
 
@@ -3110,6 +3076,7 @@ send_set_info(const unsigned int xid, struct cifs_tcon *tcon,
 	unsigned int i;
 	struct cifs_ses *ses = tcon->ses;
 	int flags = 0;
+	unsigned int total_len;
 
 	if (!ses || !(ses->server))
 		return -EIO;
@@ -3121,7 +3088,7 @@ send_set_info(const unsigned int xid, struct cifs_tcon *tcon,
 	if (!iov)
 		return -ENOMEM;
 
-	rc = small_smb2_init(SMB2_SET_INFO, tcon, (void **) &req);
+	rc = small_smb2_init(SMB2_SET_INFO, tcon, (void **) &req, &total_len);
 	if (rc) {
 		kfree(iov);
 		return rc;
@@ -3130,7 +3097,7 @@ send_set_info(const unsigned int xid, struct cifs_tcon *tcon,
 	if (encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
-	req->hdr.sync_hdr.ProcessId = cpu_to_le32(pid);
+	req->sync_hdr.ProcessId = cpu_to_le32(pid);
 
 	req->InfoType = info_type;
 	req->FileInfoClass = info_class;
@@ -3138,27 +3105,24 @@ send_set_info(const unsigned int xid, struct cifs_tcon *tcon,
 	req->VolatileFileId = volatile_fid;
 	req->AdditionalInformation = cpu_to_le32(additional_info);
 
-	/* 4 for RFC1001 length and 1 for Buffer */
+	/* 1 for Buffer */
 	req->BufferOffset =
-			cpu_to_le16(sizeof(struct smb2_set_info_req) - 1 - 4);
+			cpu_to_le16(sizeof(struct smb2_set_info_req) - 1);
 	req->BufferLength = cpu_to_le32(*size);
 
-	inc_rfc1001_len(req, *size - 1 /* Buffer */);
-
 	memcpy(req->Buffer, *data, *size);
+	total_len += *size;
 
 	iov[0].iov_base = (char *)req;
-	/* 4 for RFC1001 length */
-	iov[0].iov_len = get_rfc1002_length(req) + 4;
+	iov[0].iov_len = total_len;
 
 	for (i = 1; i < num; i++) {
-		inc_rfc1001_len(req, size[i]);
 		le32_add_cpu(&req->BufferLength, size[i]);
 		iov[i].iov_base = (char *)data[i];
 		iov[i].iov_len = size[i];
 	}
 
-	rc = SendReceive2(xid, ses, iov, num, &resp_buftype, flags, &rsp_iov);
+	rc = SendReceive3(xid, ses, iov, num, &resp_buftype, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 	rsp = (struct smb2_set_info_rsp *)rsp_iov.iov_base;
 
@@ -3310,11 +3274,17 @@ SMB2_oplock_break(const unsigned int xid, struct cifs_tcon *tcon,
 		  __u8 oplock_level)
 {
 	int rc;
-	struct smb2_oplock_break *req = NULL;
+	struct smb2_oplock_break_req *req = NULL;
+	struct cifs_ses *ses = tcon->ses;
 	int flags = CIFS_OBREAK_OP;
+	unsigned int total_len;
+	struct kvec iov[1];
+	struct kvec rsp_iov;
+	int resp_buf_type;
 
 	cifs_dbg(FYI, "SMB2_oplock_break\n");
-	rc = small_smb2_init(SMB2_OPLOCK_BREAK, tcon, (void **) &req);
+	rc = small_smb2_init(SMB2_OPLOCK_BREAK, tcon, (void **) &req,
+			     &total_len);
 	if (rc)
 		return rc;
 
@@ -3324,9 +3294,14 @@ SMB2_oplock_break(const unsigned int xid, struct cifs_tcon *tcon,
 	req->VolatileFid = volatile_fid;
 	req->PersistentFid = persistent_fid;
 	req->OplockLevel = oplock_level;
-	req->hdr.sync_hdr.CreditRequest = cpu_to_le16(1);
+	req->sync_hdr.CreditRequest = cpu_to_le16(1);
+
+	flags |= CIFS_NO_RESP;
+
+	iov[0].iov_base = (char *)req;
+	iov[0].iov_len = total_len;
 
-	rc = SendReceiveNoRsp(xid, tcon->ses, (char *) req, flags);
+	rc = SendReceive3(xid, ses, iov, 1, &resp_buf_type, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 
 	if (rc) {
@@ -3355,13 +3330,15 @@ build_qfs_info_req(struct kvec *iov, struct cifs_tcon *tcon, int level,
 {
 	int rc;
 	struct smb2_query_info_req *req;
+	unsigned int total_len;
 
 	cifs_dbg(FYI, "Query FSInfo level %d\n", level);
 
 	if ((tcon->ses == NULL) || (tcon->ses->server == NULL))
 		return -EIO;
 
-	rc = small_smb2_init(SMB2_QUERY_INFO, tcon, (void **) &req);
+	rc = small_smb2_init(SMB2_QUERY_INFO, tcon, (void **) &req,
+			     &total_len);
 	if (rc)
 		return rc;
 
@@ -3369,15 +3346,14 @@ build_qfs_info_req(struct kvec *iov, struct cifs_tcon *tcon, int level,
 	req->FileInfoClass = level;
 	req->PersistentFileId = persistent_fid;
 	req->VolatileFileId = volatile_fid;
-	/* 4 for rfc1002 length field and 1 for pad */
+	/* 1 for pad */
 	req->InputBufferOffset =
-			cpu_to_le16(sizeof(struct smb2_query_info_req) - 1 - 4);
+			cpu_to_le16(sizeof(struct smb2_query_info_req) - 1);
 	req->OutputBufferLength = cpu_to_le32(
 		outbuf_len + sizeof(struct smb2_query_info_rsp) - 1 - 4);
 
 	iov->iov_base = (char *)req;
-	/* 4 for rfc1002 length field */
-	iov->iov_len = get_rfc1002_length(req) + 4;
+	iov->iov_len = total_len;
 	return 0;
 }
 
@@ -3403,7 +3379,7 @@ SMB2_QFS_info(const unsigned int xid, struct cifs_tcon *tcon,
 	if (encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
-	rc = SendReceive2(xid, ses, &iov, 1, &resp_buftype, flags, &rsp_iov);
+	rc = SendReceive3(xid, ses, &iov, 1, &resp_buftype, flags, &rsp_iov);
 	cifs_small_buf_release(iov.iov_base);
 	if (rc) {
 		cifs_stats_fail_inc(tcon, SMB2_QUERY_INFO_HE);
@@ -3459,7 +3435,7 @@ SMB2_QFS_attr(const unsigned int xid, struct cifs_tcon *tcon,
 	if (encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
-	rc = SendReceive2(xid, ses, &iov, 1, &resp_buftype, flags, &rsp_iov);
+	rc = SendReceive3(xid, ses, &iov, 1, &resp_buftype, flags, &rsp_iov);
 	cifs_small_buf_release(iov.iov_base);
 	if (rc) {
 		cifs_stats_fail_inc(tcon, SMB2_QUERY_INFO_HE);
@@ -3505,33 +3481,32 @@ smb2_lockv(const unsigned int xid, struct cifs_tcon *tcon,
 	int resp_buf_type;
 	unsigned int count;
 	int flags = CIFS_NO_RESP;
+	unsigned int total_len;
 
 	cifs_dbg(FYI, "smb2_lockv num lock %d\n", num_lock);
 
-	rc = small_smb2_init(SMB2_LOCK, tcon, (void **) &req);
+	rc = small_smb2_init(SMB2_LOCK, tcon, (void **) &req, &total_len);
 	if (rc)
 		return rc;
 
 	if (encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
-	req->hdr.sync_hdr.ProcessId = cpu_to_le32(pid);
+	req->sync_hdr.ProcessId = cpu_to_le32(pid);
 	req->LockCount = cpu_to_le16(num_lock);
 
 	req->PersistentFileId = persist_fid;
 	req->VolatileFileId = volatile_fid;
 
 	count = num_lock * sizeof(struct smb2_lock_element);
-	inc_rfc1001_len(req, count - sizeof(struct smb2_lock_element));
 
 	iov[0].iov_base = (char *)req;
-	/* 4 for rfc1002 length field and count for all locks */
-	iov[0].iov_len = get_rfc1002_length(req) + 4 - count;
+	iov[0].iov_len = total_len;
 	iov[1].iov_base = (char *)buf;
 	iov[1].iov_len = count;
 
 	cifs_stats_inc(&tcon->stats.cifs_stats.num_locks);
-	rc = SendReceive2(xid, tcon->ses, iov, 2, &resp_buf_type, flags,
+	rc = SendReceive3(xid, tcon->ses, iov, 2, &resp_buf_type, flags,
 			  &rsp_iov);
 	cifs_small_buf_release(req);
 	if (rc) {
@@ -3565,24 +3540,34 @@ SMB2_lease_break(const unsigned int xid, struct cifs_tcon *tcon,
 {
 	int rc;
 	struct smb2_lease_ack *req = NULL;
+	struct cifs_ses *ses = tcon->ses;
 	int flags = CIFS_OBREAK_OP;
+	unsigned int total_len;
+	struct kvec iov[1];
+	struct kvec rsp_iov;
+	int resp_buf_type;
 
 	cifs_dbg(FYI, "SMB2_lease_break\n");
-	rc = small_smb2_init(SMB2_OPLOCK_BREAK, tcon, (void **) &req);
+	rc = small_smb2_init(SMB2_OPLOCK_BREAK, tcon, (void **) &req,
+			     &total_len);
 	if (rc)
 		return rc;
 
 	if (encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
-	req->hdr.sync_hdr.CreditRequest = cpu_to_le16(1);
+	req->sync_hdr.CreditRequest = cpu_to_le16(1);
 	req->StructureSize = cpu_to_le16(36);
-	inc_rfc1001_len(req, 12);
 
 	memcpy(req->LeaseKey, lease_key, 16);
 	req->LeaseState = lease_state;
 
-	rc = SendReceiveNoRsp(xid, tcon->ses, (char *) req, flags);
+	flags |= CIFS_NO_RESP;
+
+	iov[0].iov_base = (char *)req;
+	iov[0].iov_len = total_len;
+
+	rc = SendReceive3(xid, ses, iov, 1, &resp_buf_type, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 
 	if (rc) {
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index c2ec934be968..19d34881815f 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -195,7 +195,7 @@ struct smb2_symlink_err_rsp {
 #define SMB2_CLIENT_GUID_SIZE 16
 
 struct smb2_negotiate_req {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize; /* Must be 36 */
 	__le16 DialectCount;
 	__le16 SecurityMode;
@@ -282,7 +282,7 @@ struct smb2_negotiate_rsp {
 #define SMB2_SESSION_REQ_FLAG_ENCRYPT_DATA	0x04
 
 struct smb2_sess_setup_req {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize; /* Must be 25 */
 	__u8   Flags;
 	__u8   SecurityMode;
@@ -308,7 +308,7 @@ struct smb2_sess_setup_rsp {
 } __packed;
 
 struct smb2_logoff_req {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize;	/* Must be 4 */
 	__le16 Reserved;
 } __packed;
@@ -323,7 +323,7 @@ struct smb2_logoff_rsp {
 #define SMB2_SHAREFLAG_CLUSTER_RECONNECT	0x0001
 
 struct smb2_tree_connect_req {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize;	/* Must be 9 */
 	__le16 Reserved; /* Flags in SMB3.1.1 */
 	__le16 PathOffset;
@@ -375,7 +375,7 @@ struct smb2_tree_connect_rsp {
 #define SMB2_SHARE_CAP_ASYMMETRIC cpu_to_le32(0x00000080) /* 3.02 */
 
 struct smb2_tree_disconnect_req {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize;	/* Must be 4 */
 	__le16 Reserved;
 } __packed;
@@ -496,7 +496,7 @@ struct smb2_tree_disconnect_rsp {
 #define SVHDX_OPEN_DEVICE_CONTEXT	0x83CE6F1AD851E0986E34401CC9BCFCE9
 
 struct smb2_create_req {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize;	/* Must be 57 */
 	__u8   SecurityFlags;
 	__u8   RequestedOplockLevel;
@@ -753,7 +753,7 @@ struct duplicate_extents_to_file {
 } __packed;
 
 struct smb2_ioctl_req {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize;	/* Must be 57 */
 	__u16 Reserved;
 	__le32 CtlCode;
@@ -789,7 +789,7 @@ struct smb2_ioctl_rsp {
 /* Currently defined values for close flags */
 #define SMB2_CLOSE_FLAG_POSTQUERY_ATTRIB	cpu_to_le16(0x0001)
 struct smb2_close_req {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize;	/* Must be 24 */
 	__le16 Flags;
 	__le32 Reserved;
@@ -812,7 +812,7 @@ struct smb2_close_rsp {
 } __packed;
 
 struct smb2_flush_req {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize;	/* Must be 24 */
 	__le16 Reserved1;
 	__le32 Reserved2;
@@ -868,7 +868,7 @@ struct smb2_read_rsp {
 #define SMB2_WRITEFLAG_WRITE_UNBUFFERED	0x00000002	/* SMB3.02 or later */
 
 struct smb2_write_req {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize; /* Must be 49 */
 	__le16 DataOffset; /* offset from start of SMB2 header to write data */
 	__le32 Length;
@@ -907,7 +907,7 @@ struct smb2_lock_element {
 } __packed;
 
 struct smb2_lock_req {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize; /* Must be 48 */
 	__le16 LockCount;
 	__le32 Reserved;
@@ -924,7 +924,7 @@ struct smb2_lock_rsp {
 } __packed;
 
 struct smb2_echo_req {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize;	/* Must be 4 */
 	__u16  Reserved;
 } __packed;
@@ -942,7 +942,7 @@ struct smb2_echo_rsp {
 #define SMB2_REOPEN			0x10
 
 struct smb2_query_directory_req {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize; /* Must be 33 */
 	__u8   FileInformationClass;
 	__u8   Flags;
@@ -989,7 +989,7 @@ struct smb2_query_directory_rsp {
 #define SL_INDEX_SPECIFIED	0x00000004
 
 struct smb2_query_info_req {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize; /* Must be 41 */
 	__u8   InfoType;
 	__u8   FileInfoClass;
@@ -1013,7 +1013,7 @@ struct smb2_query_info_rsp {
 } __packed;
 
 struct smb2_set_info_req {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize; /* Must be 33 */
 	__u8   InfoType;
 	__u8   FileInfoClass;
@@ -1031,7 +1031,19 @@ struct smb2_set_info_rsp {
 	__le16 StructureSize; /* Must be 2 */
 } __packed;
 
-struct smb2_oplock_break {
+/* oplock break without an rfc1002 header */
+struct smb2_oplock_break_req {
+	struct smb2_sync_hdr sync_hdr;
+	__le16 StructureSize; /* Must be 24 */
+	__u8   OplockLevel;
+	__u8   Reserved;
+	__le32 Reserved2;
+	__u64  PersistentFid;
+	__u64  VolatileFid;
+} __packed;
+
+/* oplock break with an rfc1002 header */
+struct smb2_oplock_break_rsp {
 	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 24 */
 	__u8   OplockLevel;
@@ -1057,7 +1069,7 @@ struct smb2_lease_break {
 } __packed;
 
 struct smb2_lease_ack {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize; /* Must be 36 */
 	__le16 Reserved;
 	__le32 Flags;
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 7efbab013957..3f16adec3df5 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -827,6 +827,44 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 	return rc;
 }
 
+/* Like SendReceive2 but iov[0] does not contain an rfc1002 header */
+int
+SendReceive3(const unsigned int xid, struct cifs_ses *ses,
+	     struct kvec *iov, int n_vec, int *resp_buf_type /* ret */,
+	     const int flags, struct kvec *resp_iov)
+{
+	struct smb_rqst rqst;
+	struct kvec *new_iov;
+	int rc;
+	int i;
+	__u32 count;
+	__be32 rfc1002_marker;
+
+	new_iov = kmalloc(sizeof(struct kvec) * (n_vec + 1), GFP_KERNEL);
+	if (!new_iov)
+		return -ENOMEM;
+
+	/* 1st iov is an RFC1002 Session Message length */
+	memcpy(new_iov + 1, iov, (sizeof(struct kvec) * n_vec));
+
+	count = 0;
+	for (i = 1; i < n_vec + 1; i++)
+		count += new_iov[i].iov_len;
+
+	rfc1002_marker = cpu_to_be32(count);
+
+	new_iov[0].iov_base = &rfc1002_marker;
+	new_iov[0].iov_len = 4;
+
+	memset(&rqst, 0, sizeof(struct smb_rqst));
+	rqst.rq_iov = new_iov;
+	rqst.rq_nvec = n_vec + 1;
+
+	rc = cifs_send_recv(xid, ses, &rqst, resp_buf_type, flags, resp_iov);
+	kfree(new_iov);
+	return rc;
+}
+
 int
 SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	    struct smb_hdr *in_buf, struct smb_hdr *out_buf,
-- 
2.13.3
