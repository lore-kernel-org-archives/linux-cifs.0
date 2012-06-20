From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2 09/24] CIFS: Add capability to send SMB2 negotiate message
Date: Wed, 20 Jun 2012 18:30:49 +0400
Message-ID: <1340202664-28696-10-git-send-email-pshilovsky@samba.org>
References: <1340202664-28696-1-git-send-email-pshilovsky@samba.org>
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340202664-28696-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>

and add negotiate request type to let set_credits know that
we are only on negotiate stage and no need to make a decision
about disabling echos and oplocks.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/Makefile    |    3 +-
 fs/cifs/cifsglob.h  |    7 +-
 fs/cifs/smb2misc.c  |    7 +-
 fs/cifs/smb2ops.c   |   22 ++++-
 fs/cifs/smb2pdu.c   |  330 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.h   |   39 ++++++
 fs/cifs/smb2proto.h |    7 +
 7 files changed, 411 insertions(+), 4 deletions(-)
 create mode 100644 fs/cifs/smb2pdu.c

diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
index b77e9ec..daf6837 100644
--- a/fs/cifs/Makefile
+++ b/fs/cifs/Makefile
@@ -16,4 +16,5 @@ cifs-$(CONFIG_CIFS_DFS_UPCALL) += dns_resolve.o cifs_dfs_ref.o
 
 cifs-$(CONFIG_CIFS_FSCACHE) += fscache.o cache.o
 
-cifs-$(CONFIG_CIFS_SMB2) += smb2ops.o smb2maperror.o smb2transport.o smb2misc.o
+cifs-$(CONFIG_CIFS_SMB2) += smb2ops.o smb2maperror.o smb2transport.o \
+			    smb2misc.o smb2pdu.o
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index d94d3ee..414cbbc 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -393,6 +393,10 @@ struct TCP_Server_Info {
 	atomic_t in_send; /* requests trying to send */
 	atomic_t num_waiters;   /* blocked waiting to get in sendrecv */
 #endif
+#ifdef CONFIG_CIFS_SMB2
+	unsigned int	max_read;
+	unsigned int	max_write;
+#endif /* CONFIG_CIFS_SMB2 */
 };
 
 static inline unsigned int
