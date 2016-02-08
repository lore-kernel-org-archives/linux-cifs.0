From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: remove any preceding delimiter from prefix_path
Date: Mon,  8 Feb 2016 13:44:01 +0530
Message-ID: <1454919241-28048-1-git-send-email-sprabhu@redhat.com>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We currently do not check if any delimiter exists before the prefix
path in cifs_compose_mount_options(). Consequently when building the
devname using cifs_build_devname() we can end up with multiple
delimiters separating the UNC and the prefix path.

An issue was reported by the customer mounting a folder within a DFS
share from a Netapp server which uses McAfee antivirus. We have
narrowed down the cause to the use of double backslashes in the file
name used to open the file. This was determined to be caused because of
additional delimiters as a result of the bug.

In addition to changes in cifs_build_devname(), we also fix
cifs_parse_devname() to ignore any preceding delimiter for the prefix
path.

The problem was originally reported on RHEL 6 in RHEL bz 1252721. This
is the upstream version of the fix. The fix was confirmed by looking at
the packet capture of a DFS mount.

Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifs_dfs_ref.c | 6 +++++-
 fs/cifs/connect.c      | 8 ++++++--
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index 7dc886c..10db1fe 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -151,8 +151,12 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
 	if (sb_mountdata == NULL)
 		return ERR_PTR(-EINVAL);
 
-	if (strlen(fullpath) - ref->path_consumed)
+	if (strlen(fullpath) - ref->path_consumed) {
 		prepath = fullpath + ref->path_consumed;
+		/* skip initial delimiter */
+		if (*prepath == '/' || *prepath == '\\')
+			prepath++;
+	}
 
 	*devname = cifs_build_devname(ref->node_name, prepath);
 	if (IS_ERR(*devname)) {
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 4fbd92d..2acb4bb 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1196,8 +1196,12 @@ cifs_parse_devname(const char *devname, struct smb_vol *vol)
 
 	convert_delimiter(vol->UNC, '\\');
 
-	/* If pos is NULL, or is a bogus trailing delimiter then no prepath */
-	if (!*pos++ || !*pos)
+	/* skip any delimiter */
+	if (*pos == '/' || *pos == '\\')
+		pos++;
+
+	/* If pos is NULL then no prepath */
+	if (!*pos)
 		return 0;
 
 	vol->prepath = kstrdup(pos, GFP_KERNEL);
-- 
2.5.0
