From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 08/16] CIFS: Make demultiplex_thread work with SMB2 code
Date: Mon, 26 Mar 2012 13:21:35 +0400
Message-ID: <1332753703-4315-9-git-send-email-piastry@etersoft.ru>
References: <1332753703-4315-1-git-send-email-piastry@etersoft.ru>
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1332753703-4315-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Now we can process SMB2 messages: check message, get message id
and wakeup awaiting routines.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/Makefile     |    2 +-
 fs/cifs/cifs_debug.c |   27 +++++-
 fs/cifs/cifs_debug.h |    1 +
 fs/cifs/cifsglob.h   |   12 ++-
 fs/cifs/cifsproto.h  |    2 +
 fs/cifs/cifssmb.c    |    7 +-
 fs/cifs/connect.c    |   68 +++++++++--
 fs/cifs/misc.c       |   19 +++
 fs/cifs/smb2misc.c   |  304 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.h    |   30 +++++
 fs/cifs/smb2proto.h  |    2 +
 11 files changed, 455 insertions(+), 19 deletions(-)
 create mode 100644 fs/cifs/smb2misc.c

diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
index e094f8a..5bbafe4 100644
--- a/fs/cifs/Makefile
+++ b/fs/cifs/Makefile
@@ -16,4 +16,4 @@ cifs-$(CONFIG_CIFS_DFS_UPCALL) += dns_resolve.o cifs_dfs_ref.o
 
 cifs-$(CONFIG_CIFS_FSCACHE) += fscache.o cache.o
 
-cifs-$(CONFIG_CIFS_SMB2) += smb2maperror.o smb2transport.o
+cifs-$(CONFIG_CIFS_SMB2) += smb2maperror.o smb2transport.o smb2misc.o
diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 2704646..28e1891 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -30,6 +30,9 @@
 #include "cifsproto.h"
 #include "cifs_debug.h"
 #include "cifsfs.h"
+#ifdef CONFIG_CIFS_SMB2
+#include "smb2proto.h"
+#endif
 
 void
 cifs_dump_mem(char *label, void *data, int length)
@@ -65,7 +68,29 @@ void cifs_dump_detail(void *buf)
 	cERROR(1, "Cmd: %d Err: 0x%x Flags: 0x%x Flgs2: 0x%x Mid: %d Pid: %d",
 		  smb->Command, smb->Status.CifsError,
 		  smb->Flags, smb->Flags2, smb->Mid, smb->Pid);
-	cERROR(1, "smb buf %p len %d", smb, smbCalcSize(smb));
+	cERROR(1, "smb buf %p len %u", smb, smbCalcSize(smb));
+}
+
+#ifdef CONFIG_CIFS_SMB2
+static void
+smb2_dump_detail(void *buf)
+{
+	struct smb2_hdr *smb = (struct smb2_hdr *)buf;
+
+	cERROR(1, "Cmd: %d Err: 0x%x Flags: 0x%x Mid: %llu Pid: %d",
+		  smb->Command, smb->Status, smb->Flags, smb->MessageId,
+		  smb->ProcessId);
+	cERROR(1, "smb buf %p len %u", smb, smb2_calc_size(smb));
+}
+#endif
+
+void smb_dump_detail(void *buf, struct TCP_Server_Info *server)
+{
+#ifdef CONFIG_CIFS_SMB2
+	if (server->is_smb2)
+		return smb2_dump_detail(buf);
+#endif
+	return cifs_dump_detail(buf);
 }
 
 void cifs_dump_mids(struct TCP_Server_Info *server)
diff --git a/fs/cifs/cifs_debug.h b/fs/cifs/cifs_debug.h
index 566e0ae..a032f6d 100644
--- a/fs/cifs/cifs_debug.h
+++ b/fs/cifs/cifs_debug.h
@@ -27,6 +27,7 @@ void cifs_dump_mem(char *label, void *data, int length);
 #ifdef CONFIG_CIFS_DEBUG2
 #define DBG2 2
 void cifs_dump_detail(void *);
