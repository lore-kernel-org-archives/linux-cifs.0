From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 10/16] CIFS: Add capability to send SMB2 negotiate message
Date: Mon, 26 Mar 2012 13:21:37 +0400
Message-ID: <1332753703-4315-11-git-send-email-piastry@etersoft.ru>
References: <1332753703-4315-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1332753703-4315-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

and temporarily disable SMB2.1 negotiating.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/Makefile    |    2 +-
 fs/cifs/cifsglob.h  |   11 +-
 fs/cifs/cifsproto.h |    1 +
 fs/cifs/cifssmb.c   |    8 +-
 fs/cifs/connect.c   |   21 +++-
 fs/cifs/misc.c      |    3 +-
 fs/cifs/sess.c      |    2 +-
 fs/cifs/smb2misc.c  |    8 +-
 fs/cifs/smb2pdu.c   |  385 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.h   |   39 +++++
 fs/cifs/smb2proto.h |    8 +
 11 files changed, 475 insertions(+), 13 deletions(-)
 create mode 100644 fs/cifs/smb2pdu.c

diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
index 5bbafe4..2af9cbb 100644
--- a/fs/cifs/Makefile
+++ b/fs/cifs/Makefile
@@ -16,4 +16,4 @@ cifs-$(CONFIG_CIFS_DFS_UPCALL) += dns_resolve.o cifs_dfs_ref.o
 
 cifs-$(CONFIG_CIFS_FSCACHE) += fscache.o cache.o
 
