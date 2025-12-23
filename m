Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91D63358C0
	for <linux-cifs@vger.kernel.org>; Tue, 23 Dec 2025 12:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766493828; cv=none; b=hCbaycDqFHZGLL5xZ/QYK0ZrMpb48mA/J7TPkoKdwbkfCFYmNtMH8adoPGg/pWOTsTmuhDx3Jji8DVtF6oSeKqBWDISX+nniOaUgYsU8GCW8HS83JzL93AhzfuQXHDaaPGa68NGXDJ1vZpYS8HBfxPZtXywtGL5/BZE7YcOFq2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766493828; c=relaxed/simple;
	bh=kPNVdp0GBSCF292ESsYylSmdqGIcAxgtfQAGeVTeIXg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=US9FZ/b0fgBYz8mXIKQmsrxl6ZybVPII5eM4N3OqJpcBaYn0+Pr6fIWAvXFm0eoXowDrXtxqqKhgwyn5Yjo1sxAcStIEvena6+ig4Vfe0/X03s9Kmzk6UKmGDHWa9QLLJzTbE/BrtSWoXXGxuPXCnGCZ/Es47jNWE1J4NyHCrpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D5CFwY3V; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D5CFwY3V"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-34b75fba315so5596983a91.3
        for <linux-cifs@vger.kernel.org>; Tue, 23 Dec 2025 04:43:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766493826; x=1767098626; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=n9xfB6bM1Z+7QU2e/goT4Iic+k1CppgxDaL2ZCQcvYg=;
        b=D5CFwY3VAXi05ei1ReFcgxojiZnokBvWuEwJqzSnrTUIT4XGqkMv6RfRtzWkldwQKV
         J2bXonFBAU75QUsogplhcL6eeDFxjWQq30Hji9zEICrU52AwWPTxqsY81vmOgUkwXfuk
         RL4vw+QZ5Ys5FbwjlhB+/toMFhWJzsLmwkiJh0edfXsBpZJH1mEBia/v/7d7KSqmXyrG
         hVTvqLhSd6lab0U1mHZ/Gsim2+F+kNfRyw4V0YqqVFQOu4+vJUIcuK6HjkroPsvt8vmZ
         yYFWR+cPtjbax6q8QuLljELlThTwOYV6qIndSrTFxdmpreoLn1hdUe64MV0S9PSnTGAl
         7Vqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766493826; x=1767098626;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n9xfB6bM1Z+7QU2e/goT4Iic+k1CppgxDaL2ZCQcvYg=;
        b=tAMnBx1I8gYwTE4Sa4U9V5wZ3oDLQ7nHWBuintgErvZ5N1EDZ+E3/4hDad5zUmGvWG
         7Ep8gA6HK9doUSEg3Crn6JVO6q996uz8DxiNMeRFl0CnLFoOiBZYA5ncJWgJUgENubJk
         uRzCx1HY5nyKYwzzNRYxRc/g3VHuhE2+dGi8VaEn4oD7fTuxTNu6GbnJRht8ul3B1aQy
         n2ndfGWYe8IAjm+mCdlRExwnex1wBrFP2Ub9ZFI7SOvx+WpQtlWhNbvWk5Q9wq/8UjzM
         kCNAktIA9tew1UzXVBKOauC9MglpkJ3kEr99Iu8qZbdlpgdRVPl2n21Zq670SQH0elYy
         mD4Q==
X-Forwarded-Encrypted: i=1; AJvYcCUSNGcVyUZmH9AXEbN+jfW26Z3J8otyX4lc2OlR+fDUKexRRiAl4gMiy9N5w2FwAKr0hKgBYa/63a4t@vger.kernel.org
X-Gm-Message-State: AOJu0YzEQ1MY++M6KQ1yB1afmLiJI6ViA0SlDu/19WBdqBYqb6UzwWbI
	jOkCVuI3KnwVheHo3fuIJOkF6wSq5mFbklkboISnz//KWRNIjVU2/OJi
X-Gm-Gg: AY/fxX5rHyFbNJMMCc1ogxECzObg9j9lBQdx8hseiwoX/KyUHUnkXVIXwdZuimyMCCt
	5d6mWC/PQN1HtkC7Z5A+4m1OFJp56GLpWAIULPmPKWZmH0FbXNpvHAd6LNLqkHUDx3LLFfFnQUH
	YZjcHXbiAkHTWTbt0660iRvR3SbIdCQHPwnr7uU44gTVLPSTTKcbQyi4p7Fn4TgPMBmQXaw+Ek8
	KwRwcN42hGAuYq7CnKXq4CD46zRSkwBjINlmiFh1w55ia2f4QOee/XU621psl63P55t1Fvsth6L
	0xMXQGClK5I5foQUjQjrlQIqQqQvX8ZT3jZ8xlkwoIZlKYHCEEO5D0LxPjCeDsDyaklF1K/RrZZ
	NOTl9Z2G1xTp9Dj4KueMV6G6RC96YTsIIMj7T89GneZ59EOda3L3NwmqT66x84sh6OT/Tnggw7X
	/ZzlUoxkJVP4fXsKuOZM7PXI0UR8pLxGdX