+void smb_dump_detail(void *, struct TCP_Server_Info *);
 void cifs_dump_mids(struct TCP_Server_Info *);
 #else
 #define DBG2 0
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 2805c91..658280e 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -366,14 +366,22 @@ has_credits(struct TCP_Server_Info *server, int *credits)
 }
 
 static inline size_t
-header_size(void)
+header_size(struct TCP_Server_Info *server)
 {
+#ifdef CONFIG_CIFS_SMB2
+	if (server->is_smb2)
+		return sizeof(struct smb2_hdr);
+#endif
 	return sizeof(struct smb_hdr);
 }
 
 static inline size_t
-max_header_size(void)
+max_header_size(struct TCP_Server_Info *server)
 {
+#ifdef CONFIG_CIFS_SMB2
+	if (server->is_smb2)
+		return MAX_SMB2_HDR_SIZE;
+#endif
 	return MAX_CIFS_HDR_SIZE;
 }
 
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index e901bb6..b92e4ab 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -97,6 +97,8 @@ extern void cifs_add_credits(struct TCP_Server_Info *server,
 			     const unsigned int add, const int optype);
 extern void cifs_set_credits(struct TCP_Server_Info *server, const int val);
 extern int cifs_reconnect(struct TCP_Server_Info *server);
+extern int cifs_check_message(char *buf, unsigned int total_read,
+			      struct TCP_Server_Info *server);
 extern int checkSMB(char *buf, unsigned int length);
 extern bool is_valid_oplock_break(char *, struct TCP_Server_Info *);
 extern bool backup_cred(struct cifs_sb_info *);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 3e61c73..e858d9c 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1423,7 +1423,7 @@ cifs_readv_discard(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 
 		length = cifs_read_from_socket(server, server->bigbuf,
 				min_t(unsigned int, remaining,
-					CIFSMaxBufSize + max_header_size()));
+				    CIFSMaxBufSize + max_header_size(server)));
 		if (length < 0)
 			return length;
 		server->total_read += length;
@@ -1475,9 +1475,10 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	 * can if there's not enough data. At this point, we've read down to
 	 * the Mid.
 	 */
-	len = min_t(unsigned int, buflen, read_rsp_size()) - header_size() + 1;
+	len = min_t(unsigned int, buflen, read_rsp_size()) -
+							header_size(server) + 1;
 
-	rdata->iov[0].iov_base = buf + header_size() - 1;
+	rdata->iov[0].iov_base = buf + header_size(server) - 1;
 	rdata->iov[0].iov_len = len;
 
 	length = cifs_readv_from_socket(server, rdata->iov, 1, len);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index e6daae2..7a7ef74 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -52,6 +52,9 @@
 #include "nterr.h"
 #include "rfc1002pdu.h"
 #include "fscache.h"
+#ifdef CONFIG_CIFS_SMB2
+#include "smb2proto.h"
+#endif
 
 #define CIFS_PORT 445
 #define RFC1001_PORT 139
@@ -539,7 +542,7 @@ allocate_buffers(struct TCP_Server_Info *server)
 		}
 	} else if (server->large_buf) {
 		/* we are reusing a dirty large buf, clear its start */
-		memset(server->bigbuf, 0, header_size());
+		memset(server->bigbuf, 0, header_size(server));
 	}
 
 	if (!server->smallbuf) {
@@ -553,7 +556,7 @@ allocate_buffers(struct TCP_Server_Info *server)
 		/* beginning of smb buffer is cleared in our buf_get */
 	} else {
 		/* if existing small buf clear beginning */
-		memset(server->smallbuf, 0, header_size());
+		memset(server->smallbuf, 0, header_size(server));
 	}
 
 	return true;
@@ -755,9 +758,8 @@ is_smb_response(struct TCP_Server_Info *server, unsigned char type)
 }
 
 static struct mid_q_entry *
-find_mid(struct TCP_Server_Info *server, char *buffer)
+find_cifs_mid(struct TCP_Server_Info *server, struct smb_hdr *buf)
 {
-	struct smb_hdr *buf = (struct smb_hdr *)buffer;
 	struct mid_q_entry *mid;
 
 	spin_lock(&GlobalMid_Lock);
@@ -773,6 +775,40 @@ find_mid(struct TCP_Server_Info *server, char *buffer)
 	return NULL;
 }
 
