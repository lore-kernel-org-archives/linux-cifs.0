From: Gerlando Falauto <gerlando.falauto-SkAbAL50j+5BDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] CIFS: fix automount for DFS shares
Date: Tue, 18 Oct 2011 10:58:50 +0200
Message-ID: <1318928330-4498-1-git-send-email-gerlando.falauto@keymile.com>
References: <1318845543-15085-1-git-send-email-gerlando.falauto@keymile.com>
Cc: Gerlando Falauto <gerlando.falauto-SkAbAL50j+5BDgjK7y7TUQ@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1318845543-15085-1-git-send-email-gerlando.falauto-SkAbAL50j+5BDgjK7y7TUQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Automounting directories are now invalidated by .d_revalidate()
so to be d_instantiate()d again with the right DCACHE_NEED_AUTOMOUNT
flag

Reviewed-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Signed-off-by: Gerlando Falauto <gerlando.falauto-SkAbAL50j+5BDgjK7y7TUQ@public.gmane.org>
---
 fs/cifs/dir.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 9ea65cf..ca3b571 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -637,8 +637,16 @@ cifs_d_revalidate(struct dentry *direntry, struct nameidata *nd)
 	if (direntry->d_inode) {
 		if (cifs_revalidate_dentry(direntry))
 			return 0;
-		else
+		else {
+			/*
+			 * Forcibly invalidate automounting directory inodes
+			 * (remote DFS directories) so to have them
+			 * instantiated again for automount
+			 */
+			if (IS_AUTOMOUNT(direntry->d_inode))
+				return 0;
 			return 1;
+		}
 	}
 
 	/*
-- 
1.7.1