@@ -986,7 +990,8 @@ static inline void free_dfs_info_array(struct dfs_info3_param *param,
 /* Type of request operation */
 #define   CIFS_ECHO_OP      0x080    /* echo request */
 #define   CIFS_OBREAK_OP   0x0100    /* oplock break request */
-#define   CIFS_OP_MASK     0x0180    /* mask request type */
+#define   CIFS_NEG_OP      0x0200    /* negotiate request */
+#define   CIFS_OP_MASK     0x0380    /* mask request type */
 
 /* Security Flags: indicate type of session setup needed */
 #define   CIFSSEC_MAY_SIGN	0x00001
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 03167eb..1cea426 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -198,7 +198,7 @@ static const bool has_smb2_data_area[NUMBER_OF_SMB2_COMMANDS] = {
  * Returns the pointer to the beginning of the data area. Length of the data
  * area and the offset to it (from the beginning of the smb are also returned.
  */
-static char *
+char *
 smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *hdr)
 {
 	*off = 0;
@@ -217,6 +217,11 @@ smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *hdr)
 	 */
 	switch (hdr->Command) {
 	case SMB2_NEGOTIATE:
+		*off = le16_to_cpu(
+		    ((struct smb2_negotiate_rsp *)hdr)->SecurityBufferOffset);
+		*len = le16_to_cpu(
+		    ((struct smb2_negotiate_rsp *)hdr)->SecurityBufferLength);
+		break;
 	case SMB2_SESSION_SETUP:
 	case SMB2_CREATE:
 	case SMB2_READ:
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 88cbfce..e542685 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -61,7 +61,7 @@ smb2_add_credits(struct TCP_Server_Info *server, const unsigned int add,
 	val = server->ops->get_credits_field(server, optype);
 	*val += add;
 	server->in_flight--;
-	if (server->in_flight == 0)
+	if (server->in_flight == 0 && (optype & CIFS_OP_MASK) != CIFS_NEG_OP)
 		change_conf(server);
 	spin_unlock(&server->req_lock);
 	wake_up(&server->request_q);
@@ -137,6 +137,24 @@ smb2_dump_detail(void *buf)
 #endif
 }
 
+static bool
+smb2_need_neg(struct TCP_Server_Info *server)
+{
+	return server->max_read == 0;
+}
+
+static int
+smb2_negotiate(const unsigned int xid, struct cifs_ses *ses)
+{
+	int rc;
+	ses->server->CurrentMid = 0;
+	rc = SMB2_negotiate(xid, ses);
+	/* BB we probably don't need to retry with modern servers */
+	if (rc == -EAGAIN)
+		rc = -EHOSTDOWN;
+	return rc;
+}
+
 struct smb_version_operations smb21_operations = {
 	.setup_request = smb2_setup_request,
 	.check_receive = smb2_check_receive,
@@ -148,6 +166,8 @@ struct smb_version_operations smb21_operations = {
 	.find_mid = smb2_find_mid,
 	.check_message = smb2_check_message,
 	.dump_detail = smb2_dump_detail,
+	.need_neg = smb2_need_neg,
+	.negotiate = smb2_negotiate,
 };
 
 struct smb_version_values smb21_values = {
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
new file mode 100644
index 0000000..22a7448
--- /dev/null
+++ b/fs/cifs/smb2pdu.c
@@ -0,0 +1,330 @@
+/*
+ *   fs/cifs/smb2pdu.c
+ *
+ *   Copyright (C) International Business Machines  Corp., 2009, 2011
+ *                 Etersoft, 2012
+ *   Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
+ *              Pavel Shilovsky (pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org) 2012
+ *
+ *   Contains the routines for constructing the SMB2 PDUs themselves
+ *
+ *   This library is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU Lesser General Public License as published
+ *   by the Free Software Foundation; either version 2.1 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This library is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ *   the GNU Lesser General Public License for more details.
+ *
+ *   You should have received a copy of the GNU Lesser General Public License
+ *   along with this library; if not, write to the Free Software
+ *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+
+ /* SMB2 PDU handling routines here - except for leftovers (eg session setup) */
+ /* Note that there are handle based routines which must be		      */
+ /* treated slightly differently for reconnection purposes since we never     */
+ /* want to reuse a stale file handle and only the caller knows the file info */
+
+#include <linux/fs.h>
+#include <linux/kernel.h>
+#include <linux/vfs.h>
+#include <linux/uaccess.h>
+#include <linux/xattr.h>
+#include "smb2pdu.h"
+#include "cifsglob.h"
+#include "cifsacl.h"
+#include "cifsproto.h"
+#include "smb2proto.h"
+#include "cifs_unicode.h"
+#include "cifs_debug.h"
+#include "ntlmssp.h"
+#include "smb2status.h"
+
+/*
+ *  The following table defines the expected "StructureSize" of SMB2 requests
+ *  in order by SMB2 command.  This is similar to "wct" in SMB/CIFS requests.
+ *
+ *  Note that commands are defined in smb2pdu.h in le16 but the array below is
+ *  indexed by command in host byte order.
+ */
+static const int smb2_req_struct_sizes[NUMBER_OF_SMB2_COMMANDS] = {
+	/* SMB2_NEGOTIATE */ 36,
+	/* SMB2_SESSION_SETUP */ 25,
+	/* SMB2_LOGOFF */ 4,
+	/* SMB2_TREE_CONNECT */	9,
+	/* SMB2_TREE_DISCONNECT */ 4,
+	/* SMB2_CREATE */ 57,
+	/* SMB2_CLOSE */ 24,
+	/* SMB2_FLUSH */ 24,
+	/* SMB2_READ */	49,
+	/* SMB2_WRITE */ 49,
+	/* SMB2_LOCK */	48,
+	/* SMB2_IOCTL */ 57,
+	/* SMB2_CANCEL */ 4,
+	/* SMB2_ECHO */ 4,
+	/* SMB2_QUERY_DIRECTORY */ 33,
+	/* SMB2_CHANGE_NOTIFY */ 32,
+	/* SMB2_QUERY_INFO */ 41,
+	/* SMB2_SET_INFO */ 33,
+	/* SMB2_OPLOCK_BREAK */  24 /* BB this is 36 for LEASE_BREAK variant */
+};
+
+
+static void
+smb2_hdr_assemble(struct smb2_hdr *hdr, __le16 smb2_cmd /* command */ ,
+		  const struct cifs_tcon *tcon)
+{
+	struct smb2_pdu *pdu = (struct smb2_pdu *)hdr;
+	char *temp = (char *)hdr;
+	/* lookup word count ie StructureSize from table */
+	__u16 parmsize = smb2_req_struct_sizes[le16_to_cpu(smb2_cmd)];
+
+	/*
+	 * smaller than SMALL_BUFFER_SIZE but bigger than fixed area of
+	 * largest operations (Create)
+	 */
+	memset(temp, 0, 256);
+
+	/* Note this is only network field converted to big endian */
+	hdr->smb2_buf_length = cpu_to_be32(parmsize + sizeof(struct smb2_hdr)
+			- 4 /*  RFC 1001 length field itself not counted */);
+
+	hdr->ProtocolId[0] = 0xFE;
+	hdr->ProtocolId[1] = 'S';
+	hdr->ProtocolId[2] = 'M';
+	hdr->ProtocolId[3] = 'B';
+	hdr->StructureSize = cpu_to_le16(64);
+	hdr->Command = smb2_cmd;
+	hdr->CreditRequest = cpu_to_le16(2); /* BB make this dynamic */
+	hdr->ProcessId = cpu_to_le32((__u16)current->tgid);
+
+	if (!tcon)
+		goto out;
+
+	hdr->TreeId = tcon->tid;
+	/* Uid is not converted */
+	if (tcon->ses)
+		hdr->SessionId = tcon->ses->Suid;
+	/* BB check following DFS flags BB */
+	/* BB do we have to add check for SHI1005_FLAGS_DFS_ROOT too? */
+	/* if (tcon->share_flags & SHI1005_FLAGS_DFS)
+		hdr->Flags |= SMB2_FLAGS_DFS_OPERATIONS; */
+	/* BB how does SMB2 do case sensitive? */
+	/* if (tcon->nocase)
+		hdr->Flags |= SMBFLG_CASELESS; */
+	/* if (tcon->ses && tcon->ses->server &&
+	    (tcon->ses->server->sec_mode & SECMODE_SIGN_REQUIRED))
+		hdr->Flags |= SMB2_FLAGS_SIGNED; */
+out:
+	pdu->StructureSize2 = cpu_to_le16(parmsize);
+	return;
+}
+
+static int
+smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon)
+{
+	int rc = 0;
+	/* BB add missing code here */
+	return rc;
+}
+
+/*
+ * Allocate and return pointer to an SMB request hdr, and set basic
+ * SMB information in the SMB header. If the return code is zero, this
+ * function must have filled in request_buf pointer.
+ */
+static int
+small_smb2_init(__le16 smb2_command, struct cifs_tcon *tcon,
+		void **request_buf)
+{
+	int rc = 0;
+
+	rc = smb2_reconnect(smb2_command, tcon);
+	if (rc)
+		return rc;
+
+	/* BB eventually switch this to SMB2 specific small buf size */
+	*request_buf = cifs_small_buf_get();
+	if (*request_buf == NULL) {
+		/* BB should we add a retry in here if not a writepage? */
+		return -ENOMEM;
+	}
+
+	smb2_hdr_assemble((struct smb2_hdr *) *request_buf, smb2_command, tcon);
+
+	if (tcon != NULL) {
+#ifdef CONFIG_CIFS_STATS2
+		/*
+		uint16_t com_code = le16_to_cpu(smb2_command);
+		cifs_stats_inc(&tcon->stats.smb2_stats.smb2_com_sent[com_code]);
+		*/
+#endif
+		cifs_stats_inc(&tcon->num_smbs_sent);
+	}
+
+	return rc;
+}
+
+static void
+free_rsp_buf(int resp_buftype, void *rsp)
+{
+	if (resp_buftype == CIFS_SMALL_BUFFER)
+		cifs_small_buf_release(rsp);
+	else if (resp_buftype == CIFS_LARGE_BUFFER)
+		cifs_buf_release(rsp);
+}
+
+#define SMB2_NUM_PROT 1
+
+#define SMB2_PROT   0
+#define SMB21_PROT  1
+#define BAD_PROT 0xFFFF
+
+#define SMB2_PROT_ID  0x0202
+#define SMB21_PROT_ID 0x0210
+#define BAD_PROT_ID   0xFFFF
+
+static struct {
+	int index;
+	__le16 name;
+} smb2protocols[] = {
+	{SMB2_PROT,  cpu_to_le16(SMB2_PROT_ID)},
+	{SMB21_PROT, cpu_to_le16(SMB21_PROT_ID)},
+	{BAD_PROT,   cpu_to_le16(BAD_PROT_ID)}
+};
+
+/*
+ *
+ *	SMB2 Worker functions follow:
+ *
+ *	The general structure of the worker functions is:
+ *	1) Call smb2_init (assembles SMB2 header)
+ *	2) Initialize SMB2 command specific fields in fixed length area of SMB
+ *	3) Call smb_sendrcv2 (sends request on socket and waits for response)
+ *	4) Decode SMB2 command specific fields in the fixed length area
+ *	5) Decode variable length data area (if any for this SMB2 command type)
+ *	6) Call free smb buffer
+ *	7) return
+ *
+ */
+
+int
+SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
+{
+	struct smb2_negotiate_req *req;
+	struct smb2_negotiate_rsp *rsp;
+	struct kvec iov[1];
+	int rc = 0;
+	int resp_buftype;
+	struct TCP_Server_Info *server;
+	unsigned int sec_flags;
+	u16 i;
+	u16 temp = 0;
+	int blob_offset, blob_length;
+	char *security_blob;
+	int flags = CIFS_NEG_OP;
+
+	cFYI(1, "Negotiate protocol");
+
+	if (ses->server)
+		server = ses->server;
+	else {
+		rc = -EIO;
+		return rc;
+	}
+
+	rc = small_smb2_init(SMB2_NEGOTIATE, NULL, (void **) &req);
+	if (rc)
+		return rc;
+
+	/* if any of auth flags (ie not sign or seal) are overriden use them */
+	if (ses->overrideSecFlg & (~(CIFSSEC_MUST_SIGN | CIFSSEC_MUST_SEAL)))
+		sec_flags = ses->overrideSecFlg;  /* BB FIXME fix sign flags?*/
+	else /* if override flags set only sign/seal OR them with global auth */
+		sec_flags = global_secflags | ses->overrideSecFlg;
+
+	cFYI(1, "sec_flags 0x%x", sec_flags);
+
+	req->hdr.SessionId = 0;
+
+	for (i = 0; i < SMB2_NUM_PROT; i++)
+		req->Dialects[i] = smb2protocols[i].name;
+
+	req->DialectCount = cpu_to_le16(i);
+	req->hdr.smb2_buf_length =
+		cpu_to_be32(be32_to_cpu(req->hdr.smb2_buf_length) + (i * 2));
+
+	/* only one of SMB2 signing flags may be set in SMB2 request */
+	if ((sec_flags & CIFSSEC_MUST_SIGN) == CIFSSEC_MUST_SIGN)
+		temp = SMB2_NEGOTIATE_SIGNING_REQUIRED;
+	else if (sec_flags & CIFSSEC_MAY_SIGN) /* MAY_SIGN is a single flag */
+		temp = SMB2_NEGOTIATE_SIGNING_ENABLED;
+
+	req->SecurityMode = cpu_to_le16(temp);
+
+	req->Capabilities = cpu_to_le32(SMB2_GLOBAL_CAP_DFS);
+
+	iov[0].iov_base = (char *)req;
+	iov[0].iov_len = be32_to_cpu(req->hdr.smb2_buf_length) + 4;
+
+	rc = SendReceive2(xid, ses, iov, 1, &resp_buftype, flags);
+
+	rsp = (struct smb2_negotiate_rsp *)iov[0].iov_base;
+	/*
+	 * No tcon so can't do
+	 * cifs_stats_inc(&tcon->stats.smb2_stats.smb2_com_fail[SMB2...]);
+	 */
+	if (rc != 0)
+		goto neg_exit;
+
+	if (rsp == NULL) {
+		rc = -EIO;
+		goto neg_exit;
+	}
+
+	cFYI(1, "mode 0x%x", rsp->SecurityMode);
+
+	if (rsp->DialectRevision == smb2protocols[SMB21_PROT].name)
+		cFYI(1, "negotiated smb2.1 dialect");
+	else if (rsp->DialectRevision == smb2protocols[SMB2_PROT].name)
+		cFYI(1, "negotiated smb2 dialect");
+	else {
+		cERROR(1, "Illegal dialect returned by server %d",
+			   le16_to_cpu(rsp->DialectRevision));
+		rc = -EIO;
+		goto neg_exit;
+	}
+	ses->server->dialect = le16_to_cpu(rsp->DialectRevision);
+
+	ses->server->maxBuf = le32_to_cpu(rsp->MaxTransactSize);
+	ses->server->max_read = le32_to_cpu(rsp->MaxReadSize);
+	ses->server->max_write = le32_to_cpu(rsp->MaxWriteSize);
+	/* BB Do we need to validate the SecurityMode? */
+	ses->server->sec_mode = le16_to_cpu(rsp->SecurityMode);
+	ses->server->capabilities = le32_to_cpu(rsp->Capabilities);
+
+	security_blob = smb2_get_data_area_len(&blob_offset, &blob_length,
+					       &rsp->hdr);
+	if (blob_length == 0) {
+		cERROR(1, "missing security blob on negprot");
+		rc = -EIO;
+		goto neg_exit;
+	}
+#ifdef CONFIG_SMB2_ASN1  /* BB REMOVEME when updated asn1.c ready */
+	rc = decode_neg_token_init(security_blob, blob_length,
+				   &ses->server->sec_type);
+	if (rc == 1)
+		rc = 0;
+	else if (rc == 0) {
+		rc = -EIO;
+		goto neg_exit;
+	}
+#endif
+
+neg_exit:
+	free_rsp_buf(resp_buftype, rsp);
+	return rc;
+}
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index efb0d98..449973c 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -142,4 +142,43 @@ struct smb2_err_rsp {
 	__u8   ErrorData[1];  /* variable length */
 } __packed;
 
+struct smb2_negotiate_req {
+	struct smb2_hdr hdr;
+	__le16 StructureSize; /* Must be 36 */
+	__le16 DialectCount;
+	__le16 SecurityMode;
+	__le16 Reserved;	/* MBZ */
+	__le32 Capabilities;
+	__u8   ClientGUID[16];	/* MBZ */
+	__le64 ClientStartTime;	/* MBZ */
+	__le16 Dialects[2]; /* variable length */ /* Must include 0x0202 */
+} __packed;
+
+/* SecurityMode flags */
+#define	SMB2_NEGOTIATE_SIGNING_ENABLED	0x0001
+#define SMB2_NEGOTIATE_SIGNING_REQUIRED	0x0002
+/* Capabilities flags */
+#define SMB2_GLOBAL_CAP_DFS		0x00000001
+#define SMB2_GLOBAL_CAP_LEASING		0x00000002 /* Resp only New to SMB2.1 */
+#define SMB2_GLOBAL_CAP_LARGE_MTU	0X00000004 /* Resp only New to SMB2.1 */
+
+struct smb2_negotiate_rsp {
+	struct smb2_hdr hdr;
+	__le16 StructureSize;	/* Must be 65 */
+	__le16 SecurityMode;
+	__le16 DialectRevision; /* Should be 0x0202 */
+	__le16 Reserved;	/* MBZ */
+	__u8   ServerGUID[16];
+	__le32 Capabilities;
+	__le32 MaxTransactSize;
+	__le32 MaxReadSize;
+	__le32 MaxWriteSize;
+	__le64 SystemTime;	/* MBZ */
+	__le64 ServerStartTime;
+	__le16 SecurityBufferOffset;
+	__le16 SecurityBufferLength;
+	__le32 Reserved2;	/* may be any value, Ignore */
+	__u8   Buffer[1];	/* variable length GSS security buffer */
+} __packed;
+
 #endif				/* _SMB2PDU_H */
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 19bf987..fead10c 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -35,10 +35,17 @@ struct statfs;
 extern int map_smb2_to_linux_error(char *buf, bool log_err);
 extern int smb2_check_message(char *buf, unsigned int length);
 extern unsigned int smb2_calc_size(struct smb2_hdr *hdr);
+extern char *smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *hdr);
 
 extern int smb2_check_receive(struct mid_q_entry *mid,
 			      struct TCP_Server_Info *server, bool log_error);
 extern int smb2_setup_request(struct cifs_ses *ses, struct kvec *iov,
 			      unsigned int nvec, struct mid_q_entry **ret_mid);
 
+/*
+ *  SMB2 Worker functions - most of protocol specific implementation details
+ *  are contained within these calls.
+ */
+extern int SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses);
+
 #endif			/* _SMB2PROTO_H */
-- 
1.7.1
