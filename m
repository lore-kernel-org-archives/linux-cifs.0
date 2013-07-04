From: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] cifs: use sensible file nlink values if unprovided
Date: Thu,  4 Jul 2013 20:06:26 +0200
Message-ID: <1372961186-19213-1-git-send-email-ddiss@suse.de>
Cc: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Certain servers may not set the NumberOfLinks field in query file/path
info responses. In such a case, cifs_inode_needs_reval() assumes that
all regular files are hardlinks and triggers revalidation, leading to
excessive and unnecessary network traffic.

This change hardcodes cf_nlink (and subsequently i_nlink) when not
returned by the server, similar to what already occurs in cifs_mkdir().

Signed-off-by: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
---
 fs/cifs/inode.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 6f37228..8c48027 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -532,6 +532,8 @@ cifs_all_info_to_fattr(struct cifs_fattr *fattr, FILE_ALL_INFO *info,
 	fattr->cf_bytes = le64_to_cpu(info->AllocationSize);
 	fattr->cf_createtime = le64_to_cpu(info->CreationTime);
 
+	fattr->cf_nlink = le32_to_cpu(info->NumberOfLinks);
+
 	if (fattr->cf_cifsattrs & ATTR_DIRECTORY) {
 		fattr->cf_mode = S_IFDIR | cifs_sb->mnt_dir_mode;
 		fattr->cf_dtype = DT_DIR;
@@ -542,9 +544,13 @@ cifs_all_info_to_fattr(struct cifs_fattr *fattr, FILE_ALL_INFO *info,
 		/* clear write bits if ATTR_READONLY is set */
 		if (fattr->cf_cifsattrs & ATTR_READONLY)
 			fattr->cf_mode &= ~(S_IWUGO);
-	}
 
-	fattr->cf_nlink = le32_to_cpu(info->NumberOfLinks);
+		if (fattr->cf_nlink < 1) {
+			cFYI(1, "replacing bogus file nlink value %u",
+				fattr->cf_nlink);
+			fattr->cf_nlink = 1;
+		}
+	}
 
 	fattr->cf_uid = cifs_sb->mnt_uid;
 	fattr->cf_gid = cifs_sb->mnt_gid;
-- 
1.8.1.4
