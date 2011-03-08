From: Vinay Sawal <vinaysawal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] FC: cifs: Initialized an uninitialized variable
Date: Mon,  7 Mar 2011 20:00:09 -0800
Message-ID: <1299556809-16194-1-git-send-email-vinaysawal@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vinay Sawal <vinaysawal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Removed a compile time warning by initializing an uninitialized variable.

Signed-off-by: Vinay Sawal <vinaysawal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index e964b1c..a9e5901 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1819,7 +1819,7 @@ static ssize_t
 cifs_iovec_read(struct file *file, const struct iovec *iov,
 		 unsigned long nr_segs, loff_t *poffset)
 {
-	int rc;
+	int rc = -EFAULT;
 	int xid;
 	ssize_t total_read;
 	unsigned int bytes_read = 0;
-- 
1.6.2.4
