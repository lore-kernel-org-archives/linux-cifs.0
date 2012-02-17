From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/3] cifs: clean up call to cifs_dfs_release_automount_timer()
Date: Fri, 17 Feb 2012 09:31:42 -0500
Message-ID: <1329489104-7823-2-git-send-email-jlayton@redhat.com>
References: <1329489104-7823-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org,
	tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1329489104-7823-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Take the #ifdef junk out of the code, and turn it into a noop macro
when CONFIG_CIFS_DFS_UPCALL isn't defined.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsfs.c    |    2 --
 fs/cifs/cifsproto.h |    6 ++++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index b1fd382..f5fa651 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1182,9 +1182,7 @@ exit_cifs(void)
 	cFYI(DBG2, "exit_cifs");
 	cifs_proc_clean();
 	cifs_fscache_unregister();
-#ifdef CONFIG_CIFS_DFS_UPCALL
 	cifs_dfs_release_automount_timer();
-#endif
 #ifdef CONFIG_CIFS_ACL
 	cifs_destroy_idmaptrees();
 	exit_cifs_idmap();
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 6f4e243..121b949 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -168,7 +168,13 @@ extern struct smb_vol *cifs_get_volume_info(char *mount_data,
 					    const char *devname);
 extern int cifs_mount(struct cifs_sb_info *, struct smb_vol *);
 extern void cifs_umount(struct cifs_sb_info *);
+
+#if IS_ENABLED(CONFIG_CIFS_DFS_UPCALL)
 extern void cifs_dfs_release_automount_timer(void);
+#else /* ! IS_ENABLED(CONFIG_CIFS_DFS_UPCALL) */
+#define cifs_dfs_release_automount_timer()	do { } while(0)
+#endif /* ! IS_ENABLED(CONFIG_CIFS_DFS_UPCALL) */
+
 void cifs_proc_init(void);
 void cifs_proc_clean(void);
 
-- 
1.7.7.6
