From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2 07/24] CIFS: Make demultiplex_thread work with SMB2 code
Date: Wed, 20 Jun 2012 18:30:47 +0400
Message-ID: <1340202664-28696-8-git-send-email-pshilovsky@samba.org>
References: <1340202664-28696-1-git-send-email-pshilovsky@samba.org>
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340202664-28696-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Now we can process SMB2 messages: check message, get message id
and wakeup awaiting routines.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/Makefile     |    2 +-
 fs/cifs/cifs_debug.c |    2 +-
 fs/cifs/smb2misc.c   |  304 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2ops.c    |   37 ++++++
 fs/cifs/smb2pdu.h    |   30 +++++
 fs/cifs/smb2proto.h  |    2 +
 6 files changed, 375 insertions(+), 2 deletions(-)
 create mode 100644 fs/cifs/smb2misc.c

diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
index a73d7f8..b77e9ec 100644
--- a/fs/cifs/Makefile
+++ b/fs/cifs/Makefile
@@ -16,4 +16,4 @@ cifs-$(CONFIG_CIFS_DFS_UPCALL) += dns_resolve.o cifs_dfs_ref.o
 
 cifs-$(CONFIG_CIFS_FSCACHE) += fscache.o cache.o
 
-cifs-$(CONFIG_CIFS_SMB2) += smb2ops.o smb2maperror.o smb2transport.o
+cifs-$(CONFIG_CIFS_SMB2) += smb2ops.o smb2maperror.o smb2transport.o smb2misc.o
diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index e814052..8aa8693 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -65,7 +65,7 @@ void cifs_dump_detail(void *buf)
 	cERROR(1, "Cmd: %d Err: 0x%x Flags: 0x%x Flgs2: 0x%x Mid: %d Pid: %d",
 		  smb->Command, smb->Status.CifsError,
 		  smb->Flags, smb->Flags2, smb->Mid, smb->Pid);
