From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] CIFS: Show backupuid/gid in /proc/mounts
Date: Tue, 24 Apr 2012 15:28:14 +0100
Message-ID: <1335277694.3604.8.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: smfrench <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Linux CIFS mailing list <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Show  backupuid/backupgid in /proc/mounts for cifs shares mounted with
the backupuid/backupgid feature.

Also consolidate the two separate checks for 
pvolume_info->backupuid_specified into a single if condition in 
cifs_setup_cifs_sb().

Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsfs.c  |    4 ++++
 fs/cifs/connect.c |   12 ++++++------
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index d342128..ea8eb92 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -434,6 +434,10 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 		seq_printf(s, ",noperm");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO)
 		seq_printf(s, ",strictcache");
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_BACKUPUID)
+		seq_printf(s, ",backupuid=%u", cifs_sb->mnt_backupuid);
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_BACKUPGID)
+		seq_printf(s, ",backupgid=%u", cifs_sb->mnt_backupgid);
 
 	seq_printf(s, ",rsize=%d", cifs_sb->rsize);
 	seq_printf(s, ",wsize=%d", cifs_sb->wsize);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index f31dc9a..f4d381e 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3228,10 +3228,6 @@ void cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
 
 	cifs_sb->mnt_uid = pvolume_info->linux_uid;
 	cifs_sb->mnt_gid = pvolume_info->linux_gid;
-	if (pvolume_info->backupuid_specified)
-		cifs_sb->mnt_backupuid = pvolume_info->backupuid;
-	if (pvolume_info->backupgid_specified)
-		cifs_sb->mnt_backupgid = pvolume_info->backupgid;
 	cifs_sb->mnt_file_mode = pvolume_info->file_mode;
 	cifs_sb->mnt_dir_mode = pvolume_info->dir_mode;
 	cFYI(1, "file mode: 0x%hx  dir mode: 0x%hx",
@@ -3262,10 +3258,14 @@ void cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
 		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_RWPIDFORWARD;
 	if (pvolume_info->cifs_acl)
 		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_CIFS_ACL;
-	if (pvolume_info->backupuid_specified)
+	if (pvolume_info->backupuid_specified) {
 		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_CIFS_BACKUPUID;
-	if (pvolume_info->backupgid_specified)
+		cifs_sb->mnt_backupuid = pvolume_info->backupuid;
+	}
+	if (pvolume_info->backupgid_specified) {
 		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_CIFS_BACKUPGID;
+		cifs_sb->mnt_backupgid = pvolume_info->backupgid;
+	}
 	if (pvolume_info->override_uid)
 		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_OVERR_UID;
 	if (pvolume_info->override_gid)
-- 
1.7.7.6
