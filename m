Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470C9135A63
	for <linux-cifs@vger.kernel.org>; Mon, 10 Jun 2024 14:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718028881; cv=none; b=eeQEGJwYspre3UlBJdyKzO5deeRkLLQusejtgijyylTO5hPUYgtMFjS7OgjsIL39e9Z9Wu3UsmwfQt5bASsdNdflzttdNiDfV25qAAONyEbdZhnEjJ74iiZ3OpszOvfSN3PgAWFolnmEJo8ONC6dSiFXparQm0+D4iXjBJfWQhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718028881; c=relaxed/simple;
	bh=BNxqzj5amDA9JHMw5esLfbG224ZjsIBT1iLg3YfXRcs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Epnh+XvsMFPROUNirvI24lAMBjbyrsXkmhTKS/S4iKH7BK2LxzR1z+8wcdlI5kE9Ym+2nYyy7gj77wk5+FTf/lv3PeDV4vUyN/G0wXwpFcQ0lcL8KCoSgmPWBtxgdx8w56M0JqwuGbCKMDZ0vMUPXWPHnNxP0PzVYM4N00aaC2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6ff6fe215c6so3842454b3a.3
        for <linux-cifs@vger.kernel.org>; Mon, 10 Jun 2024 07:14:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718028879; x=1718633679;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YE9H+fEtj0cZMV5iMVJwCxu4bPM5szjNHskaKX4P0u4=;
        b=qTqrMBSfj7I4jvzSHlQPQw2pZb2d5yY1eq9MLaTwubalYvg6V9Q55PCy/5fb/5V2zd
         5NhD4LOg5hPTey66cLgUYtTE3O/SPErKa8KSQwz9HU3lMrsfVxh4yIgH3TUWaTu7KKWe
         skdQByiHP2g1juq8hppOk05h6HZ7ld6R5LnoDla8vPZ8oQSfLie23bA2CkJ3v/QmPJSk
         WuvKL9IpHuBicP5bg6fd+ymM7UFzIe6OKQhSbITeVRD/9um1+oCbKvLkUM07XVosXo8/
         Uz8P8XTl4FG7iVpsET8Ih1WkwhkBVMuew+xX/OTHWlzf2B5xvqDvCAAxZ3GNN3mVheCK
         DFgg==
X-Gm-Message-State: AOJu0Yzo6kwT11BSZ4K0o6j5q8FGhwY+SpbLRgeqKQM7HCDcl0r8/1Sv
	95Om2eX350yKHwzEgwfnI0gf750aVwG8wNrW/8ZEF4MothugFukSdc5VKA==
X-Google-Smtp-Source: AGHT+IH1yvCjPClFh5uIOGaBERKud1uevthDgTugqQ5WMzjDpLizVCYIjIMBSy4bl5xBly0Bm4in+w==
X-Received: by 2002:a05:6a00:809:b0:705:98d4:6227 with SMTP id d2e1a72fcca58-70598d463e1mr3606824b3a.4.1718028879175;
        Mon, 10 Jun 2024 07:14:39 -0700 (PDT)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70419a36c16sm5144392b3a.175.2024.06.10.07.14.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jun 2024 07:14:38 -0700 (PDT)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 2/3] ksmbd: add durable scavenger timer
Date: Mon, 10 Jun 2024 23:14:14 +0900
Message-Id: <20240610141416.8039-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240610141416.8039-1-linkinjeon@kernel.org>
References: <20240610141416.8039-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Launch ksmbd-durable-scavenger kernel thread to scan durable fps that
have not been reclaimed by a client within the configured time.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/mgmt/user_session.c |   2 +
 fs/smb/server/server.c            |   1 +
 fs/smb/server/server.h            |   1 +
 fs/smb/server/smb2pdu.c           |   2 +-
 fs/smb/server/smb2pdu.h           |   2 +
 fs/smb/server/vfs_cache.c         | 165 +++++++++++++++++++++++++++++-
 fs/smb/server/vfs_cache.h         |   2 +
 7 files changed, 169 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index aec0a7a12405..162a12685d2c 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -149,6 +149,7 @@ void ksmbd_session_destroy(struct ksmbd_session *sess)
 
 	ksmbd_tree_conn_session_logoff(sess);
 	ksmbd_destroy_file_table(&sess->file_table);
