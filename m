From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v6 3/5] CIFS: Move protocol specific negotiate code to ops struct
Date: Wed, 20 Jun 2012 14:54:09 +0400
Message-ID: <1340189651-25093-4-git-send-email-pshilovsky@samba.org>
References: <1340189651-25093-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340189651-25093-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    8 ++++++--
 fs/cifs/cifsproto.h |    6 +++---
 fs/cifs/cifssmb.c   |    4 ++--
 fs/cifs/connect.c   |   24 +++++++++++-------------
 fs/cifs/sess.c      |    2 +-
 fs/cifs/smb1ops.c   |   23 +++++++++++++++++++++++
 6 files changed, 46 insertions(+), 21 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 844b77c..8a41505 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -192,6 +192,10 @@ struct smb_version_operations {
 	/* process transaction2 response */
 	bool (*check_trans2)(struct mid_q_entry *, struct TCP_Server_Info *,
 			     char *, int);
+	/* check if we need to negotiate */
+	bool (*need_neg)(struct TCP_Server_Info *);
+	/* negotiate to the server */
+	int (*negotiate)(const unsigned int, struct cifs_ses *);
 };
 
 struct smb_version_values {
@@ -324,7 +328,7 @@ struct TCP_Server_Info {
 	struct mutex srv_mutex;
 	struct task_struct *tsk;
 	char server_GUID[16];
-	char sec_mode;
+	__u16 sec_mode;
 	bool session_estab; /* mark when very first sess is established */
 	u16 dialect; /* dialect index that server chose */
 	enum securityEnum secType;
@@ -459,7 +463,7 @@ struct cifs_ses {
 	char *serverOS;		/* name of operating system underlying server */
 	char *serverNOS;	/* name of network operating system of server */
 	char *serverDomain;	/* security realm of server */
-	int Suid;		/* remote smb uid  */
+	__u64 Suid;		/* remote smb uid  */
 	uid_t linux_uid;        /* overriding owner of files on the mount */
 	uid_t cred_uid;		/* owner of credentials */
 	int capabilities;
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index f52074d..047b87e 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -178,11 +178,11 @@ extern void cifs_dfs_release_automount_timer(void);
 void cifs_proc_init(void);
 void cifs_proc_clean(void);
 
-extern int cifs_negotiate_protocol(unsigned int xid,
-				  struct cifs_ses *ses);
+extern int cifs_negotiate_protocol(const unsigned int xid,
+				   struct cifs_ses *ses);
 extern int cifs_setup_session(unsigned int xid, struct cifs_ses *ses,
 			struct nls_table *nls_info);
-extern int CIFSSMBNegotiate(unsigned int xid, struct cifs_ses *ses);
+extern int CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses);
 
 extern int CIFSTCon(unsigned int xid, struct cifs_ses *ses,
 			const char *tree, struct cifs_tcon *tcon,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 58f1ab5..56ec436 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -372,7 +372,7 @@ static inline void inc_rfc1001_len(void *pSMB, int count)
 }
 
 int
-CIFSSMBNegotiate(unsigned int xid, struct cifs_ses *ses)
+CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses)
 {
 	NEGOTIATE_REQ *pSMB;
 	NEGOTIATE_RSP *pSMBr;
@@ -456,7 +456,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_ses *ses)
 			rc = -EOPNOTSUPP;
 			goto neg_err_exit;
 		}
-		server->sec_mode = (__u8)le16_to_cpu(rsp->SecurityMode);
+		server->sec_mode = le16_to_cpu(rsp->SecurityMode);
 		server->maxReq = min_t(unsigned int,
 				       le16_to_cpu(rsp->MaxMpxCount),
 				       cifs_max_pending);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index b26f85c..ec05a08 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -406,7 +406,7 @@ cifs_echo_request(struct work_struct *work)
 	 * done, which is indicated by maxBuf != 0. Also, no need to ping if
 	 * we got a response recently
 	 */
-	if (server->maxBuf == 0 ||
+	if (!server->ops->need_neg || server->ops->need_neg(server) ||
 	    time_before(jiffies, server->lstrp + SMB_ECHO_INTERVAL - HZ))
 		goto requeue_echo;
 
@@ -2405,7 +2405,8 @@ static bool warned_on_ntlm;  /* globals init to false automatically */
 static struct cifs_ses *
 cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
 {
-	int rc = -ENOMEM, xid;
+	int rc = -ENOMEM;
+	unsigned int xid;
 	struct cifs_ses *ses;
 	struct sockaddr_in *addr = (struct sockaddr_in *)&server->dstaddr;
 	struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *)&server->dstaddr;
@@ -3944,24 +3945,22 @@ cifs_umount(struct cifs_sb_info *cifs_sb)
 	kfree(cifs_sb);
 }
 
-int cifs_negotiate_protocol(unsigned int xid, struct cifs_ses *ses)
+int
+cifs_negotiate_protocol(const unsigned int xid, struct cifs_ses *ses)
 {
 	int rc = 0;
 	struct TCP_Server_Info *server = ses->server;
 
+	if (!server->ops->need_neg || !server->ops->negotiate)
+		return -ENOSYS;
+
 	/* only send once per connect */
-	if (server->maxBuf != 0)
+	if (!server->ops->need_neg(server))
 		return 0;
 
 	set_credits(server, 1);
-	rc = CIFSSMBNegotiate(xid, ses);
-	if (rc == -EAGAIN) {
-		/* retry only once on 1st time connection */
-		set_credits(server, 1);
-		rc = CIFSSMBNegotiate(xid, ses);
-		if (rc == -EAGAIN)
-			rc = -EHOSTDOWN;
-	}
+
+	rc = server->ops->negotiate(xid, ses);
 	if (rc == 0) {
 		spin_lock(&GlobalMid_Lock);
 		if (server->tcpStatus == CifsNeedNegotiate)
@@ -3969,7 +3968,6 @@ int cifs_negotiate_protocol(unsigned int xid, struct cifs_ses *ses)
 		else
 			rc = -EHOSTDOWN;
 		spin_unlock(&GlobalMid_Lock);
-
 	}
 
 	return rc;
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
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index f4f8394..ea4fb8a 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -389,6 +389,27 @@ cifs_check_trans2(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 	return true;
 }
 
+static bool
+cifs_need_neg(struct TCP_Server_Info *server)
+{
+	return server->maxBuf == 0;
+}
+
+static int
+cifs_negotiate(const unsigned int xid, struct cifs_ses *ses)
+{
+	int rc;
+	rc = CIFSSMBNegotiate(xid, ses);
+	if (rc == -EAGAIN) {
+		/* retry only once on 1st time connection */
+		set_credits(ses->server, 1);
+		rc = CIFSSMBNegotiate(xid, ses);
+		if (rc == -EAGAIN)
+			rc = -EHOSTDOWN;
+	}
+	return rc;
+}
+
 struct smb_version_operations smb1_operations = {
 	.send_cancel = send_nt_cancel,
 	.compare_fids = cifs_compare_fids,
@@ -407,6 +428,8 @@ struct smb_version_operations smb1_operations = {
 	.dump_detail = cifs_dump_detail,
 	.is_oplock_break = is_valid_oplock_break,
 	.check_trans2 = cifs_check_trans2,
+	.need_neg = cifs_need_neg,
+	.negotiate = cifs_negotiate,
 };
 
 struct smb_version_values smb1_values = {
-- 
1.7.1
