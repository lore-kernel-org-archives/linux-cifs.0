From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2 5/7] CIFS: Move protocol specific negotiate code to ops struct
Date: Mon, 28 May 2012 13:30:12 +0400
Message-ID: <1338197414-22340-6-git-send-email-pshilovsky@samba.org>
References: <1338197414-22340-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1338197414-22340-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h |    8 ++++++--
 fs/cifs/cifssmb.c  |    2 +-
 fs/cifs/connect.c  |   15 ++++-----------
 fs/cifs/sess.c     |    2 +-
 fs/cifs/smb1ops.c  |   23 +++++++++++++++++++++++
 5 files changed, 35 insertions(+), 15 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index c1030ce..9152e31 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -192,6 +192,10 @@ struct smb_version_operations {
 	/* process transaction2 response */
 	bool (*check_trans2)(struct mid_q_entry *, struct TCP_Server_Info *,
 			     char *, int);
+	/* check if we need to negotiate */
+	bool (*need_neg)(struct TCP_Server_Info *);
+	/* negotiate to the server */
+	int (*negotiate)(int, struct cifs_ses *);
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
@@ -477,7 +481,7 @@ struct cifs_ses {
 	char *serverOS;		/* name of operating system underlying server */
 	char *serverNOS;	/* name of network operating system of server */
 	char *serverDomain;	/* security realm of server */
-	int Suid;		/* remote smb uid  */
+	__u64 Suid;		/* remote smb uid  */
 	uid_t linux_uid;        /* overriding owner of files on the mount */
 	uid_t cred_uid;		/* owner of credentials */
 	int capabilities;
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 2105e56..6fa39fe 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
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
index 1c7af1d..0b9351a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -406,7 +406,7 @@ cifs_echo_request(struct work_struct *work)
 	 * done, which is indicated by maxBuf != 0. Also, no need to ping if
 	 * we got a response recently
 	 */
-	if (server->maxBuf == 0 ||
+	if (S_OP(server, need_neg, false, server) ||
 	    time_before(jiffies, server->lstrp + SMB_ECHO_INTERVAL - HZ))
 		goto requeue_echo;
 
@@ -3945,18 +3945,12 @@ int cifs_negotiate_protocol(unsigned int xid, struct cifs_ses *ses)
 	struct TCP_Server_Info *server = ses->server;
 
 	/* only send once per connect */
-	if (server->maxBuf != 0)
+	if (!S_OP(server, need_neg, false, server))
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
+	rc = S_OP(server, negotiate, -ENOSYS, xid, ses);
 	if (rc == 0) {
 		spin_lock(&GlobalMid_Lock);
 		if (server->tcpStatus == CifsNeedNegotiate)
@@ -3964,7 +3958,6 @@ int cifs_negotiate_protocol(unsigned int xid, struct cifs_ses *ses)
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
index a562695..0ae208a 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -377,6 +377,27 @@ cifs_check_trans2(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 	return true;
 }
 
+static bool
+cifs_need_neg(struct TCP_Server_Info *server)
+{
+	return server->maxBuf == 0;
+}
+
+static int
+cifs_negotiate(int xid, struct cifs_ses *ses)
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
@@ -393,6 +414,8 @@ struct smb_version_operations smb1_operations = {
 	.dump_detail = cifs_dump_detail,
 	.is_oplock_break = is_valid_oplock_break,
 	.check_trans2 = cifs_check_trans2,
+	.need_neg = cifs_need_neg,
+	.negotiate = cifs_negotiate,
 };
 
 struct smb_version_values smb1_values = {
-- 
1.7.1
