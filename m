From: ZhangZhen <zhenzhang.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: new helper: file_inode(file)
Date: Thu, 6 Mar 2014 12:01:03 +0800
Message-ID: <5317F2FF.9020609@huawei.com>
References: <5316EE49.6090409@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Du Yongfeng <du.duyongfeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
To: <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5316EE49.6090409-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

cifs: new helper: file_inode(file)

Signed-off-by: Zhang Zhen <zhenzhang.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 7749230..45cb59b 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -85,7 +85,7 @@ static long cifs_ioctl_clone(unsigned int xid, struct file *dst_file,
 		goto out_fput;
 	}

-	src_inode = src_file.file->f_dentry->d_inode;
+	src_inode = file_inode(src_file.file);

 	/*
 	 * Note: cifs case is easier than btrfs since server responsible for
-- 
1.8.1.4


.




_______________________________________________
kernel.openeuler mailing list
kernel.openeuler-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
http://rnd-openeuler.huawei.com/mailman/listinfo/kernel.openeuler
