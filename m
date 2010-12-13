From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 7/7] CIFS: Add strictcache mount option
Date: Mon, 13 Dec 2010 18:00:55 +0300
Message-ID: <1292252455-4025-7-git-send-email-piastryyy@gmail.com>
References: <1292252455-4025-1-git-send-email-piastryyy@gmail.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1292252455-4025-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Use for switching on strict cache mode. In this mode the
client reads from the cache all the time it has Oplock Level II,
otherwise - read from the server. As for write - the client stores
a data in the cache in Exclusive Oplock case, otherwise - write
directly to the server.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/README    |    5 +++++
 fs/cifs/connect.c |    5 +++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/README b/fs/cifs/README
index 46af99a..fe16835 100644
--- a/fs/cifs/README
+++ b/fs/cifs/README
@@ -452,6 +452,11 @@ A partial list of the supported mount options follows:
 		if oplock (caching token) is granted and held. Note that
 		direct allows write operations larger than page size
 		to be sent to the server.
+  strictcache   Use for switching on strict cache mode. In this mode the
+		client read from the cache all the time it has Oplock Level II,
+		otherwise - read from the server. All written data are stored
+		in the cache, but if the client doesn't have Exclusive Oplock,
+		it writes the data to the server.
   acl   	Allow setfacl and getfacl to manage posix ACLs if server
 		supports them.  (default)
   noacl 	Do not allow setfacl and getfacl calls on this mount
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index cc1a860..877cb9e 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -84,6 +84,7 @@ struct smb_vol {
 	bool no_xattr:1;   /* set if xattr (EA) support should be disabled*/
 	bool server_ino:1; /* use inode numbers from server ie UniqueId */
 	bool direct_io:1;
+	bool strict_io:1; /* strict cache behavior */
 	bool remap:1;      /* set to remap seven reserved chars in filenames */
 	bool posix_paths:1; /* unset to not ask for posix pathnames. */
 	bool no_linux_ext:1;
@@ -1357,6 +1358,8 @@ cifs_parse_mount_options(char *options, const char *devname,
 			vol->direct_io = 1;
 		} else if (strnicmp(data, "forcedirectio", 13) == 0) {
 			vol->direct_io = 1;
+		} else if (strnicmp(data, "strictcache", 11) == 0) {
+			vol->strict_io = 1;
 		} else if (strnicmp(data, "noac", 4) == 0) {
 			printk(KERN_WARNING "CIFS: Mount option noac not "
 				"supported. Instead set "
@@ -2614,6 +2617,8 @@ static void setup_cifs_sb(struct smb_vol *pvolume_info,
 	if (pvolume_info->multiuser)
 		cifs_sb->mnt_cifs_flags |= (CIFS_MOUNT_MULTIUSER |
 					    CIFS_MOUNT_NO_PERM);
+	if (pvolume_info->strict_io)
+		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_STRICT_IO;
 	if (pvolume_info->direct_io) {
 		cFYI(1, "mounting share using direct i/o");
 		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_DIRECT_IO;
-- 
1.7.3.2
