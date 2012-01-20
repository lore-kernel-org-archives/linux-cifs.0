From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 05/50] CIFS: Add SMB2 transport routines
Date: Fri, 20 Jan 2012 12:34:26 +0400
Message-ID: <1327048511-2342-5-git-send-email-piastry@etersoft.ru>
References: <1327048511-2342-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1327048511-2342-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

And simplify smb_sendv to make it process SMB2 requests. It let us
send SMB2 negotiate message to the server.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifs_debug.h    |    3 +
 fs/cifs/cifsglob.h      |   18 +++
 fs/cifs/cifsproto.h     |   12 ++-
 fs/cifs/smb2misc.c      |   35 ++++++
 fs/cifs/smb2pdu.h       |   59 +++++++++
 fs/cifs/smb2proto.h     |   42 +++++++
 fs/cifs/smb2transport.c |  305 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/transport.c     |  142 +++++++++++++----------
 8 files changed, 554 insertions(+), 62 deletions(-)
 create mode 100644 fs/cifs/smb2misc.c
 create mode 100644 fs/cifs/smb2proto.h
 create mode 100644 fs/cifs/smb2transport.c

diff --git a/fs/cifs/cifs_debug.h b/fs/cifs/cifs_debug.h
index 8942b28..e9911bf 100644
--- a/fs/cifs/cifs_debug.h
+++ b/fs/cifs/cifs_debug.h
@@ -33,6 +33,9 @@ void cifs_dump_mids(struct TCP_Server_Info *);
 #endif
 extern int traceSMB;		/* flag which enables the function below */
 void dump_smb(struct smb_hdr *, int);
+#ifdef CONFIG_CIFS_SMB2
+void dump_smb2(struct smb2_hdr *smb_buf, int smb_buf_length);
+#endif
 #define CIFS_INFO	0x01
 #define CIFS_RC		0x02
 #define CIFS_TIMER	0x04
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 15c3a92..bb2af48 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -22,11 +22,15 @@
 #include <linux/in.h>
 #include <linux/in6.h>
 #include <linux/slab.h>
+#include <linux/mempool.h>
 #include <linux/workqueue.h>
 #include "cifs_fs_sb.h"
 #include "cifsacl.h"
 #include <crypto/internal/hash.h>
 #include <linux/scatterlist.h>
+#ifdef CONFIG_CIFS_SMB2
+#include "smb2pdu.h"
+#endif /* CONFIG_CIFS_SMB2 */
 
 /*
  * The sizes of various internal tables and strings
@@ -236,6 +240,12 @@ struct cifs_mnt_data {
 	int flags;
 };
 
+static inline unsigned int
+get_rfc1002_length(void *buf)
+{
+	return be32_to_cpu(*((__be32 *)buf));
+}
+
 struct TCP_Server_Info {
 	struct list_head tcp_ses_list;
 	struct list_head smb_ses_list;
@@ -307,6 +317,9 @@ struct TCP_Server_Info {
 	atomic_t in_send; /* requests trying to send */
 	atomic_t num_waiters;   /* blocked waiting to get in sendrecv */
 #endif
+#ifdef CONFIG_CIFS_SMB2
+	__u64 current_smb2_mid;         /* multiplex id - rotating counter */
+#endif
 };
 
 /*
@@ -693,6 +706,7 @@ struct mid_q_entry {
 	unsigned long when_sent; /* time when smb send finished */
 	unsigned long when_received; /* when demux complete (taken off wire) */
 #endif
+	bool is_smb2:1;		/* SMB2 mid */
 	mid_receive_t *receive; /* call receive callback */
 	mid_callback_t *callback; /* call completion callback */
 	void *callback_data;	/* general purpose pointer for callback */