X-Google-Smtp-Source: AGHT+IEaFjA9v+EGIAoGfDWVvHiWVW2eowhdPUVTkzF3db83+cxFxSZ1FxpHKpAkokMdTpM9NMDAbQ==
X-Received: by 2002:a17:90b:590b:b0:32d:dc3e:5575 with SMTP id 98e67ed59e1d1-34e9212a396mr11211228a91.5.1766493825919;
        Tue, 23 Dec 2025 04:43:45 -0800 (PST)
Received: from archlinuxms.domain.name ([2401:4900:1cc4:6259:9219:dc3e:6361:833a])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1e7961b4d0sm11815288a12.5.2025.12.23.04.43.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 04:43:45 -0800 (PST)
From: Piyush Sachdeva <s.piyush1024@gmail.com>
To: sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: sprasad@microsoft.com,
	bharathsm@microsoft.com,
	msetiya@microsoft.com,
	rajasimandal@microsoft.com,
	psachdeva@microsoft.com,
	Piyush Sachdeva <s.piyush1024@gmail.com>
Subject: [PATCH] smb: client: close all files marked for deferred close immediately
Date: Tue, 23 Dec 2025 18:11:19 +0530
Message-ID: <20251223124119.1383159-1-s.piyush1024@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Piyush Sachdeva <psachdeva@microsoft.com>

SMB client has a feature to delay the close of a file on the server,
expecting if an open call comes for the same file, the file doesn't
need to be re-opened. The time duration of the deferred close is set
by the mount option `closetimeo`.
This patch lets a user list all handles marked for deferred close, by
cat /proc/fs/cifs/close_deferred_closes.
It also allow for force close of all files marked for deferred close,
across all session by writing a non-zero value to the same procfs file.

Signed-off-by: Piyush Sachdeva <psachdeva@microsoft.com>
Signed-off-by: Piyush Sachdeva <s.piyush1024@gmail.com>
---
 fs/smb/client/cifs_debug.c | 137 +++++++++++++++++++++++++++++++++++++
 fs/smb/client/cifsglob.h   |   5 ++
 2 files changed, 142 insertions(+)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 7fdcaf9feb16..e149a403b16e 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -952,6 +952,7 @@ static const struct proc_ops traceSMB_proc_ops;
 static const struct proc_ops cifs_security_flags_proc_ops;
 static const struct proc_ops cifs_linux_ext_proc_ops;
 static const struct proc_ops cifs_mount_params_proc_ops;
+static const struct proc_ops close_all_deferred_close_ops;
 
 void
 cifs_proc_init(void)
@@ -981,6 +982,8 @@ cifs_proc_init(void)
 
 	proc_create("mount_params", 0444, proc_fs_cifs, &cifs_mount_params_proc_ops);
 
+	proc_create("close_deferred_closes", 0644, proc_fs_cifs, &close_all_deferred_close_ops);
+
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	proc_create("dfscache", 0644, proc_fs_cifs, &dfscache_proc_ops);
 #endif
@@ -1021,6 +1024,7 @@ cifs_proc_clean(void)
 	remove_proc_entry("LinuxExtensionsEnabled", proc_fs_cifs);
 	remove_proc_entry("LookupCacheEnabled", proc_fs_cifs);
 	remove_proc_entry("mount_params", proc_fs_cifs);
+	remove_proc_entry("close_deferred_closes", proc_fs_cifs);
 
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	remove_proc_entry("dfscache", proc_fs_cifs);
@@ -1317,6 +1321,139 @@ static const struct proc_ops cifs_mount_params_proc_ops = {
 	/* .proc_write	= cifs_mount_params_proc_write, */
 };
 
