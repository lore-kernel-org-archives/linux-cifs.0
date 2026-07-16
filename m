Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BFA9346A1D
	for <linux-cifs@vger.kernel.org>; Thu, 16 Jul 2026 09:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784195851; cv=none; b=u9Cy5RB1m+igcmhxDLF8ya6Dj8e2SPIQ2/JqMz1G2t8RPeoKh39yXNTojwDO14KNIb+CtlkHbNVtaN1C/AlWw/Xkdzub25lZ1ALxYn4ZUnW0i1LiiedhK6rqEBc2ZLFkiYFtbBJq69Dmq2gkoe3Jo4AF0GZ7WS20PiD9BK33+CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784195851; c=relaxed/simple;
	bh=udHLaHvuCbJ23Z8gt2S9fYQBRE1GQUpYgMnzXJ2136I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LmdI4L9TrULlTighVsd4ropWl+iEorg3i8bV0Nbp5ME73lzJxG9jpCT3p19I1JZT/jgc0a1eQNnkskfZm8GZndROlQBd7z62qSQ4cKnD/LT9bJnSXGycvJNXO+TNhmNqVuO9jfrizKiBL3Wcsa64QLOmg0IpZnP7lziuqhnb2Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ocCsm9nD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ocCsm9nD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750131F000E9;
	Thu, 16 Jul 2026 09:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784195849;
	bh=7U/KlJSOr8RiCMytu+es0GUs/BQna9i0qF9Q18lE3v8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ocCsm9nDIC+n/oriYw08Rjv5JAd31oIh4y/dORSDZ8z0GdfbPYBesMgsrdTO8Qotk
	 PzOtXnwxCucoad5EauqEdH+wFx2RQ26c0NjWY2WKSQ+yOtHE76jBzi8tswWVQ3x7Y7
	 k9c2Bsd83Fmk4viLPmZKtrGqyQGXVX3izAF8gi7i3bKr+LXkbRT89SKLPOT9vjs+Ot
	 GTKluwdG2wr3e2NJ4bJS5y1l6d5clyugWL0uiqkcLVioA4GHJWa8IfEhjI3oonMZZ9
	 eYtBj+s8nL/6rHIj3NNEy6/95x6o0evoFz2p70FKKimQvWarpCMEDedoFmBw0xcInV
	 zgOuFXF9Fnmhw==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7/7] ksmbd: extend procfs server statistics
Date: Thu, 16 Jul 2026 18:57:10 +0900
Message-Id: <20260716095711.6228-7-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260716095711.6228-1-linkinjeon@kernel.org>
References: <20260716095711.6228-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The server proc entry does not expose configured limits or enough outcome
data to distinguish protocol errors from transport stalls.

Report the server state, listener and signing configuration, connection
limits, timeout values, current client and open-file totals, IPC activity,
and durable scavenger state. Classify processed SMB2 response statuses by
NTSTATUS severity and provide counters for common error groups while
retaining the per-command counters.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/proc.c       | 121 +++++++++++++++++++++++++++++++++----
 fs/smb/server/server.c     |   7 ++-
 fs/smb/server/smb_common.h |   2 +-
 fs/smb/server/stats.h      |  53 +++++++++++++++-
 fs/smb/server/vfs_cache.c  |  10 +++
 fs/smb/server/vfs_cache.h  |   1 +
 6 files changed, 176 insertions(+), 18 deletions(-)

diff --git a/fs/smb/server/proc.c b/fs/smb/server/proc.c
index b41490142480..1bf4e00dee34 100644
--- a/fs/smb/server/proc.c
+++ b/fs/smb/server/proc.c
@@ -11,10 +11,12 @@
 #include <linux/seq_file.h>
 
 #include "misc.h"
+#include "connection.h"
 #include "server.h"
 #include "stats.h"
 #include "smb_common.h"
 #include "smb2pdu.h"
+#include "vfs_cache.h"
 
 static struct proc_dir_entry *ksmbd_proc_fs;
 struct ksmbd_counters ksmbd_counters;
@@ -90,34 +92,127 @@ static const struct ksmbd_const_smb2_process_req smb2_process_req[KSMBD_COUNTER_
 	{le16_to_cpu(SMB2_OPLOCK_BREAK), "SMB2_OPLOCK_BREAK"},
 };
 
