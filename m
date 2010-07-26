From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] cifs: map NT_STATUS_ERROR_WRITE_PROTECTED to -EROFS
Date: Mon, 26 Jul 2010 10:29:57 -0400
Message-ID: <1280154598-29628-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Seems like a more sensible mapping than -EIO.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/netmisc.c |    1 +
 fs/cifs/smberr.h  |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index 3489468..c6721ee 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -61,6 +61,7 @@ static const struct smb_to_posix_error mapping_table_ERRDOS[] = {
 	{ERRremcd, -EACCES},
 	{ERRdiffdevice, -EXDEV},
 	{ERRnofiles, -ENOENT},
+	{ERRwriteprot, -EROFS},
 	{ERRbadshare, -ETXTBSY},
 	{ERRlock, -EACCES},
 	{ERRunsup, -EINVAL},
diff --git a/fs/cifs/smberr.h b/fs/cifs/smberr.h
index c5084d2..7f16cb8 100644
--- a/fs/cifs/smberr.h
+++ b/fs/cifs/smberr.h
@@ -76,6 +76,7 @@
 #define ERRnofiles		18	/* A File Search command can find no
 					   more files matching the specified
 					   criteria. */
+#define ERRwriteprot		19	/* media is write protected */
 #define ERRgeneral		31
 #define ERRbadshare		32	/* The sharing mode specified for an
 					   Open conflicts with existing FIDs on
-- 
1.7.1.1
