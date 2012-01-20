From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 07/50] CIFS: Make demultiplex_thread work with SMB2 code
Date: Fri, 20 Jan 2012 12:34:28 +0400
Message-ID: <1327048511-2342-7-git-send-email-piastry@etersoft.ru>
References: <1327048511-2342-1-git-send-email-piastry@etersoft.ru>
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1327048511-2342-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Now we can process SMB2 messages: check message, get message id
and wakeup awaiting routines.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifs_debug.c |   14 +++-
 fs/cifs/cifs_debug.h |    1 +
 fs/cifs/connect.c    |  177 +++++++++++++++++++++++++++------
 fs/cifs/misc.c       |    5 +
 fs/cifs/smb2misc.c   |  274 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.h    |   30 ++++++
 fs/cifs/smb2proto.h  |    2 +
 7 files changed, 473 insertions(+), 30 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 0308b52..0591249 100644
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
@@ -63,9 +66,18 @@ void cifs_dump_detail(struct smb_hdr *smb)
 	cERROR(1, "Cmd: %d Err: 0x%x Flags: 0x%x Flgs2: 0x%x Mid: %d Pid: %d",
 		  smb->Command, smb->Status.CifsError,
 		  smb->Flags, smb->Flags2, smb->Mid, smb->Pid);
-	cERROR(1, "smb buf %p len %d", smb, smbCalcSize(smb));
+	cERROR(1, "smb buf %p len %u", smb, smbCalcSize(smb));
 }
 
