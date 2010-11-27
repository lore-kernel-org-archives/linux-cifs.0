From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: [PATCH 13/14] cifs: make hard mounts the default
Date: Sat, 27 Nov 2010 08:01:25 -0500
Message-ID: <1290862886-2914-14-git-send-email-jlayton@redhat.com>
References: <1290862886-2914-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1290862886-2914-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Allowing calls to time out is fine when a user wants that, however we
should default to the behavior that allows for the most robust operation
for applications.

Defaulting to soft means unreliable behavior for applications in the face
of reconnects. Change the default to hard mounts.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index ece7275..d966976 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -899,7 +899,8 @@ cifs_parse_mount_options(char *options, const char *devname,
 	/* default to only allowing write access to owner of the mount */
 	vol->dir_mode = vol->file_mode = S_IRUGO | S_IXUGO | S_IWUSR;
 
-	/* vol->retry default is 0 (i.e. "soft" limited retry not hard retry) */
+	/* default is to retry requests indefinitely */
+	vol->retry = 1;
 	/* default is always to request posix paths. */
 	vol->posix_paths = 1;
 	/* default to using server inode numbers where available */
-- 
1.7.3.2
