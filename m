From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 22/22] CIFS: Allow SMB2 statistics to be tracked
Date: Tue, 19 Jun 2012 16:40:11 +0400
Message-ID: <1340109611-7210-23-git-send-email-pshilovsky@samba.org>
References: <1340109611-7210-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340109611-7210-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Since there are only 19 command codes, it also is easier to track by exact
command code than it was for cifs.

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h |    9 ++++++
 fs/cifs/smb2ops.c  |   81 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.c  |    4 +--
 3 files changed, 91 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 3665e1c..9f11a78 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -28,6 +28,9 @@
 #include "cifsacl.h"
 #include <crypto/internal/hash.h>
 #include <linux/scatterlist.h>
+#ifdef CONFIG_CIFS_SMB2
+#include "smb2pdu.h"
+#endif
 
 /*
  * The sizes of various internal tables and strings
@@ -582,6 +585,12 @@ struct cifs_tcon {
 			atomic_t num_acl_get;
 			atomic_t num_acl_set;
 		} cifs_stats;
+#ifdef CONFIG_CIFS_SMB2
+		struct {
+			atomic_t smb2_com_sent[NUMBER_OF_SMB2_COMMANDS];
+			atomic_t smb2_com_failed[NUMBER_OF_SMB2_COMMANDS];
+		} smb2_stats;
+#endif /* CONFIG_CIFS_SMB2 */
 	} stats;
 #ifdef CONFIG_CIFS_STATS2
 	unsigned long long time_writes;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index bf277c3..e3686ee 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -212,6 +212,85 @@ smb2_can_echo(struct TCP_Server_Info *server)
 	return server->echos;
 }
 