-cifs-$(CONFIG_CIFS_SMB2) += smb2maperror.o smb2transport.o smb2misc.o
+cifs-$(CONFIG_CIFS_SMB2) += smb2maperror.o smb2transport.o smb2misc.o smb2pdu.o
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 658280e..49f6a57 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -269,7 +269,7 @@ struct TCP_Server_Info {
 	struct mutex srv_mutex;
 	struct task_struct *tsk;
 	char server_GUID[16];
-	char sec_mode;
+	__u16 sec_mode;
 	bool session_estab; /* mark when very first sess is established */
 #ifdef CONFIG_CIFS_SMB2
 	bool is_smb2;	/* SMB2 not CIFS protocol negotiated */
@@ -322,6 +322,10 @@ struct TCP_Server_Info {
 	atomic_t in_send; /* requests trying to send */
 	atomic_t num_waiters;   /* blocked waiting to get in sendrecv */
 #endif
+#ifdef CONFIG_CIFS_SMB2
+	unsigned int	max_read;
+	unsigned int	max_write;
+#endif /* CONFIG_CIFS_SMB2 */
 };
 
 static inline unsigned int
@@ -336,7 +340,8 @@ in_flight(struct TCP_Server_Info *server)
 
 #define   CIFS_OBREAK_OP    0x080    /* oplock break request */
 #define   CIFS_ECHO_OP     0x0100    /* echo request */
-#define   CIFS_REQ_MASK    0x0180    /* mask request type */
+#define   CIFS_NEG_OP      0x0200    /* negotiate request */
+#define   CIFS_REQ_MASK    0x0380    /* mask request type */
 
 static inline int*
 get_credits_field(struct TCP_Server_Info *server, const int optype)
@@ -432,7 +437,7 @@ struct cifs_ses {
 	char *serverOS;		/* name of operating system underlying server */
 	char *serverNOS;	/* name of network operating system of server */
 	char *serverDomain;	/* security realm of server */
-	int Suid;		/* remote smb uid  */
+	__u64 Suid;		/* remote smb uid  */
 	uid_t linux_uid;        /* overriding owner of files on the mount */
 	uid_t cred_uid;		/* owner of credentials */
 	int capabilities;
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index b92e4ab..5378311 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -178,6 +178,7 @@ extern struct smb_vol *cifs_get_volume_info(char *mount_data,
 					    const char *devname);
 extern int cifs_mount(struct cifs_sb_info *, struct smb_vol *);
 extern void cifs_umount(struct cifs_sb_info *);
+extern void cifs_mark_open_files_invalid(struct cifs_tcon *tcon);
 
 #if IS_ENABLED(CONFIG_CIFS_DFS_UPCALL)
 extern void cifs_dfs_release_automount_timer(void);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index e858d9c..c97dcdc 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -91,7 +91,7 @@ static void cifs_readv_complete(struct work_struct *work);
 
 /* Mark as invalid, all open files on tree connections since they
    were closed when session to server was lost */
-static void mark_open_files_invalid(struct cifs_tcon *pTcon)
+void cifs_mark_open_files_invalid(struct cifs_tcon *tcon)
 {
 	struct cifsFileInfo *open_file = NULL;
 	struct list_head *tmp;
@@ -99,7 +99,7 @@ static void mark_open_files_invalid(struct cifs_tcon *pTcon)
 
 /* list all files open on tree connection and mark them invalid */
 	spin_lock(&cifs_file_list_lock);
-	list_for_each_safe(tmp, tmp1, &pTcon->openFileList) {
+	list_for_each_safe(tmp, tmp1, &tcon->openFileList) {
 		open_file = list_entry(tmp, struct cifsFileInfo, tlist);
 		open_file->invalidHandle = true;
 		open_file->oplock_break_cancelled = true;
@@ -186,7 +186,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 		goto out;
 	}
 
-	mark_open_files_invalid(tcon);
+	cifs_mark_open_files_invalid(tcon);
 	rc = CIFSTCon(0, ses, tcon->treeName, tcon, nls_codepage);
 	mutex_unlock(&ses->session_mutex);
 	cFYI(1, "reconnect tcon rc = %d", rc);
@@ -457,7 +457,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_ses *ses)
 			rc = -EOPNOTSUPP;
 			goto neg_err_exit;
 		}
-		server->sec_mode = (__u8)le16_to_cpu(rsp->SecurityMode);
+		server->sec_mode = le16_to_cpu(rsp->SecurityMode);
 		server->maxReq = min_t(unsigned int,
 				       le16_to_cpu(rsp->MaxMpxCount),
 				       cifs_max_pending);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 7a7ef74..c59d051 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -4124,11 +4124,26 @@ int cifs_negotiate_protocol(unsigned int xid, struct cifs_ses *ses)
 	int rc = 0;
 	struct TCP_Server_Info *server = ses->server;
 
+	cifs_set_credits(server, 1);
+
+#ifdef CONFIG_CIFS_SMB2
+	if (ses->server->is_smb2) {
+		if (server->max_read != 0)
+			return 0;
+		server->CurrentMid = 0;
+		rc = SMB2_negotiate(xid, ses);
+		/* BB we probably don't need to retry with modern servers */
+		if (rc == -EAGAIN)
+			rc = -EHOSTDOWN;
+
+		goto neg_prot_exit;
+	}
+#endif /* CONFIG_CIFS_SMB2 */
+
 	/* only send once per connect */
 	if (server->maxBuf != 0)
 		return 0;
 
-	cifs_set_credits(server, 1);
 	rc = CIFSSMBNegotiate(xid, ses);
 	if (rc == -EAGAIN) {
 		/* retry only once on 1st time connection */
@@ -4137,6 +4152,10 @@ int cifs_negotiate_protocol(unsigned int xid, struct cifs_ses *ses)
 		if (rc == -EAGAIN)
 			rc = -EHOSTDOWN;
 	}
+
+#ifdef CONFIG_CIFS_SMB2
+neg_prot_exit:
+#endif /* CONFIG_CIFS_SMB2 */
 	if (rc == 0) {
 		spin_lock(&GlobalMid_Lock);
 		if (server->tcpStatus == CifsNeedNegotiate)
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index cd587c0..fd8bef7 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -777,7 +777,8 @@ cifs_add_credits(struct TCP_Server_Info *server, const unsigned int add,
 	*val += add;
 	server->in_flight--;
 #ifdef CONFIG_CIFS_SMB2
-	if (server->is_smb2 && server->in_flight == 0) {
+	if (server->is_smb2 && server->in_flight == 0 &&
+	    (optype & CIFS_REQ_MASK) != CIFS_NEG_OP) {
 		server->credits += server->echo_credits +
 				   server->oplock_credits;
 		cifs_change_conf(server);
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 551d0c2..f88fa4d 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -898,7 +898,7 @@ ssetup_ntlmssp_authenticate:
 	if (action & GUEST_LOGIN)
 		cFYI(1, "Guest login"); /* BB mark SesInfo struct? */
 	ses->Suid = smb_buf->Uid;   /* UID left in wire format (le) */
-	cFYI(1, "UID = %d ", ses->Suid);
+	cFYI(1, "UID = %llu ", ses->Suid);
 	/* response can have either 3 or 4 word count - Samba sends 3 */
 	/* and lanman response is 3 */
 	bytes_remaining = get_bcc(smb_buf);
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index db9ecd5..88918ac 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -198,8 +198,7 @@ static const bool has_smb2_data_area[NUMBER_OF_SMB2_COMMANDS] = {
  * Returns the pointer to the beginning of the data area. Length of the data
  * area and the offset to it (from the beginning of the smb are also returned.
  */
-static char *
-smb2_get_data_area_len(int *poff, int *plen, struct smb2_hdr *pSMB2)
+char *smb2_get_data_area_len(int *poff, int *plen, struct smb2_hdr *pSMB2)
 {
 	*poff = 0;
 	*plen = 0;
@@ -217,6 +216,11 @@ smb2_get_data_area_len(int *poff, int *plen, struct smb2_hdr *pSMB2)
 	 */
 	switch (pSMB2->Command) {
 	case SMB2_NEGOTIATE:
+		*poff = le16_to_cpu(
+		    ((struct smb2_negotiate_rsp *)pSMB2)->SecurityBufferOffset);
+		*plen = le16_to_cpu(
+		    ((struct smb2_negotiate_rsp *)pSMB2)->SecurityBufferLength);
+		break;
 	case SMB2_SESSION_SETUP:
 	case SMB2_CREATE:
 	case SMB2_READ:
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
new file mode 100644
index 0000000..1a12e7f
--- /dev/null
+++ b/fs/cifs/smb2pdu.c
@@ -0,0 +1,385 @@
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
+ *  indexed by command in host byte order
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
+/*
+ * NB: MID can not be set if tcon not passed in, in that
+ * case it is responsbility of caller to set the mid
+ */
+static void
+smb2_hdr_assemble(struct smb2_hdr *buffer, __le16 smb2_cmd /* command */ ,
+		  const struct cifs_tcon *tcon)
+{
+	struct list_head *temp_item;
+	struct cifs_ses *ses;
+	struct smb2_pdu *smb = (struct smb2_pdu *)buffer;
+	char *temp = (char *) buffer;
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
+	buffer->smb2_buf_length = cpu_to_be32(parmsize + sizeof(struct smb2_hdr)
+			- 4 /*  RFC 1001 length field itself not counted */);
+
+	buffer->ProtocolId[0] = 0xFE;
+	buffer->ProtocolId[1] = 'S';
+	buffer->ProtocolId[2] = 'M';
+	buffer->ProtocolId[3] = 'B';
+	buffer->StructureSize = cpu_to_le16(64);
+	buffer->Command = smb2_cmd;
+	buffer->CreditRequest = cpu_to_le16(2); /* BB make this dynamic */
+	buffer->ProcessId = cpu_to_le32((__u16)current->tgid);
+
+	if (!tcon)
+		goto out;
+
+	buffer->TreeId = tcon->tid;
+	/* For the multiuser case, there are few obvious technically  */
+	/* possible mechanisms to match the local linux user (uid)    */
+	/* to a valid remote smb user (smb_uid):		      */
+	/*      1) Query Winbind (or other local pam/nss daemon       */
+	/*         for userid/password/logon_domain or credential      */
+	/*      2) Query Winbind for uid to sid to username mapping   */
+	/*         and see if we have a matching password for existing*/
+	/*         session for that user perhas getting password by   */
+	/*         adding a new pam_smb2 module that stores passwords */
+	/*         so that the smb2 vfs can get at that for all logged*/
+	/*         on users					      */
+	/*      3) (Which is the mechanism we have chosen)	      */
+	/*         Search through sessions to the same server for a   */
+	/*         a match on the uid that was passed in on mount     */
+	/*         with the current processes uid (or euid?) and use  */
+	/*         that smb uid.   If no existing smb session for     */
+	/*         that uid found, use the default smb session ie     */
+	/*         the smb session for the volume mounted which is    */
+	/*         the same as would be used if the multiuser mount   */
+	/*         flag were disabled.  */
+
+	/*  BB Add support for establishing new tcon and SMB Session  */
+	/*      with userid/password pairs found on the smb session   */
+	/*      for other target tcp/ip addresses		BB    */
+	if (!tcon->ses)
+		goto set_tcon_flags;
+
+	/* Uid is not converted */
+	buffer->SessionId = tcon->ses->Suid;
+	/* BB check this against related recent cifs changes */
+	if (multiuser_mount == 0)
+		goto set_tcon_flags;
+
+	if (current_fsuid() == tcon->ses->linux_uid)
+		goto set_tcon_flags;
+
+	cFYI(1, "Multiuser mode and UID did not match tcon uid");
+	spin_lock(&cifs_tcp_ses_lock);
+	list_for_each(temp_item,
+		      &tcon->ses->server->smb_ses_list) {
+		ses = list_entry(temp_item, struct cifs_ses,
+				 smb_ses_list);
+		if (ses->linux_uid == current_fsuid()) {
+			if (ses->server == tcon->ses->server) {
+				buffer->SessionId = ses->Suid;
+				break;
+			}
+			/* BB eventually setup a session here */
+			cFYI(1, "local UID found but no smb ses server exists");
+		}
+	}
+	spin_unlock(&cifs_tcp_ses_lock);
+set_tcon_flags:
+	/* BB check following DFS flags BB */
+	/* BB do we have to add check for SHI1005_FLAGS_DFS_ROOT too? */
+	/* if (tcon->share_flags & SHI1005_FLAGS_DFS)
+		buffer->Flags |= SMB2_FLAGS_DFS_OPERATIONS; */
+	/* BB how does SMB2 do case sensitive? */
+	/* if (tcon->nocase)
+		buffer->Flags |= SMBFLG_CASELESS; */
+	/* if (tcon->ses && tcon->ses->server &&
+	    (tcon->ses->server->sec_mode & SECMODE_SIGN_REQUIRED))
+		buffer->Flags |= SMB2_FLAGS_SIGNED; */
+out:
+	smb->StructureSize2 = cpu_to_le16(parmsize);
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
+ * Allocate and return pointer to an SMB request buffer, and set basic
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
+static void free_rsp_buf(int resp_buftype, void *pSMB2r)
+{
+	if (resp_buftype == CIFS_SMALL_BUFFER)
+		cifs_small_buf_release(pSMB2r);
+	else if (resp_buftype == CIFS_LARGE_BUFFER)
+		cifs_buf_release(pSMB2r);
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
+SMB2_negotiate(unsigned int xid, struct cifs_ses *ses)
+{
+	struct smb2_negotiate_req *pSMB2;
+	struct smb2_negotiate_rsp *pSMB2r;
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
+	rc = small_smb2_init(SMB2_NEGOTIATE, NULL, (void **) &pSMB2);
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
+	pSMB2->hdr.SessionId = 0;
+
+	for (i = 0; i < SMB2_NUM_PROT; i++)
+		pSMB2->Dialects[i] = smb2protocols[i].name;
+
+	pSMB2->DialectCount = cpu_to_le16(i);
+	pSMB2->hdr.smb2_buf_length =
+		cpu_to_be32(be32_to_cpu(pSMB2->hdr.smb2_buf_length) + (i * 2));
+
+	/* only one of SMB2 signing flags may be set in SMB2 request */
+	if ((sec_flags & CIFSSEC_MUST_SIGN) == CIFSSEC_MUST_SIGN)
+		temp = SMB2_NEGOTIATE_SIGNING_REQUIRED;
+	else if (sec_flags & CIFSSEC_MAY_SIGN) /* MAY_SIGN is a single flag */
+		temp = SMB2_NEGOTIATE_SIGNING_ENABLED;
+
+	pSMB2->SecurityMode = cpu_to_le16(temp);
+
+	pSMB2->Capabilities = cpu_to_le32(SMB2_GLOBAL_CAP_DFS);
+
+	iov[0].iov_base = (char *)pSMB2;
+	iov[0].iov_len = be32_to_cpu(pSMB2->hdr.smb2_buf_length) + 4;
+
+	rc = SendReceive2(xid, ses, iov, 1, &resp_buftype, flags);
+
+	pSMB2r = (struct smb2_negotiate_rsp *)iov[0].iov_base;
+	/*
+	 * No tcon so can't do
+	 * cifs_stats_inc(&tcon->stats.smb2_stats.smb2_com_fail[SMB2...]);
+	 */
+	if (rc != 0)
+		goto neg_exit;
+
+	if (pSMB2r == NULL) {
+		rc = -EIO;
+		goto neg_exit;
+	}
+
+	cFYI(1, "mode 0x%x", pSMB2r->SecurityMode);
+
+	if (pSMB2r->DialectRevision == smb2protocols[SMB21_PROT].name)
+		cFYI(1, "negotiated smb2.1 dialect");
+	else if (pSMB2r->DialectRevision == smb2protocols[SMB2_PROT].name)
+		cFYI(1, "negotiated smb2 dialect");
+	else {
+		cERROR(1, "Illegal dialect returned by server %d",
+			   le16_to_cpu(pSMB2r->DialectRevision));
+		rc = -EIO;
+		goto neg_exit;
+	}
+	ses->server->dialect = le16_to_cpu(pSMB2r->DialectRevision);
+
+	ses->server->maxBuf = le32_to_cpu(pSMB2r->MaxTransactSize);
+	ses->server->max_read = le32_to_cpu(pSMB2r->MaxReadSize);
+	ses->server->max_write = le32_to_cpu(pSMB2r->MaxWriteSize);
+	/* BB Do we need to validate the SecurityMode? */
+	ses->server->sec_mode = le16_to_cpu(pSMB2r->SecurityMode);
+	ses->server->capabilities = le32_to_cpu(pSMB2r->Capabilities);
+
+	security_blob = smb2_get_data_area_len(&blob_offset, &blob_length,
+					       &pSMB2r->hdr);
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
+	free_rsp_buf(resp_buftype, pSMB2r);
+	return rc;
+}
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 66ab8d6..65be640 100644
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
index 1c7c8e4..bc283ff 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -35,10 +35,18 @@ struct statfs;
 extern int map_smb2_to_linux_error(struct smb2_hdr *smb2, int log_err);
 extern int checkSMB2(char *buf, unsigned int length);
 extern unsigned int smb2_calc_size(struct smb2_hdr *pSMB2h);
+extern char *smb2_get_data_area_len(int *poff, int *plen,
+				     struct smb2_hdr *pSMB2);
 
 extern int smb2_check_receive(struct mid_q_entry *mid,
 			      struct TCP_Server_Info *server, bool log_error);
 extern int smb2_setup_request(struct cifs_ses *ses, struct kvec *iov,
 			      unsigned int nvec, struct mid_q_entry **ret_mid);
 
+/*
+ *  SMB2 Worker functions - most of protocol specific implementation details
+ *  are contained within these calls
+ */
+extern int SMB2_negotiate(unsigned int xid, struct cifs_ses *ses);
+
 #endif			/* _SMB2PROTO_H */
-- 
1.7.1
