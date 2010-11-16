From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [RFC][PATCH] cifs: add attribute cache timeout (actimeo) tunable
Date: Tue, 16 Nov 2010 15:39:37 +0530
Message-ID: <1289902177-12963-1-git-send-email-sjayaraman@suse.de>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Currently, the attribute cache timeout for CIFS is 1 sec. This means that the
client might have to issue a QPATHINFO/QFILEINFO call every 1 sec to verify if
something has changed, which seems too expensive. On the otherhand, increasing
this value further may not work well for all the users.

This patch introduces a tunable mount option 'actimeo' that can be used to tune
the attribute cache timeout. This patch takes a conservative approach and sets
the default timeout is set to 3 seconds while limiting maximum timeout to 60
seconds. Ideally, it is preferred to set attribute cache timeouts separately
for files and directories like how NFS does. However, I think it is better to
keep it simple without too many options, introduce the option to users, get
feedback from them and then decide what is working better for CIFS.

This patch has been tested lightly and no adverse effects were seen.

Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 fs/cifs/cifs_fs_sb.h |    1 +
 fs/cifs/cifsglob.h   |    3 +++
 fs/cifs/connect.c    |   16 ++++++++++++++++
 fs/cifs/inode.c      |    6 +++---
 4 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index e9a393c..efd2d73 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -48,6 +48,7 @@ struct cifs_sb_info {
 	struct nls_table *local_nls;
 	unsigned int rsize;
 	unsigned int wsize;
+	unsigned int actimeo;
 	atomic_t active;
 	uid_t	mnt_uid;
 	gid_t	mnt_gid;
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index b577bf0..eb22130 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -44,6 +44,9 @@
 
 #define CIFS_MIN_RCV_POOL 4
 
+#define CIFS_DEF_ACTIMEO (3)	/* default attribute cache timeout (seconds) */
+#define CIFS_MAX_ACTIMEO (60)	/* max allowed attribute cache timeout */
+
 /*
  * MAX_REQ is the maximum number of requests that WE will send
  * on one socket concurrently. It also matches the most common
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 251a17c..39edc54 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -103,6 +103,7 @@ struct smb_vol {
 	bool multiuser:1;
 	unsigned int rsize;
 	unsigned int wsize;
+	unsigned int actimeo; /* attribute cache timeout */
 	bool sockopt_tcp_nodelay:1;
 	unsigned short int port;
 	char *prepath;
@@ -1214,6 +1215,10 @@ cifs_parse_mount_options(char *options, const char *devname,
 					printk(KERN_WARNING "CIFS: server net"
 					"biosname longer than 15 truncated.\n");
 			}
+		} else if (strnicmp(data, "actimeo", 7) == 0) {
+			if (value && *value)
+				vol->actimeo =
+					simple_strtoul(value, &value, 0);
 		} else if (strnicmp(data, "credentials", 4) == 0) {
 			/* ignore */
 		} else if (strnicmp(data, "version", 3) == 0) {
@@ -2566,6 +2571,17 @@ static void setup_cifs_sb(struct smb_vol *pvolume_info,
 	cFYI(1, "file mode: 0x%x  dir mode: 0x%x",
 		cifs_sb->mnt_file_mode, cifs_sb->mnt_dir_mode);
 
+	if ((pvolume_info->actimeo) &&
+			(pvolume_info->actimeo < CIFS_MAX_ACTIMEO))
+		cifs_sb->actimeo = pvolume_info->actimeo;
+	else if ((pvolume_info->actimeo) &&
+			(pvolume_info->actimeo >= CIFS_MAX_ACTIMEO)) {
+		cifs_sb->actimeo = CIFS_MAX_ACTIMEO;
+		cERROR(1, "actimeo %d too large, using %d instead",
+				pvolume_info->actimeo, CIFS_MAX_ACTIMEO);
+	} else /* default */
+		cifs_sb->actimeo = CIFS_DEF_ACTIMEO;
+
 	if (pvolume_info->noperm)
 		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NO_PERM;
 	if (pvolume_info->setuids)
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index ff7d299..f30700d 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1648,6 +1648,7 @@ static bool
 cifs_inode_needs_reval(struct inode *inode)
 {
 	struct cifsInodeInfo *cifs_i = CIFS_I(inode);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 
 	if (cifs_i->clientCanCacheRead)
 		return false;
@@ -1658,12 +1659,11 @@ cifs_inode_needs_reval(struct inode *inode)
 	if (cifs_i->time == 0)
 		return true;
 
-	/* FIXME: the actimeo should be tunable */
-	if (time_after_eq(jiffies, cifs_i->time + HZ))
+	if (time_after_eq(jiffies, cifs_i->time + (cifs_sb->actimeo * HZ)))
 		return true;
 
 	/* hardlinked files w/ noserverino get "special" treatment */
-	if (!(CIFS_SB(inode->i_sb)->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) &&
+	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) &&
 	    S_ISREG(inode->i_mode) && inode->i_nlink != 1)
 		return true;
 
