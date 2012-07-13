From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v3 11/32] CIFS: Add SMB2 credits support
Date: Fri, 13 Jul 2012 11:53:24 +0400
Message-ID: <1342166025-29377-12-git-send-email-pshilovsky@samba.org>
References: <1342166025-29377-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342166025-29377-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

For SMB2 protocol we can add more than one credit for one received
request: it depends on CreditRequest field in SMB2 response header.
Also we divide all requests by type: echoes, oplocks and others.
Each type uses its own slot pull.

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    5 +++
 fs/cifs/cifsproto.h |    1 +
 fs/cifs/connect.c   |    2 +-
 fs/cifs/smb2ops.c   |   79 +++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 86 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 3575f0f..480b638 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -343,6 +343,11 @@ struct TCP_Server_Info {
 	char server_GUID[16];
 	__u16 sec_mode;
 	bool session_estab; /* mark when very first sess is established */
+#ifdef CONFIG_CIFS_SMB2
+	int echo_credits;  /* echo reserved slots */
+	int oplock_credits;  /* oplock break reserved slots */
+	bool echoes:1; /* enable echoes */
+#endif
 	u16 dialect; /* dialect index that server chose */
 	enum securityEnum secType;
 	bool oplocks:1; /* enable oplocks */
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 2b85867..692d283 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -91,6 +91,7 @@ extern int SendReceiveBlockingLock(const unsigned int xid,
 			struct smb_hdr *in_buf ,
 			struct smb_hdr *out_buf,
 			int *bytes_returned);
+extern int cifs_reconnect(struct TCP_Server_Info *server);
 extern int checkSMB(char *buf, unsigned int length);
 extern bool is_valid_oplock_break(char *, struct TCP_Server_Info *);
 extern bool backup_cred(struct cifs_sb_info *);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 0ef321f..c19caa7 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -296,7 +296,7 @@ static int cifs_setup_volume_info(struct smb_vol *volume_info, char *mount_data,
  * reconnect tcp session
  * wake up waiters on reconnection? - (not needed currently)
  */
-static int
+int
 cifs_reconnect(struct TCP_Server_Info *server)
 {
 	int rc = 0;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 09530f4..67a0598 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -20,6 +20,81 @@
 #include "cifsglob.h"
 #include "smb2pdu.h"
 #include "smb2proto.h"
+#include "cifsproto.h"
+#include "cifs_debug.h"
+
+static int
+change_conf(struct TCP_Server_Info *server)
+{
+	server->credits += server->echo_credits + server->oplock_credits;
+	server->oplock_credits = server->echo_credits = 0;
+	switch (server->credits) {
+	case 0:
+		return -1;
+	case 1:
+		server->echoes = false;
+		server->oplocks = false;
+		cERROR(1, "disabling echoes and oplocks");
+		break;
+	case 2:
+		server->echoes = true;
+		server->oplocks = false;
+		server->echo_credits = 1;
+		cFYI(1, "disabling oplocks");
+		break;
+	default:
+		server->echoes = true;
+		server->oplocks = true;
+		server->echo_credits = 1;
+		server->oplock_credits = 1;
+	}
+	server->credits -= server->echo_credits + server->oplock_credits;
+	return 0;
+}
+
+static void
+smb2_add_credits(struct TCP_Server_Info *server, const unsigned int add,
+		 const int optype)
+{
+	int *val, rc = 0;
+	spin_lock(&server->req_lock);
+	val = server->ops->get_credits_field(server, optype);
+	*val += add;
+	server->in_flight--;
+	if (server->in_flight == 0)
+		rc = change_conf(server);
+	spin_unlock(&server->req_lock);
+	wake_up(&server->request_q);
+	if (rc)
+		cifs_reconnect(server);
+}
+
+static void
+smb2_set_credits(struct TCP_Server_Info *server, const int val)
+{
+	spin_lock(&server->req_lock);
+	server->credits = val;
+	spin_unlock(&server->req_lock);
+}
+
+static int *
+smb2_get_credits_field(struct TCP_Server_Info *server, const int optype)
+{
+	switch (optype) {
+	case CIFS_ECHO_OP:
+		return &server->echo_credits;
+	case CIFS_OBREAK_OP:
+		return &server->oplock_credits;
+	default:
+		return &server->credits;
+	}
+}
+
+static unsigned int
+smb2_get_credits(struct mid_q_entry *mid)
+{
+	return le16_to_cpu(((struct smb2_hdr *)mid->resp_buf)->CreditRequest);
+}
 
 static __u64
 smb2_get_next_mid(struct TCP_Server_Info *server)
@@ -35,6 +110,10 @@ smb2_get_next_mid(struct TCP_Server_Info *server)
 struct smb_version_operations smb21_operations = {
 	.setup_request = smb2_setup_request,
 	.check_receive = smb2_check_receive,
+	.add_credits = smb2_add_credits,
+	.set_credits = smb2_set_credits,
+	.get_credits_field = smb2_get_credits_field,
+	.get_credits = smb2_get_credits,
 	.get_next_mid = smb2_get_next_mid,
 };
 
-- 
1.7.1