+#ifdef CONFIG_CIFS_SMB2
+void smb2_dump_detail(struct smb2_hdr *smb)
+{
+	cERROR(1, "Cmd: %d Err: 0x%x Flags: 0x%x Mid: %llu Pid: %d",
+		  smb->Command, smb->Status, smb->Flags, smb->MessageId,
+		  smb->ProcessId);
+	cERROR(1, "smb buf %p len %u", smb, smb2_calc_size(smb));
+}
+#endif
 
 void cifs_dump_mids(struct TCP_Server_Info *server)
 {
diff --git a/fs/cifs/cifs_debug.h b/fs/cifs/cifs_debug.h
index e9911bf..8f20c7a 100644
--- a/fs/cifs/cifs_debug.h
+++ b/fs/cifs/cifs_debug.h
@@ -35,6 +35,7 @@ extern int traceSMB;		/* flag which enables the function below */
 void dump_smb(struct smb_hdr *, int);
 #ifdef CONFIG_CIFS_SMB2
 void dump_smb2(struct smb2_hdr *smb_buf, int smb_buf_length);
+void smb2_dump_detail(struct smb2_hdr *);
 #endif
 #define CIFS_INFO	0x01
 #define CIFS_RC		0x02
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index ccfcfbe..9d4b3c2 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -49,6 +49,9 @@
 #include "nterr.h"
 #include "rfc1002pdu.h"
 #include "fscache.h"
+#ifdef CONFIG_CIFS_SMB2
+#include "smb2proto.h"
+#endif
 
 #define CIFS_PORT 445
 #define RFC1001_PORT 139
@@ -323,6 +326,14 @@ requeue_echo:
 static bool
 allocate_buffers(struct TCP_Server_Info *server)
 {
+	size_t buf_size;
+
+#ifdef CONFIG_CIFS_SMB2
+	if (server->is_smb2)
+		buf_size = sizeof(struct smb2_hdr);
+	else
+#endif
+		buf_size = sizeof(struct smb_hdr);
 	if (!server->bigbuf) {
 		server->bigbuf = (char *)cifs_buf_get();
 		if (!server->bigbuf) {
@@ -333,7 +344,7 @@ allocate_buffers(struct TCP_Server_Info *server)
 		}
 	} else if (server->large_buf) {
 		/* we are reusing a dirty large buf, clear its start */
-		memset(server->bigbuf, 0, sizeof(struct smb_hdr));
+		memset(server->bigbuf, 0, buf_size);
 	}
 
 	if (!server->smallbuf) {
@@ -347,7 +358,7 @@ allocate_buffers(struct TCP_Server_Info *server)
 		/* beginning of smb buffer is cleared in our buf_get */
 	} else {
 		/* if existing small buf clear beginning */
-		memset(server->smallbuf, 0, sizeof(struct smb_hdr));
+		memset(server->smallbuf, 0, buf_size);
 	}
 
 	return true;
@@ -539,7 +550,7 @@ is_smb_response(struct TCP_Server_Info *server, unsigned char type)
 }
 
 static struct mid_q_entry *
-find_mid(struct TCP_Server_Info *server, struct smb_hdr *buf)
+find_cifs_mid(struct TCP_Server_Info *server, struct smb_hdr *buf)
 {
 	struct mid_q_entry *mid;
 
@@ -556,6 +567,40 @@ find_mid(struct TCP_Server_Info *server, struct smb_hdr *buf)
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
@@ -573,13 +618,18 @@ dequeue_mid(struct mid_q_entry *mid, bool malformed)
 
 static void
 handle_mid(struct mid_q_entry *mid, struct TCP_Server_Info *server,
-	   struct smb_hdr *buf, int malformed)
+	   char *buf, int malformed)
 {
-	if (malformed == 0 && check2ndT2(buf) > 0) {
+#ifdef CONFIG_CIFS_SMB2
+	if (server->is_smb2)
+		goto next;
+#endif
+	if (malformed == 0 && check2ndT2((struct smb_hdr *)buf) > 0) {
 		mid->multiRsp = true;
 		if (mid->resp_buf) {
 			/* merge response - fix up 1st*/
-			malformed = coalesce_t2(buf, mid->resp_buf);
+			malformed = coalesce_t2((struct smb_hdr *)buf,
+						mid->resp_buf);
 			if (malformed > 0)
 				return;
 
@@ -598,6 +648,9 @@ handle_mid(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 		}
 		return;
 	}
+#ifdef CONFIG_CIFS_SMB2
+next:
+#endif
 	mid->resp_buf = buf;
 	mid->large_buf = server->large_buf;
 	/* Was previous buf put in mpx struct for multi-rsp? */
@@ -631,8 +684,19 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 	 * time to as little as two.
 	 */
 	spin_lock(&GlobalMid_Lock);
+#ifdef CONFIG_CIFS_SMB2
+	if (server->is_smb2) {
+		if (atomic_read(&server->credits) == 0)
+			/* set to a big value to wake up awaiting processes */
+			atomic_set(&server->credits, 1024);
+	} else {
+		if (atomic_read(&server->inFlight) >= cifs_max_pending)
+			atomic_set(&server->inFlight, cifs_max_pending - 1);
+	}
+#else
 	if (atomic_read(&server->inFlight) >= cifs_max_pending)
 		atomic_set(&server->inFlight, cifs_max_pending - 1);
+#endif
 	/*
 	 * We do not want to set the max_pending too low or we could end up
 	 * with the counter going negative.
@@ -712,13 +776,27 @@ standard_receive3(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 {
 	int length;
 	char *buf = server->smallbuf;
-	struct smb_hdr *smb_buffer = (struct smb_hdr *)buf;
-	unsigned int pdu_length = be32_to_cpu(smb_buffer->smb_buf_length);
+	unsigned int pdu_length = get_rfc1002_length(buf);
+	size_t buf_size, max_hdr_size;
+	struct smb_hdr *smb_buffer = (struct smb_hdr *)buf; /* quiet compiler */
+#ifdef CONFIG_CIFS_SMB2
+	struct smb2_hdr *smb2_buffer = (struct smb2_hdr *)buf;
+#endif
 
+#ifdef CONFIG_CIFS_SMB2
+	if (server->is_smb2) {
+		max_hdr_size = MAX_SMB2_HDR_SIZE;
+		buf_size = sizeof(struct smb2_hdr);
+	} else {
+#endif
+		max_hdr_size = MAX_CIFS_HDR_SIZE;
+		buf_size = sizeof(struct smb_hdr);
+#ifdef CONFIG_CIFS_SMB2
+	}
+#endif
 	/* make sure this will fit in a large buffer */
-	if (pdu_length > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4) {
-		cERROR(1, "SMB response too long (%u bytes)",
-			pdu_length);
+	if (pdu_length > CIFSMaxBufSize + max_hdr_size - 4) {
+		cERROR(1, "SMB response too long (%u bytes)", pdu_length);
 		cifs_reconnect(server);
 		wake_up(&server->response_q);
 		return -EAGAIN;
@@ -729,18 +807,27 @@ standard_receive3(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		server->large_buf = true;
 		memcpy(server->bigbuf, server->smallbuf, server->total_read);
 		buf = server->bigbuf;
-		smb_buffer = (struct smb_hdr *)buf;
+#ifdef CONFIG_CIFS_SMB2
+		if (server->is_smb2)
+			smb2_buffer = (struct smb2_hdr *)buf;
+		else
+#endif
+			smb_buffer = (struct smb_hdr *)buf;
 	}
 
 	/* now read the rest */
-	length = cifs_read_from_socket(server,
-			  buf + sizeof(struct smb_hdr) - 1,
-			  pdu_length - sizeof(struct smb_hdr) + 1 + 4);
+	length = cifs_read_from_socket(server, buf + buf_size - 1,
+				       pdu_length - buf_size + 1 + 4);
 	if (length < 0)
 		return length;
 	server->total_read += length;
 
-	dump_smb(smb_buffer, server->total_read);
+#ifdef CONFIG_CIFS_SMB2
+	if (server->is_smb2)
+		dump_smb2(smb2_buffer, server->total_read);
+	else
+#endif
+		dump_smb(smb_buffer, server->total_read);
 
 	/*
 	 * We know that we received enough to get to the MID as we
@@ -751,13 +838,20 @@ standard_receive3(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	 * 48 bytes is enough to display the header and a little bit
 	 * into the payload for debugging purposes.
 	 */
-	length = checkSMB(smb_buffer, smb_buffer->Mid, server->total_read);
+#ifdef CONFIG_CIFS_SMB2
+	if (server->is_smb2)
+		length = checkSMB2(smb2_buffer, smb2_buffer->MessageId,
+				   server->total_read);
+	else
+#endif
+		length = checkSMB(smb_buffer, smb_buffer->Mid,
+				  server->total_read);
 	if (length != 0)
 		cifs_dump_mem("Bad SMB: ", buf,
 			min_t(unsigned int, server->total_read, 48));
 
 	if (mid)
-		handle_mid(mid, server, smb_buffer, length);
+		handle_mid(mid, server, buf, length);
 
 	return length;
 }
@@ -769,7 +863,11 @@ cifs_demultiplex_thread(void *p)
 	struct TCP_Server_Info *server = p;
 	unsigned int pdu_length;
 	char *buf = NULL;
+	size_t buf_size;
 	struct smb_hdr *smb_buffer = NULL;
+#ifdef CONFIG_CIFS_SMB2
+	struct smb2_hdr *smb2_buffer = NULL;
+#endif
 	struct task_struct *task_to_wake = NULL;
 	struct mid_q_entry *mid_entry;
 
@@ -781,6 +879,13 @@ cifs_demultiplex_thread(void *p)
 		mempool_resize(cifs_req_poolp, length + cifs_min_rcv,
 				GFP_KERNEL);
 
+#ifdef CONFIG_CIFS_SMB2
+	if (server->is_smb2)
+		buf_size = sizeof(struct smb2_hdr);
+	else
+#endif
+		buf_size = sizeof(struct smb_hdr);
+
 	set_freezable();
 	while (server->tcpStatus != CifsExiting) {
 		if (try_to_freeze())
@@ -790,8 +895,13 @@ cifs_demultiplex_thread(void *p)
 			continue;
 
 		server->large_buf = false;
-		smb_buffer = (struct smb_hdr *)server->smallbuf;
 		buf = server->smallbuf;
+#ifdef CONFIG_CIFS_SMB2
+		if (server->is_smb2)
+			smb2_buffer = (struct smb2_hdr *)buf;
+		else
+#endif
+			smb_buffer = (struct smb_hdr *)buf;
 		pdu_length = 4; /* enough to get RFC1001 header */
 
 		length = cifs_read_from_socket(server, buf, pdu_length);
@@ -803,14 +913,14 @@ cifs_demultiplex_thread(void *p)
 		 * The right amount was read from socket - 4 bytes,
 		 * so we can now interpret the length field.
 		 */
-		pdu_length = be32_to_cpu(smb_buffer->smb_buf_length);
+		pdu_length = get_rfc1002_length(buf);
 
 		cFYI(1, "RFC1002 header 0x%x", pdu_length);
 		if (!is_smb_response(server, buf[0]))
 			continue;
 
 		/* make sure we have enough to get to the MID */
-		if (pdu_length < sizeof(struct smb_hdr) - 1 - 4) {
+		if (pdu_length < buf_size - 1 - 4) {
 			cERROR(1, "SMB response too short (%u bytes)",
 				pdu_length);
 			cifs_reconnect(server);
@@ -820,12 +930,12 @@ cifs_demultiplex_thread(void *p)
 
 		/* read down to the MID */
 		length = cifs_read_from_socket(server, buf + 4,
-					sizeof(struct smb_hdr) - 1 - 4);
+					       buf_size - 1 - 4);
 		if (length < 0)
 			continue;
 		server->total_read += length;
 
-		mid_entry = find_mid(server, smb_buffer);
+		mid_entry = find_mid(server, buf);
 
 		if (!mid_entry || !mid_entry->receive)
 			length = standard_receive3(server, mid_entry);
@@ -837,20 +947,29 @@ cifs_demultiplex_thread(void *p)
 
 		if (server->large_buf) {
 			buf = server->bigbuf;
-			smb_buffer = (struct smb_hdr *)buf;
+#ifdef CONFIG_CIFS_SMB2
+			if (server->is_smb2)
+				smb2_buffer = (struct smb2_hdr *)buf;
+			else
+#endif
+				smb_buffer = (struct smb_hdr *)buf;
 		}
 
 		server->lstrp = jiffies;
 		if (mid_entry != NULL) {
 			if (!mid_entry->multiRsp || mid_entry->multiEnd)
 				mid_entry->callback(mid_entry);
-		} else if (!is_valid_oplock_break(smb_buffer, server)) {
+		} else if (!is_valid_oplock_break((void *)buf, server)) {
 			cERROR(1, "No task to wake, unknown frame received! "
-				   "NumMids %d", atomic_read(&midCount));
-			cifs_dump_mem("Received Data is: ", buf,
-				      sizeof(struct smb_hdr));
+				  "NumMids %d", atomic_read(&midCount));
+			cifs_dump_mem("Received Data is: ", buf, buf_size);
 #ifdef CONFIG_CIFS_DEBUG2
-			cifs_dump_detail(smb_buffer);
+#ifdef CONFIG_CIFS_SMB2
+			if (server->is_smb2)
+				smb2_dump_detail(smb2_buffer);
+			else
+#endif
+				cifs_dump_detail(smb_buffer);
 			cifs_dump_mids(server);
 #endif /* CIFS_DEBUG2 */
 
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index dad14d1..531791f 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -511,6 +511,11 @@ is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
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
index 355fb15..2390c02 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -33,3 +33,277 @@ dump_smb2(struct smb2_hdr *smb_buf, int smb_buf_length)
 {
 	dump_smb((struct smb_hdr *)smb_buf, smb_buf_length);
 }
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
+checkSMB2(struct smb2_hdr *smb, __u64 mid, unsigned int length)
+{
+	struct smb2_pdu * smb2 = (struct smb2_pdu *)smb;
+	__u32 len = be32_to_cpu(smb->smb2_buf_length);
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
+		if ((length >= sizeof(struct smb2_hdr))
+			    && (smb->Status != 0)) {
+			smb2->StructureSize2 = 0;
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
+		cERROR(1, "smb length greater than maximum, mid=%lld",
+				   smb->MessageId);
+		return 1;
+	}
+
+	if (check_smb2_hdr(smb, mid))
+		return 1;
+
+	if (le16_to_cpu(smb->StructureSize) != 64) {
+		cERROR(1, "Illegal structure size %d",
+			  le16_to_cpu(smb->StructureSize));
+		return 1;
+	}
+
+	command = le16_to_cpu(smb->Command);
+	if (command >= NUMBER_OF_SMB2_COMMANDS) {
+		cERROR(1, "illegal SMB2 command %d", command);
+		return 1;
+	}
+
+	if (smb2_rsp_struct_sizes[command] !=
+	    le16_to_cpu(smb2->StructureSize2)) {
+		if ((smb->Status == 0) ||
+		    (le16_to_cpu(smb2->StructureSize2) != 9)) {
+			/* error packets have 9 byte structure size */
+			cERROR(1, "Illegal response size %d for command %d",
+				   le16_to_cpu(smb2->StructureSize2), command);
+			return 1;
+		}
+	}
+
+	clc_len = smb2_calc_size(smb);
+
+	if (4 + len != length) {
+		cERROR(1, "Length read does not match RFC1001 length %d",
+			   len);
+		return 1;
+	}
+
+	if (4 + len != clc_len) {
+		cFYI(1, "Calculated size %d length %d mismatch for mid %lld",
+			 clc_len, 4 + len, smb->MessageId);
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
index 5ec0c9f..041e83b 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -111,4 +111,34 @@ struct smb2_hdr {
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
index 6cffdf1..92a119a 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -32,6 +32,8 @@ struct statfs;
  *****************************************************************
  */
 extern int map_smb2_to_linux_error(struct smb2_hdr *smb2, int logErr);
+extern int checkSMB2(struct smb2_hdr *smb, __u64 mid, unsigned int length);
+extern unsigned int smb2_calc_size(struct smb2_hdr *pSMB2h);
 
 extern int smb2_sendrcv2(const unsigned int xid, struct cifs_ses *ses,
 			 struct kvec *vec, int nvec, int *ret_buf_type,
-- 
1.7.1
