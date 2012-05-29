From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v3 1/7] CIFS: Introduce S_OP/S_OPV macros for a safe access to ops struct field
Date: Tue, 29 May 2012 20:18:58 +0400
Message-ID: <1338308344-29149-2-git-send-email-pshilovsky@samba.org>
References: <1338308344-29149-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1338308344-29149-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h  |   18 ++++++++++++++++++
 fs/cifs/connect.c   |    4 ++--
 fs/cifs/transport.c |    3 +--
 3 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 20350a9..48d1009 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -367,6 +367,24 @@ struct TCP_Server_Info {
 #endif
 };
 
+/*
+ * The macro is used for safe access to ops field.
+ *
+ * @server - pointer to the server.
+ * @op - name of ops field.
+ * @miss_code - return code.
+ * @... - ops field arguments.
+ *
+ * Return miss_code if server->ops doesn't have op field. Otherwise - return
+ * servr->ops->op(...).
+ */
+
+#define S_OP(server, op, miss_code, ...) \
+	(server->ops->op ? server->ops->op(__VA_ARGS__) : miss_code)
+
+/* Void returned version of S_OP macro */
+#define S_OPV(server, op, ...) S_OP(server, op, 0, __VA_ARGS__)
+
 static inline unsigned int
 in_flight(struct TCP_Server_Info *server)
 {
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index ccafded..a849aca 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1058,13 +1058,13 @@ cifs_demultiplex_thread(void *p)
 		if (mid_entry != NULL) {
 			if (!mid_entry->multiRsp || mid_entry->multiEnd)
 				mid_entry->callback(mid_entry);
-		} else if (!server->ops->is_oplock_break(buf, server)) {
+		} else if (!S_OP(server, is_oplock_break, false, buf, server)) {
 			cERROR(1, "No task to wake, unknown frame received! "
 				   "NumMids %d", atomic_read(&midCount));
 			cifs_dump_mem("Received Data is: ", buf,
 				      HEADER_SIZE(server));
 #ifdef CONFIG_CIFS_DEBUG2
-			server->ops->dump_detail(buf);
+			S_OPV(server, dump_detail, buf);
 			cifs_dump_mids(server);
 #endif /* CIFS_DEBUG2 */
 
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 1b36ffe..81d68f4 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -487,8 +487,7 @@ cifs_sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
 static inline int
 send_cancel(struct TCP_Server_Info *server, void *buf, struct mid_q_entry *mid)
 {
-	return server->ops->send_cancel ?
-				server->ops->send_cancel(server, buf, mid) : 0;
+	return S_OP(server, send_cancel, 0, server, buf, mid);
 }
 
 int
-- 
1.7.1