+#ifdef CONFIG_CIFS_SMB2
+static struct mid_q_entry *
+find_smb2_mid(struct TCP_Server_Info *server, struct smb2_hdr *buf)
+{
+	struct mid_q_entry *mid;
+
+	spin_lock(&GlobalMid_Lock);
+	list_for_each_entry(mid, &server->pending_mid_q, qhead) {
+		if ((mid->mid == buf->MessageId) &&
+		    (mid->mid_state == MID_REQUEST_SUBMITTED) &&
+		    (mid->command == buf->Command)) {
+			spin_unlock(&GlobalMid_Lock);
+			return mid;
+		}
+	}
+	spin_unlock(&GlobalMid_Lock);
+	return NULL;
+}
+#endif
+
+static struct mid_q_entry *
+find_mid(struct TCP_Server_Info *server, char *buf)
+{
+	struct mid_q_entry *mid;
+
+#ifdef CONFIG_CIFS_SMB2
+	if (server->is_smb2)
+		mid = find_smb2_mid(server, (struct smb2_hdr *)buf);
+	else
+#endif
+		mid = find_cifs_mid(server, (struct smb_hdr *)buf);
+	return mid;
+}
+
 void
 dequeue_mid(struct mid_q_entry *mid, bool malformed)
 {
@@ -792,6 +828,10 @@ static void
 handle_mid(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 	   char *buf, int malformed)
 {
+#ifdef CONFIG_CIFS_SMB2
+	if (server->is_smb2)
+		goto next;
+#endif
 	if (malformed == 0 && check2ndT2(buf) > 0) {
 		mid->multiRsp = true;
 		if (mid->resp_buf) {
@@ -815,6 +855,9 @@ handle_mid(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 		}
 		return;
 	}
+#ifdef CONFIG_CIFS_SMB2
+next:
+#endif
 	mid->resp_buf = buf;
 	mid->large_buf = server->large_buf;
 	/* Was previous buf put in mpx struct for multi-rsp? */
@@ -924,7 +967,7 @@ standard_receive3(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	unsigned int pdu_length = get_rfc1002_length(buf);
 
 	/* make sure this will fit in a large buffer */
-	if (pdu_length > CIFSMaxBufSize + max_header_size() - 4) {
+	if (pdu_length > CIFSMaxBufSize + max_header_size(server) - 4) {
 		cERROR(1, "SMB response too long (%u bytes)",
 			pdu_length);
 		cifs_reconnect(server);
@@ -940,8 +983,8 @@ standard_receive3(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	}
 
 	/* now read the rest */
-	length = cifs_read_from_socket(server, buf + header_size() - 1,
-				       pdu_length - header_size() + 1 + 4);
+	length = cifs_read_from_socket(server, buf + header_size(server) - 1,
+				pdu_length - header_size(server) + 1 + 4);
 	if (length < 0)
 		return length;
 	server->total_read += length;
@@ -957,7 +1000,7 @@ standard_receive3(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	 * 48 bytes is enough to display the header and a little bit
 	 * into the payload for debugging purposes.
 	 */
-	length = checkSMB(buf, server->total_read);
+	length = cifs_check_message(buf, server->total_read, server);
 	if (length != 0)
 		cifs_dump_mem("Bad SMB: ", buf,
 			min_t(unsigned int, server->total_read, 48));
@@ -1015,7 +1058,7 @@ cifs_demultiplex_thread(void *p)
 			continue;
 
 		/* make sure we have enough to get to the MID */
-		if (pdu_length < header_size() - 1 - 4) {
+		if (pdu_length < header_size(server) - 1 - 4) {
 			cERROR(1, "SMB response too short (%u bytes)",
 				pdu_length);
 			cifs_reconnect(server);
@@ -1025,7 +1068,7 @@ cifs_demultiplex_thread(void *p)
 
 		/* read down to the MID */
 		length = cifs_read_from_socket(server, buf + 4,
-					       header_size() - 1 - 4);
+					       header_size(server) - 1 - 4);
 		if (length < 0)
 			continue;
 		server->total_read += length;
@@ -1050,9 +1093,10 @@ cifs_demultiplex_thread(void *p)
 		} else if (!is_valid_oplock_break(buf, server)) {
 			cERROR(1, "No task to wake, unknown frame received! "
 				   "NumMids %d", atomic_read(&midCount));
-			cifs_dump_mem("Received Data is: ", buf, header_size());
+			cifs_dump_mem("Received Data is: ", buf,
+				      header_size(server));
 #ifdef CONFIG_CIFS_DEBUG2
-			cifs_dump_detail(buf);
+			smb_dump_detail(buf, server);
 			cifs_dump_mids(server);
 #endif /* CIFS_DEBUG2 */
 
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 2e0bb8c..14c8fb0 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -29,6 +29,9 @@
 #include "smberr.h"
 #include "nterr.h"
 #include "cifs_unicode.h"
+#ifdef CONFIG_CIFS_SMB2
+#include "smb2proto.h"
+#endif
 
 extern mempool_t *cifs_sm_req_poolp;
 extern mempool_t *cifs_req_poolp;
@@ -439,6 +442,17 @@ check_smb_hdr(struct smb_hdr *smb, __u16 mid)
 }
 
 int
+cifs_check_message(char *buf, unsigned int total_read,
+		   struct TCP_Server_Info *server)
+{
+#ifdef CONFIG_CIFS_SMB2
+	if (server->is_smb2)
+		return checkSMB2(buf, total_read);
+#endif
+	return checkSMB(buf, total_read);
+}
+
+int
 checkSMB(char *buf, unsigned int total_read)
 {
 	struct smb_hdr *smb = (struct smb_hdr *)buf;
@@ -533,6 +547,11 @@ is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv)
 	struct cifsInodeInfo *pCifsInode;
 	struct cifsFileInfo *netfile;
 
+#ifdef CONFIG_CIFS_SMB2
+	if (srv->is_smb2)
+		return false;
+#endif
+
 	cFYI(1, "Checking for oplock break or dnotify response");
 	if ((pSMB->hdr.Command == SMB_COM_NT_TRANSACT) &&
 	   (pSMB->hdr.Flags & SMBFLG_RESPONSE)) {
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
new file mode 100644
index 0000000..db9ecd5
--- /dev/null
+++ b/fs/cifs/smb2misc.c
@@ -0,0 +1,304 @@
+/*
+ *   fs/cifs/smb2misc.c
+ *
+ *   Copyright (C) International Business Machines  Corp., 2002,2011
+ *                 Etersoft, 2012
+ *   Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
+ *              Pavel Shilovsky (pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org) 2012
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
+#include <linux/ctype.h>
+#include "smb2pdu.h"
+#include "cifsglob.h"
+#include "cifsproto.h"
+#include "smb2proto.h"
+#include "cifs_debug.h"
+#include "cifs_unicode.h"
+#include "smb2status.h"
+
+static int
+check_smb2_hdr(struct smb2_hdr *smb, __u64 mid)
+{
+	/*
+	 * Make sure that this really is an SMB, that it is a response,
+	 * and that the message ids match
+	 */
+	if ((*(__le32 *) smb->ProtocolId == cpu_to_le32(0x424d53fe)) &&
+		(mid == smb->MessageId)) {
+		if (smb->Flags & SMB2_FLAGS_SERVER_TO_REDIR)
+			return 0;
+		else {
+		/* only one valid case where server sends us request */
+			if (smb->Command == SMB2_OPLOCK_BREAK)
+				return 0;
+			else
+				cERROR(1, "Received Request not response");
+		}
+	} else { /* bad signature or mid */
+		if (*(__le32 *) smb->ProtocolId != cpu_to_le32(0x424d53fe))
+			cERROR(1, "Bad protocol string signature header %x",
+				*(unsigned int *) smb->ProtocolId);
+		if (mid != smb->MessageId)
+			cERROR(1, "Mids do not match");
+	}
+	cERROR(1, "bad smb detected. The Mid=%lld", smb->MessageId);
+	return 1;
+}
+
+/*
+ *  The following table defines the expected "StructureSize" of SMB2 responses
+ *  in order by SMB2 command.  This is similar to "wct" in SMB/CIFS responses.
+ *
+ *  Note that commands are defined in smb2pdu.h in le16 but the array below is
+ *  indexed by command in host byte order
+ */
+static const int smb2_rsp_struct_sizes[NUMBER_OF_SMB2_COMMANDS] = {
+	/* SMB2_NEGOTIATE */ 65,
+	/* SMB2_SESSION_SETUP */ 9,
+	/* SMB2_LOGOFF */ 4,
+	/* SMB2_TREE_CONNECT */	16,
+	/* SMB2_TREE_DISCONNECT */ 4,
+	/* SMB2_CREATE */ 89,
+	/* SMB2_CLOSE */ 60,
+	/* SMB2_FLUSH */ 4,
+	/* SMB2_READ */	17,
+	/* SMB2_WRITE */ 17,
+	/* SMB2_LOCK */	4,
+	/* SMB2_IOCTL */ 49,
+	/* SMB2_CANCEL */ 0, /* BB CHECK this ... not listed in documentation */
+	/* SMB2_ECHO */ 4,
+	/* SMB2_QUERY_DIRECTORY */ 9,
+	/* SMB2_CHANGE_NOTIFY */ 9,
+	/* SMB2_QUERY_INFO */ 9,
+	/* SMB2_SET_INFO */ 2,
+	/* SMB2_OPLOCK_BREAK */ 24 /* BB FIXME can also be 44 for lease break */
+};
+
+int
+checkSMB2(char *buf, unsigned int length)
+{
+	struct smb2_hdr *hdr = (struct smb2_hdr *)buf;
+	struct smb2_pdu *pdu = (struct smb2_pdu *)hdr;
+	__u64 mid = hdr->MessageId;
+	__u32 len = get_rfc1002_length(buf);
+	__u32 clc_len;  /* calculated length */
+	int command;
+
+	/* BB disable following printk later */
+	cFYI(1, "checkSMB Length: 0x%x, smb_buf_length: 0x%x", length, len);
+
+	/*
+	 * Add function to do table lookup of StructureSize by command
+	 * ie Validate the wct via smb2_struct_sizes table above
+	 */
+
+	if (length < 2 + sizeof(struct smb2_hdr)) {
+		if ((length >= sizeof(struct smb2_hdr)) && (hdr->Status != 0)) {
+			pdu->StructureSize2 = 0;
+			/*
+			 * As with SMB/CIFS, on some error cases servers may
+			 * not return wct properly
+			 */
+			return 0;
+		} else {
+			cERROR(1, "Length less than smb header size");
+		}
+		return 1;
+	}
+	if (len > CIFSMaxBufSize + MAX_SMB2_HDR_SIZE - 4) {
+		cERROR(1, "smb length greater than maximum, mid=%lld", mid);
+		return 1;
+	}
+
+	if (check_smb2_hdr(hdr, mid))
+		return 1;
+
+	if (le16_to_cpu(hdr->StructureSize) != 64) {
+		cERROR(1, "Illegal structure size %d",
+			  le16_to_cpu(hdr->StructureSize));
+		return 1;
+	}
+
+	command = le16_to_cpu(hdr->Command);
+	if (command >= NUMBER_OF_SMB2_COMMANDS) {
+		cERROR(1, "illegal SMB2 command %d", command);
+		return 1;
+	}
+
+	if (smb2_rsp_struct_sizes[command] !=
+	    le16_to_cpu(pdu->StructureSize2)) {
+		if ((hdr->Status == 0) ||
+		    (le16_to_cpu(pdu->StructureSize2) != 9)) {
+			/* error packets have 9 byte structure size */
+			cERROR(1, "Illegal response size %d for command %d",
+				   le16_to_cpu(pdu->StructureSize2), command);
+			return 1;
+		}
+	}
+
+	clc_len = smb2_calc_size(hdr);
+
+	if (4 + len != length) {
+		cERROR(1, "Length read does not match RFC1001 length %d",
+			   len);
+		return 1;
+	}
+
+	if (4 + len != clc_len) {
+		cFYI(1, "Calculated size %d length %d mismatch for mid %lld",
+			 clc_len, 4 + len, mid);
+		if (clc_len == 4 + len + 1) /* BB FIXME (fix samba) */
+			return 0; /* BB workaround Samba 3 bug SessSetup rsp */
+		return 1;
+	}
+	return 0;
+}
+
+/*
+ *  The size of the variable area depends on the offset and length fields
+ *  located in different fields for various SMB2 responses.  SMB2 responses
+ *  with no variable length info, show an offset of zero for the offset field.
+ */
+static const bool has_smb2_data_area[NUMBER_OF_SMB2_COMMANDS] = {
+	/* SMB2_NEGOTIATE */ true,
+	/* SMB2_SESSION_SETUP */ true,
+	/* SMB2_LOGOFF */ false,
+	/* SMB2_TREE_CONNECT */	false,
+	/* SMB2_TREE_DISCONNECT */ false,
+	/* SMB2_CREATE */ true,
+	/* SMB2_CLOSE */ false,
+	/* SMB2_FLUSH */ false,
+	/* SMB2_READ */	true,
+	/* SMB2_WRITE */ false,
+	/* SMB2_LOCK */	false,
+	/* SMB2_IOCTL */ true,
+	/* SMB2_CANCEL */ false, /* BB CHECK this not listed in documentation */
+	/* SMB2_ECHO */ false,
+	/* SMB2_QUERY_DIRECTORY */ true,
+	/* SMB2_CHANGE_NOTIFY */ true,
+	/* SMB2_QUERY_INFO */ true,
+	/* SMB2_SET_INFO */ false,
+	/* SMB2_OPLOCK_BREAK */ false
+};
+
+/*
+ * Returns the pointer to the beginning of the data area. Length of the data
+ * area and the offset to it (from the beginning of the smb are also returned.
+ */
+static char *
+smb2_get_data_area_len(int *poff, int *plen, struct smb2_hdr *pSMB2)
+{
+	*poff = 0;
+	*plen = 0;
+
+	/* error responses do not have data area */
+	if (pSMB2->Status &&
+	   (le32_to_cpu(pSMB2->Status) != STATUS_MORE_PROCESSING_REQUIRED) &&
+	   (le16_to_cpu(((struct smb2_err_rsp *)pSMB2)->StructureSize) == 9))
+		return NULL;
+
+	/*
+	 * Following commands have data areas so we have to get the location
+	 * of the data buffer offset and data buffer length for the particular
+	 * command.
+	 */
+	switch (pSMB2->Command) {
+	case SMB2_NEGOTIATE:
+	case SMB2_SESSION_SETUP:
+	case SMB2_CREATE:
+	case SMB2_READ:
+	case SMB2_QUERY_INFO:
+	case SMB2_QUERY_DIRECTORY:
+	case SMB2_IOCTL:
+	case SMB2_CHANGE_NOTIFY:
+	default:
+		/* BB FIXME for unimplemented cases above */
+		cERROR(1, "no length check for command");
+		break;
+	}
+
+	/*
+	 * Invalid length or offset probably means data area is invalid, but
+	 * we have little choice but to ignore the data area in this case.
+	 */
+	if (*poff > 4096) {
+		dump_stack();
+		cERROR(1, "offset %d too large, data area ignored", *poff);
+		*plen = 0;
+		*poff = 0;
+	} else if (*poff < 0) {
+		cERROR(1, "negative offset to data invalid ignore data area");
+		*poff = 0;
+		*plen = 0;
+	} else if (*plen < 0) {
+		cERROR(1, "negative data length invalid, data area ignored");
+		*plen = 0;
+	} else if (*plen > 128 * 1024) {
+		cERROR(1, "data area larger than 128K");
+		*plen = 0;
+	}
+
+	/* return pointer to beginning of data area, ie offset from SMB start */
+	if ((*poff != 0) && (*plen != 0))
+		return pSMB2->ProtocolId + *poff;
+	else
+		return NULL;
+}
+
+/*
+ * Calculate the size of the SMB message based on the fixed header
+ * portion, the number of word parameters and the data portion of the message.
+ */
+unsigned int
+smb2_calc_size(struct smb2_hdr *pSMB2h)
+{
+	struct smb2_pdu *pSMB2 = (struct smb2_pdu *)pSMB2h;
+	int offset; /* the offset from the beginning of SMB to data area */
+	int data_length; /* the length of the variable length data area */
+	/* Structure Size has already been checked to make sure it is 64 */
+	int len = 4 + le16_to_cpu(pSMB2->hdr.StructureSize);
+
+	/*
+	 * StructureSize2, ie length of fixed parameter area has already
+	 * been checked to make sure it is the correct length.
+	 */
+	len += le16_to_cpu(pSMB2->StructureSize2);
+
+	if (has_smb2_data_area[le16_to_cpu(pSMB2h->Command)] == false)
+		goto calc_size_exit;
+
+	smb2_get_data_area_len(&offset, &data_length, pSMB2h);
+	cFYI(1, "smb2 data length %d offset %d", data_length, offset);
+
+	if (data_length > 0) {
+		/*
+		 * Check to make sure that data area begins after fixed area,
+		 * Note that last byte of the fixed area is part of data area
+		 * for some commands, typically those with odd StructureSize,
+		 * so we must add one to the calculation (and 4 to account for
+		 * the size of the RFC1001 hdr.
+		 */
+		if (offset + 4 + 1 < len) {
+			cERROR(1, "data area overlaps SMB2 header, ignoring");
+			data_length = 0;
+		} else {
+			len = 4 + offset + data_length;
+		}
+	}
+calc_size_exit:
+	cFYI(1, "smb2 len %d", len);
+	return len;
+}
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 574ed1d..66ab8d6 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -112,4 +112,34 @@ struct smb2_hdr {
 	__u8   Signature[16];
 } __packed;
 
+struct smb2_pdu {
+	struct smb2_hdr hdr;
+	__le16 StructureSize2; /* size of wct area (varies, request specific) */
+} __packed;
+
+/*
+ *	SMB2 flag definitions
+ */
+#define SMB2_FLAGS_SERVER_TO_REDIR	cpu_to_le32(0x00000001) /* Response */
+#define SMB2_FLAGS_ASYNC_COMMAND	cpu_to_le32(0x00000002)
+#define SMB2_FLAGS_RELATED_OPERATIONS	cpu_to_le32(0x00000004)
+#define SMB2_FLAGS_SIGNED		cpu_to_le32(0x00000008)
+#define SMB2_FLAGS_DFS_OPERATIONS	cpu_to_le32(0x10000000)
+
+/*
+ *	Definitions for SMB2 Protocol Data Units (network frames)
+ *
+ *  See MS-SMB2.PDF specification for protocol details.
+ *  The Naming convention is the lower case version of the SMB2
+ *  command code name for the struct. Note that structures must be packed.
+ *
+ */
+struct smb2_err_rsp {
+	struct smb2_hdr hdr;
+	__le16 StructureSize;
+	__le16 Reserved; /* MBZ */
+	__le32 ByteCount;  /* even if zero, at least one byte follows */
+	__u8   ErrorData[1];  /* variable length */
+} __packed;
+
 #endif				/* _SMB2PDU_H */
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 86a1aa9..1c7c8e4 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -33,6 +33,8 @@ struct statfs;
  *****************************************************************
  */
 extern int map_smb2_to_linux_error(struct smb2_hdr *smb2, int log_err);
+extern int checkSMB2(char *buf, unsigned int length);
+extern unsigned int smb2_calc_size(struct smb2_hdr *pSMB2h);
 
 extern int smb2_check_receive(struct mid_q_entry *mid,
 			      struct TCP_Server_Info *server, bool log_error);
-- 
1.7.1
