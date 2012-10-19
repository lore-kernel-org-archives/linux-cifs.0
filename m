From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 9/9] cifs: ensure we revalidate the inode after readdir if cifsacl is enabled
Date: Fri, 19 Oct 2012 08:20:50 -0400
Message-ID: <1350649250-5343-10-git-send-email-jlayton@redhat.com>
References: <1350649250-5343-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1350649250-5343-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Otherwise, "ls -l" will simply show the ownership of the files as
the default mnt_uid/gid. This may make "ls -l" performance on large
directories super-suck in some cases, but that's the cost of cifsacl.

One possibility to make it suck less would be to somehow proactively
dispatch the ACL requests asynchronously from readdir codepath, but
that's non-trivial to implement.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/readdir.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index f9b5d3d..96fe44b 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -134,6 +134,16 @@ cifs_fill_common_info(struct cifs_fattr *fattr, struct cifs_sb_info *cifs_sb)
 	if (fattr->cf_cifsattrs & ATTR_READONLY)
 		fattr->cf_mode &= ~S_IWUGO;
 
+	/*
+	 * We of course don't get ACL info in FIND_FIRST/NEXT results, so
+	 * mark it for revalidation so that "ls -l" will look right. It might
+	 * be super-slow, but if we don't do this then the ownership of files
+	 * may look wrong since the inodes may not have timed out by the time
+	 * "ls" does a stat() call on them.
+	 */
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL)
+		fattr->cf_flags |= CIFS_FATTR_NEED_REVAL;
+
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL &&
 	    fattr->cf_cifsattrs & ATTR_SYSTEM) {
 		if (fattr->cf_eof == 0)  {
-- 
1.7.11.7