+static void
+smb2_clear_stats(struct cifs_tcon *tcon)
+{
+#ifdef CONFIG_CIFS_STATS
+	int i;
+	for (i = 0; i < NUMBER_OF_SMB2_COMMANDS; i++) {
+		atomic_set(&tcon->stats.smb2_stats.smb2_com_sent[i], 0);
+		atomic_set(&tcon->stats.smb2_stats.smb2_com_failed[i], 0);
+	}
+#endif
+}
+
+static void
+smb2_print_stats(struct seq_file *m, struct cifs_tcon *tcon)
+{
+#ifdef CONFIG_CIFS_STATS
+	atomic_t *sent = tcon->stats.smb2_stats.smb2_com_sent;
+	atomic_t *failed = tcon->stats.smb2_stats.smb2_com_failed;
+	seq_printf(m, "\nNegotiates: %d sent %d failed",
+		   atomic_read(&sent[SMB2NEGOTIATE]),
+		   atomic_read(&failed[SMB2NEGOTIATE]));
+	seq_printf(m, "\nSessionSetups: %d sent %d failed",
+		   atomic_read(&sent[SMB2SESSION_SETUP]),
+		   atomic_read(&failed[SMB2SESSION_SETUP]));
+#define SMB2LOGOFF		0x0002 /* trivial request/resp */
+	seq_printf(m, "\nLogoffs: %d sent %d failed",
+		   atomic_read(&sent[SMB2LOGOFF]),
+		   atomic_read(&failed[SMB2LOGOFF]));
+	seq_printf(m, "\nTreeConnects: %d sent %d failed",
+		   atomic_read(&sent[SMB2TREE_CONNECT]),
+		   atomic_read(&failed[SMB2TREE_CONNECT]));
+	seq_printf(m, "\nTreeDisconnects: %d sent %d failed",
+		   atomic_read(&sent[SMB2TREE_DISCONNECT]),
+		   atomic_read(&failed[SMB2TREE_DISCONNECT]));
+	seq_printf(m, "\nCreates: %d sent %d failed",
+		   atomic_read(&sent[SMB2CREATE]),
+		   atomic_read(&failed[SMB2CREATE]));
+	seq_printf(m, "\nCloses: %d sent %d failed",
+		   atomic_read(&sent[SMB2CLOSE]),
+		   atomic_read(&failed[SMB2CLOSE]));
+	seq_printf(m, "\nFlushes: %d sent %d failed",
+		   atomic_read(&sent[SMB2FLUSH]),
+		   atomic_read(&failed[SMB2FLUSH]));
+	seq_printf(m, "\nReads: %d sent %d failed",
+		   atomic_read(&sent[SMB2READ]),
+		   atomic_read(&failed[SMB2READ]));
+	seq_printf(m, "\nWrites: %d sent %d failed",
+		   atomic_read(&sent[SMB2WRITE]),
+		   atomic_read(&failed[SMB2WRITE]));
+	seq_printf(m, "\nLocks: %d sent %d failed",
+		   atomic_read(&sent[SMB2LOCK]),
+		   atomic_read(&failed[SMB2LOCK]));
+	seq_printf(m, "\nIOCTLs: %d sent %d failed",
+		   atomic_read(&sent[SMB2IOCTL]),
+		   atomic_read(&failed[SMB2IOCTL]));
+	seq_printf(m, "\nCancels: %d sent %d failed",
+		   atomic_read(&sent[SMB2CANCEL]),
+		   atomic_read(&failed[SMB2CANCEL]));
+	seq_printf(m, "\nEchos: %d sent %d failed",
+		   atomic_read(&sent[SMB2ECHO]),
+		   atomic_read(&failed[SMB2ECHO]));
+	seq_printf(m, "\nQueryDirectories: %d sent %d failed",
+		   atomic_read(&sent[SMB2QUERY_DIRECTORY]),
+		   atomic_read(&failed[SMB2QUERY_DIRECTORY]));
+	seq_printf(m, "\nChangeNotifies: %d sent %d failed",
+		   atomic_read(&sent[SMB2CHANGE_NOTIFY]),
+		   atomic_read(&failed[SMB2CHANGE_NOTIFY]));
+	seq_printf(m, "\nQueryInfos: %d sent %d failed",
+		   atomic_read(&sent[SMB2QUERY_INFO]),
+		   atomic_read(&failed[SMB2QUERY_INFO]));
+	seq_printf(m, "\nSetInfos: %d sent %d failed",
+		   atomic_read(&sent[SMB2SET_INFO]),
+		   atomic_read(&failed[SMB2SET_INFO]));
+	seq_printf(m, "\nOplockBreaks: %d sent %d failed",
+		   atomic_read(&sent[SMB2OPLOCK_BREAK]),
+		   atomic_read(&failed[SMB2OPLOCK_BREAK]));
+#endif
+}
+
 struct smb_version_operations smb21_operations = {
 	.setup_request = smb2_setup_request,
 	.check_receive = smb2_check_receive,
@@ -223,6 +302,8 @@ struct smb_version_operations smb21_operations = {
 	.find_mid = smb2_find_mid,
 	.check_message = smb2_check_message,
 	.dump_detail = smb2_dump_detail,
+	.clear_stats = smb2_clear_stats,
+	.print_stats = smb2_print_stats,
 	.need_neg = smb2_need_neg,
 	.negotiate = smb2_negotiate,
 	.sess_setup = SMB2_sess_setup,
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 10eb1b6..609eb04 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -286,10 +286,8 @@ small_smb2_init(__le16 smb2_command, struct cifs_tcon *tcon,
 
 	if (tcon != NULL) {
 #ifdef CONFIG_CIFS_STATS2
-		/*
 		uint16_t com_code = le16_to_cpu(smb2_command);
 		cifs_stats_inc(&tcon->stats.smb2_stats.smb2_com_sent[com_code]);
-		*/
 #endif
 		cifs_stats_inc(&tcon->num_smbs_sent);
 	}
@@ -685,7 +683,7 @@ SMB2_logoff(const int xid, struct cifs_ses *ses)
 
 static inline void cifs_stats_fail_inc(struct cifs_tcon *tcon, uint16_t code)
 {
-	/* cifs_stats_inc(&tcon->stats.smb2_stats.smb2_com_fail[code]); */
+	cifs_stats_inc(&tcon->stats.smb2_stats.smb2_com_failed[code]);
 }
 
 #define MAX_SHARENAME_LENGTH (255 /* server */ + 80 /* share */ + 1 /* NULL */)
-- 
1.7.1
