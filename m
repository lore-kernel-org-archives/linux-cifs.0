From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/3] cifs: clean up ordering in exit_cifs
Date: Fri, 17 Feb 2012 09:31:43 -0500
Message-ID: <1329489104-7823-3-git-send-email-jlayton@redhat.com>
References: <1329489104-7823-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org,
	tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1329489104-7823-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...ensure that we undo things in the reverse order from the way they
were done. In truth, the ordering doesn't matter for a lot of these,
but it's still better to do it that way to be sure.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsfs.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index f5fa651..a848082 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1180,8 +1180,7 @@ static void __exit
 exit_cifs(void)
 {
 	cFYI(DBG2, "exit_cifs");
-	cifs_proc_clean();
-	cifs_fscache_unregister();
+	unregister_filesystem(&cifs_fs_type);
 	cifs_dfs_release_automount_timer();
 #ifdef CONFIG_CIFS_ACL
 	cifs_destroy_idmaptrees();
@@ -1190,10 +1189,11 @@ exit_cifs(void)
 #ifdef CONFIG_CIFS_UPCALL
 	unregister_key_type(&cifs_spnego_key_type);
 #endif
-	unregister_filesystem(&cifs_fs_type);
-	cifs_destroy_inodecache();
-	cifs_destroy_mids();
 	cifs_destroy_request_bufs();
+	cifs_destroy_mids();
+	cifs_destroy_inodecache();
+	cifs_fscache_unregister();
+	cifs_proc_clean();
 }
 
 MODULE_AUTHOR("Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>");
-- 
1.7.7.6
