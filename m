From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/6] cifs: make convert_delimiter use strchr instead of open-coding it
Date: Fri, 16 Nov 2012 12:36:51 -0500
Message-ID: <1353087414-32152-4-git-send-email-jlayton@redhat.com>
References: <1353087414-32152-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fsauter-LVkJPw3T+odGBRGhe+f61g@public.gmane.org,
	almiller_1-/E1597aS9LT10XsdtD+oqA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1353087414-32152-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Take advantage of accelerated strchr() on arches that support it.

Also, no caller ever passes in a NULL pointer. Get rid of the unneeded
NULL pointer check.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index b141c90..414d93b 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1066,21 +1066,16 @@ static inline char CIFS_DIR_SEP(const struct cifs_sb_info *cifs_sb)
 static inline void
 convert_delimiter(char *path, char delim)
 {
-	int i;
-	char old_delim;
-
-	if (path == NULL)
-		return;
+	char old_delim, *pos;
 
 	if (delim == '/')
 		old_delim = '\\';
 	else
 		old_delim = '/';
 
-	for (i = 0; path[i] != '\0'; i++) {
-		if (path[i] == old_delim)
-			path[i] = delim;
-	}
+	pos = path;
+	while ((pos = strchr(pos, old_delim)))
+		*pos = delim;
 }
 
 static inline char *
-- 
1.7.11.7
