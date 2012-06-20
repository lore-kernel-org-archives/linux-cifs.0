From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2 24/24] CIFS: Allow SMB2 statistics to be tracked
Date: Wed, 20 Jun 2012 18:31:04 +0400
Message-ID: <1340202664-28696-25-git-send-email-pshilovsky@samba.org>
References: <1340202664-28696-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340202664-28696-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
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
index 1a7e7f2..45e7f23 100644
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
index 985780f..ee72184 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -211,6 +211,85 @@ smb2_can_echo(struct TCP_Server_Info *server)
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
+		   atomic_read(&sent[SMB2_NEGOTIATE_HE]),
+		   atomic_read(&failed[SMB2_NEGOTIATE_HE]));
+	seq_printf(m, "\nSessionSetups: %d sent %d failed",
+		   atomic_read(&sent[SMB2_SESSION_SETUP_HE]),
+		   atomic_read(&failed[SMB2_SESSION_SETUP_HE]));
+#define SMB2LOGOFF		0x0002 /* trivial request/resp */
+	seq_printf(m, "\nLogoffs: %d sent %d failed",
+		   atomic_read(&sent[SMB2_LOGOFF_HE]),
+		   atomic_read(&failed[SMB2_LOGOFF_HE]));
+	seq_printf(m, "\nTreeConnects: %d sent %d failed",
+		   atomic_read(&sent[SMB2_TREE_CONNECT_HE]),
+		   atomic_read(&failed[SMB2_TREE_CONNECT_HE]));
+	seq_printf(m, "\nTreeDisconnects: %d sent %d failed",
+		   atomic_read(&sent[SMB2_TREE_DISCONNECT_HE]),
+		   atomic_read(&failed[SMB2_TREE_DISCONNECT_HE]));
+	seq_printf(m, "\nCreates: %d sent %d failed",
+		   atomic_read(&sent[SMB2_CREATE_HE]),
+		   atomic_read(&failed[SMB2_CREATE_HE]));
+	seq_printf(m, "\nCloses: %d sent %d failed",
+		   atomic_read(&sent[SMB2_CLOSE_HE]),
+		   atomic_read(&failed[SMB2_CLOSE_HE]));
+	seq_printf(m, "\nFlushes: %d sent %d failed",
+		   atomic_read(&sent[SMB2_FLUSH_HE]),
+		   atomic_read(&failed[SMB2_FLUSH_HE]));
+	seq_printf(m, "\nReads: %d sent %d failed",
+		   atomic_read(&sent[SMB2_READ_HE]),
+		   atomic_read(&failed[SMB2_READ_HE]));
+	seq_printf(m, "\nWrites: %d sent %d failed",
+		   atomic_read(&sent[SMB2_WRITE_HE]),
+		   atomic_read(&failed[SMB2_WRITE_HE]));
+	seq_printf(m, "\nLocks: %d sent %d failed",
+		   atomic_read(&sent[SMB2_LOCK_HE]),
+		   atomic_read(&failed[SMB2_LOCK_HE]));
+	seq_printf(m, "\nIOCTLs: %d sent %d failed",
+		   atomic_read(&sent[SMB2_IOCTL_HE]),
+		   atomic_read(&failed[SMB2_IOCTL_HE]));
+	seq_printf(m, "\nCancels: %d sent %d failed",
+		   atomic_read(&sent[SMB2_CANCEL_HE]),
+		   atomic_read(&failed[SMB2_CANCEL_HE]));
+	seq_printf(m, "\nEchos: %d sent %d failed",
+		   atomic_read(&sent[SMB2_ECHO_HE]),
+		   atomic_read(&failed[SMB2_ECHO_HE]));
+	seq_printf(m, "\nQueryDirectories: %d sent %d failed",
+		   atomic_read(&sent[SMB2_QUERY_DIRECTORY_HE]),
+		   atomic_read(&failed[SMB2_QUERY_DIRECTORY_HE]));
+	seq_printf(m, "\nChangeNotifies: %d sent %d failed",
+		   atomic_read(&sent[SMB2_CHANGE_NOTIFY_HE]),
+		   atomic_read(&failed[SMB2_CHANGE_NOTIFY_HE]));
+	seq_printf(m, "\nQueryInfos: %d sent %d failed",
+		   atomic_read(&sent[SMB2_QUERY_INFO_HE]),
+		   atomic_read(&failed[SMB2_QUERY_INFO_HE]));
+	seq_printf(m, "\nSetInfos: %d sent %d failed",
+		   atomic_read(&sent[SMB2_SET_INFO_HE]),
+		   atomic_read(&failed[SMB2_SET_INFO_HE]));
+	seq_printf(m, "\nOplockBreaks: %d sent %d failed",
+		   atomic_read(&sent[SMB2_OPLOCK_BREAK_HE]),
+		   atomic_read(&failed[SMB2_OPLOCK_BREAK_HE]));
+#endif
+}
+
 struct smb_version_operations smb21_operations = {
 	.setup_request = smb2_setup_request,
 	.check_receive = smb2_check_receive,
@@ -222,6 +301,8 @@ struct smb_version_operations smb21_operations = {
 	.find_mid = smb2_find_mid,
 	.check_message = smb2_check_message,
 	.dump_detail = smb2_dump_detail,
+	.clear_stats = smb2_clear_stats,
+	.print_stats = smb2_print_stats,
 	.need_neg = smb2_need_neg,
 	.negotiate = smb2_negotiate,
 	.sess_setup = SMB2_sess_setup,
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index e5e2cf0..8a4299f 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -282,10 +282,8 @@ small_smb2_init(__le16 smb2_command, struct cifs_tcon *tcon,
 
 	if (tcon != NULL) {
 #ifdef CONFIG_CIFS_STATS2
-		/*
 		uint16_t com_code = le16_to_cpu(smb2_command);
 		cifs_stats_inc(&tcon->stats.smb2_stats.smb2_com_sent[com_code]);
-		*/
 #endif
 		cifs_stats_inc(&tcon->num_smbs_sent);
 	}
@@ -679,7 +677,7 @@ SMB2_logoff(const unsigned int xid, struct cifs_ses *ses)
 
 static inline void cifs_stats_fail_inc(struct cifs_tcon *tcon, uint16_t code)
 {
-	/* cifs_stats_inc(&tcon->stats.smb2_stats.smb2_com_fail[code]); */
+	cifs_stats_inc(&tcon->stats.smb2_stats.smb2_com_failed[code]);
 }
 
 #define MAX_SHARENAME_LENGTH (255 /* server */ + 80 /* share */ + 1 /* NULL */)
-- 
1.7.1
