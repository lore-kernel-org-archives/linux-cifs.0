From: scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH 2/2] cifs: Expand max share name length to 256
Date: Thu, 25 Jul 2013 13:35:21 -0400
Message-ID: <1374773721-24394-2-git-send-email-scott.lovenberg@gmail.com>
References: <1374773721-24394-1-git-send-email-scott.lovenberg@gmail.com>
Cc: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gang.chen-bOixZGp5f+dBDgjK7y7TUQ@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1374773721-24394-1-git-send-email-scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

The old max share name length limit was 80 due to Windows NET SHARE
command not allowing more than that.  However, share names can be much
longer.  This is a more reasonable maximum share name length.

Signed-off-by: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 include/uapi/linux/cifs/cifs_mount.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/cifs/cifs_mount.h b/include/uapi/linux/cifs/cifs_mount.h
index 1485781..f7e4aee 100644
--- a/include/uapi/linux/cifs/cifs_mount.h
+++ b/include/uapi/linux/cifs/cifs_mount.h
@@ -20,6 +20,6 @@
 #define CIFS_MAX_DOMAINNAME_LEN 256 /* max fully qualified domain name */
 #define CIFS_MAX_USERNAME_LEN   256 /* reasonable max for current servers */
 #define CIFS_MAX_PASSWORD_LEN   512 /* Windows max seems to be 256 wide chars */
-#define CIFS_MAX_SHARE_LEN 80
+#define CIFS_MAX_SHARE_LEN      256 /* reasonable max share name length */
 
 #endif /* _CIFS_MOUNT_H */
-- 
1.8.1.4
