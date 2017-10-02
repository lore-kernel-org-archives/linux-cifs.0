From: Long Li <longli@exchange.microsoft.com>
Subject: [Patch v4 03/22] CIFS: SMBD: export protocol initial values
Date: Sun,  1 Oct 2017 19:30:11 -0700
Message-ID: <20171002023030.3582-4-longli@exchange.microsoft.com>
References: <20171002023030.3582-1-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Tom Talpey <ttalpey@microsoft.com>,
        Matthew Wilcox <mawilcox@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171002023030.3582-1-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

Those values can be configured by user. Export them to /proc/fs/cifs.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifs_debug.c | 70 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 9727e1d..bdc2f38 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -369,6 +369,52 @@ static const struct file_operations cifs_stats_proc_fops = {
 };
 #endif /* STATS */
 
+#define PROC_FILE_DEFINE(name) \
+static ssize_t name##_write(struct file *file, const char __user *buffer, \
+	size_t count, loff_t *ppos) \
+{ \
+	int rc; \
+	rc = kstrtoint_from_user(buffer, count, 10, & name ); \
+	if (rc) \
+		return rc; \
+	return count; \
+} \
+static int name##_proc_show(struct seq_file *m, void *v) \
+{ \
+	seq_printf(m, "%d\n", name ); \
+	return 0; \
+} \
+static int name##_open(struct inode *inode, struct file *file) \
+{ \
+	return single_open(file, name##_proc_show, NULL); \
+} \
+\
+static const struct file_operations cifs_##name##_proc_fops = { \
+	.open		= name##_open, \
+	.read		= seq_read, \
+	.llseek		= seq_lseek, \
+	.release	= single_release, \
+	.write		= name##_write, \
+}
+
+extern int rdma_readwrite_threshold;
+extern int smbd_max_frmr_depth;
+extern int smbd_keep_alive_interval;
+extern int smbd_max_receive_size;
+extern int smbd_max_fragmented_recv_size;
+extern int smbd_max_send_size;
+extern int smbd_send_credit_target;
+extern int smbd_receive_credit_max;
+
+PROC_FILE_DEFINE(rdma_readwrite_threshold);
+PROC_FILE_DEFINE(smbd_max_frmr_depth);
+PROC_FILE_DEFINE(smbd_keep_alive_interval);
+PROC_FILE_DEFINE(smbd_max_receive_size);
+PROC_FILE_DEFINE(smbd_max_fragmented_recv_size);
+PROC_FILE_DEFINE(smbd_max_send_size);
+PROC_FILE_DEFINE(smbd_send_credit_target);
+PROC_FILE_DEFINE(smbd_receive_credit_max);
+
 static struct proc_dir_entry *proc_fs_cifs;
 static const struct file_operations cifsFYI_proc_fops;
 static const struct file_operations cifs_lookup_cache_proc_fops;
@@ -396,6 +442,22 @@ cifs_proc_init(void)
 		    &cifs_security_flags_proc_fops);
 	proc_create("LookupCacheEnabled", 0, proc_fs_cifs,
 		    &cifs_lookup_cache_proc_fops);
+	proc_create("rdma_readwrite_threshold", 0, proc_fs_cifs,
+		&cifs_rdma_readwrite_threshold_proc_fops);
+	proc_create("smbd_max_frmr_depth", 0, proc_fs_cifs,
+		&cifs_smbd_max_frmr_depth_proc_fops);
+	proc_create("smbd_keep_alive_interval", 0, proc_fs_cifs,
+		&cifs_smbd_keep_alive_interval_proc_fops);
+	proc_create("smbd_max_receive_size", 0, proc_fs_cifs,
+		&cifs_smbd_max_receive_size_proc_fops);
+	proc_create("smbd_max_fragmented_recv_size", 0, proc_fs_cifs,
+		&cifs_smbd_max_fragmented_recv_size_proc_fops);
+	proc_create("smbd_max_send_size", 0, proc_fs_cifs,
+		&cifs_smbd_max_send_size_proc_fops);
+	proc_create("smbd_send_credit_target", 0, proc_fs_cifs,
+		&cifs_smbd_send_credit_target_proc_fops);
+	proc_create("smbd_receive_credit_max", 0, proc_fs_cifs,
+		&cifs_smbd_receive_credit_max_proc_fops);
 }
 
 void
@@ -413,6 +475,14 @@ cifs_proc_clean(void)
 	remove_proc_entry("SecurityFlags", proc_fs_cifs);
 	remove_proc_entry("LinuxExtensionsEnabled", proc_fs_cifs);
 	remove_proc_entry("LookupCacheEnabled", proc_fs_cifs);
+	remove_proc_entry("rdma_readwrite_threshold", proc_fs_cifs);
+	remove_proc_entry("smbd_max_frmr_depth", proc_fs_cifs);
+	remove_proc_entry("smbd_keep_alive_interval", proc_fs_cifs);
+	remove_proc_entry("smbd_max_receive_size", proc_fs_cifs);
+	remove_proc_entry("smbd_max_fragmented_recv_size", proc_fs_cifs);
+	remove_proc_entry("smbd_max_send_size", proc_fs_cifs);
+	remove_proc_entry("smbd_send_credit_target", proc_fs_cifs);
+	remove_proc_entry("smbd_receive_credit_max", proc_fs_cifs);
 	remove_proc_entry("fs/cifs", NULL);
 }
 
-- 
2.7.4