@@ -835,6 +849,7 @@ static inline void free_dfs_info_array(struct dfs_info3_param *param,
 #define   MID_RETRY_NEEDED      8 /* session closed while this request out */
 #define   MID_RESPONSE_MALFORMED 0x10
 #define   MID_SHUTDOWN		 0x20
+#define   MID_NO_RESPONSE_NEEDED 0x40
 
 /* Types of response buffer returned from SendReceive2 */
 #define   CIFS_NO_BUFFER        0    /* Response buffer not returned */
@@ -843,6 +858,7 @@ static inline void free_dfs_info_array(struct dfs_info3_param *param,
 #define   CIFS_IOVEC            4    /* array of response buffers */
 
 /* Type of Request to SendReceive2 */
+#define   CIFS_STD_OP		0
 #define   CIFS_BLOCKING_OP      1    /* operation can block */
 #define   CIFS_ASYNC_OP         2    /* do not wait for response */
 #define   CIFS_TIMEOUT_MASK 0x003    /* only one of above set in req */
@@ -1028,4 +1044,6 @@ void cifs_oplock_break(struct work_struct *work);
 
 extern const struct slow_work_ops cifs_oplock_break_ops;
 
+extern mempool_t *cifs_mid_poolp;
+
 #endif	/* _CIFS_GLOB_H */
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 6f4e243..d1e30d9 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -36,7 +36,9 @@ extern void cifs_buf_release(void *);
 extern struct smb_hdr *cifs_small_buf_get(void);
 extern void cifs_small_buf_release(void *);
 extern int smb_send(struct TCP_Server_Info *, struct smb_hdr *,
-			unsigned int /* length */);
+		    unsigned int /* length */);
+extern int smb_sendv(struct TCP_Server_Info *server, struct kvec *iov,
+		     int n_vec);
 extern unsigned int _GetXid(void);
 extern void _FreeXid(unsigned int);
 #define GetXid()						\
@@ -68,6 +70,14 @@ extern char *cifs_compose_mount_options(const char *sb_mountdata,
 extern struct mid_q_entry *AllocMidQEntry(const struct smb_hdr *smb_buffer,
 					struct TCP_Server_Info *server);
 extern void DeleteMidQEntry(struct mid_q_entry *midEntry);
+extern void cifs_delete_mid(struct mid_q_entry *midEntry);
+extern int cifs_sync_mid_result(struct mid_q_entry *mid,
+				struct TCP_Server_Info *server);
+extern int cifs_wait_for_free_request(struct TCP_Server_Info *server,
+				      const int long_op);
+extern int cifs_wait_for_response(struct TCP_Server_Info *server,
+				  struct mid_q_entry *midQ);
+extern void cifs_wake_up_task(struct mid_q_entry *mid);
 extern int cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 			   unsigned int nvec, mid_receive_t *receive,
 			   mid_callback_t *callback, void *cbdata,
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
new file mode 100644
index 0000000..355fb15
--- /dev/null
+++ b/fs/cifs/smb2misc.c
@@ -0,0 +1,35 @@
+/*
+ *   fs/cifs/smb2misc.c
+ *
+ *   Copyright (C) International Business Machines  Corp., 2002,2011
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
+void
+dump_smb2(struct smb2_hdr *smb_buf, int smb_buf_length)
+{
+	dump_smb((struct smb_hdr *)smb_buf, smb_buf_length);
+}
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index e3e67bb..5ec0c9f 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -26,6 +26,65 @@
 #include <net/sock.h>
 
 /*
+ * Note that, due to trying to use names similar to the protocol specifications,
+ * there are many mixed case field names in the structures below.  Although
+ * this does not match typical Linux kernel style, it is necessary to be
+ * be able to match against the protocol specfication.
+ *
+ * SMB2 commands
+ * Some commands have minimal (wct=0,bcc=0), or uninteresting, responses
+ * (ie no useful data other than the SMB error code itself) and are marked such.
+ * Knowing this helps avoid response buffer allocations and copy in some cases.
+ */
+
+/* List is sent on wire as little endian */
+#define SMB2_NEGOTIATE		cpu_to_le16(0x0000)
+#define SMB2_SESSION_SETUP	cpu_to_le16(0x0001)
+#define SMB2_LOGOFF		cpu_to_le16(0x0002) /* trivial request/resp */
+#define SMB2_TREE_CONNECT	cpu_to_le16(0x0003)
+#define SMB2_TREE_DISCONNECT	cpu_to_le16(0x0004) /* trivial req/resp */
+#define SMB2_CREATE		cpu_to_le16(0x0005)
+#define SMB2_CLOSE		cpu_to_le16(0x0006)
+#define SMB2_FLUSH		cpu_to_le16(0x0007) /* trivial resp */
+#define SMB2_READ		cpu_to_le16(0x0008)
+#define SMB2_WRITE		cpu_to_le16(0x0009)
+#define SMB2_LOCK		cpu_to_le16(0x000A)
+#define SMB2_IOCTL		cpu_to_le16(0x000B)
+#define SMB2_CANCEL		cpu_to_le16(0x000C)
+#define SMB2_ECHO		cpu_to_le16(0x000D)
+#define SMB2_QUERY_DIRECTORY	cpu_to_le16(0x000E)
+#define SMB2_CHANGE_NOTIFY	cpu_to_le16(0x000F)
+#define SMB2_QUERY_INFO		cpu_to_le16(0x0010)
+#define SMB2_SET_INFO		cpu_to_le16(0x0011)
+#define SMB2_OPLOCK_BREAK	cpu_to_le16(0x0012)
+
+/* Same List of commands in host endian */
+#define SMB2NEGOTIATE		0x0000
+#define SMB2SESSION_SETUP	0x0001
+#define SMB2LOGOFF		0x0002 /* trivial request/resp */
+#define SMB2TREE_CONNECT	0x0003
+#define SMB2TREE_DISCONNECT	0x0004 /* trivial req/resp */
+#define SMB2CREATE		0x0005
+#define SMB2CLOSE		0x0006
+#define SMB2FLUSH		0x0007 /* trivial resp */
+#define SMB2READ		0x0008
+#define SMB2WRITE		0x0009
+#define SMB2LOCK		0x000A
+#define SMB2IOCTL		0x000B
+#define SMB2CANCEL		0x000C
+#define SMB2ECHO		0x000D
+#define SMB2QUERY_DIRECTORY	0x000E
+#define SMB2CHANGE_NOTIFY	0x000F
+#define SMB2QUERY_INFO		0x0010
+#define SMB2SET_INFO		0x0011
+#define SMB2OPLOCK_BREAK	0x0012
+
+#define NUMBER_OF_SMB2_COMMANDS	0x0013
+
+/* BB FIXME - analyze following length BB */
+#define MAX_SMB2_HDR_SIZE 0x78 /* 4 len + 64 hdr + (2*24 wct) + 2 bct + 2 pad */
+
+/*
  * SMB2 Header Definition
  *
  * "MBZ" :  Must be Zero
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
new file mode 100644
index 0000000..6cffdf1
--- /dev/null
+++ b/fs/cifs/smb2proto.h
@@ -0,0 +1,42 @@
+/*
+ *   fs/cifs/smb2proto.h
+ *
+ *   Copyright (c) International Business Machines  Corp., 2002, 2011
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
+#ifndef _SMB2PROTO_H
+#define _SMB2PROTO_H
+#include <linux/nls.h>
+#include <linux/key-type.h>
+
+struct statfs;
+
+/*
+ *****************************************************************
+ * All Prototypes
+ *****************************************************************
+ */
+extern int map_smb2_to_linux_error(struct smb2_hdr *smb2, int logErr);
+
+extern int smb2_sendrcv2(const unsigned int xid, struct cifs_ses *ses,
+			 struct kvec *vec, int nvec, int *ret_buf_type,
+			 int *status, const int flags);
+extern int smb2_sendrcv_norsp(const unsigned int xid, struct cifs_ses *ses,
+			      struct smb2_hdr *in_buf, int flags);
+
+#endif			/* _SMB2PROTO_H */
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
new file mode 100644
index 0000000..d7f1c05
--- /dev/null
+++ b/fs/cifs/smb2transport.c
@@ -0,0 +1,305 @@
+/*
+ *   fs/cifs/smb2transport.c
+ *
+ *   Copyright (C) International Business Machines  Corp., 2002, 2011
+ *   Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
+ *              Jeremy Allison (jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org) 2006
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
+
+#include <linux/fs.h>
+#include <linux/list.h>
+#include <linux/wait.h>
+#include <linux/net.h>
+#include <linux/delay.h>
+#include <linux/uaccess.h>
+#include <asm/processor.h>
+#include <linux/mempool.h>
+#include "smb2pdu.h"
+#include "cifsglob.h"
+#include "cifsproto.h"
+#include "smb2proto.h"
+#include "cifs_debug.h"
+#include "smb2status.h"
+
+static __u64
+smb2_get_mid(struct TCP_Server_Info *server)
+{
+	__u64 mid;
+
+	spin_lock(&GlobalMid_Lock);
+	mid = server->current_smb2_mid++;
+	spin_unlock(&GlobalMid_Lock);
+	return mid;
+} /* BB do we eventually need an SMB2 version of this routine? BB */
+
+/*
+ * Set message id for the request. Should be called after wait_for_free_request
+ * and when srv_mutex is held. iov array must have at least 1 element.
+ */
+static inline void
+smb2_seq_num_into_buf(struct TCP_Server_Info *server, struct kvec *iov)
+{
+	((struct smb2_hdr *)iov[0].iov_base)->MessageId = smb2_get_mid(server);
+}
+
+static struct mid_q_entry *
+smb2_mid_entry_alloc(const struct smb2_hdr *smb_buffer,
+		     struct TCP_Server_Info *server)
+{
+	struct mid_q_entry *temp;
+
+	if (server == NULL) {
+		cERROR(1, "Null TCP session in smb2_mid_entry_alloc");
+		return NULL;
+	}
+
+	temp = mempool_alloc(cifs_mid_poolp, GFP_NOFS);
+	if (temp == NULL)
+		return temp;
+	else {
+		memset(temp, 0, sizeof(struct mid_q_entry));
+		temp->mid = smb_buffer->MessageId;	/* always LE */
+		temp->pid = current->pid;
+		temp->command = smb_buffer->Command;	/* Always LE */
+		temp->when_alloc = jiffies;
+		temp->is_smb2 = true;
+
+		/*
+		 * The default is for the mid to be synchronous, so the
+		 * default callback just wakes up the current task.
+		 */
+		temp->callback = cifs_wake_up_task;
+		temp->callback_data = current;
+	}
+
+	atomic_inc(&midCount);
+	temp->mid_state = MID_REQUEST_ALLOCATED;
+	return temp;
+}
+
+static int
+smb2_get_mid_entry(struct cifs_ses *ses, struct smb2_hdr *buf,
+		   struct mid_q_entry **mid)
+{
+	if (ses->server->tcpStatus == CifsExiting)
+		return -ENOENT;
+
+	if (ses->server->tcpStatus == CifsNeedReconnect) {
+		cFYI(1, "tcp session dead - return to caller to retry");
+		return -EAGAIN;
+	}
+
+	if (ses->status != CifsGood) {
+		/* check if SMB2 session is bad because we are setting it up */
+		if ((buf->Command != SMB2_SESSION_SETUP) &&
+		    (buf->Command != SMB2_NEGOTIATE))
+			return -EAGAIN;
+		/* else ok - we are setting up session */
+	}
+	*mid = smb2_mid_entry_alloc(buf, ses->server);
+	if (*mid == NULL)
+		return -ENOMEM;
+	spin_lock(&GlobalMid_Lock);
+	list_add_tail(&(*mid)->qhead, &ses->server->pending_mid_q);
+	spin_unlock(&GlobalMid_Lock);
+	return 0;
+}
+
+static int
+smb2_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
+		   unsigned int receive_len, bool log_error)
+{
+	unsigned int len = get_rfc1002_length(mid->resp_buf);
+
+	dump_smb2(mid->resp_buf, min_t(u32, 80, len));
+	/* convert the length into a more usable form */
+	/* BB - uncomment with SMB2 signing implementation */
+	/* if ((receive_len > 24) &&
+	    (server->sec_mode & (SECMODE_SIGN_REQUIRED|SECMODE_SIGN_ENABLED))) {
+		if (smb2_verify_signature(mid->resp_buf, server))
+			cERROR(1, "Unexpected SMB signature");
+	} */
+
+	return map_smb2_to_linux_error(mid->resp_buf, log_error);
+}
+
+int
+smb2_sendrcv2(const unsigned int xid, struct cifs_ses *ses,
+	      struct kvec *iov, int n_vec, int *presp_buftype /* ret */,
+	      int *status /* ret SMB2 network status code */, const int flags)
+{
+	int rc = 0;
+	int long_op;
+	unsigned int receive_len;
+	struct mid_q_entry *midQ;
+	struct smb2_hdr *buf = iov[0].iov_base;
+
+	if (status)
+		*status = STATUS_SUCCESS;
+	long_op = flags & CIFS_TIMEOUT_MASK;
+
+	*presp_buftype = CIFS_NO_BUFFER;  /* no response buf yet */
+
+	if ((ses == NULL) || (ses->server == NULL)) {
+		cifs_small_buf_release(buf);
+		cERROR(1, "Null session");
+		return -EIO;
+	}
+
+	if (ses->server->tcpStatus == CifsExiting) {
+		cifs_small_buf_release(buf);
+		return -ENOENT;
+	}
+
+	rc = cifs_wait_for_free_request(ses->server, long_op);
+	if (rc) {
+		cifs_small_buf_release(buf);
+		return rc;
+	}
+
+	/*
+	 * Make sure that we sign in the same order that we send on this socket
+	 * and avoid races inside tcp sendmsg code that could cause corruption
+	 * of smb data.
+	 */
+
+	mutex_lock(&ses->server->srv_mutex);
+
+	smb2_seq_num_into_buf(ses->server, iov);
+
+	rc = smb2_get_mid_entry(ses, buf, &midQ);
+	if (rc) {
+		mutex_unlock(&ses->server->srv_mutex);
+		cifs_small_buf_release(buf);
+		wake_up(&ses->server->request_q);
+		return rc;
+	}
+	/* rc = smb2_sign_smb2(iov, n_vec, ses->server);
+	if (rc) {
+		mutex_unlock(&ses->server->srv_mutex);
+		cifs_small_buf_release(buf);
+		goto out;
+	} */
+
+	midQ->mid_state = MID_REQUEST_SUBMITTED;
+	cifs_in_send_inc(ses->server);
+	rc = smb_sendv(ses->server, iov, n_vec);
+	cifs_in_send_dec(ses->server);
+	cifs_save_when_sent(midQ);
+
+	mutex_unlock(&ses->server->srv_mutex);
+
+	if (rc < 0) {
+		cifs_small_buf_release(buf);
+		goto out;
+	}
+
+	if (long_op == CIFS_ASYNC_OP) {
+		cifs_small_buf_release(buf);
+		goto out;
+	}
+
+	rc = cifs_wait_for_response(ses->server, midQ);
+	if (rc != 0) {
+		/* BB send cancel message */
+		spin_lock(&GlobalMid_Lock);
+		if (midQ->mid_state == MID_REQUEST_SUBMITTED) {
+			midQ->callback = cifs_delete_mid;
+			spin_unlock(&GlobalMid_Lock);
+			cifs_small_buf_release(buf);
+			wake_up(&ses->server->request_q);
+			return rc;
+		}
+		spin_unlock(&GlobalMid_Lock);
+	}
+
+	cifs_small_buf_release(buf);
+
+	rc = cifs_sync_mid_result(midQ, ses->server);
+	if (rc) {
+		wake_up(&ses->server->request_q);
+		return rc;
+	}
+
+	if (!midQ->resp_buf || (midQ->mid_state != MID_RESPONSE_RECEIVED)) {
+		rc = -EIO;
+		cFYI(1, "Bad MID state?");
+		goto out;
+	}
+
+	buf = (struct smb2_hdr *)midQ->resp_buf;
+	receive_len = get_rfc1002_length(buf);
+
+	if (receive_len > CIFSMaxBufSize + MAX_SMB2_HDR_SIZE) {
+		cERROR(1, "Frame too large received.  Length: %d  Xid: %d",
+			receive_len, xid);
+		rc = -EIO;
+		goto out;
+	}
+
+	/* rcvd frame is ok */
+
+	iov[0].iov_base = (char *)buf;
+	iov[0].iov_len = receive_len + 4;
+	if (midQ->large_buf)
+		*presp_buftype = CIFS_LARGE_BUFFER;
+	else
+		*presp_buftype = CIFS_SMALL_BUFFER;
+
+	rc = smb2_check_receive(midQ, ses->server, receive_len,
+				flags & CIFS_LOG_ERROR);
+
+	if (status)
+		*status = le32_to_cpu(buf->Status);
+
+	if ((flags & CIFS_NO_RESP) == 0)
+		/* mark it so buf will not be freed by free_smb2mid */
+		midQ->resp_buf = NULL;
+
+out:
+	cifs_delete_mid(midQ);
+	wake_up(&ses->server->request_q);
+	return rc;
+}
+
+/*
+ * Send an SMB2 Request. No response info (other than return code) needs to
+ * be parsed.
+ *
+ * flags indicate the type of request buffer and how long to wait
+ * and whether to log NT STATUS code (error) before mapping it to POSIX error.
+ */
+int
+smb2_sendrcv_norsp(const unsigned int xid, struct cifs_ses *ses,
+		   struct smb2_hdr *in_buf, int flags)
+{
+	int rc;
+	struct kvec iov[1];
+	int resp_buf_type;
+
+	iov[0].iov_base = (char *)in_buf;
+	iov[0].iov_len = get_rfc1002_length(in_buf) + 4;
+	flags |= CIFS_NO_RESP;
+	rc = smb2_sendrcv2(xid, ses, iov, 1, &resp_buf_type, NULL, flags);
+	/* BB remove the following debug line eventually */
+	cFYI(1, "%s flags %d rc %d", __func__, flags, rc);
+
+	return rc;
+}
+
+/* BB add missing functions here */
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index f3f98ad..f7ac3f0 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -35,10 +35,8 @@
 #include "cifsproto.h"
 #include "cifs_debug.h"
 
-extern mempool_t *cifs_mid_poolp;
-
-static void
-wake_up_task(struct mid_q_entry *mid)
+void
+cifs_wake_up_task(struct mid_q_entry *mid)
 {
 	wake_up_process(mid->callback_data);
 }
@@ -70,7 +68,7 @@ AllocMidQEntry(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
 		 * The default is for the mid to be synchronous, so the
 		 * default callback just wakes up the current task.
 		 */
-		temp->callback = wake_up_task;
+		temp->callback = cifs_wake_up_task;
 		temp->callback_data = current;
 	}
 
@@ -83,7 +81,15 @@ void
 DeleteMidQEntry(struct mid_q_entry *midEntry)
 {
 #ifdef CONFIG_CIFS_STATS2
+	__le16 command;
 	unsigned long now;
+
+#ifdef CONFIG_CIFS_SMB2
+	if (midEntry->is_smb2)
+		command = SMB2_LOCK;
+	else
+#endif
+		command = cpu_to_le16(SMB_COM_LOCKING_ANDX);
 #endif
 	midEntry->mid_state = MID_FREE;
 	atomic_dec(&midCount);
@@ -98,8 +104,7 @@ DeleteMidQEntry(struct mid_q_entry *midEntry)
 	 * something is wrong, unless it is quite a slow link or server.
 	 */
 	if ((now - midEntry->when_alloc) > HZ) {
-		if ((cifsFYI & CIFS_TIMER) &&
-		    (midEntry->command != cpu_to_le16(SMB_COM_LOCKING_ANDX))) {
+		if ((cifsFYI & CIFS_TIMER) && (midEntry->command != command)) {
 			printk(KERN_DEBUG " CIFS slow rsp: cmd %d mid %llu",
 			       midEntry->command, midEntry->mid);
 			printk(" A: 0x%lx S: 0x%lx R: 0x%lx\n",
@@ -112,8 +117,8 @@ DeleteMidQEntry(struct mid_q_entry *midEntry)
 	mempool_free(midEntry, cifs_mid_poolp);
 }
 
-static void
-delete_mid(struct mid_q_entry *mid)
+void
+cifs_delete_mid(struct mid_q_entry *mid)
 {
 	spin_lock(&GlobalMid_Lock);
 	list_del(&mid->qhead);
@@ -122,18 +127,24 @@ delete_mid(struct mid_q_entry *mid)
 	DeleteMidQEntry(mid);
 }
 
-static int
+int
 smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
 {
 	int rc = 0;
 	int i = 0;
 	struct msghdr smb_msg;
+	__be32 *buf_length = (__be32 *)iov[0].iov_base;
 	struct smb_hdr *smb_buffer = iov[0].iov_base;
+#ifdef CONFIG_CIFS_SMB2
+	struct smb2_hdr *smb2_buffer = iov[0].iov_base;
+#endif
 	unsigned int len = iov[0].iov_len;
 	unsigned int total_len;
 	int first_vec = 0;
-	unsigned int smb_buf_length = be32_to_cpu(smb_buffer->smb_buf_length);
 	struct socket *ssocket = server->ssocket;
+	unsigned int smb_buf_length;
+
+	smb_buf_length = get_rfc1002_length(iov[0].iov_base);
 
 	if (ssocket == NULL)
 		return -ENOTSOCK; /* BB eventually add reconnect code here */
@@ -152,7 +163,12 @@ smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
 		total_len += iov[i].iov_len;
 
 	cFYI(1, "Sending smb:  total_len %d", total_len);
-	dump_smb(smb_buffer, len);
+#ifdef CONFIG_CIFS_SMB2
+	if (server->is_smb2)
+		dump_smb2(smb2_buffer, len);
+	else
+#endif
+		dump_smb(smb_buffer, len);
 
 	i = 0;
 	while (total_len) {
@@ -160,24 +176,25 @@ smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
 				    n_vec - first_vec, total_len);
 		if ((rc == -ENOSPC) || (rc == -EAGAIN)) {
 			i++;
-			/* if blocking send we try 3 times, since each can block
-			   for 5 seconds. For nonblocking  we have to try more
-			   but wait increasing amounts of time allowing time for
-			   socket to clear.  The overall time we wait in either
-			   case to send on the socket is about 15 seconds.
-			   Similarly we wait for 15 seconds for
-			   a response from the server in SendReceive[2]
-			   for the server to send a response back for
-			   most types of requests (except SMB Write
-			   past end of file which can be slow, and
-			   blocking lock operations). NFS waits slightly longer
-			   than CIFS, but this can make it take longer for
-			   nonresponsive servers to be detected and 15 seconds
-			   is more than enough time for modern networks to
-			   send a packet.  In most cases if we fail to send
-			   after the retries we will kill the socket and
-			   reconnect which may clear the network problem.
-			*/
+			/*
+			 * If blocking send we try 3 times, since each can block
+			 * for 5 seconds. For nonblocking  we have to try more
+			 * but wait increasing amounts of time allowing time for
+			 * socket to clear.  The overall time we wait in either
+			 * case to send on the socket is about 15 seconds.
+			 * Similarly we wait for 15 seconds for
+			 * a response from the server in SendReceive[2]
+			 * for the server to send a response back for
+			 * most types of requests (except SMB Write
+			 * past end of file which can be slow, and
+			 * blocking lock operations). NFS waits slightly longer
+			 * than CIFS, but this can make it take longer for
+			 * nonresponsive servers to be detected and 15 seconds
+			 * is more than enough time for modern networks to
+			 * send a packet.  In most cases if we fail to send
+			 * after the retries we will kill the socket and
+			 * reconnect which may clear the network problem.
+			 */
 			if ((i >= 14) || (!server->noblocksnd && (i > 2))) {
 				cERROR(1, "sends on sock %p stuck for 15 seconds",
 				    ssocket);
@@ -198,8 +215,10 @@ smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
 			break;
 		}
 		if (rc == 0) {
-			/* should never happen, letting socket clear before
-			   retrying is our only obvious option here */
+			/*
+			 * Should never happen, letting socket clear before
+			 * retrying is our only obvious option here.
+			 */
 			cERROR(1, "tcp sent no data");
 			msleep(500);
 			continue;
@@ -225,10 +244,12 @@ smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
 	if ((total_len > 0) && (total_len != smb_buf_length + 4)) {
 		cFYI(1, "partial send (%d remaining), terminating session",
 			total_len);
-		/* If we have only sent part of an SMB then the next SMB
-		   could be taken as the remainder of this one.  We need
-		   to kill the socket so the server throws away the partial
-		   SMB */
+		/*
+		 * If we have only sent part of an SMB then the next SMB
+		 * could be taken as the remainder of this one.  We need
+		 * to kill the socket so the server throws away the partial
+		 * SMB.
+		 */
 		server->tcpStatus = CifsNeedReconnect;
 	}
 
@@ -237,9 +258,8 @@ smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
 	else
 		rc = 0;
 
-	/* Don't want to modify the buffer as a
-	   side effect of this call. */
-	smb_buffer->smb_buf_length = cpu_to_be32(smb_buf_length);
+	/* Don't want to modify the buffer as a side effect of this call. */
+	*buf_length = cpu_to_be32(smb_buf_length);
 
 	return rc;
 }
@@ -256,8 +276,8 @@ smb_send(struct TCP_Server_Info *server, struct smb_hdr *smb_buffer,
 	return smb_sendv(server, &iov, 1);
 }
 
-static int
-wait_for_free_request(struct TCP_Server_Info *server, const int long_op)
+int
+cifs_wait_for_free_request(struct TCP_Server_Info *server, const int long_op)
 {
 	if (long_op == CIFS_ASYNC_OP) {
 		/* oplock breaks must not be held up */
@@ -322,8 +342,8 @@ static int allocate_mid(struct cifs_ses *ses, struct smb_hdr *in_buf,
 	return 0;
 }
 
-static int
-wait_for_response(struct TCP_Server_Info *server, struct mid_q_entry *midQ)
+int
+cifs_wait_for_response(struct TCP_Server_Info *server, struct mid_q_entry *midQ)
 {
 	int error;
 
@@ -335,7 +355,6 @@ wait_for_response(struct TCP_Server_Info *server, struct mid_q_entry *midQ)
 	return 0;
 }
 
-
 /*
  * Send a SMB request and set the callback function in the mid to handle
  * the result. Caller is responsible for dealing with timeouts.
@@ -349,7 +368,8 @@ cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 	struct mid_q_entry *mid;
 	struct smb_hdr *hdr = (struct smb_hdr *)iov[0].iov_base;
 
-	rc = wait_for_free_request(server, ignore_pend ? CIFS_ASYNC_OP : 0);
+	rc = cifs_wait_for_free_request(server,
+					ignore_pend ? CIFS_ASYNC_OP : 0);
 	if (rc)
 		return rc;
 
@@ -393,7 +413,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 
 	return rc;
 out_err:
-	delete_mid(mid);
+	cifs_delete_mid(mid);
 	atomic_dec(&server->inFlight);
 	wake_up(&server->request_q);
 	return rc;
@@ -425,7 +445,7 @@ SendReceiveNoRsp(const unsigned int xid, struct cifs_ses *ses,
 	return rc;
 }
 
-static int
+int
 cifs_sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
 {
 	int rc = 0;
@@ -550,7 +570,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 	   to the same server. We may make this configurable later or
 	   use ses->maxReq */
 
-	rc = wait_for_free_request(ses->server, long_op);
+	rc = cifs_wait_for_free_request(ses->server, long_op);
 	if (rc) {
 		cifs_small_buf_release(in_buf);
 		return rc;
@@ -596,7 +616,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 		goto out;
 	}
 
-	rc = wait_for_response(ses->server, midQ);
+	rc = cifs_wait_for_response(ses->server, midQ);
 	if (rc != 0) {
 		send_nt_cancel(ses->server, in_buf, midQ);
 		spin_lock(&GlobalMid_Lock);
@@ -636,11 +656,11 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 
 	rc = cifs_check_receive(midQ, ses->server, flags & CIFS_LOG_ERROR);
 
-	/* mark it so buf will not be freed by delete_mid */
+	/* mark it so buf will not be freed by cifs_delete_mid */
 	if ((flags & CIFS_NO_RESP) == 0)
 		midQ->resp_buf = NULL;
 out:
-	delete_mid(midQ);
+	cifs_delete_mid(midQ);
 	atomic_dec(&ses->server->inFlight);
 	wake_up(&ses->server->request_q);
 
@@ -679,7 +699,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 		return -EIO;
 	}
 
-	rc = wait_for_free_request(ses->server, long_op);
+	rc = cifs_wait_for_free_request(ses->server, long_op);
 	if (rc)
 		return rc;
 
@@ -718,7 +738,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	if (long_op == CIFS_ASYNC_OP)
 		goto out;
 
-	rc = wait_for_response(ses->server, midQ);
+	rc = cifs_wait_for_response(ses->server, midQ);
 	if (rc != 0) {
 		send_nt_cancel(ses->server, in_buf, midQ);
 		spin_lock(&GlobalMid_Lock);
@@ -752,7 +772,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	memcpy(out_buf, buf, *pbytes_returned + 4);
 	rc = cifs_check_receive(midQ, ses->server, 0);
 out:
-	delete_mid(midQ);
+	cifs_delete_mid(midQ);
 	atomic_dec(&ses->server->inFlight);
 	wake_up(&ses->server->request_q);
 
@@ -820,7 +840,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 		return -EIO;
 	}
 
-	rc = wait_for_free_request(ses->server, CIFS_BLOCKING_OP);
+	rc = cifs_wait_for_free_request(ses->server, CIFS_BLOCKING_OP);
 	if (rc)
 		return rc;
 
@@ -838,7 +858,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 
 	rc = cifs_sign_smb(in_buf, ses->server, &midQ->sequence_number);
 	if (rc) {
-		delete_mid(midQ);
+		cifs_delete_mid(midQ);
 		mutex_unlock(&ses->server->srv_mutex);
 		return rc;
 	}
@@ -851,7 +871,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	mutex_unlock(&ses->server->srv_mutex);
 
 	if (rc < 0) {
-		delete_mid(midQ);
+		cifs_delete_mid(midQ);
 		return rc;
 	}
 
@@ -872,7 +892,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 			   blocking lock to return. */
 			rc = send_nt_cancel(ses->server, in_buf, midQ);
 			if (rc) {
-				delete_mid(midQ);
+				cifs_delete_mid(midQ);
 				return rc;
 			}
 		} else {
@@ -884,12 +904,12 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 			/* If we get -ENOLCK back the lock may have
 			   already been removed. Don't exit in this case. */
 			if (rc && rc != -ENOLCK) {
-				delete_mid(midQ);
+				cifs_delete_mid(midQ);
 				return rc;
 			}
 		}
 
-		rc = wait_for_response(ses->server, midQ);
+		rc = cifs_wait_for_response(ses->server, midQ);
 		if (rc) {
 			send_nt_cancel(ses->server, in_buf, midQ);
 			spin_lock(&GlobalMid_Lock);
@@ -922,7 +942,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	memcpy(out_buf, buf, *pbytes_returned + 4);
 	rc = cifs_check_receive(midQ, ses->server, 0);
 out:
-	delete_mid(midQ);
+	cifs_delete_mid(midQ);
 	if (rstart && rc == -EACCES)
 		return -ERESTARTSYS;
 	return rc;
-- 
1.7.1
