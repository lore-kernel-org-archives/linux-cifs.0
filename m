From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: add fallback in is_path_accessible for old servers
Date: Tue, 17 May 2011 06:40:30 -0400
Message-ID: <1305628830-17952-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sandro.bonazzola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The is_path_accessible check uses a QPathInfo call, which isn't
supported by ancient win9x era servers. Fall back to an older
SMBQueryInfo call if it fails with the magic error codes.

Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Reported-and-Tested-by: Sandro Bonazzola <sandro.bonazzola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 05f1dcf..277262a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2673,6 +2673,11 @@ is_path_accessible(int xid, struct cifsTconInfo *tcon,
 			      0 /* not legacy */, cifs_sb->local_nls,
 			      cifs_sb->mnt_cifs_flags &
 				CIFS_MOUNT_MAP_SPECIAL_CHR);
+
+	if (rc == -EOPNOTSUPP || rc == -EINVAL)
+		rc = SMBQueryInformation(xid, tcon, full_path, pfile_info,
+				cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
+				  CIFS_MOUNT_MAP_SPECIAL_CHR);
 	kfree(pfile_info);
 	return rc;
 }
-- 
1.7.4.4
