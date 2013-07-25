From: scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH 2/2] cifs: Correct comment about domainname length
Date: Thu, 25 Jul 2013 14:34:45 -0400
Message-ID: <1374777285-25639-2-git-send-email-scott.lovenberg@gmail.com>
References: <1374777285-25639-1-git-send-email-scott.lovenberg@gmail.com>
Cc: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gang.chen-bOixZGp5f+dBDgjK7y7TUQ@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1374777285-25639-1-git-send-email-scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

CIFS_MAX_DOMAINNAME_LEN is the max length for a domain name, not a fully qualified domain name.

Signed-off-by: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 include/uapi/linux/cifs/cifs_mount.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/cifs/cifs_mount.h b/include/uapi/linux/cifs/cifs_mount.h
index a58fc6e..d2408ec 100644
--- a/include/uapi/linux/cifs/cifs_mount.h
+++ b/include/uapi/linux/cifs/cifs_mount.h
@@ -17,7 +17,7 @@
 #define _CIFS_MOUNT_H
 
 /* Max string lengths for cifs mounting options. */
-#define CIFS_MAX_DOMAINNAME_LEN 256 /* max fully qualified domain name */
+#define CIFS_MAX_DOMAINNAME_LEN 256 /* max domain name length */
 #define CIFS_MAX_USERNAME_LEN   256 /* reasonable max for current servers */
 #define CIFS_MAX_PASSWORD_LEN   512 /* Windows max seems to be 256 wide chars */
 #define CIFS_MAX_SHARE_LEN      256 /* reasonable max share name length */
-- 
1.8.1.4