-	cERROR(1, "smb buf %p len %d", smb, smbCalcSize(smb));
+	cERROR(1, "smb buf %p len %u", smb, smbCalcSize(smb));
 #endif /* CONFIG_CIFS_DEBUG2 */
 }
 
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
new file mode 100644
index 0000000..03167eb
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
+check_smb2_hdr(struct smb2_hdr *hdr, __u64 mid)
+{
+	/*
+	 * Make sure that this really is an SMB, that it is a response,
+	 * and that the message ids match
+	 */
+	if ((*(__le32 *)hdr->ProtocolId == cpu_to_le32(0x424d53fe)) &&
+	    (mid == hdr->MessageId)) {
+		if (hdr->Flags & SMB2_FLAGS_SERVER_TO_REDIR)
+			return 0;
+		else {
+			/* only one valid case where server sends us request */
+			if (hdr->Command == SMB2_OPLOCK_BREAK)
+				return 0;
+			else
+				cERROR(1, "Received Request not response");
+		}
+	} else { /* bad signature or mid */
+		if (*(__le32 *)hdr->ProtocolId != cpu_to_le32(0x424d53fe))
+			cERROR(1, "Bad protocol string signature header %x",
+			       *(unsigned int *) hdr->ProtocolId);
+		if (mid != hdr->MessageId)
+			cERROR(1, "Mids do not match");
+	}
+	cERROR(1, "Bad SMB detected. The Mid=%llu", hdr->MessageId);
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
+smb2_check_message(char *buf, unsigned int length)
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
+smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *hdr)
+{
+	*off = 0;
+	*len = 0;
+
+	/* error responses do not have data area */
+	if (hdr->Status &&
+	   (le32_to_cpu(hdr->Status) != STATUS_MORE_PROCESSING_REQUIRED) &&
+	   (le16_to_cpu(((struct smb2_err_rsp *)hdr)->StructureSize) == 9))
+		return NULL;
+
+	/*
+	 * Following commands have data areas so we have to get the location
+	 * of the data buffer offset and data buffer length for the particular
+	 * command.
+	 */
+	switch (hdr->Command) {
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
+	if (*off > 4096) {
+		dump_stack();
+		cERROR(1, "offset %d too large, data area ignored", *off);
+		*len = 0;
+		*off = 0;
+	} else if (*off < 0) {
+		cERROR(1, "negative offset to data invalid ignore data area");
+		*off = 0;
+		*len = 0;
+	} else if (*len < 0) {
+		cERROR(1, "negative data length invalid, data area ignored");
+		*len = 0;
+	} else if (*len > 128 * 1024) {
+		cERROR(1, "data area larger than 128K");
+		*len = 0;
+	}
+
+	/* return pointer to beginning of data area, ie offset from SMB start */
+	if ((*off != 0) && (*len != 0))
+		return hdr->ProtocolId + *off;
+	else
+		return NULL;
+}
+
+/*
+ * Calculate the size of the SMB message based on the fixed header
+ * portion, the number of word parameters and the data portion of the message.
+ */
+unsigned int
+smb2_calc_size(struct smb2_hdr *hdr)
+{
+	struct smb2_pdu *pdu = (struct smb2_pdu *)hdr;
+	int offset; /* the offset from the beginning of SMB to data area */
+	int data_length; /* the length of the variable length data area */
+	/* Structure Size has already been checked to make sure it is 64 */
+	int len = 4 + le16_to_cpu(pdu->hdr.StructureSize);
+
+	/*
+	 * StructureSize2, ie length of fixed parameter area has already
+	 * been checked to make sure it is the correct length.
+	 */
+	len += le16_to_cpu(pdu->StructureSize2);
+
+	if (has_smb2_data_area[le16_to_cpu(hdr->Command)] == false)
+		goto calc_size_exit;
+
+	smb2_get_data_area_len(&offset, &data_length, hdr);
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
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index ab2590f..88cbfce 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -105,6 +105,38 @@ smb2_get_next_mid(struct TCP_Server_Info *server)
 	return mid;
 }
 
+static struct mid_q_entry *
+smb2_find_mid(struct TCP_Server_Info *server, char *buf)
+{
+	struct mid_q_entry *mid;
+	struct smb2_hdr *hdr = (struct smb2_hdr *)buf;
+
+	spin_lock(&GlobalMid_Lock);
+	list_for_each_entry(mid, &server->pending_mid_q, qhead) {
+		if ((mid->mid == hdr->MessageId) &&
+		    (mid->mid_state == MID_REQUEST_SUBMITTED) &&
+		    (mid->command == hdr->Command)) {
+			spin_unlock(&GlobalMid_Lock);
+			return mid;
+		}
+	}
+	spin_unlock(&GlobalMid_Lock);
+	return NULL;
+}
+
+static void
+smb2_dump_detail(void *buf)
+{
+#ifdef CONFIG_CIFS_DEBUG2
+	struct smb2_hdr *smb = (struct smb2_hdr *)buf;
+
+	cERROR(1, "Cmd: %d Err: 0x%x Flags: 0x%x Mid: %llu Pid: %d",
+		  smb->Command, smb->Status, smb->Flags, smb->MessageId,
+		  smb->ProcessId);
+	cERROR(1, "smb buf %p len %u", smb, smb2_calc_size(smb));
+#endif
+}
+
 struct smb_version_operations smb21_operations = {
 	.setup_request = smb2_setup_request,
 	.check_receive = smb2_check_receive,
@@ -113,9 +145,14 @@ struct smb_version_operations smb21_operations = {
 	.get_credits_field = smb2_get_credits_field,
 	.get_credits = smb2_get_credits,
 	.get_next_mid = smb2_get_next_mid,
+	.find_mid = smb2_find_mid,
+	.check_message = smb2_check_message,
+	.dump_detail = smb2_dump_detail,
 };
 
 struct smb_version_values smb21_values = {
 	.version_string = SMB21_VERSION_STRING,
+	.header_size = sizeof(struct smb2_hdr),
+	.max_header_size = MAX_SMB2_HDR_SIZE,
 	.lock_cmd = SMB2_LOCK,
 };
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index c7f52e3..efb0d98 100644
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
index 0e59afb..19bf987 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -33,6 +33,8 @@ struct statfs;
  *****************************************************************
  */
 extern int map_smb2_to_linux_error(char *buf, bool log_err);
+extern int smb2_check_message(char *buf, unsigned int length);
+extern unsigned int smb2_calc_size(struct smb2_hdr *hdr);
 
 extern int smb2_check_receive(struct mid_q_entry *mid,
 			      struct TCP_Server_Info *server, bool log_error);
-- 
1.7.1
