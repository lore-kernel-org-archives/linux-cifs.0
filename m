From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 2/6] mount.cifs: don't pass "flag" options to the kernel
Date: Tue,  4 Dec 2012 10:16:40 -0500
Message-ID: <1354634204-21602-3-git-send-email-jlayton@samba.org>
References: <1354634204-21602-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1354634204-21602-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

When certain options are passed to the mount helper, we want to turn
them into mountflags for the mount() syscall. There's no need to copy
them to the options string in that case though.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 mount.cifs.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index 9760d1f..869af35 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -1091,23 +1091,15 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
 					"WARNING: '%s' not expressed in octal.\n",
 					data);
 			break;
-
-		/* the following mount options should be
-		   stripped out from what is passed into the kernel
-		   since these options are best passed as the
-		   mount flags rather than redundantly to the kernel
-		   and could generate spurious warnings depending on the
-		   level of the corresponding cifs vfs kernel code */
 		case OPT_NO_SUID:
 			*filesys_flags |= MS_NOSUID;
-			break;
+			goto nocopy;
 		case OPT_SUID:
 			*filesys_flags &= ~MS_NOSUID;
-			break;
+			goto nocopy;
 		case OPT_NO_DEV:
 			*filesys_flags |= MS_NODEV;
-			break;
-		/* nolock || nobrl */
+			goto nocopy;
 		case OPT_NO_LOCK:
 			*filesys_flags &= ~MS_MANDLOCK;
 			break;
@@ -1119,17 +1111,17 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
 			goto nocopy;
 		case OPT_DEV:
 			*filesys_flags &= ~MS_NODEV;
-			break;
+			goto nocopy;
 		case OPT_NO_EXEC:
 			*filesys_flags |= MS_NOEXEC;
-			break;
+			goto nocopy;
 		case OPT_EXEC:
 			*filesys_flags &= ~MS_NOEXEC;
-			break;
+			goto nocopy;
 		case OPT_GUEST:
 			parsed_info->got_user = 1;
 			parsed_info->got_password = 1;
-			break;
+			goto nocopy;
 		case OPT_RO:
 			*filesys_flags |= MS_RDONLY;
 			goto nocopy;
@@ -1138,7 +1130,7 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
 			goto nocopy;
 		case OPT_REMOUNT:
 			*filesys_flags |= MS_REMOUNT;
-			break;
+			goto nocopy;
 		case OPT_IGNORE:
 			goto nocopy;
 		case OPT_BKUPUID:
-- 
1.7.11.7
