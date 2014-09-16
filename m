From: Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>
Subject: [PATCH 05/22] cifs: Replace strnicmp with strncasecmp
Date: Tue, 16 Sep 2014 22:51:19 +0200
Message-ID: <1410900696-6481-6-git-send-email-linux@rasmusvillemoes.dk>
References: <1410900696-6481-1-git-send-email-linux@rasmusvillemoes.dk>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410900696-6481-1-git-send-email-linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The kernel used to contain two functions for length-delimited,
case-insensitive string comparison, strnicmp with correct semantics
and a slightly buggy strncasecmp. The latter is the POSIX name, so
strnicmp was renamed to strncasecmp, and strnicmp made into a wrapper
for the new strncasecmp to avoid breaking existing users.

To allow the compat wrapper strnicmp to be removed at some point in
the future, and to avoid the extra indirection cost, do
s/strnicmp/strncasecmp/g.

Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
Signed-off-by: Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>
---
 fs/cifs/cifs_dfs_ref.c | 6 +++---
 fs/cifs/connect.c      | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index 58df174..b8602f1 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -195,15 +195,15 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
 		else
 			noff = tkn_e - (sb_mountdata + off) + 1;
 
-		if (strnicmp(sb_mountdata + off, "unc=", 4) == 0) {
+		if (strncasecmp(sb_mountdata + off, "unc=", 4) == 0) {
 			off += noff;
 			continue;
 		}
-		if (strnicmp(sb_mountdata + off, "ip=", 3) == 0) {
+		if (strncasecmp(sb_mountdata + off, "ip=", 3) == 0) {
 			off += noff;
 			continue;
 		}
-		if (strnicmp(sb_mountdata + off, "prefixpath=", 11) == 0) {
+		if (strncasecmp(sb_mountdata + off, "prefixpath=", 11) == 0) {
 			off += noff;
 			continue;
 		}
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 8a9fded..48e079e 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1705,7 +1705,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 				goto cifs_parse_mount_err;
 			}
 
-			 if (strnicmp(string, "default", 7) != 0) {
+			 if (strncasecmp(string, "default", 7) != 0) {
 				vol->iocharset = kstrdup(string,
 							 GFP_KERNEL);
 				if (!vol->iocharset) {
@@ -1777,7 +1777,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			if (string == NULL)
 				goto out_nomem;
 
-			if (strnicmp(string, "1", 1) == 0) {
+			if (strncasecmp(string, "1", 1) == 0) {
 				/* This is the default */
 				break;
 			}
-- 
2.0.4
