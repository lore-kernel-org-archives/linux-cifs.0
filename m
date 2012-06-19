From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 04/22] CIFS: Add SMB2 credits support
Date: Tue, 19 Jun 2012 16:39:53 +0400
Message-ID: <1340109611-7210-5-git-send-email-pshilovsky@samba.org>
References: <1340109611-7210-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340109611-7210-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

For SMB2 protocol we can add more than one credit for one received
request: it depends on CreditRequest field in SMB2 response header.
Also we divide all requests by type: echos, oplocks and others. Each
type uses its own slot pull.

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    5 +++
 fs/cifs/cifsproto.h |    1 +
 fs/cifs/connect.c   |    2 +-
 fs/cifs/smb2ops.c   |   77 +++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 84 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index ae27ab8..6c062e2 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -343,6 +343,11 @@ struct TCP_Server_Info {
 	char server_GUID[16];
 	__u16 sec_mode;
 	bool session_estab; /* mark when very first sess is established */
+#ifdef CONFIG_CIFS_SMB2
+	int echo_credits;  /* echo reserved slots */
+	int oplock_credits;  /* oplock break reserved slots */
+	bool echos:1; /* enable echos */
+#endif
 	u16 dialect; /* dialect index that server chose */
 	enum securityEnum secType;
 	bool oplocks:1; /* enable oplocks */
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index c45adfa..19987a7 100644
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
index 72fb35b..d45df03 100644
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
index 80d9674..1393d70 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -20,6 +20,79 @@
 #include "cifsglob.h"
 #include "smb2pdu.h"
 #include "smb2proto.h"
+#include "cifsproto.h"
+#include "cifs_debug.h"
+
+static void
+change_conf(struct TCP_Server_Info *server)
+{
+	server->credits += server->echo_credits + server->oplock_credits;
+	server->oplock_credits = server->echo_credits = 0;
+	switch (server->credits) {
+	case 0:
+		cifs_reconnect(server);
+		return;
+	case 1:
+		server->echos = false;
+		server->oplocks = false;
+		cERROR(1, "disabling echos and oplocks");
+		break;
+	case 2:
+		server->echos = true;
+		server->oplocks = false;
+		server->echo_credits = 1;
+		cFYI(1, "disabling oplocks");
+		break;
+	default:
+		server->echos = true;
+		server->oplocks = true;
+		server->echo_credits = 1;
+		server->oplock_credits = 1;
+	}
+	server->credits -= server->echo_credits + server->oplock_credits;
+}
+
+static void
+smb2_add_credits(struct TCP_Server_Info *server, const unsigned int add,
+		 const int optype)
+{
+	int *val;
+	spin_lock(&server->req_lock);
+	val = server->ops->get_credits_field(server, optype);
+	*val += add;
+	server->in_flight--;
+	if (server->in_flight == 0)
+		change_conf(server);
+	spin_unlock(&server->req_lock);
+	wake_up(&server->request_q);
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
@@ -36,6 +109,10 @@ smb2_get_next_mid(struct TCP_Server_Info *server)
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