+static struct list_head *get_all_tcons(void)
+{
+	struct TCP_Server_Info *server;
+	struct cifs_ses *ses;
+	struct cifs_tcon *tcon;
+	struct global_tcon_list *tree_con_list, *tmp_tree_con_list;
+	struct list_head *tcon_head;
+
+	tcon_head = kmalloc(sizeof(struct list_head), GFP_KERNEL);
+	if (tcon_head == NULL)
+		return NULL;
+
+	INIT_LIST_HEAD(tcon_head);
+	spin_lock(&cifs_tcp_ses_lock);
+	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
+		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+			if (cifs_ses_exiting(ses))
+				continue;
+			list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
+				tree_con_list =
+					kmalloc(sizeof(struct global_tcon_list),
+						GFP_ATOMIC);
+				if (tree_con_list == NULL)
+					goto tcon_alloc_fail;
+				tree_con_list->tcon = tcon;
+				list_add_tail(&tree_con_list->list, tcon_head);
+			}
+		}
+	}
+	spin_unlock(&cifs_tcp_ses_lock);
+	return tcon_head;
+
+tcon_alloc_fail:
+	spin_unlock(&cifs_tcp_ses_lock);
+	list_for_each_entry_safe(tree_con_list, tmp_tree_con_list, tcon_head,
+				 list) {
+		list_del(&tree_con_list->list);
+		kfree(tree_con_list);
+	}
+	kfree(tcon_head);
+	return NULL;
+}
+
+static ssize_t close_all_deferred_close_files(struct file *file,
+					  const char __user *buffer,
+					  size_t count, loff_t *ppos)
+{
+	char c;
+	int rc;
+	struct global_tcon_list *tmp_list, *tmp_next_list;
+	struct list_head *tcon_head;
+
+	rc = get_user(c, buffer);
+	if (rc)
+		return rc;
+	if (c == '0')
+		return -EINVAL;
+
+	tcon_head = get_all_tcons();
+	if (tcon_head == NULL)
+		return count;
+
+	list_for_each_entry_safe(tmp_list, tmp_next_list, tcon_head, list) {
+		cifs_close_all_deferred_files(tmp_list->tcon);
+		list_del(&tmp_list->list);
+		kfree(tmp_list);
+	}
+
+	kfree(tcon_head);
+	return count;
+}
+
+static int show_all_deferred_close_files(struct seq_file *m, void *v)
+{
+	struct global_tcon_list *tmp_list, *tmp_next_list;
+	struct list_head *tcon_head;
+	struct cifs_tcon *tcon;
+	struct cifsFileInfo *cfile;
+
+	seq_puts(m, "# Version:1\n");
+	seq_puts(m, "# Format:\n");
+	seq_puts(m, "# <tree id> <ses id> <persistent fid> <flags> <count> <pid> <uid>");
+#ifdef CONFIG_CIFS_DEBUG2
+	seq_puts(m, " <filename> <mid>\n");
+#else
+	seq_puts(m, " <filename>\n");
+#endif /* CIFS_DEBUG2 */
+
+	tcon_head = get_all_tcons();
+	if (tcon_head == NULL)
+		return 0;
+
+	list_for_each_entry_safe(tmp_list, tmp_next_list, tcon_head, list) {
+		tcon = tmp_list->tcon;
+		spin_lock(&tcon->open_file_lock);
+		list_for_each_entry(cfile, &tcon->openFileList, tlist) {
+			if (delayed_work_pending(&cfile->deferred)) {
+				seq_printf(
+					m,
+					"0x%x 0x%llx 0x%llx 0x%x %d %d %d %pd",
+					tcon->tid, tcon->ses->Suid,
+					cfile->fid.persistent_fid,
+					cfile->f_flags, cfile->count,
+					cfile->pid,
+					from_kuid(&init_user_ns, cfile->uid),
+					cfile->dentry);
+			}
+		}
+		spin_unlock(&tcon->open_file_lock);
+		list_del(&tmp_list->list);
+		kfree(tmp_list);
+	}
+
+	kfree(tcon_head);
+	seq_putc(m, '\n');
+
+	return 0;
+}
+
+static int show_all_deferred_close_proc_open(struct inode *inode,
+					      struct file *file)
+{
+	return single_open(file, show_all_deferred_close_files, NULL);
+}
+
+static const struct proc_ops close_all_deferred_close_ops = {
+	.proc_open = show_all_deferred_close_proc_open,
+	.proc_read = seq_read,
+	.proc_lseek = seq_lseek,
+	.proc_release = single_release,
+	.proc_write = close_all_deferred_close_files,
+};
+
 #else
 inline void cifs_proc_init(void)
 {
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 203e2aaa3c25..56c987258c4b 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1806,6 +1806,11 @@ struct dfs_info3_param {
 	int ttl;
 };
 
+struct global_tcon_list {
+	struct list_head list;
+	struct cifs_tcon *tcon;
+};
+
 struct file_list {
 	struct list_head list;
 	struct cifsFileInfo *cfile;
-- 
2.52.0