+static const char *ksmbd_server_state_string(void)
+{
+	switch (READ_ONCE(server_conf.state)) {
+	case SERVER_STATE_STARTING_UP:
+		return "starting";
+	case SERVER_STATE_RUNNING:
+		return "running";
+	case SERVER_STATE_RESETTING:
+		return "resetting";
+	case SERVER_STATE_SHUTTING_DOWN:
+		return "shutdown";
+	default:
+		return "unknown";
+	}
+}
+
+static const char *ksmbd_signing_mode_string(void)
+{
+	switch (server_conf.signing) {
+	case KSMBD_CONFIG_OPT_DISABLED:
+		return "disabled";
+	case KSMBD_CONFIG_OPT_MANDATORY:
+		return "mandatory";
+	case KSMBD_CONFIG_OPT_AUTO:
+		return "auto";
+	default:
+		return "unknown";
+	}
+}
+
+static void proc_show_runtime_totals(struct seq_file *m)
+{
+	struct ksmbd_conn *conn;
+	unsigned int clients = 0;
+	unsigned int open_files = 0;
+	int i;
+
+	down_read(&conn_list_lock);
+	hash_for_each(conn_list, i, conn, hlist) {
+		clients++;
+		open_files += atomic_read(&conn->stats.open_files_count);
+	}
+	up_read(&conn_list_lock);
+
+	seq_printf(m, "clients:\t%u\n", clients);
+	seq_printf(m, "open_files:\t%u\n", open_files);
+}
+
 static int proc_show_ksmbd_stats(struct seq_file *m, void *v)
 {
 	int i;
 
 	seq_puts(m, "Server\n");
-	seq_printf(m, "name: %s\n", ksmbd_server_string());
-	seq_printf(m, "netbios: %s\n", ksmbd_netbios_name());
-	seq_printf(m, "work group: %s\n", ksmbd_work_group());
-	seq_printf(m, "min protocol: %s\n", ksmbd_get_protocol_string(server_conf.min_protocol));
-	seq_printf(m, "max protocol: %s\n", ksmbd_get_protocol_string(server_conf.max_protocol));
-	seq_printf(m, "flags: 0x%08x\n", server_conf.flags);
-	seq_printf(m, "share_fake_fscaps: 0x%08x\n",
+	seq_printf(m, "state:\t%s\n", ksmbd_server_state_string());
+	seq_printf(m, "name:\t%s\n", ksmbd_server_string());
+	seq_printf(m, "netbios:\t%s\n", ksmbd_netbios_name());
+	seq_printf(m, "work_group:\t%s\n", ksmbd_work_group());
+	seq_printf(m, "min_protocol:\t%s\n", ksmbd_get_protocol_string(server_conf.min_protocol));
+	seq_printf(m, "max_protocol:\t%s\n", ksmbd_get_protocol_string(server_conf.max_protocol));
+	seq_printf(m, "flags:\t0x%08x\n", server_conf.flags);
+	seq_printf(m, "tcp_port:\t%u\n", server_conf.tcp_port);
+	seq_printf(m, "signing:\t%s\n", ksmbd_signing_mode_string());
+	seq_printf(m, "signing_enforced:\t%s\n",
+		   server_conf.enforced_signing ? "yes" : "no");
+	seq_printf(m, "bind_interfaces_only:\t%s\n",
+		   server_conf.bind_interfaces_only ? "yes" : "no");
+	seq_printf(m, "max_connections:\t%u\n", server_conf.max_connections);
+	seq_printf(m, "max_connections_per_ip:\t%u\n",
+		   server_conf.max_ip_connections);
+	seq_printf(m, "max_inflight_requests:\t%u\n",
+		   server_conf.max_inflight_req);
+	seq_printf(m, "deadtime_seconds:\t%lu\n", server_conf.deadtime / HZ);
+	seq_printf(m, "ipc_timeout_seconds:\t%u\n", server_conf.ipc_timeout / HZ);
+	if (server_conf.ipc_last_active)
+		seq_printf(m, "ipc_last_active_seconds:\t%lu\n",
+			   jiffies_to_msecs(jiffies - server_conf.ipc_last_active) /
+			   MSEC_PER_SEC);
+	else
+		seq_puts(m, "ipc_last_active_seconds:\tnever\n");
+	seq_printf(m, "durable_scavenger:\t%s\n",
+		   ksmbd_durable_scavenger_active() ? "running" : "stopped");
+	seq_printf(m, "share_fake_fscaps:\t0x%08x\n",
 		   server_conf.share_fake_fscaps);
-	seq_printf(m, "sessions: %lld\n",
+	proc_show_runtime_totals(m);
+	seq_printf(m, "sessions:\t%lld\n",
 		   ksmbd_counter_sum(KSMBD_COUNTER_SESSIONS));
-	seq_printf(m, "tree connects: %lld\n",
+	seq_printf(m, "tree_connects:\t%lld\n",
 		   ksmbd_counter_sum(KSMBD_COUNTER_TREE_CONNS));
-	seq_printf(m, "requests: %lld\n",
+	seq_printf(m, "requests:\t%lld\n",
 		   ksmbd_counter_sum(KSMBD_COUNTER_REQUESTS));
-	seq_printf(m, "read bytes: %lld\n",
+	seq_printf(m, "read_bytes:\t%lld\n",
 		   ksmbd_counter_sum(KSMBD_COUNTER_READ_BYTES));
-	seq_printf(m, "written bytes: %lld\n",
+	seq_printf(m, "written_bytes:\t%lld\n",
 		   ksmbd_counter_sum(KSMBD_COUNTER_WRITE_BYTES));
 
 	seq_puts(m, "\nSMB2\n");
 	for (i = 0; i < KSMBD_COUNTER_MAX_REQS; i++)
-		seq_printf(m, "%-20s:\t%lld\n", smb2_process_req[i].name,
+		seq_printf(m, "%s:\t%lld\n", smb2_process_req[i].name,
 			   ksmbd_counter_sum(KSMBD_COUNTER_FIRST_REQ + i));
+
+	seq_puts(m, "\nSMB2 status\n");
+	seq_printf(m, "success:\t%lld\n",
+		   ksmbd_counter_sum(KSMBD_COUNTER_STATUS_SUCCESS));
+	seq_printf(m, "informational:\t%lld\n",
+		   ksmbd_counter_sum(KSMBD_COUNTER_STATUS_INFORMATIONAL));
+	seq_printf(m, "warning:\t%lld\n",
+		   ksmbd_counter_sum(KSMBD_COUNTER_STATUS_WARNING));
+	seq_printf(m, "error:\t%lld\n",
+		   ksmbd_counter_sum(KSMBD_COUNTER_STATUS_ERROR));
+	seq_printf(m, "access_denied:\t%lld\n",
+		   ksmbd_counter_sum(KSMBD_COUNTER_ERROR_ACCESS_DENIED));
+	seq_printf(m, "not_found:\t%lld\n",
+		   ksmbd_counter_sum(KSMBD_COUNTER_ERROR_NOT_FOUND));
+	seq_printf(m, "invalid_parameter:\t%lld\n",
+		   ksmbd_counter_sum(KSMBD_COUNTER_ERROR_INVALID_PARAMETER));
+	seq_printf(m, "sharing_violation:\t%lld\n",
+		   ksmbd_counter_sum(KSMBD_COUNTER_ERROR_SHARING_VIOLATION));
+	seq_printf(m, "not_supported:\t%lld\n",
+		   ksmbd_counter_sum(KSMBD_COUNTER_ERROR_NOT_SUPPORTED));
+	seq_printf(m, "other:\t%lld\n",
+		   ksmbd_counter_sum(KSMBD_COUNTER_ERROR_OTHER));
 	return 0;
 }
 
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 7a2730e71fd2..348dd03981f1 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -148,8 +148,11 @@ static int __process_request(struct ksmbd_work *work, struct ksmbd_conn *conn,
 	}
 
 	ret = cmds->proc(work);
-	if (conn->ops->inc_reqs)
-		conn->ops->inc_reqs(command);
+	if (conn->ops->inc_reqs) {
+		struct smb2_hdr *rsp = ksmbd_resp_buf_curr(work);
+
+		conn->ops->inc_reqs(command, rsp->Status);
+	}
 
 	if (ret < 0)
 		ksmbd_debug(CONN, "Failed to process %u [%d]\n", command, ret);
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index b090b56743c4..7b9c5cfcb63b 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -135,7 +135,7 @@ struct file_id_both_directory_info {
 
 struct smb_version_ops {
 	u16 (*get_cmd_val)(struct ksmbd_work *swork);
-	void (*inc_reqs)(unsigned int cmd);
+	void (*inc_reqs)(unsigned int cmd, __le32 status);
 	int (*init_rsp_hdr)(struct ksmbd_work *swork);
 	void (*set_rsp_status)(struct ksmbd_work *swork, __le32 err);
 	int (*allocate_rsp_buf)(struct ksmbd_work *work);
diff --git a/fs/smb/server/stats.h b/fs/smb/server/stats.h
index 08ee66f91eaa..bc864efa0d46 100644
--- a/fs/smb/server/stats.h
+++ b/fs/smb/server/stats.h
@@ -9,12 +9,24 @@
 #ifndef __KSMBD_STATS_H__
 #define __KSMBD_STATS_H__
 
+#include "../common/smb2status.h"
+
 #define KSMBD_COUNTER_MAX_REQS	19
 
 enum {
 	KSMBD_COUNTER_SESSIONS = 0,
 	KSMBD_COUNTER_TREE_CONNS,
 	KSMBD_COUNTER_REQUESTS,
+	KSMBD_COUNTER_STATUS_SUCCESS,
+	KSMBD_COUNTER_STATUS_INFORMATIONAL,
+	KSMBD_COUNTER_STATUS_WARNING,
+	KSMBD_COUNTER_STATUS_ERROR,
+	KSMBD_COUNTER_ERROR_ACCESS_DENIED,
+	KSMBD_COUNTER_ERROR_NOT_FOUND,
+	KSMBD_COUNTER_ERROR_INVALID_PARAMETER,
+	KSMBD_COUNTER_ERROR_SHARING_VIOLATION,
+	KSMBD_COUNTER_ERROR_NOT_SUPPORTED,
+	KSMBD_COUNTER_ERROR_OTHER,
 	KSMBD_COUNTER_READ_BYTES,
 	KSMBD_COUNTER_WRITE_BYTES,
 	KSMBD_COUNTER_FIRST_REQ,
@@ -50,8 +62,45 @@ static inline void ksmbd_counter_sub(int type, s64 value)
 	percpu_counter_sub(&ksmbd_counters.counters[type], value);
 }
 
-static inline void ksmbd_counter_inc_reqs(unsigned int cmd)
+static inline void ksmbd_counter_inc_reqs(unsigned int cmd, __le32 status)
 {
+	unsigned int severity = le32_to_cpu(status) >> 30;
+	int type;
+
+	switch (severity) {
+	case 0:
+		type = KSMBD_COUNTER_STATUS_SUCCESS;
+		break;
+	case 1:
+		type = KSMBD_COUNTER_STATUS_INFORMATIONAL;
+		break;
+	case 2:
+		type = KSMBD_COUNTER_STATUS_WARNING;
+		break;
+	default:
+		type = KSMBD_COUNTER_STATUS_ERROR;
+		break;
+	}
+	percpu_counter_inc(&ksmbd_counters.counters[type]);
+
+	if (severity == 3) {
+		if (status == STATUS_ACCESS_DENIED)
+			type = KSMBD_COUNTER_ERROR_ACCESS_DENIED;
+		else if (status == STATUS_OBJECT_NAME_NOT_FOUND ||
+			 status == STATUS_NO_SUCH_FILE)
+			type = KSMBD_COUNTER_ERROR_NOT_FOUND;
+		else if (status == STATUS_INVALID_PARAMETER)
+			type = KSMBD_COUNTER_ERROR_INVALID_PARAMETER;
+		else if (status == STATUS_SHARING_VIOLATION)
+			type = KSMBD_COUNTER_ERROR_SHARING_VIOLATION;
+		else if (status == STATUS_NOT_SUPPORTED ||
+			 status == STATUS_NOT_IMPLEMENTED)
+			type = KSMBD_COUNTER_ERROR_NOT_SUPPORTED;
+		else
+			type = KSMBD_COUNTER_ERROR_OTHER;
+		percpu_counter_inc(&ksmbd_counters.counters[type]);
+	}
+
 	if (cmd < KSMBD_COUNTER_MAX_REQS) {
 		percpu_counter_inc(&ksmbd_counters.counters[KSMBD_COUNTER_REQUESTS]);
 		percpu_counter_inc(&ksmbd_counters.counters[KSMBD_COUNTER_FIRST_REQ + cmd]);
@@ -68,7 +117,7 @@ static inline void ksmbd_counter_inc(int type) {}
 static inline void ksmbd_counter_dec(int type) {}
 static inline void ksmbd_counter_add(int type, s64 value) {}
 static inline void ksmbd_counter_sub(int type, s64 value) {}
-static inline void ksmbd_counter_inc_reqs(unsigned int cmd) {}
+static inline void ksmbd_counter_inc_reqs(unsigned int cmd, __le32 status) {}
 static inline s64 ksmbd_counter_sum(int type) { return 0; }
 #endif
 
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 5c1929a81234..68bf7b0512da 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -191,6 +191,16 @@ static bool durable_scavenger_running;
 static DEFINE_MUTEX(durable_scavenger_lock);
 static wait_queue_head_t dh_wq;
 
+bool ksmbd_durable_scavenger_active(void)
+{
+	bool active;
+
+	mutex_lock(&durable_scavenger_lock);
+	active = durable_scavenger_running;
+	mutex_unlock(&durable_scavenger_lock);
+	return active;
+}
+
 void ksmbd_set_fd_limit(unsigned long limit)
 {
 	limit = min(limit, get_max_files());
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index 5aff9bb556ec..5fac4b0b419d 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -216,6 +216,7 @@ unsigned int ksmbd_open_durable_fd(struct ksmbd_file *fp);
 struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp);
 void ksmbd_launch_ksmbd_durable_scavenger(void);
 void ksmbd_stop_durable_scavenger(void);
+bool ksmbd_durable_scavenger_active(void);
 void ksmbd_close_tree_conn_fds(struct ksmbd_work *work);
 void ksmbd_close_session_fds(struct ksmbd_work *work);
 int ksmbd_close_inode_fds(struct ksmbd_work *work, struct inode *inode);
-- 
2.25.1