+	ksmbd_launch_ksmbd_durable_scavenger();
 	ksmbd_session_rpc_clear_list(sess);
 	free_channel_list(sess);
 	kfree(sess->Preauth_HashValue);
@@ -326,6 +327,7 @@ void destroy_previous_session(struct ksmbd_conn *conn,
 
 	ksmbd_destroy_file_table(&prev_sess->file_table);
 	prev_sess->state = SMB2_SESSION_EXPIRED;
+	ksmbd_launch_ksmbd_durable_scavenger();
 out:
 	up_write(&conn->session_lock);
 	up_write(&sessions_table_lock);
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index c67fbc8d6683..4d24cc105ef6 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -377,6 +377,7 @@ static void server_ctrl_handle_reset(struct server_ctrl_struct *ctrl)
 {
 	ksmbd_ipc_soft_reset();
 	ksmbd_conn_transport_destroy();
+	ksmbd_stop_durable_scavenger();
 	server_conf_free();
 	server_conf_init();
 	WRITE_ONCE(server_conf.state, SERVER_STATE_STARTING_UP);
diff --git a/fs/smb/server/server.h b/fs/smb/server/server.h
index db7278181760..4fc529335271 100644
--- a/fs/smb/server/server.h
+++ b/fs/smb/server/server.h
@@ -44,6 +44,7 @@ struct ksmbd_server_config {
 	unsigned int		max_connections;
 
 	char			*conf[SERVER_CONF_WORK_GROUP + 1];
+	struct task_struct	*dh_task;
 };
 
 extern struct ksmbd_server_config server_conf;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b6c5a8ea3887..4fb5070d3dc5 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3519,7 +3519,7 @@ int smb2_open(struct ksmbd_work *work)
 					SMB2_CREATE_GUID_SIZE);
 			if (dh_info.timeout)
 				fp->durable_timeout = min(dh_info.timeout,
-						300000);
+						DURABLE_HANDLE_MAX_TIMEOUT);
 			else
 				fp->durable_timeout = 60;
 		}
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index 643f5e1cfe35..3be7d5ae65a8 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -72,6 +72,8 @@ struct create_durable_req_v2 {
 	__u8 CreateGuid[16];
 } __packed;
 
