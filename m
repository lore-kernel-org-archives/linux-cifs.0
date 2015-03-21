From: Taesoo Kim <tsgatesv-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/1] cifs: potential memory leaks when parsing mnt opts
Date: Sat, 21 Mar 2015 19:08:30 -0400
Message-ID: <1426979310-31201-1-git-send-email-tsgatesv@gmail.com>
Cc: taesoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org, changwoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org, sanidhya-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org,
	blee-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org, csong84-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org,
	Taesoo Kim <tsgatesv-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

For example, when mount opt is redundently specified
(e.g., "user=A,user=B,user=C"), kernel kept allocating new key/val
with kstrdup() and overwrite previous ptr (to be freed).

Althouhg mkfs.cifs in userspace performs a bit of sanitization
(e.g., forcing one user option), current implementation is not
robust. Other options such as iocharset and domainanme are similary
vulnerable.

Signed-off-by: Taesoo Kim <tsgatesv-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/connect.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index d3aa999..4cb8450 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1599,6 +1599,8 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 				pr_warn("CIFS: username too long\n");
 				goto cifs_parse_mount_err;
 			}
+
+			kfree(vol->username);
 			vol->username = kstrdup(string, GFP_KERNEL);
 			if (!vol->username)
 				goto cifs_parse_mount_err;
@@ -1700,6 +1702,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 				goto cifs_parse_mount_err;
 			}
 
+			kfree(vol->domainname);
 			vol->domainname = kstrdup(string, GFP_KERNEL);
 			if (!vol->domainname) {
 				pr_warn("CIFS: no memory for domainname\n");
@@ -1731,6 +1734,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			}
 
 			 if (strncasecmp(string, "default", 7) != 0) {
+				kfree(vol->iocharset);
 				vol->iocharset = kstrdup(string,
 							 GFP_KERNEL);
 				if (!vol->iocharset) {
-- 
2.3.3
