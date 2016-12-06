From: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: [PATCH 01/15] CIFS: Separate SMB2 header structure
Date: Tue,  6 Dec 2016 14:02:24 -0800
Message-ID: <1481061758-52020-2-git-send-email-pshilov@microsoft.com>
References: <1481061758-52020-1-git-send-email-pshilov@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1481061758-52020-1-git-send-email-pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

In order to support compounding and encryption we need to separate
RFC1001 length field and SMB2 header structure because the protocol
treats them differently. This change will allow to simplify parsing
of such complex SMB2 packets further.

Signed-off-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/smb2glob.h      |   5 ++
 fs/cifs/smb2maperror.c  |   5 +-
 fs/cifs/smb2misc.c      |  61 ++++++++++++----------
 fs/cifs/smb2ops.c       |  26 +++++-----
 fs/cifs/smb2pdu.c       | 132 ++++++++++++++++++++++++++----------------------
 fs/cifs/smb2pdu.h       |  12 +++--
 fs/cifs/smb2transport.c |  81 +++++++++++++++--------------
 7 files changed, 174 insertions(+), 148 deletions(-)

diff --git a/fs/cifs/smb2glob.h b/fs/cifs/smb2glob.h
index 0ffa180..401a5d8 100644
--- a/fs/cifs/smb2glob.h
+++ b/fs/cifs/smb2glob.h
@@ -61,4 +61,9 @@
 /* Maximum buffer size value we can send with 1 credit */
 #define SMB2_MAX_BUFFER_SIZE 65536
 
+static inline struct smb2_sync_hdr *get_sync_hdr(void *buf)
+{
+	return &(((struct smb2_hdr *)buf)->sync_hdr);
+}
+
 #endif	/* _SMB2_GLOB_H */
diff --git a/fs/cifs/smb2maperror.c b/fs/cifs/smb2maperror.c
index 8257a5a..3030a9d 100644
--- a/fs/cifs/smb2maperror.c
+++ b/fs/cifs/smb2maperror.c
@@ -26,6 +26,7 @@
 #include "smb2pdu.h"
 #include "smb2proto.h"
 #include "smb2status.h"
