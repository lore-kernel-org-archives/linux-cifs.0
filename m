From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: fsc should not default to "on"
Date: Mon, 26 Jul 2010 14:25:08 -0400
Message-ID: <1280168708-2943-1-git-send-email-jlayton@redhat.com>
Cc: sjayaraman-l3A5Bk7waGM@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I'm not sure why this was merged with this flag hardcoded on, but it
seems quite dangerous. Turn it off.

Also, mount.cifs hands unrecognized options off to the kernel so there
should be no need for changes there in order to support this.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 85a994c..2a43a0a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -846,9 +846,6 @@ cifs_parse_mount_options(char *options, const char *devname,
 	/* default to using server inode numbers where available */
 	vol->server_ino = 1;
 
-	/* XXX: default to fsc for testing until mount.cifs pieces are done */
-	vol->fsc = 1;
-
 	if (!options)
 		return 1;
 
-- 
1.7.1.1