+#define DURABLE_HANDLE_MAX_TIMEOUT	300000
+
 struct create_durable_reconn_req {
 	struct create_context_hdr ccontext;
 	__u8   Name[8];
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index a6804545db28..882a87f9e3ab 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -8,6 +8,8 @@
 #include <linux/filelock.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
 
 #include "glob.h"
 #include "vfs_cache.h"
@@ -17,6 +19,7 @@
 #include "mgmt/tree_connect.h"
 #include "mgmt/user_session.h"
 #include "smb_common.h"
+#include "server.h"
 
 #define S_DEL_PENDING			1
 #define S_DEL_ON_CLS			2
@@ -31,6 +34,11 @@ static struct ksmbd_file_table global_ft;
 static atomic_long_t fd_limit;
 static struct kmem_cache *filp_cache;
 
+static bool durable_scavenger_running;
+static DEFINE_MUTEX(durable_scavenger_lock);
+struct task_struc *dh_task;
+wait_queue_head_t dh_wq;
+
 void ksmbd_set_fd_limit(unsigned long limit)
 {
 	limit = min(limit, get_max_files());
@@ -279,9 +287,16 @@ static void __ksmbd_remove_durable_fd(struct ksmbd_file *fp)
 	if (!has_file_id(fp->persistent_id))
 		return;
 
-	write_lock(&global_ft.lock);
 	idr_remove(global_ft.idr, fp->persistent_id);
+}
+
+static void ksmbd_remove_durable_fd(struct ksmbd_file *fp)
+{
+	write_lock(&global_ft.lock);
+	__ksmbd_remove_durable_fd(fp);
 	write_unlock(&global_ft.lock);
+	if (waitqueue_active(&dh_wq))
+		wake_up(&dh_wq);
 }
 
 static void __ksmbd_remove_fd(struct ksmbd_file_table *ft, struct ksmbd_file *fp)
@@ -304,7 +319,7 @@ static void __ksmbd_close_fd(struct ksmbd_file_table *ft, struct ksmbd_file *fp)
 	struct ksmbd_lock *smb_lock, *tmp_lock;
 
 	fd_limit_close();
-	__ksmbd_remove_durable_fd(fp);
+	ksmbd_remove_durable_fd(fp);
 	if (ft)
 		__ksmbd_remove_fd(ft, fp);
 
@@ -696,6 +711,142 @@ static bool tree_conn_fd_check(struct ksmbd_tree_connect *tcon,
 	return fp->tcon != tcon;
 }
 
+static bool ksmbd_durable_scavenger_alive(void)
+{
+	mutex_lock(&durable_scavenger_lock);
+	if (!durable_scavenger_running) {
+		mutex_unlock(&durable_scavenger_lock);
+		return false;
+	}
+	mutex_unlock(&durable_scavenger_lock);
+
+	if (kthread_should_stop())
+		return false;
+
+	if (idr_is_empty(global_ft.idr))
+		return false;
+
+	return true;
+}
+
+static void ksmbd_scavenger_dispose_dh(struct list_head *head)
+{
+	while (!list_empty(head)) {
+		struct ksmbd_file *fp;
+
+		fp = list_first_entry(head, struct ksmbd_file, node);
+		list_del_init(&fp->node);
+		__ksmbd_close_fd(NULL, fp);
+	}
+}
+
+static int ksmbd_durable_scavenger(void *dummy)
+{
+	struct ksmbd_file *fp = NULL;
+	unsigned int id;
+	unsigned int min_timeout = 1;
+	bool found_fp_timeout;
+	LIST_HEAD(scavenger_list);
+	unsigned long remaining_jiffies;
+
+	__module_get(THIS_MODULE);
+
+	set_freezable();
+	while (ksmbd_durable_scavenger_alive()) {
+		if (try_to_freeze())
+			continue;
+
+		found_fp_timeout = false;
+
+		remaining_jiffies = wait_event_timeout(dh_wq,
+				   ksmbd_durable_scavenger_alive() == false,
+				   __msecs_to_jiffies(min_timeout));
+		if (remaining_jiffies)
+			min_timeout = jiffies_to_msecs(remaining_jiffies);
+		else
+			min_timeout = DURABLE_HANDLE_MAX_TIMEOUT;
+
+		write_lock(&global_ft.lock);
+		idr_for_each_entry(global_ft.idr, fp, id) {
+			if (!fp->durable_timeout)
+				continue;
+
+			if (atomic_read(&fp->refcount) > 1 ||
+			    fp->conn)
+				continue;
+
+			found_fp_timeout = true;
+			if (fp->durable_scavenger_timeout <=
+			    jiffies_to_msecs(jiffies)) {
+				__ksmbd_remove_durable_fd(fp);
+				list_add(&fp->node, &scavenger_list);
+			} else {
+				unsigned long durable_timeout;
+
+				durable_timeout =
+					fp->durable_scavenger_timeout -
+						jiffies_to_msecs(jiffies);
+
+				if (min_timeout > durable_timeout)
+					min_timeout = durable_timeout;
+			}
+		}
+		write_unlock(&global_ft.lock);
+
+		ksmbd_scavenger_dispose_dh(&scavenger_list);
+
+		if (found_fp_timeout == false)
+			break;
+	}
+
+	mutex_lock(&durable_scavenger_lock);
+	durable_scavenger_running = false;
+	mutex_unlock(&durable_scavenger_lock);
+
+	module_put(THIS_MODULE);
+
+	return 0;
+}
+
+void ksmbd_launch_ksmbd_durable_scavenger(void)
+{
+	if (!(server_conf.flags & KSMBD_GLOBAL_FLAG_DURABLE_HANDLE))
+		return;
+
+	mutex_lock(&durable_scavenger_lock);
+	if (durable_scavenger_running == true) {
+		mutex_unlock(&durable_scavenger_lock);
+		return;
+	}
+
+	durable_scavenger_running = true;
+
+	server_conf.dh_task = kthread_run(ksmbd_durable_scavenger,
+				     (void *)NULL, "ksmbd-durable-scavenger");
+	if (IS_ERR(server_conf.dh_task))
+		pr_err("cannot start conn thread, err : %ld\n",
+		       PTR_ERR(server_conf.dh_task));
+	mutex_unlock(&durable_scavenger_lock);
+}
+
+void ksmbd_stop_durable_scavenger(void)
+{
+	if (!(server_conf.flags & KSMBD_GLOBAL_FLAG_DURABLE_HANDLE))
+		return;
+
+	mutex_lock(&durable_scavenger_lock);
+	if (!durable_scavenger_running) {
+		mutex_unlock(&durable_scavenger_lock);
+		return;
+	}
+
+	durable_scavenger_running = false;
+	if (waitqueue_active(&dh_wq))
+		wake_up(&dh_wq);
+	mutex_unlock(&durable_scavenger_lock);
+	kthread_stop(server_conf.dh_task);
+}
+
 static bool session_fd_check(struct ksmbd_tree_connect *tcon,
 			     struct ksmbd_file *fp)
 {
@@ -756,11 +907,12 @@ void ksmbd_free_global_file_table(void)
 	unsigned int		id;
 
 	idr_for_each_entry(global_ft.idr, fp, id) {
-		__ksmbd_remove_durable_fd(fp);
-		kmem_cache_free(filp_cache, fp);
+		ksmbd_remove_durable_fd(fp);
+		__ksmbd_close_fd(NULL, fp);
 	}
 
-	ksmbd_destroy_file_table(&global_ft);
+	idr_destroy(global_ft.idr);
+	kfree(global_ft.idr);
 }
 
 int ksmbd_validate_name_reconnect(struct ksmbd_share_config *share,
@@ -816,6 +968,7 @@ int ksmbd_reopen_durable_fd(struct ksmbd_work *work, struct ksmbd_file *fp)
 	}
 	up_write(&ci->m_lock);
 
+	fp->f_state = FP_NEW;
 	__open_id(&work->sess->file_table, fp, OPEN_ID_TYPE_VOLATILE_ID);
 	if (!has_file_id(fp->volatile_id)) {
 		fp->conn = NULL;
@@ -855,6 +1008,8 @@ int ksmbd_init_file_cache(void)
 	if (!filp_cache)
 		goto out;
 
+	init_waitqueue_head(&dh_wq);
+
 	return 0;
 
 out:
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index f2ab1514e81a..b0f6d0f94cb8 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -153,6 +153,8 @@ struct ksmbd_file *ksmbd_lookup_fd_cguid(char *cguid);
 struct ksmbd_file *ksmbd_lookup_fd_inode(struct dentry *dentry);
 unsigned int ksmbd_open_durable_fd(struct ksmbd_file *fp);
 struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp);
+void ksmbd_launch_ksmbd_durable_scavenger(void);
+void ksmbd_stop_durable_scavenger(void);
 void ksmbd_close_tree_conn_fds(struct ksmbd_work *work);
 void ksmbd_close_session_fds(struct ksmbd_work *work);
 int ksmbd_close_inode_fds(struct ksmbd_work *work, struct inode *inode);
-- 
2.25.1