+#include "smb2glob.h"
 
 struct status_to_posix_error {
 	__le32 smb2_status;
@@ -2449,10 +2450,10 @@ smb2_print_status(__le32 status)
 int
 map_smb2_to_linux_error(char *buf, bool log_err)
 {
-	struct smb2_hdr *hdr = (struct smb2_hdr *)buf;
+	struct smb2_sync_hdr *shdr = get_sync_hdr(buf);
 	unsigned int i;
 	int rc = -EIO;
-	__le32 smb2err = hdr->Status;
+	__le32 smb2err = shdr->Status;
 
 	if (smb2err == 0)
 		return 0;
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 3d38348..fd516ea 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -28,31 +28,32 @@
 #include "cifs_debug.h"
 #include "cifs_unicode.h"
 #include "smb2status.h"
+#include "smb2glob.h"
 
 static int
-check_smb2_hdr(struct smb2_hdr *hdr, __u64 mid)
+check_smb2_hdr(struct smb2_sync_hdr *shdr, __u64 mid)
 {
-	__u64 wire_mid = le64_to_cpu(hdr->MessageId);
+	__u64 wire_mid = le64_to_cpu(shdr->MessageId);
 
 	/*
 	 * Make sure that this really is an SMB, that it is a response,
 	 * and that the message ids match.
 	 */
-	if ((hdr->ProtocolId == SMB2_PROTO_NUMBER) &&
+	if ((shdr->ProtocolId == SMB2_PROTO_NUMBER) &&
 	    (mid == wire_mid)) {
-		if (hdr->Flags & SMB2_FLAGS_SERVER_TO_REDIR)
+		if (shdr->Flags & SMB2_FLAGS_SERVER_TO_REDIR)
 			return 0;
 		else {
 			/* only one valid case where server sends us request */
-			if (hdr->Command == SMB2_OPLOCK_BREAK)
+			if (shdr->Command == SMB2_OPLOCK_BREAK)
 				return 0;
 			else
 				cifs_dbg(VFS, "Received Request not response\n");
 		}
 	} else { /* bad signature or mid */
-		if (hdr->ProtocolId != SMB2_PROTO_NUMBER)
+		if (shdr->ProtocolId != SMB2_PROTO_NUMBER)
 			cifs_dbg(VFS, "Bad protocol string signature header %x\n",
-				 le32_to_cpu(hdr->ProtocolId));
+				 le32_to_cpu(shdr->ProtocolId));
 		if (mid != wire_mid)
 			cifs_dbg(VFS, "Mids do not match: %llu and %llu\n",
 				 mid, wire_mid);
@@ -95,8 +96,9 @@ static const __le16 smb2_rsp_struct_sizes[NUMBER_OF_SMB2_COMMANDS] = {
 int
 smb2_check_message(char *buf, unsigned int length, struct TCP_Server_Info *srvr)
 {
-	struct smb2_hdr *hdr = (struct smb2_hdr *)buf;
-	struct smb2_pdu *pdu = (struct smb2_pdu *)hdr;
+	struct smb2_pdu *pdu = (struct smb2_pdu *)buf;
+	struct smb2_hdr *hdr = &pdu->hdr;
+	struct smb2_sync_hdr *shdr = get_sync_hdr(buf);
 	__u64 mid;
 	__u32 len = get_rfc1002_length(buf);
 	__u32 clc_len;  /* calculated length */
@@ -111,7 +113,7 @@ smb2_check_message(char *buf, unsigned int length, struct TCP_Server_Info *srvr)
 	 * ie Validate the wct via smb2_struct_sizes table above
 	 */
 
-	if (hdr->ProtocolId == SMB2_TRANSFORM_PROTO_NUM) {
+	if (shdr->ProtocolId == SMB2_TRANSFORM_PROTO_NUM) {
 		struct smb2_transform_hdr *thdr =
 			(struct smb2_transform_hdr *)buf;
 		struct cifs_ses *ses = NULL;
@@ -133,10 +135,10 @@ smb2_check_message(char *buf, unsigned int length, struct TCP_Server_Info *srvr)
 		}
 	}
 
-
-	mid = le64_to_cpu(hdr->MessageId);
+	mid = le64_to_cpu(shdr->MessageId);
 	if (length < sizeof(struct smb2_pdu)) {
-		if ((length >= sizeof(struct smb2_hdr)) && (hdr->Status != 0)) {
+		if ((length >= sizeof(struct smb2_hdr))
+		    && (shdr->Status != 0)) {
 			pdu->StructureSize2 = 0;
 			/*
 			 * As with SMB/CIFS, on some error cases servers may
@@ -154,29 +156,30 @@ smb2_check_message(char *buf, unsigned int length, struct TCP_Server_Info *srvr)
 		return 1;
 	}
 
-	if (check_smb2_hdr(hdr, mid))
+	if (check_smb2_hdr(shdr, mid))
 		return 1;
 
-	if (hdr->StructureSize != SMB2_HEADER_STRUCTURE_SIZE) {
+	if (shdr->StructureSize != SMB2_HEADER_STRUCTURE_SIZE) {
 		cifs_dbg(VFS, "Illegal structure size %u\n",
-			 le16_to_cpu(hdr->StructureSize));
+			 le16_to_cpu(shdr->StructureSize));
 		return 1;
 	}
 
-	command = le16_to_cpu(hdr->Command);
+	command = le16_to_cpu(shdr->Command);
 	if (command >= NUMBER_OF_SMB2_COMMANDS) {
 		cifs_dbg(VFS, "Illegal SMB2 command %d\n", command);
 		return 1;
 	}
 
 	if (smb2_rsp_struct_sizes[command] != pdu->StructureSize2) {
-		if (command != SMB2_OPLOCK_BREAK_HE && (hdr->Status == 0 ||
+		if (command != SMB2_OPLOCK_BREAK_HE && (shdr->Status == 0 ||
 		    pdu->StructureSize2 != SMB2_ERROR_STRUCTURE_SIZE2)) {
 			/* error packets have 9 byte structure size */
 			cifs_dbg(VFS, "Illegal response size %u for command %d\n",
 				 le16_to_cpu(pdu->StructureSize2), command);
 			return 1;
-		} else if (command == SMB2_OPLOCK_BREAK_HE && (hdr->Status == 0)
+		} else if (command == SMB2_OPLOCK_BREAK_HE
+			   && (shdr->Status == 0)
 			   && (le16_to_cpu(pdu->StructureSize2) != 44)
 			   && (le16_to_cpu(pdu->StructureSize2) != 36)) {
 			/* special case for SMB2.1 lease break message */
@@ -199,7 +202,7 @@ smb2_check_message(char *buf, unsigned int length, struct TCP_Server_Info *srvr)
 			 clc_len, 4 + len, mid);
 		/* create failed on symlink */
 		if (command == SMB2_CREATE_HE &&
-		    hdr->Status == STATUS_STOPPED_ON_SYMLINK)
+		    shdr->Status == STATUS_STOPPED_ON_SYMLINK)
 			return 0;
 		/* Windows 7 server returns 24 bytes more */
 		if (clc_len + 20 == len && command == SMB2_OPLOCK_BREAK_HE)
@@ -261,11 +264,12 @@ static const bool has_smb2_data_area[NUMBER_OF_SMB2_COMMANDS] = {
 char *
 smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *hdr)
 {
+	struct smb2_sync_hdr *shdr = get_sync_hdr(hdr);
 	*off = 0;
 	*len = 0;
 
 	/* error responses do not have data area */
-	if (hdr->Status && hdr->Status != STATUS_MORE_PROCESSING_REQUIRED &&
+	if (shdr->Status && shdr->Status != STATUS_MORE_PROCESSING_REQUIRED &&
 	    (((struct smb2_err_rsp *)hdr)->StructureSize) ==
 						SMB2_ERROR_STRUCTURE_SIZE2)
 		return NULL;
@@ -275,7 +279,7 @@ smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *hdr)
 	 * of the data buffer offset and data buffer length for the particular
 	 * command.
 	 */
-	switch (hdr->Command) {
+	switch (shdr->Command) {
 	case SMB2_NEGOTIATE:
 		*off = le16_to_cpu(
 		    ((struct smb2_negotiate_rsp *)hdr)->SecurityBufferOffset);
@@ -346,7 +350,7 @@ smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *hdr)
 
 	/* return pointer to beginning of data area, ie offset from SMB start */
 	if ((*off != 0) && (*len != 0))
-		return (char *)(&hdr->ProtocolId) + *off;
+		return (char *)shdr + *off;
 	else
 		return NULL;
 }
@@ -358,12 +362,13 @@ smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *hdr)
 unsigned int
 smb2_calc_size(void *buf)
 {
-	struct smb2_hdr *hdr = (struct smb2_hdr *)buf;
-	struct smb2_pdu *pdu = (struct smb2_pdu *)hdr;
+	struct smb2_pdu *pdu = (struct smb2_pdu *)buf;
+	struct smb2_hdr *hdr = &pdu->hdr;
+	struct smb2_sync_hdr *shdr = get_sync_hdr(hdr);
 	int offset; /* the offset from the beginning of SMB to data area */
 	int data_length; /* the length of the variable length data area */
 	/* Structure Size has already been checked to make sure it is 64 */
-	int len = 4 + le16_to_cpu(pdu->hdr.StructureSize);
+	int len = 4 + le16_to_cpu(shdr->StructureSize);
 
 	/*
 	 * StructureSize2, ie length of fixed parameter area has already
@@ -371,7 +376,7 @@ smb2_calc_size(void *buf)
 	 */
 	len += le16_to_cpu(pdu->StructureSize2);
 
-	if (has_smb2_data_area[le16_to_cpu(hdr->Command)] == false)
+	if (has_smb2_data_area[le16_to_cpu(shdr->Command)] == false)
 		goto calc_size_exit;
 
 	smb2_get_data_area_len(&offset, &data_length, hdr);
@@ -582,7 +587,7 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
 
 	cifs_dbg(FYI, "Checking for oplock break\n");
 
-	if (rsp->hdr.Command != SMB2_OPLOCK_BREAK)
+	if (rsp->hdr.sync_hdr.Command != SMB2_OPLOCK_BREAK)
 		return false;
 
 	if (rsp->StructureSize !=
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 5d456eb..ef8b2a8 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -119,7 +119,9 @@ smb2_get_credits_field(struct TCP_Server_Info *server, const int optype)
 static unsigned int
 smb2_get_credits(struct mid_q_entry *mid)
 {
-	return le16_to_cpu(((struct smb2_hdr *)mid->resp_buf)->CreditRequest);
+	struct smb2_sync_hdr *shdr = get_sync_hdr(mid->resp_buf);
+
+	return le16_to_cpu(shdr->CreditRequest);
 }
 
 static int
@@ -184,10 +186,10 @@ static struct mid_q_entry *
 smb2_find_mid(struct TCP_Server_Info *server, char *buf)
 {
 	struct mid_q_entry *mid;
-	struct smb2_hdr *hdr = (struct smb2_hdr *)buf;
-	__u64 wire_mid = le64_to_cpu(hdr->MessageId);
+	struct smb2_sync_hdr *shdr = get_sync_hdr(buf);
+	__u64 wire_mid = le64_to_cpu(shdr->MessageId);
 
-	if (hdr->ProtocolId == SMB2_TRANSFORM_PROTO_NUM) {
+	if (shdr->ProtocolId == SMB2_TRANSFORM_PROTO_NUM) {
 		cifs_dbg(VFS, "encrypted frame parsing not supported yet");
 		return NULL;
 	}
@@ -196,7 +198,7 @@ smb2_find_mid(struct TCP_Server_Info *server, char *buf)
 	list_for_each_entry(mid, &server->pending_mid_q, qhead) {
 		if ((mid->mid == wire_mid) &&
 		    (mid->mid_state == MID_REQUEST_SUBMITTED) &&
-		    (mid->command == hdr->Command)) {
+		    (mid->command == shdr->Command)) {
 			spin_unlock(&GlobalMid_Lock);
 			return mid;
 		}
@@ -209,12 +211,12 @@ static void
 smb2_dump_detail(void *buf)
 {
 #ifdef CONFIG_CIFS_DEBUG2
-	struct smb2_hdr *smb = (struct smb2_hdr *)buf;
+	struct smb2_sync_hdr *shdr = get_sync_hdr(buf);
 
 	cifs_dbg(VFS, "Cmd: %d Err: 0x%x Flags: 0x%x Mid: %llu Pid: %d\n",
-		 smb->Command, smb->Status, smb->Flags, smb->MessageId,
-		 smb->ProcessId);
-	cifs_dbg(VFS, "smb buf %p len %u\n", smb, smb2_calc_size(smb));
+		 shdr->Command, shdr->Status, shdr->Flags, shdr->MessageId,
+		 shdr->ProcessId);
+	cifs_dbg(VFS, "smb buf %p len %u\n", buf, smb2_calc_size(buf));
 #endif
 }
 
@@ -1002,14 +1004,14 @@ smb2_close_dir(const unsigned int xid, struct cifs_tcon *tcon,
 static bool
 smb2_is_status_pending(char *buf, struct TCP_Server_Info *server, int length)
 {
-	struct smb2_hdr *hdr = (struct smb2_hdr *)buf;
+	struct smb2_sync_hdr *shdr = get_sync_hdr(buf);
 
-	if (hdr->Status != STATUS_PENDING)
+	if (shdr->Status != STATUS_PENDING)
 		return false;
 
 	if (!length) {
 		spin_lock(&server->req_lock);
-		server->credits += le16_to_cpu(hdr->CreditRequest);
+		server->credits += le16_to_cpu(shdr->CreditRequest);
 		spin_unlock(&server->req_lock);
 		wake_up(&server->request_q);
 	}
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 8745722..0a668c7 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -83,6 +83,7 @@ smb2_hdr_assemble(struct smb2_hdr *hdr, __le16 smb2_cmd /* command */ ,
 		  const struct cifs_tcon *tcon)
 {
 	struct smb2_pdu *pdu = (struct smb2_pdu *)hdr;
+	struct smb2_sync_hdr *shdr = get_sync_hdr(hdr);
 	char *temp = (char *)hdr;
 	/* lookup word count ie StructureSize from table */
 	__u16 parmsize = smb2_req_struct_sizes[le16_to_cpu(smb2_cmd)];
@@ -94,28 +95,28 @@ smb2_hdr_assemble(struct smb2_hdr *hdr, __le16 smb2_cmd /* command */ ,
 	memset(temp, 0, 256);
 
 	/* Note this is only network field converted to big endian */
-	hdr->smb2_buf_length = cpu_to_be32(parmsize + sizeof(struct smb2_hdr)
-			- 4 /*  RFC 1001 length field itself not counted */);
+	hdr->smb2_buf_length =
+			cpu_to_be32(parmsize + sizeof(struct smb2_sync_hdr));
 
-	hdr->ProtocolId = SMB2_PROTO_NUMBER;
-	hdr->StructureSize = cpu_to_le16(64);
-	hdr->Command = smb2_cmd;
+	shdr->ProtocolId = SMB2_PROTO_NUMBER;
+	shdr->StructureSize = cpu_to_le16(64);
+	shdr->Command = smb2_cmd;
 	if (tcon && tcon->ses && tcon->ses->server) {
 		struct TCP_Server_Info *server = tcon->ses->server;
 
 		spin_lock(&server->req_lock);
 		/* Request up to 2 credits but don't go over the limit. */
 		if (server->credits >= server->max_credits)
-			hdr->CreditRequest = cpu_to_le16(0);
+			shdr->CreditRequest = cpu_to_le16(0);
 		else
-			hdr->CreditRequest = cpu_to_le16(
+			shdr->CreditRequest = cpu_to_le16(
 				min_t(int, server->max_credits -
 						server->credits, 2));
 		spin_unlock(&server->req_lock);
 	} else {
-		hdr->CreditRequest = cpu_to_le16(2);
+		shdr->CreditRequest = cpu_to_le16(2);
 	}
-	hdr->ProcessId = cpu_to_le32((__u16)current->tgid);
+	shdr->ProcessId = cpu_to_le32((__u16)current->tgid);
 
 	if (!tcon)
 		goto out;
@@ -124,13 +125,13 @@ smb2_hdr_assemble(struct smb2_hdr *hdr, __le16 smb2_cmd /* command */ ,
 	/* See sections 2.2.4 and 3.2.4.1.5 of MS-SMB2 */
 	if ((tcon->ses) && (tcon->ses->server) &&
 	    (tcon->ses->server->capabilities & SMB2_GLOBAL_CAP_LARGE_MTU))
-		hdr->CreditCharge = cpu_to_le16(1);
+		shdr->CreditCharge = cpu_to_le16(1);
 	/* else CreditCharge MBZ */
 
-	hdr->TreeId = tcon->tid;
+	shdr->TreeId = tcon->tid;
 	/* Uid is not converted */
 	if (tcon->ses)
-		hdr->SessionId = tcon->ses->Suid;
+		shdr->SessionId = tcon->ses->Suid;
 
 	/*
 	 * If we would set SMB2_FLAGS_DFS_OPERATIONS on open we also would have
@@ -143,10 +144,10 @@ smb2_hdr_assemble(struct smb2_hdr *hdr, __le16 smb2_cmd /* command */ ,
 	 * but it is safer to net set it for now.
 	 */
 /*	if (tcon->share_flags & SHI1005_FLAGS_DFS)
-		hdr->Flags |= SMB2_FLAGS_DFS_OPERATIONS; */
+		shdr->Flags |= SMB2_FLAGS_DFS_OPERATIONS; */
 
 	if (tcon->ses && tcon->ses->server && tcon->ses->server->sign)
-		hdr->Flags |= SMB2_FLAGS_SIGNED;
+		shdr->Flags |= SMB2_FLAGS_SIGNED;
 out:
 	pdu->StructureSize2 = cpu_to_le16(parmsize);
 	return;
@@ -416,7 +417,7 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 	if (rc)
 		return rc;
 
-	req->hdr.SessionId = 0;
+	req->hdr.sync_hdr.SessionId = 0;
 
 	req->Dialects[0] = cpu_to_le16(ses->server->vals->protocol_id);
 
@@ -627,14 +628,15 @@ SMB2_sess_alloc_buffer(struct SMB2_sess_data *sess_data)
 	if (rc)
 		return rc;
 
-	req->hdr.SessionId = 0; /* First session, not a reauthenticate */
+	/* First session, not a reauthenticate */
+	req->hdr.sync_hdr.SessionId = 0;
 
 	/* if reconnect, we need to send previous sess id, otherwise it is 0 */
 	req->PreviousSessionId = sess_data->previous_session;
 
 	req->Flags = 0; /* MBZ */
 	/* to enable echos and oplocks */
-	req->hdr.CreditRequest = cpu_to_le16(3);
+	req->hdr.sync_hdr.CreditRequest = cpu_to_le16(3);
 
 	/* only one of SMB2 signing flags may be set in SMB2 request */
 	if (server->sign)
@@ -781,7 +783,7 @@ SMB2_auth_kerberos(struct SMB2_sess_data *sess_data)
 		goto out_put_spnego_key;
 
 	rsp = (struct smb2_sess_setup_rsp *)sess_data->iov[0].iov_base;
-	ses->Suid = rsp->hdr.SessionId;
+	ses->Suid = rsp->hdr.sync_hdr.SessionId;
 
 	ses->session_flags = le16_to_cpu(rsp->SessionFlags);
 	if (ses->session_flags & SMB2_SESSION_FLAG_ENCRYPT_DATA)
@@ -859,7 +861,7 @@ SMB2_sess_auth_rawntlmssp_negotiate(struct SMB2_sess_data *sess_data)
 
 	/* If true, rc here is expected and not an error */
 	if (sess_data->buf0_type != CIFS_NO_BUFFER &&
-		rsp->hdr.Status == STATUS_MORE_PROCESSING_REQUIRED)
+		rsp->hdr.sync_hdr.Status == STATUS_MORE_PROCESSING_REQUIRED)
 		rc = 0;
 
 	if (rc)
@@ -880,7 +882,7 @@ SMB2_sess_auth_rawntlmssp_negotiate(struct SMB2_sess_data *sess_data)
 	cifs_dbg(FYI, "rawntlmssp session setup challenge phase\n");
 
 
-	ses->Suid = rsp->hdr.SessionId;
+	ses->Suid = rsp->hdr.sync_hdr.SessionId;
 	ses->session_flags = le16_to_cpu(rsp->SessionFlags);
 	if (ses->session_flags & SMB2_SESSION_FLAG_ENCRYPT_DATA)
 		cifs_dbg(VFS, "SMB3 encryption not supported yet\n");
@@ -916,7 +918,7 @@ SMB2_sess_auth_rawntlmssp_authenticate(struct SMB2_sess_data *sess_data)
 		goto out;
 
 	req = (struct smb2_sess_setup_req *) sess_data->iov[0].iov_base;
-	req->hdr.SessionId = ses->Suid;
+	req->hdr.sync_hdr.SessionId = ses->Suid;
 
 	rc = build_ntlmssp_auth_blob(&ntlmssp_blob, &blob_length, ses,
 					sess_data->nls_cp);
@@ -940,7 +942,7 @@ SMB2_sess_auth_rawntlmssp_authenticate(struct SMB2_sess_data *sess_data)
 
 	rsp = (struct smb2_sess_setup_rsp *)sess_data->iov[0].iov_base;
 
-	ses->Suid = rsp->hdr.SessionId;
+	ses->Suid = rsp->hdr.sync_hdr.SessionId;
 	ses->session_flags = le16_to_cpu(rsp->SessionFlags);
 	if (ses->session_flags & SMB2_SESSION_FLAG_ENCRYPT_DATA)
 		cifs_dbg(VFS, "SMB3 encryption not supported yet\n");
@@ -1035,9 +1037,9 @@ SMB2_logoff(const unsigned int xid, struct cifs_ses *ses)
 		return rc;
 
 	 /* since no tcon, smb2_init can not do this, so do here */
-	req->hdr.SessionId = ses->Suid;
+	req->hdr.sync_hdr.SessionId = ses->Suid;
 	if (server->sign)
-		req->hdr.Flags |= SMB2_FLAGS_SIGNED;
+		req->hdr.sync_hdr.Flags |= SMB2_FLAGS_SIGNED;
 
 	rc = SendReceiveNoRsp(xid, ses, (char *) &req->hdr, 0);
 	/*
@@ -1112,7 +1114,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 
 	if (tcon == NULL) {
 		/* since no tcon, smb2_init can not do this, so do here */
-		req->hdr.SessionId = ses->Suid;
+		req->hdr.sync_hdr.SessionId = ses->Suid;
 		/* if (ses->server->sec_mode & SECMODE_SIGN_REQUIRED)
 			req->hdr.Flags |= SMB2_FLAGS_SIGNED; */
 	}
@@ -1142,7 +1144,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 	}
 
 	if (tcon == NULL) {
-		ses->ipc_tid = rsp->hdr.TreeId;
+		ses->ipc_tid = rsp->hdr.sync_hdr.TreeId;
 		goto tcon_exit;
 	}
 
@@ -1165,7 +1167,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 	tcon->maximal_access = le32_to_cpu(rsp->MaximalAccess);
 	tcon->tidStatus = CifsGood;
 	tcon->need_reconnect = false;
-	tcon->tid = rsp->hdr.TreeId;
+	tcon->tid = rsp->hdr.sync_hdr.TreeId;
 	strlcpy(tcon->treeName, tree, sizeof(tcon->treeName));
 
 	if ((rsp->Capabilities & SMB2_SHARE_CAP_DFS) &&
@@ -1182,7 +1184,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 	return rc;
 
 tcon_error_exit:
-	if (rsp->hdr.Status == STATUS_BAD_NETWORK_NAME) {
+	if (rsp->hdr.sync_hdr.Status == STATUS_BAD_NETWORK_NAME) {
 		cifs_dbg(VFS, "BAD_NETWORK_NAME: %s\n", tree);
 		if (tcon)
 			tcon->bad_network_name = true;
@@ -1618,6 +1620,7 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 {
 	struct smb2_ioctl_req *req;
 	struct smb2_ioctl_rsp *rsp;
+	struct smb2_sync_hdr *shdr;
 	struct TCP_Server_Info *server;
 	struct cifs_ses *ses;
 	struct kvec iov[2];
@@ -1742,9 +1745,8 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 		goto ioctl_exit;
 	}
 
-	memcpy(*out_data,
-	       (char *)&rsp->hdr.ProtocolId + le32_to_cpu(rsp->OutputOffset),
-	       *plen);
+	shdr = get_sync_hdr(rsp);
+	memcpy(*out_data, (char *)shdr + le32_to_cpu(rsp->OutputOffset), *plen);
 ioctl_exit:
 	free_rsp_buf(resp_buftype, rsp);
 	return rc;
@@ -1963,11 +1965,11 @@ static void
 smb2_echo_callback(struct mid_q_entry *mid)
 {
 	struct TCP_Server_Info *server = mid->callback_data;
-	struct smb2_echo_rsp *smb2 = (struct smb2_echo_rsp *)mid->resp_buf;
+	struct smb2_echo_rsp *rsp = (struct smb2_echo_rsp *)mid->resp_buf;
 	unsigned int credits_received = 1;
 
 	if (mid->mid_state == MID_RESPONSE_RECEIVED)
-		credits_received = le16_to_cpu(smb2->hdr.CreditRequest);
+		credits_received = le16_to_cpu(rsp->hdr.sync_hdr.CreditRequest);
 
 	mutex_lock(&server->srv_mutex);
 	DeleteMidQEntry(mid);
@@ -2045,7 +2047,7 @@ SMB2_echo(struct TCP_Server_Info *server)
 	if (rc)
 		return rc;
 
-	req->hdr.CreditRequest = cpu_to_le16(1);
+	req->hdr.sync_hdr.CreditRequest = cpu_to_le16(1);
 
 	iov.iov_base = (char *)req;
 	/* 4 for rfc1002 length field */
@@ -2108,6 +2110,7 @@ smb2_new_read_req(struct kvec *iov, struct cifs_io_parms *io_parms,
 {
 	int rc = -EACCES;
 	struct smb2_read_req *req = NULL;
+	struct smb2_sync_hdr *shdr;
 
 	rc = small_smb2_init(SMB2_READ, io_parms->tcon, (void **) &req);
 	if (rc)
@@ -2115,7 +2118,8 @@ smb2_new_read_req(struct kvec *iov, struct cifs_io_parms *io_parms,
 	if (io_parms->tcon->ses->server == NULL)
 		return -ECONNABORTED;
 
-	req->hdr.ProcessId = cpu_to_le32(io_parms->pid);
+	shdr = get_sync_hdr(req);
+	shdr->ProcessId = cpu_to_le32(io_parms->pid);
 
 	req->PersistentFileId = io_parms->persistent_fid;
 	req->VolatileFileId = io_parms->volatile_fid;
@@ -2129,18 +2133,18 @@ smb2_new_read_req(struct kvec *iov, struct cifs_io_parms *io_parms,
 	if (request_type & CHAINED_REQUEST) {
 		if (!(request_type & END_OF_CHAIN)) {
 			/* 4 for rfc1002 length field */
-			req->hdr.NextCommand =
+			shdr->NextCommand =
 				cpu_to_le32(get_rfc1002_length(req) + 4);
 		} else /* END_OF_CHAIN */
-			req->hdr.NextCommand = 0;
+			shdr->NextCommand = 0;
 		if (request_type & RELATED_REQUEST) {
-			req->hdr.Flags |= SMB2_FLAGS_RELATED_OPERATIONS;
+			shdr->Flags |= SMB2_FLAGS_RELATED_OPERATIONS;
 			/*
 			 * Related requests use info from previous read request
 			 * in chain.
 			 */
-			req->hdr.SessionId = 0xFFFFFFFF;
-			req->hdr.TreeId = 0xFFFFFFFF;
+			shdr->SessionId = 0xFFFFFFFF;
+			shdr->TreeId = 0xFFFFFFFF;
 			req->PersistentFileId = 0xFFFFFFFF;
 			req->VolatileFileId = 0xFFFFFFFF;
 		}
@@ -2162,7 +2166,7 @@ smb2_readv_callback(struct mid_q_entry *mid)
 	struct cifs_readdata *rdata = mid->callback_data;
 	struct cifs_tcon *tcon = tlink_tcon(rdata->cfile->tlink);
 	struct TCP_Server_Info *server = tcon->ses->server;
-	struct smb2_hdr *buf = (struct smb2_hdr *)rdata->iov.iov_base;
+	struct smb2_sync_hdr *shdr = get_sync_hdr(rdata->iov.iov_base);
 	unsigned int credits_received = 1;
 	struct smb_rqst rqst = { .rq_iov = &rdata->iov,
 				 .rq_nvec = 1,
@@ -2177,7 +2181,7 @@ smb2_readv_callback(struct mid_q_entry *mid)
 
 	switch (mid->mid_state) {
 	case MID_RESPONSE_RECEIVED:
-		credits_received = le16_to_cpu(buf->CreditRequest);
+		credits_received = le16_to_cpu(shdr->CreditRequest);
 		/* result already set, check signature */
 		if (server->sign) {
 			int rc;
@@ -2221,7 +2225,8 @@ int
 smb2_async_readv(struct cifs_readdata *rdata)
 {
 	int rc, flags = 0;
-	struct smb2_hdr *buf;
+	char *buf;
+	struct smb2_sync_hdr *shdr;
 	struct cifs_io_parms io_parms;
 	struct smb_rqst rqst = { .rq_iov = &rdata->iov,
 				 .rq_nvec = 1 };
@@ -2252,17 +2257,18 @@ smb2_async_readv(struct cifs_readdata *rdata)
 		return rc;
 	}
 
-	buf = (struct smb2_hdr *)rdata->iov.iov_base;
+	buf = rdata->iov.iov_base;
+	shdr = get_sync_hdr(buf);
 	/* 4 for rfc1002 length field */
 	rdata->iov.iov_len = get_rfc1002_length(rdata->iov.iov_base) + 4;
 
 	if (rdata->credits) {
-		buf->CreditCharge = cpu_to_le16(DIV_ROUND_UP(rdata->bytes,
+		shdr->CreditCharge = cpu_to_le16(DIV_ROUND_UP(rdata->bytes,
 						SMB2_MAX_BUFFER_SIZE));
-		buf->CreditRequest = buf->CreditCharge;
+		shdr->CreditRequest = shdr->CreditCharge;
 		spin_lock(&server->req_lock);
 		server->credits += rdata->credits -
-						le16_to_cpu(buf->CreditCharge);
+						le16_to_cpu(shdr->CreditCharge);
 		spin_unlock(&server->req_lock);
 		wake_up(&server->request_q);
 		flags = CIFS_HAS_CREDITS;
@@ -2287,6 +2293,7 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 {
 	int resp_buftype, rc = -EACCES;
 	struct smb2_read_rsp *rsp = NULL;
+	struct smb2_sync_hdr *shdr;
 	struct kvec iov[1];
 
 	*nbytes = 0;
@@ -2298,8 +2305,9 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 			  &resp_buftype, CIFS_LOG_ERROR);
 
 	rsp = (struct smb2_read_rsp *)iov[0].iov_base;
+	shdr = get_sync_hdr(rsp);
 
-	if (rsp->hdr.Status == STATUS_END_OF_FILE) {
+	if (shdr->Status == STATUS_END_OF_FILE) {
 		free_rsp_buf(resp_buftype, iov[0].iov_base);
 		return 0;
 	}
@@ -2319,8 +2327,7 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 	}
 
 	if (*buf) {
-		memcpy(*buf, (char *)&rsp->hdr.ProtocolId + rsp->DataOffset,
-		       *nbytes);
+		memcpy(*buf, (char *)shdr + rsp->DataOffset, *nbytes);
 		free_rsp_buf(resp_buftype, iov[0].iov_base);
 	} else if (resp_buftype != CIFS_NO_BUFFER) {
 		*buf = iov[0].iov_base;
@@ -2348,7 +2355,7 @@ smb2_writev_callback(struct mid_q_entry *mid)
 
 	switch (mid->mid_state) {
 	case MID_RESPONSE_RECEIVED:
-		credits_received = le16_to_cpu(rsp->hdr.CreditRequest);
+		credits_received = le16_to_cpu(rsp->hdr.sync_hdr.CreditRequest);
 		wdata->result = smb2_check_receive(mid, tcon->ses->server, 0);
 		if (wdata->result != 0)
 			break;
@@ -2394,6 +2401,7 @@ smb2_async_writev(struct cifs_writedata *wdata,
 {
 	int rc = -EACCES, flags = 0;
 	struct smb2_write_req *req = NULL;
+	struct smb2_sync_hdr *shdr;
 	struct cifs_tcon *tcon = tlink_tcon(wdata->cfile->tlink);
 	struct TCP_Server_Info *server = tcon->ses->server;
 	struct kvec iov;
@@ -2412,7 +2420,8 @@ smb2_async_writev(struct cifs_writedata *wdata,
 		goto async_writev_out;
 	}
 
-	req->hdr.ProcessId = cpu_to_le32(wdata->cfile->pid);
+	shdr = get_sync_hdr(req);
+	shdr->ProcessId = cpu_to_le32(wdata->cfile->pid);
 
 	req->PersistentFileId = wdata->cfile->fid.persistent_fid;
 	req->VolatileFileId = wdata->cfile->fid.volatile_fid;
@@ -2444,12 +2453,12 @@ smb2_async_writev(struct cifs_writedata *wdata,
 	inc_rfc1001_len(&req->hdr, wdata->bytes - 1 /* Buffer */);
 
 	if (wdata->credits) {
-		req->hdr.CreditCharge = cpu_to_le16(DIV_ROUND_UP(wdata->bytes,
+		shdr->CreditCharge = cpu_to_le16(DIV_ROUND_UP(wdata->bytes,
 						    SMB2_MAX_BUFFER_SIZE));
-		req->hdr.CreditRequest = req->hdr.CreditCharge;
+		shdr->CreditRequest = shdr->CreditCharge;
 		spin_lock(&server->req_lock);
 		server->credits += wdata->credits -
-					le16_to_cpu(req->hdr.CreditCharge);
+						le16_to_cpu(shdr->CreditCharge);
 		spin_unlock(&server->req_lock);
 		wake_up(&server->request_q);
 		flags = CIFS_HAS_CREDITS;
@@ -2495,7 +2504,7 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 	if (io_parms->tcon->ses->server == NULL)
 		return -ECONNABORTED;
 
-	req->hdr.ProcessId = cpu_to_le32(io_parms->pid);
+	req->hdr.sync_hdr.ProcessId = cpu_to_le32(io_parms->pid);
 
 	req->PersistentFileId = io_parms->persistent_fid;
 	req->VolatileFileId = io_parms->volatile_fid;
@@ -2649,7 +2658,8 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 	rsp = (struct smb2_query_directory_rsp *)iov[0].iov_base;
 
 	if (rc) {
-		if (rc == -ENODATA && rsp->hdr.Status == STATUS_NO_MORE_FILES) {
+		if (rc == -ENODATA &&
+		    rsp->hdr.sync_hdr.Status == STATUS_NO_MORE_FILES) {
 			srch_inf->endOfSearch = true;
 			rc = 0;
 		}
@@ -2729,7 +2739,7 @@ send_set_info(const unsigned int xid, struct cifs_tcon *tcon,
 		return rc;
 	}
 
-	req->hdr.ProcessId = cpu_to_le32(pid);
+	req->hdr.sync_hdr.ProcessId = cpu_to_le32(pid);
 
 	req->InfoType = SMB2_O_INFO_FILE;
 	req->FileInfoClass = info_class;
@@ -2895,7 +2905,7 @@ SMB2_oplock_break(const unsigned int xid, struct cifs_tcon *tcon,
 	req->VolatileFid = volatile_fid;
 	req->PersistentFid = persistent_fid;
 	req->OplockLevel = oplock_level;
-	req->hdr.CreditRequest = cpu_to_le16(1);
+	req->hdr.sync_hdr.CreditRequest = cpu_to_le16(1);
 
 	rc = SendReceiveNoRsp(xid, tcon->ses, (char *) req, CIFS_OBREAK_OP);
 	/* SMB2 buffer freed by function above */
@@ -3069,7 +3079,7 @@ smb2_lockv(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc)
 		return rc;
 
-	req->hdr.ProcessId = cpu_to_le32(pid);
+	req->hdr.sync_hdr.ProcessId = cpu_to_le32(pid);
 	req->LockCount = cpu_to_le16(num_lock);
 
 	req->PersistentFileId = persist_fid;
@@ -3124,7 +3134,7 @@ SMB2_lease_break(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc)
 		return rc;
 
-	req->hdr.CreditRequest = cpu_to_le16(1);
+	req->hdr.sync_hdr.CreditRequest = cpu_to_le16(1);
 	req->StructureSize = cpu_to_le16(36);
 	inc_rfc1001_len(req, 12);
 
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index dc0d141..8dd24b7 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -101,10 +101,7 @@
 
 #define SMB2_HEADER_STRUCTURE_SIZE cpu_to_le16(64)
 
-struct smb2_hdr {
-	__be32 smb2_buf_length;	/* big endian on wire */
-				/* length is only two or three bytes - with
-				 one or two byte type preceding it that MBZ */
+struct smb2_sync_hdr {
 	__le32 ProtocolId;	/* 0xFE 'S' 'M' 'B' */
 	__le16 StructureSize;	/* 64 */
 	__le16 CreditCharge;	/* MBZ */
@@ -120,6 +117,13 @@ struct smb2_hdr {
 	__u8   Signature[16];
 } __packed;
 
+struct smb2_hdr {
+	__be32 smb2_buf_length;	/* big endian on wire */
+				/* length is only two or three bytes - with */
+				/* one or two byte type preceding it that MBZ */
+	struct smb2_sync_hdr sync_hdr;
+} __packed;
+
 struct smb2_pdu {
 	struct smb2_hdr hdr;
 	__le16 StructureSize2; /* size of wct area (varies, request specific) */
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index bc9a7b6..52ff937 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -115,13 +115,13 @@ smb3_crypto_shash_allocate(struct TCP_Server_Info *server)
 }
 
 static struct cifs_ses *
-smb2_find_smb_ses(struct smb2_hdr *smb2hdr, struct TCP_Server_Info *server)
+smb2_find_smb_ses(struct smb2_sync_hdr *shdr, struct TCP_Server_Info *server)
 {
 	struct cifs_ses *ses;
 
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
-		if (ses->Suid != smb2hdr->SessionId)
+		if (ses->Suid != shdr->SessionId)
 			continue;
 		spin_unlock(&cifs_tcp_ses_lock);
 		return ses;
@@ -131,7 +131,6 @@ smb2_find_smb_ses(struct smb2_hdr *smb2hdr, struct TCP_Server_Info *server)
 	return NULL;
 }
 
-
 int
 smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 {
@@ -139,17 +138,17 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 	unsigned char smb2_signature[SMB2_HMACSHA256_SIZE];
 	unsigned char *sigptr = smb2_signature;
 	struct kvec *iov = rqst->rq_iov;
-	struct smb2_hdr *smb2_pdu = (struct smb2_hdr *)iov[0].iov_base;
+	struct smb2_sync_hdr *shdr = get_sync_hdr(iov[0].iov_base);
 	struct cifs_ses *ses;
 
-	ses = smb2_find_smb_ses(smb2_pdu, server);
+	ses = smb2_find_smb_ses(shdr, server);
 	if (!ses) {
 		cifs_dbg(VFS, "%s: Could not find session\n", __func__);
 		return 0;
 	}
 
 	memset(smb2_signature, 0x0, SMB2_HMACSHA256_SIZE);
-	memset(smb2_pdu->Signature, 0x0, SMB2_SIGNATURE_SIZE);
+	memset(shdr->Signature, 0x0, SMB2_SIGNATURE_SIZE);
 
 	rc = smb2_crypto_shash_allocate(server);
 	if (rc) {
@@ -174,7 +173,7 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 		&server->secmech.sdeschmacsha256->shash);
 
 	if (!rc)
-		memcpy(smb2_pdu->Signature, sigptr, SMB2_SIGNATURE_SIZE);
+		memcpy(shdr->Signature, sigptr, SMB2_SIGNATURE_SIZE);
 
 	return rc;
 }
@@ -356,17 +355,17 @@ smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 	unsigned char smb3_signature[SMB2_CMACAES_SIZE];
 	unsigned char *sigptr = smb3_signature;
 	struct kvec *iov = rqst->rq_iov;
-	struct smb2_hdr *smb2_pdu = (struct smb2_hdr *)iov[0].iov_base;
+	struct smb2_sync_hdr *shdr = get_sync_hdr(iov[0].iov_base);
 	struct cifs_ses *ses;
 
-	ses = smb2_find_smb_ses(smb2_pdu, server);
+	ses = smb2_find_smb_ses(shdr, server);
 	if (!ses) {
 		cifs_dbg(VFS, "%s: Could not find session\n", __func__);
 		return 0;
 	}
 
 	memset(smb3_signature, 0x0, SMB2_CMACAES_SIZE);
-	memset(smb2_pdu->Signature, 0x0, SMB2_SIGNATURE_SIZE);
+	memset(shdr->Signature, 0x0, SMB2_SIGNATURE_SIZE);
 
 	rc = crypto_shash_setkey(server->secmech.cmacaes,
 		ses->smb3signingkey, SMB2_CMACAES_SIZE);
@@ -391,7 +390,7 @@ smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 				   &server->secmech.sdesccmacaes->shash);
 
 	if (!rc)
-		memcpy(smb2_pdu->Signature, sigptr, SMB2_SIGNATURE_SIZE);
+		memcpy(shdr->Signature, sigptr, SMB2_SIGNATURE_SIZE);
 
 	return rc;
 }
@@ -401,14 +400,14 @@ static int
 smb2_sign_rqst(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 {
 	int rc = 0;
-	struct smb2_hdr *smb2_pdu = rqst->rq_iov[0].iov_base;
+	struct smb2_sync_hdr *shdr = get_sync_hdr(rqst->rq_iov[0].iov_base);
 
-	if (!(smb2_pdu->Flags & SMB2_FLAGS_SIGNED) ||
+	if (!(shdr->Flags & SMB2_FLAGS_SIGNED) ||
 	    server->tcpStatus == CifsNeedNegotiate)
 		return rc;
 
 	if (!server->session_estab) {
-		strncpy(smb2_pdu->Signature, "BSRSPYL", 8);
+		strncpy(shdr->Signature, "BSRSPYL", 8);
 		return rc;
 	}
 
@@ -422,11 +421,11 @@ smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 {
 	unsigned int rc;
 	char server_response_sig[16];
-	struct smb2_hdr *smb2_pdu = (struct smb2_hdr *)rqst->rq_iov[0].iov_base;
+	struct smb2_sync_hdr *shdr = get_sync_hdr(rqst->rq_iov[0].iov_base);
 
-	if ((smb2_pdu->Command == SMB2_NEGOTIATE) ||
-	    (smb2_pdu->Command == SMB2_SESSION_SETUP) ||
-	    (smb2_pdu->Command == SMB2_OPLOCK_BREAK) ||
+	if ((shdr->Command == SMB2_NEGOTIATE) ||
+	    (shdr->Command == SMB2_SESSION_SETUP) ||
+	    (shdr->Command == SMB2_OPLOCK_BREAK) ||
 	    (!server->session_estab))
 		return 0;
 
@@ -436,17 +435,17 @@ smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 	 */
 
 	/* Do not need to verify session setups with signature "BSRSPYL " */
-	if (memcmp(smb2_pdu->Signature, "BSRSPYL ", 8) == 0)
+	if (memcmp(shdr->Signature, "BSRSPYL ", 8) == 0)
 		cifs_dbg(FYI, "dummy signature received for smb command 0x%x\n",
-			 smb2_pdu->Command);
+			 shdr->Command);
 
 	/*
 	 * Save off the origiginal signature so we can modify the smb and check
 	 * our calculated signature against what the server sent.
 	 */
-	memcpy(server_response_sig, smb2_pdu->Signature, SMB2_SIGNATURE_SIZE);
+	memcpy(server_response_sig, shdr->Signature, SMB2_SIGNATURE_SIZE);
 
-	memset(smb2_pdu->Signature, 0, SMB2_SIGNATURE_SIZE);
+	memset(shdr->Signature, 0, SMB2_SIGNATURE_SIZE);
 
 	mutex_lock(&server->srv_mutex);
 	rc = server->ops->calc_signature(rqst, server);
@@ -455,8 +454,7 @@ smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 	if (rc)
 		return rc;
 
-	if (memcmp(server_response_sig, smb2_pdu->Signature,
-		   SMB2_SIGNATURE_SIZE))
+	if (memcmp(server_response_sig, shdr->Signature, SMB2_SIGNATURE_SIZE))
 		return -EACCES;
 	else
 		return 0;
@@ -467,18 +465,19 @@ smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
  * and when srv_mutex is held.
  */
 static inline void
-smb2_seq_num_into_buf(struct TCP_Server_Info *server, struct smb2_hdr *hdr)
+smb2_seq_num_into_buf(struct TCP_Server_Info *server,
+		      struct smb2_sync_hdr *shdr)
 {
-	unsigned int i, num = le16_to_cpu(hdr->CreditCharge);
+	unsigned int i, num = le16_to_cpu(shdr->CreditCharge);
 
-	hdr->MessageId = get_next_mid64(server);
+	shdr->MessageId = get_next_mid64(server);
 	/* skip message numbers according to CreditCharge field */
 	for (i = 1; i < num; i++)
 		get_next_mid(server);
 }
 
 static struct mid_q_entry *
-smb2_mid_entry_alloc(const struct smb2_hdr *smb_buffer,
+smb2_mid_entry_alloc(const struct smb2_sync_hdr *shdr,
 		     struct TCP_Server_Info *server)
 {
 	struct mid_q_entry *temp;
@@ -493,9 +492,9 @@ smb2_mid_entry_alloc(const struct smb2_hdr *smb_buffer,
 		return temp;
 	else {
 		memset(temp, 0, sizeof(struct mid_q_entry));
-		temp->mid = le64_to_cpu(smb_buffer->MessageId);
+		temp->mid = le64_to_cpu(shdr->MessageId);
 		temp->pid = current->pid;
-		temp->command = smb_buffer->Command;	/* Always LE */
+		temp->command = shdr->Command; /* Always LE */
 		temp->when_alloc = jiffies;
 		temp->server = server;
 
@@ -513,7 +512,7 @@ smb2_mid_entry_alloc(const struct smb2_hdr *smb_buffer,
 }
 
 static int
-smb2_get_mid_entry(struct cifs_ses *ses, struct smb2_hdr *buf,
+smb2_get_mid_entry(struct cifs_ses *ses, struct smb2_sync_hdr *shdr,
 		   struct mid_q_entry **mid)
 {
 	if (ses->server->tcpStatus == CifsExiting)
@@ -525,19 +524,19 @@ smb2_get_mid_entry(struct cifs_ses *ses, struct smb2_hdr *buf,
 	}
 
 	if (ses->status == CifsNew) {
-		if ((buf->Command != SMB2_SESSION_SETUP) &&
-		    (buf->Command != SMB2_NEGOTIATE))
+		if ((shdr->Command != SMB2_SESSION_SETUP) &&
+		    (shdr->Command != SMB2_NEGOTIATE))
 			return -EAGAIN;
 		/* else ok - we are setting up session */
 	}
 
 	if (ses->status == CifsExiting) {
-		if (buf->Command != SMB2_LOGOFF)
+		if (shdr->Command != SMB2_LOGOFF)
 			return -EAGAIN;
 		/* else ok - we are shutting down the session */
 	}
 
-	*mid = smb2_mid_entry_alloc(buf, ses->server);
+	*mid = smb2_mid_entry_alloc(shdr, ses->server);
 	if (*mid == NULL)
 		return -ENOMEM;
 	spin_lock(&GlobalMid_Lock);
@@ -576,12 +575,12 @@ struct mid_q_entry *
 smb2_setup_request(struct cifs_ses *ses, struct smb_rqst *rqst)
 {
 	int rc;
-	struct smb2_hdr *hdr = (struct smb2_hdr *)rqst->rq_iov[0].iov_base;
+	struct smb2_sync_hdr *shdr = get_sync_hdr(rqst->rq_iov[0].iov_base);
 	struct mid_q_entry *mid;
 
-	smb2_seq_num_into_buf(ses->server, hdr);
+	smb2_seq_num_into_buf(ses->server, shdr);
 
-	rc = smb2_get_mid_entry(ses, hdr, &mid);
+	rc = smb2_get_mid_entry(ses, shdr, &mid);
 	if (rc)
 		return ERR_PTR(rc);
 	rc = smb2_sign_rqst(rqst, ses->server);
@@ -596,12 +595,12 @@ struct mid_q_entry *
 smb2_setup_async_request(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 {
 	int rc;
-	struct smb2_hdr *hdr = (struct smb2_hdr *)rqst->rq_iov[0].iov_base;
+	struct smb2_sync_hdr *shdr = get_sync_hdr(rqst->rq_iov[0].iov_base);
 	struct mid_q_entry *mid;
 
-	smb2_seq_num_into_buf(server, hdr);
+	smb2_seq_num_into_buf(server, shdr);
 
-	mid = smb2_mid_entry_alloc(hdr, server);
+	mid = smb2_mid_entry_alloc(shdr, server);
 	if (mid == NULL)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.7.4
