From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] manpage: cleanups to new backupuid/gid sections
Date: Wed, 19 Oct 2011 13:57:04 -0400
Message-ID: <1319047024-8676-1-git-send-email-jlayton@samba.org>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Minor cleanups and consistency fixes...

Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 mount.cifs.8 |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/mount.cifs.8 b/mount.cifs.8
index 8207bcb..958efa5 100644
--- a/mount.cifs.8
+++ b/mount.cifs.8
@@ -282,16 +282,16 @@ See sections on
 for more information\&.
 .RE
 .PP
-backupuid=arg
+backupuid=\fIarg\fR
 .RS 4
-Restrict access to files, with the backup intent, to a user.  Either a name or an id must be provided as an argument, there are no default values.
+Restrict access to files with the backup intent to a user. Either a name or an id must be provided as an argument, there are no default values.
 .sp
 See section \fIACCESSING FILES WITH BACKUP INTENT\fR for more details
 .RE
 .PP
-backupgid=arg
+backupgid=\fIarg\fR
 .RS 4
-Restrict Allow access to files, with the backup intent, to a group.  Either a name or an id must be provided as an argument, there are no default values.
+Restrict access to files with the backup intent to a group. Either a name or an id must be provided as an argument, there are no default values.
 .sp
 See section \fIACCESSING FILES WITH BACKUP INTENT\fR for more details
 .RE
@@ -625,11 +625,7 @@ But the user testuser, if it becomes part of the group Backup Operators, can ope
 Any user on the client side who can authenticate as such a user on the server,
 can access the files with the backup intent. But it is desirable and preferable for security reasons amongst many, to restrict this special right.
 
-The mount option backupuid is used to restrict this special right to a user which is specified by either a name or an id.
-.sp 0
-The mount option backupgid is used to restrict this special right to the users in a group which is specified by either a name or an id.
-.sp 0
-These two mount options can be used together.
+The mount option backupuid is used to restrict this special right to a user which is specified by either a name or an id. The mount option backupgid is used to restrict this special right to the users in a group which is specified by either a name or an id. These two mount options can be used together.
 .SH "FILE AND DIRECTORY OWNERSHIP AND PERMISSIONS"
 .PP
 The core CIFS protocol does not provide unix ownership information or mode for files and directories\&. Because of this, files and directories will generally appear to be owned by whatever values the uid= or gid= options are set, and will have permissions set to the default file_mode and dir_mode for the mount\&. Attempting to change these values via chmod/chown will return success but have no effect\&.
-- 
1.7.6.4
