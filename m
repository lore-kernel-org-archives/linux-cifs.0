From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 4/6] CIFS: Move protocol specific negotiate code to ops struct
Date: Fri, 25 May 2012 13:19:21 +0400
Message-ID: <1337937563-8417-5-git-send-email-pshilovsky@samba.org>
References: <1337937563-8417-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337937563-8417-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h |    8 ++++++--
 fs/cifs/cifssmb.c  |    2 +-
 fs/cifs/connect.c  |   13 +++----------
 fs/cifs/sess.c     |    2 +-
 fs/cifs/smb1ops.c  |   23 +++++++++++++++++++++++
 5 files changed, 34 insertions(+), 14 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index a9abbbc..1e09082 100644
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
@@ -459,7 +463,7 @@ struct cifs_ses {
 	char *serverOS;		/* name of operating system underlying server */
 	char *serverNOS;	/* name of network operating system of server */
 	char *serverDomain;	/* security realm of server */
-	int Suid;		/* remote smb uid  */
+	__u64 Suid;		/* remote smb uid  */
 	uid_t linux_uid;        /* overriding owner of files on the mount */
 	uid_t cred_uid;		/* owner of credentials */
 	int capabilities;
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 65898cc..ffe5def 100644
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
index a98d8ef..73db014 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3945,18 +3945,12 @@ int cifs_negotiate_protocol(unsigned int xid, struct cifs_ses *ses)
 	struct TCP_Server_Info *server = ses->server;
 
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
index f4f8394..b8f73c9 100644
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
