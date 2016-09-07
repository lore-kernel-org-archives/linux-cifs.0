From: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH v1 1/1] fs/cifs/dir.c: use correct path separators
Date: Wed,  7 Sep 2016 15:45:52 +0200
Message-ID: <1473255952-27579-1-git-send-email-aaptel@suse.com>
Cc: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

When a prefix path needs to be added, current code hardcodes the initial
path separator to backslash. Use CIFS_DIR_SEP instead and properly
convert path separator in the prefix path.

CIFS_MOUNT_USE_PREFIX_PATH is rarely needed (Windows shares with very
specific ACL or buggy mount call AFAIK) which explains why the
backsplash wasn't a big issue.

Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
---
 fs/cifs/dir.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 4716c54..c85a8bb 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -160,13 +160,15 @@ cifs_bp_rename_retry:
 
 	if (pplen) {
 		int i;
+		char oldsep = dirsep == '/' ? '\\' : '/';
 
 		cifs_dbg(FYI, "using cifs_sb prepath <%s>\n", cifs_sb->prepath);
+
+		full_path[dfsplen] = dirsep;
 		memcpy(full_path+dfsplen+1, cifs_sb->prepath, pplen-1);
-		full_path[dfsplen] = '\\';
-		for (i = 0; i < pplen-1; i++)
-			if (full_path[dfsplen+1+i] == '/')
-				full_path[dfsplen+1+i] = CIFS_DIR_SEP(cifs_sb);
+		for (i = 1; i < pplen; i++)
+			if (full_path[dfsplen+i] == oldsep)
+				full_path[dfsplen+i] = dirsep;
 	}
 
 	if (dfsplen) {
-- 
2.1.4
