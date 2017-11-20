From: Leif Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Patch v7 06/22] CIFS: SMBD: export protocol initial values
Date: Mon, 20 Nov 2017 02:37:41 -0500 (EST)
Message-ID: <1490537439.28570701.1511163461828.JavaMail.zimbra@redhat.com>
References: <20171107085514.12693-1-longli@exchange.microsoft.com> <20171107085514.12693-7-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
        Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Stephen Hemminger <sthemmin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171107085514.12693-7-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Acked-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


----- Original Message -----
From: "Long Li" <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
To: "Steve French" <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Christoph Hellwig" <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Tom Talpey" <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, "Matthew Wilcox" <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, "Stephen Hemminger" <sthemmin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Cc: "Long Li" <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Sent: Tuesday, 7 November, 2017 7:54:58 PM
Subject: [Patch v7 06/22] CIFS: SMBD: export protocol initial values

From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

For use-configurable SMB Direct protocol values, export them to /proc/fs/cifs.

Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/cifs_debug.c | 79 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index ba0870d..7025d8d 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -30,6 +30,9 @@
 #include "cifsproto.h"
 #include "cifs_debug.h"
 #include "cifsfs.h"
+#ifdef CONFIG_CIFS_SMB_DIRECT
+#include "smbdirect.h"
+#endif
 
 void
 cifs_dump_mem(char *label, void *data, int length)
@@ -371,6 +374,54 @@ static const struct file_operations cifs_stats_proc_fops = {
 };
 #endif /* STATS */
 
+#ifdef CONFIG_CIFS_SMB_DIRECT
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
+#endif
+
 static struct proc_dir_entry *proc_fs_cifs;
 static const struct file_operations cifsFYI_proc_fops;
 static const struct file_operations cifs_lookup_cache_proc_fops;
@@ -398,6 +449,24 @@ cifs_proc_init(void)
 		    &cifs_security_flags_proc_fops);
 	proc_create("LookupCacheEnabled", 0, proc_fs_cifs,
 		    &cifs_lookup_cache_proc_fops);
+#ifdef CONFIG_CIFS_SMB_DIRECT
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
+#endif
 }
 
 void
@@ -415,6 +484,16 @@ cifs_proc_clean(void)
 	remove_proc_entry("SecurityFlags", proc_fs_cifs);
 	remove_proc_entry("LinuxExtensionsEnabled", proc_fs_cifs);
 	remove_proc_entry("LookupCacheEnabled", proc_fs_cifs);
+#ifdef CONFIG_CIFS_SMB_DIRECT
+	remove_proc_entry("rdma_readwrite_threshold", proc_fs_cifs);
+	remove_proc_entry("smbd_max_frmr_depth", proc_fs_cifs);
+	remove_proc_entry("smbd_keep_alive_interval", proc_fs_cifs);
+	remove_proc_entry("smbd_max_receive_size", proc_fs_cifs);
+	remove_proc_entry("smbd_max_fragmented_recv_size", proc_fs_cifs);
+	remove_proc_entry("smbd_max_send_size", proc_fs_cifs);
+	remove_proc_entry("smbd_send_credit_target", proc_fs_cifs);
+	remove_proc_entry("smbd_receive_credit_max", proc_fs_cifs);
+#endif
 	remove_proc_entry("fs/cifs", NULL);
 }
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
